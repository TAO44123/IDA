
function readDN () {
	
	// Prepare output
	dataset.object_type.clear();
	dataset.object_dn.clear();
	dataset.object_displayname.clear();
	dataset.object_uid.clear();
	dataset.object_index.clear();
	dataset.object_parent.clear();
	
	// Get Input
	
	if ( dataset.isEmpty('dn') ){
		return;
	}
	
	var dn = dataset.dn.get();
	
	fulldn = dn.split(",");
	
	var temp = "";
	var params, res, index = 0, parent ;
	
	for ( i = fulldn.length-1 ;i >=0 ;  i-- ) {
		
		temp = temp != ""?fulldn[i] + "," + temp:fulldn[i] ;
		
		dataset.object_type.add ( fulldn[i].substring (0,2) );
		dataset.object_displayname.add (fulldn[i].substring (3) );
		dataset.object_dn.add ( temp );
		dataset.object_parent.add ( parent );
		dataset.object_index.add ( index.toFixed(0) );
		
		// get permission code if any
		params = new java.util.HashMap();
		params.put("dn", temp );
		res = connector.executeView(null, "ad_object_check", params );
		
		if (res.length > 0 ){
			dataset.object_uid.add ( res[0].get("uid") );
		}
		else{
			dataset.object_uid.add ( null );
		}
		
		index+= 1;
		parent = temp
		
	}
	
}