import "../resources/JSON.javascript"

function deserializeOptions( ){
	var ser = dataset.options.get();
	var varnamesStr = dataset.varnames.get();
	print("deserializeOptions: varnames="+varnamesStr+ " ser="+ser);
	if ( varnamesStr && ser ){
		var varnames = varnamesStr.split(",");	
		var obj = JSON.parse(ser); 
		for ( var i=0; i <varnames.length;i++){
			var /*String*/ varname=varnames[i];
			dataset.get(varname).set(obj[varname]);
		}	
	}	
}

/*returns the options json string */
function serializeOptions() {
	var varnamesStr = dataset.varnames.get();	
	var /*Array*/ varnames = varnamesStr.length >0? varnamesStr.split(","): [];	
	var secretnamesStr = dataset.secretnames != null? dataset.secretnames.get(): "";
	var /*Array*/ secretnames = secretnamesStr.length >0? secretnamesStr.split(","): [];
	var dsname = dataset.secretdsname != null? dataset.secretdsname.get(): "";	
	var obj = {}
	for ( var i=0; i  <varnames.length;i++){		
		var /*String*/ varname=varnames[i];
		var varvalue = dataset.get(varname).get();
		// process secrets
		if (secretnames.indexOf(varname) >= 0) {
			varvalue = vaultSaveSecret(dsname, varname, varvalue);
		}
	    obj[varname] = varvalue;
	}	
	var ser = JSON.stringify(obj);
	print("serializeOptions: dataset="+dataset + " varnames="+varnames+ " length="+varnames.length+ " ser="+ser);	
	return ser; 
}

// adds non-specific values to options
// returns the options json string
// slow but safe: we deserialize, patch, then serialize the JSON
function patchOptions() {
	var obj = JSON.parse(dataset.options.get()); 
	if (dataset.action != null ) {
		var /*String*/ action = dataset.action.get();
		if (action != null)
		  obj._action = action;
	}
	var ser = JSON.stringify(obj);
	print("patch options ->" +ser);	
	return ser; 		
}


function vault_api_url( /*String */part ) {	
	return config.bwdsm_vault_url +"/"+ part; 
}

function vaultSaveSecret(/*String*/ds_code, /*String*/option_name, secret_value ){
  
   var /*String*/ key = "DS_"+ds_code.toUpperCase()+"_"+option_name.toUpperCase(); 
   var /*String*/ ref =  "$("+key+")";
   // already registered?
   if ( secret_value === ref){
   	  return ref; 
   }
   var data = {
   	  value: secret_value
   }
   var result = { secret: key}; 
   var result = connector.sendHttpRequest("POST",vault_api_url("vault/"+key) , null, data); 
   print( " vault returned:" + result);
   if (result !== null && result.key !== null){   	  	  
   	  return ref;
   }
   else {
   	//couldn't register, so use password instead
   	return secret_value; 
   }
}


/* 
 columns = Input { multivalued: True mandatory: True}
  columnsOrder = Output { multivalued: True }
  mappedColumns = Output { multivalued: True }
*/

function initColumns(){
	var len = dataset.columns.length;
	var /*Attribute*/ columnsOrder = dataset.columnsOrder;
	var /*Attribute*/ mappedColumns = dataset.mappedColumns;
	columnsOrder.clear();
	mappedColumns.clear();
	for( var i=0; i< len;i++){
		columnsOrder.add(i+1);
		mappedColumns.add("");
	}
}


