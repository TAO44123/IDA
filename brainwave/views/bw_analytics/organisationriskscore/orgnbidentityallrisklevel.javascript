// organisation risk score
//
// The idea is to score each organisation by the ratio of identities having risk per risk level
// score format is the following:
// RLR5RLR4RLR3RLR2RLR1RLR0
// Where RLRX is the percent of identities having a problem of risk level X, values are concatened in a bit field to facilitate 32bits integer ordering
// At the end of the day, the higher the riskscore, the higher the ratio of people within the organisation with high risks
// @out riskscore

var /*String*/ lastKey = null;
var /*DataSet*/ lastRecord = null;
var /*boolean*/ noMoreRecord = false;

var /*Integer*/ nbrisk0 = 0;
var /*Integer*/ nbrisk1 = 0;
var /*Integer*/ nbrisk2 = 0;
var /*Integer*/ nbrisk3 = 0;
var /*Integer*/ nbrisk4 = 0;
var /*Integer*/ nbrisk5 = 0;

function init() {
}

function computeOrgRiskScore(/*Integer*/ totalidentititesinorg) {
	var ratio0 = Math.round((31*nbrisk0)/totalidentititesinorg);
	var ratio1 = Math.round((31*nbrisk1)/totalidentititesinorg);
	var ratio2 = Math.round((31*nbrisk2)/totalidentititesinorg);
	var ratio3 = Math.round((31*nbrisk3)/totalidentititesinorg);
	var ratio4 = Math.round((31*nbrisk4)/totalidentititesinorg);
	var ratio5 = Math.round((31*nbrisk5)/totalidentititesinorg);

	var score = ratio0+
				(ratio1<<5)+
				(ratio2<<10)+
				(ratio3<<15)+
				(ratio4<<20)+
				(ratio5<<25);

	//return score;
	return ratio0+
			ratio1+
			ratio2+
			ratio3+
			ratio4+
			ratio5;
}
function resetRiskCounters() {
	nbrisk0 = 0;
	nbrisk2 = 0;
	nbrisk3 = 0;
	nbrisk4 = 0;
	nbrisk5 = 0;
}
function updateRiskCounters(/*Integer*/ riskscore) {
	if((riskscore & 0x1F) != 0) nbrisk0++;
	if((riskscore & 0x3E0) != 0) nbrisk1++;
	if((riskscore & 0x7C00) != 0) nbrisk2++;
	if((riskscore & 0xF80000) != 0) nbrisk3++;
	if((riskscore & 0x1F00000) != 0) nbrisk4++;
	if((riskscore & 0x3E000000) != 0) nbrisk5++;
}
function read() {
    // check if the source has no more record
    if (noMoreRecord) {
        return null;
    }
    else if (lastRecord == null) {
        // this is the first time a record is read to initiate the buffering
        lastRecord = businessview.getNextRecord();
        if (lastRecord == null) {
            noMoreRecord = true;
            return null;
        }
        lastKey = lastRecord.uid.get();

        // Update score
		resetRiskCounters();
		
        var riskscore = lastRecord.isEmpty('aggriskscore')?0:lastRecord.aggriskscore.get();
        updateRiskCounters(riskscore);
    }
    // read all the records with the same key
    record = businessview.getNextRecord();
    while (record != null) {
        // check the org key
        var /*String*/ key = record.uid.get();
        if (lastKey == key) {
            // update counters
	        var riskscore = record.isEmpty('aggriskscore')?0:record.aggriskscore.get();
	        updateRiskCounters(riskscore);
        }
        else {
            // keep this new org in the buffer
            var /*DataSet*/ previousRecord = lastRecord;
            lastRecord = record;
            lastKey = key;

            // the last buffered record is then returned with the risk score
			var totalinorg = previousRecord.nbtotalmembers.get();
			var orgscore = computeOrgRiskScore(totalinorg);
            previousRecord.orgscore = orgscore;
            
	        // Update score
	        resetRiskCounters();
			
	        var riskscore = record.isEmpty('aggriskscore')?0:record.aggriskscore.get();
	        updateRiskCounters(riskscore);
            
            return previousRecord;
        }
        record = businessview.getNextRecord();
    }
    noMoreRecord = true;
    var /*DataSet*/ record = lastRecord;

    // the last buffered record is then returned with the ris kscore
	var totalinorg = record.nbtotalmembers.get();
	var orgscore = computeOrgRiskScore(totalinorg);

    record.orgscore = orgscore;

    return record;
}

function dispose() {
}