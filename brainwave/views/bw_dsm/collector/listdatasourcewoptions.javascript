import "JSON.javascript" ;

var controller_enabled = [];

function onRead(){
  var /*DataSet*/ record = businessview.getNextRecord();
  if ( record !== null){
  	var /*Attribute*/ attr ;
  	attr = record.get("opt_");
    if (attr !== null) {
    	var /* String */ json = attr.get();
    	var obj = JSON.parse(json); 
	    for ( key in obj){   	
	    	attr = record.add("opt_"+key);
	    	attr.set( obj[key]);
	    }	
    }  	
  }
  return record;
}

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