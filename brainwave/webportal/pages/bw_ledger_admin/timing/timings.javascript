
var crcTable = makeCRCTable();

function makeCRCTable (){
    var c;
    var crcTable = [];
    for(var n =0; n < 256; n++){
        c = n;
        for(var k =0; k < 8; k++){
            c = ((c&1) ? (0xEDB88320 ^ (c >>> 1)) : (c >>> 1));
        }
        crcTable[n] = c;
    }
    return crcTable;
}

var crc32 = function crc32 (str) {
    //var crcTable = window.crcTable || (window.crcTable = makeCRCTable());
    var crc = 0 ^ (-1);

    for (var i = 0; i < str.length; i++ ) {
        crc = (crc >>> 8) ^ crcTable[(crc ^ str.charCodeAt(i)) & 0xFF];
    }

    return ( (crc ^ (-1)) >>> 0 ).toString(16);
}

function hashtimeslot ( timeslotUid, fields ) {
	
	var params = new java.util.HashMap();
	params.put("uid", timeslotUid );
	var res = connector.executeView(timeslotUid, "timeslot_timing" , params);
	
	var checksum = "";
	var chunk = "";
	var whole = "";
	var parent = null;
	
	
	if ( res.length > 0 ) {
		
		for ( var i = 0 ; i < fields.length ; i++ ) {
			chunk = fields[i] + ":" +   res[ 0 ].get( "ts_" + dataset.selectedFields.get(i) ) + "|";
			whole = whole + chunk;
			checksum = crc32 ( checksum + chunk );
		}
		
		parent = res[ 0 ].get("parent_uid") ;
	}
	
	//print ( timeslotUid + " " + checksum + " " + whole );
	
	var results = [];
	results.push ( checksum );
	results.push ( parent );
	return results;
	
}

function timeslotsChecksum () {
	
	// Prepare output
	dataset.uid.clear();
	dataset.checksum.clear();
	dataset.parent_uid.clear();
	dataset.parent_checksum.clear();
	dataset.changed.clear();
	
	
	var fields = [];
	var results = [];
	var hash1, hash2;
	
	for ( var i = 0 ; i < dataset.selectedFields.length ; i++ ) {
		fields.push ( dataset.selectedFields.get(i) );
	}
	
	for ( var i = 0 ; i < dataset.timeslotsUid.length ; i++ ) {
		
		hash1 = hash2 = "";
		
		dataset.uid.add ( dataset.timeslotsUid.get(i) );
		
		results = hashtimeslot(dataset.timeslotsUid.get(i), fields);
		dataset.checksum.add ( results[0] );
		hash1=results[0];
		
		if (results[1] !=null) {
			dataset.parent_uid.add ( results[1] );
			results = hashtimeslot( results[1] , fields);
			hash2=results[0];
			dataset.parent_checksum.add ( results[0] );
		}
		else {
			dataset.parent_uid.add ( null );
			dataset.parent_checksum.add ( null );
		}
		
		if (hash2 != null && hash2 != "" && hash1 != hash2) {
			dataset.changed.add ( "yes" );
		}
		else {
			dataset.changed.add ( "no" );
		}
	}
	
	
		
}

function intPad ( num , size) {
	var st = "000" + num;
	return st.substring ( st.length - size );
}

function msToTime ( timeInMs, includeMs ) {
	
	var inMs = timeInMs;
	var ms = inMs % 1000;
  	inMs = ( inMs - ms) / 1000;
  	var secs = inMs % 60;
  	inMs = ( inMs - secs) / 60;
  	var mins = inMs % 60;
  	var hrs = ( inMs - mins) / 60;

	if (includeMs){
		return intPad(hrs,2) + ':' + intPad(mins,2) + ':' + intPad(secs,2) + '.' + intPad(ms,3);
	}
	else {
		return intPad(hrs,2) + ':' + intPad(mins,2) + ':' + intPad(secs,2)
	}
	

}


function fromatMs () {
	
	var includeMs = false;
	
	if ( !dataset.isEmpty("includeMs")){
		includeMs = dataset.includeMs.get();
	}
	
	if (dataset.isEmpty("inMs")){
		return "";
	}
	else {
		var inMs = dataset.get("inMs");
		return msToTime ( inMs, includeMs );	
	}
}

function tsElapsedTime ( step, timeslotUid, applyformat ) {
	
	var params, res, startstamp, endstamp, elapsedms;	
	
	if (step == null) {
		
		// Get the elapsed time already calculated
		params = new java.util.HashMap();
		params.put("uid", timeslotUid );
		res = connector.executeView(timeslotUid, "timeslot_elapsed" , params);
		elapsedms = null;
		if ( res.length > 0 ) {
			elapsedms = res[ 0 ].get("totaltime");
		}
		else {
			if (applyformat == false)
			{
				return 0;
			}
			else {
				return msToTime(0,false);
			}	
		}
		
		
	}
	else {
		//print ("step " + step );
		// Get start timestamp
		params = new java.util.HashMap();
		params.put("uid", timeslotUid );
		params.put("step", step );
		if (step == "Activation") { 
			var activationsteps = new Array();
			activationsteps.push("Activation");
			activationsteps.push("CommitEntities");
			params.put("step", activationsteps);
		}
		res = connector.executeView(timeslotUid, "timeslot_step_starttime" , params);
		startstamp = null;
		if ( res.length > 0 ) {
			startstamp = res[ 0 ].get("startdate");
		}
		
		// Get end timestamp
		params = new java.util.HashMap();
		params.put("uid", timeslotUid );
		params.put("step", step );
		if (step == "Activation") { 
			var activationsteps = new Array();
			activationsteps.push("Activation");
			activationsteps.push("CommitEntities");
			params.put("step", activationsteps);
		}
		res = connector.executeView(timeslotUid, "timeslot_step_endtime" , params);
		endstamp = null;
		if ( res.length > 0 ) {
			endstamp = res[ 0 ].get("enddate");
		}
		
		if (startstamp == null || endstamp == null){
			if (applyformat == false)
			{
				return 0;
			}
			else {
				return msToTime(0,false);
			}
		}
		
		// Calculate elapsed time in ms
		var startD = new Date (startstamp.substring(0, 4), startstamp.substring(4,6)-1,startstamp.substring(6,8),startstamp.substring(8,10),startstamp.substring(10,12),startstamp.substring(12,14) );
		var endD = new Date ( endstamp.substring(0, 4), endstamp.substring(4,6)-1,endstamp.substring(6,8),endstamp.substring(8,10),endstamp.substring(10,12),endstamp.substring(12,14) );
		elapsedms  = endD.getTime() - startD.getTime();
	
	}
	
	if (applyformat == false)
	{
		return Math.round ( elapsedms ).toFixed(0) ;
	}
	else {
		return msToTime ( elapsedms  , false );
	}
}


function elapsedTime() {
	
	var step = null ;
	var formatTime = true;
	
	if (!dataset.isEmpty("step")){
		step = dataset.step.get();
	}
	
	if (dataset.isEmpty("timeslotUid")){
		return msToTime(0,false);
	}
	
	if ( !dataset.isEmpty("formatTime")){
		formatTime = dataset.formatTime.get();
	}
	
	var timeslotUid = dataset.timeslotUid.get();
	
	return tsElapsedTime (step, timeslotUid, formatTime);
	
}

function produceJSON(){
	
	var results = "{ \"data\":[" ; 
	
	var item ;
	
	var selectedStep = null;
	
	if ( dataset.isEmpty('step') == false ) {
		if ( dataset.step.get() == "Total" ){
			selectedStep = null;
		}
		else {
			selectedStep = dataset.step.get();
		}
	}
	
	for ( var i = 0 ; i < dataset.uids.length ; i++ ) {
	
		if (i > 0 ) {
			results = results + ",";
		}
		
		item = "{ \"uid\":\""+dataset.uids.get(i)+"\",\"time\":\""+ tsElapsedTime( selectedStep , dataset.uids.get(i), false)+"\"}";
		
		results = results + item ;
	}
	
	results = results + "]}" 
	
	return results.replace(/ /g,'');
}

function paginationLimits(){
	var maxItems = 20, itemPerPage = 5;
	dataset.limitDates.clear();
	var timeslotUid = dataset.timeslotUid.get();
	
	if (!dataset.isEmpty("maxItems")){
		maxItems = dataset.maxItems.get();
	}
	
	if (!dataset.isEmpty("itemPerPage")){
		itemPerPage = dataset.itemPerPage.get();
	}
	
	// todo: limit the number of results
	var res = connector.executeView(timeslotUid, "timeslot_all");
	
	var max = 0;
	
	for ( var i = 0; i < res.length; i++ ){
		if ( res[i].get("totaltime") > max ){
			max = res[i].get("totaltime");
		}
		
		if  ( i < (maxItems-1) && (( i==0 ) || (i%itemPerPage == 0)) ){
			dataset.limitDates.add ( res[i].get("importdate").toLDAPString() );
		}
	}
	
	dataset.maxValue = max.toString();
}

function truncateToInt() {
	
	var inputVar = "";
	
	if (!dataset.isEmpty("inputVar")){
		inputVar = dataset.inputVar.get();
	}
	
	return inputVar.toFixed(0);
	
}
