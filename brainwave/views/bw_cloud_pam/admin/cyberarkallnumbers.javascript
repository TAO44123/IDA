
types = []
count = {}


function init() {
	res = businessview.executeView(null, "bwcpam_cyberarknumbers")
	for ( i=0; i<res.length; i++ ){
		count [ res[i].get('type') ] = Number(res[i].get('nb'));
	}
	res = businessview.executeView(null, "bwcdpam_cyberarksecretsnumbers")
	for ( i=0; i<res.length; i++ ){
		count [ res[i].get('type') ] = Number(res[i].get('nb'));
	}
	types.push (1);
}

function read() {
	if ( types.length > 0 ) {
		types.pop();
		var ds = new DataSet();
		ds.ca_safe = count ['ca_safe']==null?0:count ['ca_safe'];
		ds.ca_vault = count ['ca_vault']==null?0:count['ca_vault'] ;
		ds.ca_secret = count ['ca_secret']==null?0:count['ca_secret'] ;
		return ds;
	}
	else  {
		return null;
	}
		
}
