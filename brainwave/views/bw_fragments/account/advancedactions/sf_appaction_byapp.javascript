import "../../../../library/script/bw_fragments/office365/actionslib_office365.javascript"

var appactioncache = {};
var actionDisplayname = null;

function read() {
	var element = null;
	do {	
		element = businessview.getNextRecord();
		
		if ( element != null ){
			
			if ( element.appaction in appactioncache ) {
				appactioncache[element.appaction] += 1;
			}
			else {
				appactioncache[element.appaction] = 1
			}
		}
		
	} while ( element != null && appactioncache[element.appaction] > 1 )
	
	return element;
}

function initdisplayname() {
	if ( dataset.appfamily.get() == "SharePointOnline") {
		 actionDisplayname = getSharePointOnlineActionsDisplayname();
	}
	if ( dataset.appfamily.get() == "ExchangeOnline") {
		 actionDisplayname = getExchangeOnlineActionsDisplayname();
	}
}

function readdisplayname() {
	var item = businessview.getNextRecord()
	
	if (item != null){
		if ( actionDisplayname != null ) {
			var currentdisplayname = []
			var appactionsplit = item.appaction.toString().split('');
			for ( i =0; i< appactionsplit.length ; i++ ){
				if ( appactionsplit[i] in actionDisplayname ){
					currentdisplayname.push (actionDisplayname[ appactionsplit[i] ]);
				}
			}
			item.appactiondisplayname = currentdisplayname.join(', ');
			item.appactioncount = currentdisplayname.length;
		}
	}
	
	return item;
}


