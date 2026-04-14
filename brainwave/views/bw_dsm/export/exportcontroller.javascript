

var all_datasets = [];

function init() {
	var result = businessview.sendHttpRequest( "GET", config.bwdsm_controller_url +"/connector"  );
	var /*java.util.List*/ list;
	if (result!==null) {
		list =  result.connectors;
		// filter by category
		if ( list !== null ){
			var /*java.util.List*/ newList = new java.util.ArrayList();
			var /*java.util.Map*/ ds ; 
			for (var i=0;i<list.size();i++){
				ds =list.get(i);
				currentDS = new DataSet();
				
				currentDS.add("name");
				currentDS.name = ds.get("name");
				
				currentDS.add("scheduling");
				currentDS.scheduling = ds.get("scheduling");
				
				currentDS.add("id");
				currentDS.id = ds.get("id").toString();
				
				currentDS.add("category");
				currentDS.category = ds.get("category");
				
				currentDS.add("type");
				currentDS.type = ds.get("type");
				
				currentDS.add("enabled");
				currentDS.enabled = ds.get("enabled").toString();
				
				currentDS.add("description");
				
				// resolve description , that is given by another endpoint
				var description_result = businessview.sendHttpRequest( "GET", config.bwdsm_controller_url +"/connector/" + ds.get("id").toString()  );
				if (description_result!=null) {
					if (description_result.description !=null) {
						currentDS.description = description_result.description;
					}
				}
				
				currentDS.add("join_key_ctl");
				currentDS.join_key_ctl = "bw_datasource_def$$"+ds.get("id").toString();
				
				all_datasets.push( currentDS );
				
			}
		}
	}
}

function read() {
	return all_datasets.pop();
}
