
function refreshPendingRecon () {
	if ( dataset.isEmpty('accountUid') ){
		return;
	}
	var account = dataset.accountUid.get();
	dataset.isPending.clear();
	dataset.isPending.set (false);
	var params = new java.util.HashMap();
	params.put("accountuid", account );
	var res = connector.executeView(null, "br_reconciliation_pending" , params);
	if ( res!=null && res.length > 0 ) {
		dataset.isPending.set (true);
	}
}