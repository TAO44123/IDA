// @in uid
// @in nb
// @out riskscore

var /*String*/ lastKey = null;
var /*DataSet*/ lastRecord = null;
var /*Integer*/ riskscore = 0;
var /*boolean*/ noMoreRecord = false;

var nbrisk0 = 0;
var nbrisk1 = 0;
var nbrisk2 = 0;
var nbrisk3 = 0;
var nbrisk4 = 0;
var nbrisk5 = 0;

function init() {
}

function resetCounters() {
	nbrisk0 = 0;
	nbrisk1 = 0;
	nbrisk2 = 0;
	nbrisk3 = 0;
	nbrisk4 = 0;
	nbrisk5 = 0;
}

function updateCounters(/*Integer*/ value, /*Integer*/ risklevel) {
	if(value == null || value == 0)
		return;

	if( risklevel == null || risklevel < 0)
		risklevel = 0;
	if( risklevel > 5)
		risklevel = 5;
	
	if(risklevel == 0)
		nbrisk0 = nbrisk0 + value;
	else if(risklevel == 1) 	
		nbrisk1 = nbrisk1 + value;
	else if(risklevel == 2) 	
		nbrisk2 = nbrisk2 + value;
	else if(risklevel == 3) 	
		nbrisk3 = nbrisk3 + value;
	else if(risklevel == 4) 	
		nbrisk4 = nbrisk4 + value;
	else if(risklevel == 5) 	
		nbrisk5 = nbrisk5 + value;
}

function /*Integer*/ computeScore() {
	var score = 0;
	var r0 = transformCounter(nbrisk0);
	var r1 = transformCounter(nbrisk1);
	var r2 = transformCounter(nbrisk2);
	var r3 = transformCounter(nbrisk3);
	var r4 = transformCounter(nbrisk4);
	var r5 = transformCounter(nbrisk5);

	score = r0+
			(r1<<5)+
			(r2<<10)+
			(r3<<15)+
			(r4<<20)+
			(r5<<25);
	
	return score;
}

function /*Integer*/ transformCounter(/*Integer*/ count) {
	var nb = 0;
	nb = Math.round(Math.sqrt(2*count)); // convert the initial range to 0...31 so that we can have a bigger nb of problems (480) at the same risk level
	if(nb>31)
		nb=31; // upper bound
	return nb;
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
        var lastrisklevel = lastRecord.isEmpty('risklevel')?0:lastRecord.risklevel.get();
        var lastnb = lastRecord.isEmpty('nb')?0:lastRecord.nb.get();

        resetCounters();
        updateCounters(lastnb, lastrisklevel);
    }
    // read all the records with the same key
    record = businessview.getNextRecord();
    while (record != null) {
        // check the identity key
        var /*String*/ key = record.uid.get();
        if (lastKey == key) {
            // add score to the current risk score 
	        var risklevel = record.isEmpty('risklevel')?0:record.risklevel.get();
	        var nb = record.isEmpty('nb')?0:record.nb.get();

	        updateCounters(nb, risklevel);
        }
        else {
            // keep this new identity in the buffer
            var /*DataSet*/ previousRecord = lastRecord;
            lastRecord = record;
            lastKey = key;
            // the last buffered record is then returned with the risk score
            previousRecord.riskscore = computeScore();
            
	        // Update score
	        var lastrisklevel = lastRecord.isEmpty('risklevel')?0:lastRecord.risklevel.get();
	        var lastnb = lastRecord.isEmpty('nb')?0:lastRecord.nb.get();

	        resetCounters();
	        updateCounters(lastnb, lastrisklevel);
            
            return previousRecord;
        }
        record = businessview.getNextRecord();
    }
    noMoreRecord = true;
    var /*DataSet*/ record = lastRecord;
    // the last buffered record is then returned with the ris kscore
    record.riskscore = computeScore();

    return record;
}

function dispose() {
}