var /*Boolean*/ initDone = false;

var /*DataSet*/ res = null;
var list = new Array();
var /*Integer*/ index = 0;

function formatDate(str) {
	var ret = str.left(4)+'-'+str.substring(4).left(2)+'-'+str.substring(6).left(2);	
	return ret;
}

function nextBucket(/*String*/ bucket) {
	var /*Number*/ year = parseInt(bucket.left(4), 10);
	var /*Number*/ month = parseInt(bucket.substring(4).left(2), 10);
	var /*Number*/ day = parseInt(bucket.substring(6).left(2), 10);

	var cDate = new Date();
	cDate.setFullYear(year, month-1, day);
	cDate = cDate.add('d', 1);
	
	var /*String*/ result = cDate.toLDAPString();
	result = result.left(8);
	
	return result;
}

function fillBlanks(/*String*/ firstBucket, /*String*/ lastBucket) {
	if(firstBucket.equals(lastBucket))
		return;
		
	var forceExit = 1000;
	var /*String*/ currentBucket = nextBucket(firstBucket);
	while(!currentBucket.equals(lastBucket)) {
		// this should never happens but...
		forceExit = forceExit -1;
		if(forceExit==0)
			break;

		var r = {};
		r.bucket = formatDate(currentBucket);
		r.nb = 0;
		list.push(r);

		currentBucket = nextBucket(currentBucket);
	}
}

function onInit() {
	initDone = true;

	var /*String*/ bucket = null;
	var /*Integer*/ count = 0;
	var /*DataSet*/ r;
	while( (r=businessview.getNextRecord())!=null ) {
		if(res==null) {
			res = r;
			var d1 = r.submissiondate.get().toLDAPString().left(8);
			var d2 = r.actiondate.get().toLDAPString().left(8);

			// pour traiter le cas de la revue incrementale ou on a un actionDate < submissionDate, on force dans ce 
			// cas le démarrage du graph a la submissionDate et on ramene toutes les entrées antérieures à la date
			// du submissionDate
			if(r.actiondate.get().getTime()<r.submissiondate.get().getTime())
				d2 = d1;

			if(!d1.equals(d2)) {
				var json = {};
				json.bucket = formatDate(d1);
				json.nb = 0;
				list.push(json);
			}
			fillBlanks(d1, d2);
		}
		
		var /*String*/ b;
		// pour traiter le cas de la revue incrementale ou on a un actionDate < submissionDate, on force dans ce 
		// cas le démarrage du graph a la submissionDate et on ramene toutes les entrées antérieures à la date
		// du submissionDate
		if(r.actiondate.get().getTime()<r.submissiondate.get().getTime())
			b = r.submissiondate.get().toLDAPString();
		else
			b = r.actiondate.get().toLDAPString();

		b = b.left(8);
		var nb = r.nb.get();

		if(bucket == null) {
			bucket = b;
			count = nb;	
		}
		else if(b.equals(bucket)) {
			count = count + nb;	
		}
		else {
			var json = {};
			json.bucket = formatDate(bucket);
			json.nb = count;
			list.push(json);

			fillBlanks(bucket, b);

			bucket = b;
			count = nb;
		}
	}
	
	if(count>0) {
		var r = {};
		r.bucket = formatDate(bucket);
		r.nb = count;
		list.push(r);
	}
}

function read() {
	if(!initDone)
		onInit();
	
	if(index>=list.length)
		return null;
		
	var r = list[index];
	index = index + 1;

	res.bucket = r.bucket;
	res.nb = r.nb;
	
	return res;
}
