/* API for getting and settings app params
parameters are written in {projectPath/webportal/params/ directory 
*/

import "utils.javascript"

function setParams( ) {
	//print("[DEBUG] setParams facet="+dataset.facet.get()+" names="+dataset.names.toString()+ " values="+dataset.values.toString() )  ;
	writeValuesToFile(dataset.facet.get(), "params", dataset.role.get() , multiValuedToArray(dataset.names), multiValuedToArray(dataset.values));
}

function setData( ) {
	writeValuesToFile(dataset.facet.get(), type, dataset.role.get() ,  multiValuedToArray(dataset.names), multiValuedToArray(dataset.values) );
}

/* INTERNAL FUNCTIONS, do not call from pages */

function writeDatasetVariablesToFile ( facet, type, roleOrNull, names )  {
	var values = [];
	var value; 
	for  each( var name in names){
        value = dataset.get(name);
        if (value instanceof Attribute && value.isMultivalued()) {
        	value = serializeArrayValueInternal(value);
        }	
		values.push( value);
	} 	
	writeValuesToFile(facet, type, roleOrNull, names, values);
}

function loadParamsInternal( facet, role, names){
	loadDataInternal(facet, "params", role, names)
}

function loadDataInternal( facet,type, role, names) {
	var values = getDataInternal(facet, type,role, names);
	//print("data="+values.join(";"));
	for (var i=0; i < names.length; i++){
		var value = values[i];
		var split ; 
		var /*Attribute*/ attr = dataset.get(names[i]);
		//print("attr name="+names[i]+ " attr="+(attr?attr.toString(): "not set" ) + " value="+value);
		// we must test for null because not all parameters are mandatory
		if (attr != null ){ 
		    if (attr.isMultivalued()){     
                split = value == null || value.length == 0 ? []: value.split(",");
 				setAttributeValues(attr, split);
			}
			else {
				attr.set(value);
			}			
		}
	
	}
}

/*String[]*/ function getDataInternal( facet, type, role,  names) {
	return readValuesFromFile(facet,type,role ,role == null ? getDefaultRole(): role , names);
}

/* if roleOrNull is null, then write for user */
function writeValuesToFile( /*String*/facet,/*String*/type,  /*String*/ roleOrNull , /*String[]*/ names, /*String[]*/ values) {
   var /*String*/ dataFilePath = getDataFilePath(facet, type, roleOrNull ) ;
	//print("[DEBUG] facet="+facet+" dataFilePath"+ dataFilePath+ " names="+names+ " values="+values )  ;
	var /*java.util.Properties*/ props = new java.util.Properties();
	// try reading file if exist
	if ( new java.io.File(dataFilePath).exists()){
		  props.loadFromXML(new java.io.FileInputStream(dataFilePath));
	}
	for ( var i = 0 ; i < names.length; i++) {
       //print("[DEBUG] i= "+i+" names="+names.get(i)+ " values="+values.get(i))  ;
		props.put(names[i], values[i]);
	}

	var /*java.io.FileOutputStream*/ output = new java.io.FileOutputStream(dataFilePath);
	props.storeToXML(output, "Last saved for "+config.__PRINCIPAL_FULLNAME+ ( roleOrNull ? " as "+roleOrNull: ""));
}

/* if roleOrNull is null, then read for user
if not found, then read for defaultRole
return array of values */
/*String[]*/ function readValuesFromFile( /*String*/facet, /*String*/ type, /*String*/ roleOrNull , /*String*/defaultRole, /*String[]*/ names) {
  /* read defaults*/
    var /*String*/ dataFilePath;
    var /*java.util.Properties*/ defaultProps;
    if (defaultRole != null ) {
    	  dataFilePath = getDataFilePath(facet, type, defaultRole ) ;
		defaultProps = new java.util.Properties();
		// try reading file if exist
		if ( new java.io.File(dataFilePath).exists()){
			  defaultProps.loadFromXML(new java.io.FileInputStream(dataFilePath));
		}
    } 
    else 
       defaultProps = null; 
       
    dataFilePath = getDataFilePath(facet, type, roleOrNull ) ;
    
	var /*java.util.Properties*/ props = new java.util.Properties();
	// try reading file if exist
	if ( new java.io.File(dataFilePath).exists()){
		  props.loadFromXML(new java.io.FileInputStream(dataFilePath));
	}
	var values = [];
	var /*String*/ name; 
	var /*String*/ val; 
	for ( var i = 0 ; i < names.length; i++) {
       name = names[i];
		val = props.containsKey(name)? props.get(name): defaultProps != null ? defaultProps.get(name): null;
		if (val == null) val = ""; 
		values.push(val);
	}
	// print("[DEBUG] readValuesFromFile dataFilePath"+ dataFilePath+ " names="+names+ " values="+values )  ;
    return values;
}

/* String*/ function serializeArrayValue() {
	return serializeArrayValueInternal(dataset.array);
}

/* String*/ function serializeBooleanValue() {
	var /*Boolean*/ bool = dataset.bool.get(); 
	return bool == true ? "true": "false"; 
}

/*String*/ function getDataFilePath( /*String*/facet, /*String*/ type, /*String*/roleOrNull) {
   var /* String*/ baseDir = config.projectPath+ "/webportal/data/"+facet;
   new java.io.File(baseDir).mkdirs(); // create intermediate dirs 
    var /*String*/ roleOrUser = roleOrNull != null ? "R_"+roleOrNull : "U_"+config.__PRINCIPAL_UID;
	return  baseDir+"/"+type+"_" + roleOrUser +".xml";
}

function getDefaultRole() {
	return "admin";
}

function setAttributeValues( /*Attribute*/ attribute, values) {
 //  print( "setAttributeValues values=["+values+"] length="+values.length);
  attribute.clear();
  for each (var  val in values) {
      attribute.add(val);
   } 	
}


/* String*/ function serializeArrayValueInternal( /*Attribute*/ array) {
	var res = "";
	for (var i=0; i < array.length; i++) {		
       if (i != 0) res+=",";
		res+= array.get(i);		
	}
	return res; 
}
