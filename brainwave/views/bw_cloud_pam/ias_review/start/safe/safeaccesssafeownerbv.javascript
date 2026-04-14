
var safeownermax = {}

function init() {
	var /*java.util.HashMap*/ params = new java.util.HashMap();
	params.put ('safelist', dataset.safelist )
	var v = businessview.executeView(null, "bwir_safeowner" , params);
	for(var i=0;i<v.length;i++) {
	
		var safeuid = v[i].get('safeuid');
		var rank = v[i].get('rank');
		
		if ( safeuid in safeownermax ){
		  if (rank > safeownermax[safeuid]){
		    safeownermax[safeuid] = Number(rank);
		  }
		}
		else {
			safeownermax[safeuid] = Number(rank);
		}
	}
}

function read() {
	var record = businessview.getNextRecord();
 		if (record == null) { 
 		return null;
 	}
 	if ( record.get("rank") == safeownermax[record.get("safeuid")]){
 		record.keep = 1;
	 }
 	return record;
}
