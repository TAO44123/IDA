
function findContainersFromDN (){
	
	
	// Get input 
	var dn = dataset.dn.get();
	
	// Get output
	dataset.containers.clear();
	
	if (dn == null ){
		return;
	}
	
	while ( dn.indexOf (",") >= 0 ){
		
		dn = dn.substring ( dn.indexOf (",") + 1 )
		dataset.containers.add (dn);
		
	}	
}


function parsePasswordPolicies () {
	
	// Get input 
	var contents =  dataset.contents.get();
	
	if ( dataset.isEmpty('contents') ) {
		return;
	}
	
	// Get output
	dataset.pname.clear();
	dataset.ptype.clear();
	dataset.pvalue.clear();
	
	var objarr = eval ( contents );
	
	if ( objarr == null ){
		return;
	}
	
	for (i =0; i < objarr.length; i++) { 
		dataset.pname.add ( objarr[i]["name"]);
		dataset.ptype.add ( objarr[i]["type"]);
		dataset.pvalue.add ( objarr[i]["value"]);	
	}
}