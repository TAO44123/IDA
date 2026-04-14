import "../../../../library/script/bw_fragments/office365/actionslib_office365.javascript"

var actionlist = [];
var actionCode = {};

function init() {
	if ( dataset.appfamily.get() == "SharePointOnline") {
		 actionCode = getSharePointOnlineActions();
	}
	if ( dataset.appfamily.get() == "ExchangeOnline") {
		 actionCode = getExchangeOnlineActions();
	}
	if (! dataset.isEmpty("action") ) {
		actionlist = dataset.action.get().split('');
	}
}

function read() {
	var newrow = null;
	
	if ( actionlist.length > 0 ) {
		newrow = new DataSet();
		newrow.action = dataset.action.get();
		newrow.unitaction = actionlist.pop().toString();
		newrow.unitcode = actionCode[newrow.unitaction.get()];
	}
	
	return newrow;
}
