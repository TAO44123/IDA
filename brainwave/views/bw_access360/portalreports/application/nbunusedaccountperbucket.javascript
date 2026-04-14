var /*boolean*/ initdone = false;
var count = 0;
var lastbucket = 'NaN';



var results = new Array();
var index = 0;

var /*DataSet*/ ds = null;

function init() {
}

function nextBucket(/*String*/ bucket) {
	var /*Number*/ year = parseInt(bucket.left(4), 10);
	var /*Number*/ month = parseInt(bucket.substring(4), 10);

	month = month + 1;
	if(month == 13) {
		month = 1;
		year = year + 1;		
	}	

	var /*String*/ result = ('0000'+year).right(4)+('0'+month).right(2);

	return result;
}

function fillBlanks(/*String*/ firstBucket, /*String*/ lastBucket) {
	if(firstBucket.equals(lastBucket))
		return;
		
	var /*String*/ currentBucket = nextBucket(firstBucket);
	while(!currentBucket.equals(lastBucket)) {
		pushEntry(currentBucket, 0);
		currentBucket = nextBucket(currentBucket);
	}
}

function pushEntry(/*String*/ bucket, /*Number*/ nb) {
	var data = {};
	data.bucket = bucket;
	data.nb = nb;
	results.push(data);		
}
	
function doInit() {
	initdone = true;
	var /*DataSet*/ record = null;
	
	while((record = businessview.getNextRecord()) != null) {
		var /*String*/ bucket = record.bucket.get();
	
		// new bucket
		if(!lastbucket.equals(bucket)) {
			// very first line, init year&month
			ds = record;
			if(lastbucket.equals('NaN')) {
				lastbucket = bucket;
				count = 1;
			}
			// add new entry
			else {
				pushEntry(lastbucket, count);
				fillBlanks(lastbucket, bucket);
				lastbucket = bucket;
				count = 1;	
			}	
		}
		else {
			count = count+1;	
		}
	}

	// add the last bucket (if at least one entry has been listed)
	if(!lastbucket.equals('NaN')) {
		pushEntry(lastbucket, count);
	}
}


function read() {
	if(!initdone) {
		doInit();
	}

	if(index>=results.length)
		return null;

	var entry = results[index];
	index = index + 1;

	ds.bucket.set(entry.bucket);
	ds.bucketlabel.set( entry.bucket.left(4)+'/'+entry.bucket.right(2) );
	ds.nb.set(entry.nb);

	return ds;
}

function dispose() {
}
