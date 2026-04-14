var noMoreRecord = false;
var counter = 0;
var prev = -1;

function init() {
}

function read() {
    if (noMoreRecord) {
        return null;
    }

    record = businessview.getNextRecord();
    if (record== null) {
        noMoreRecord = true;
        return null;
    }

	var score = record.score.get();
	if(score!=prev) {    
    	counter = counter + 1;
		prev = score;
	}

    record.riskrank = counter;
    
    return record;
}

function dispose() {
}
