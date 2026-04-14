
var controller_enabled = [];

function init_controller() {
	var results = businessview.sendHttpRequest( "GET", config.bwdsm_controller_url +"/connector"  );
	if (results!= null) {
		if ( results.get("connectors") != null   ) {
			results = results["connectors"];
			for ( var i=0 ; i < results.size() ; i++ ) {
				if ( results.get(i).get('name') !=null && results.get(i).get('name')!=null ) {
					controller_enabled[ results.get(i).get('name') ] = results.get(i).get('enabled').toString();
				}
			}
		}
	}
}

function read_controller() {
	var current = businessview.getNextRecord();
	if (current!=null) {
		current.enabled = controller_enabled[current.code]
	}
	return current;
}
