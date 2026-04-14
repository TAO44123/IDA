var /*Boolean*/ initDone = false;
var /*DataSet*/ result = null;

// Obj.date = yyyyMMdd
// Obj.status.[status] = nb
var list = new Array();
var ret = new Array();
var /*Integer*/ index = 0;

function init() {
}

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

function fillBlanks(/*String*/ firstBucket, /*String*/ lastBucket, todo, update, ok, revoke, not_reviewed) {
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
		r.date = formatDate(currentBucket);
		r.status = 'todo';
		r.nb = todo;		
		ret.push(r);
		
		r = {};
		r.date = formatDate(currentBucket);
		r.status = 'update';
		r.nb = update;		
		ret.push(r);

		r = {};
		r.date = formatDate(currentBucket);
		r.status = 'ok';
		r.nb = ok;		
		ret.push(r);

		r = {};
		r.date = formatDate(currentBucket);
		r.status = 'revoke';
		r.nb = revoke;		
		ret.push(r);

		r = {};
		r.date = formatDate(currentBucket);
		r.status = 'not reviewed';
		r.nb = not_reviewed;		
		ret.push(r);

		currentBucket = nextBucket(currentBucket);
	}
}

function onInit() {
	var /*DataSet*/ r = null;

	// consolidate KPIs
	var total = dataset.total.get();
	var currentDate = null;
	var current = null;	
	var /*Date*/ submissiondate = null;
	
	while((r=businessview.getNextRecord()) != null) {
		if(result==null)
			result = r;
			
		submissiondate = r.submissiondate.get();
		
		var /*String*/ status = r.status.get();		
		var /*String*/ statuskey = status.replace(' ', '_', 'g');
		var /*Integer*/ nb = r.nb.get();		
		var /*String*/ dateStr = r.actiondate.get().toLDAPString();

		// pour traiter le cas de la revue incrementale ou on a un actionDate < submissionDate, on force dans ce 
		// cas le démarrage du graph a la submissionDate et on ramene toutes les entrées antérieures à la date
		// du submissionDate
		if(r.actiondate.get().getTime()<submissiondate.getTime())
			dateStr = r.submissiondate.get().toLDAPString().left(8);
		else
			dateStr = dateStr.left(8);

		if(!dateStr.equals(currentDate)) {
			if(current !=null)
				list.push(current);
			currentDate = dateStr;
			current = {};
			current.date = currentDate;
			current.status = {};
			current.status[statuskey] = nb;
			total = total - nb;
			current.status['todo'] = total;
		}
		else {
			if(current.status[statuskey] === undefined) {
				current.status[statuskey] = nb;
				total = total - nb;
				current.status['todo'] = total;
			}
			else {
				current.status[statuskey] = current.status[statuskey] + nb;
				total = total - nb;
				current.status['todo'] = total;
			}
		}
	}
	if(result==null) // empty dataset
		return; 
	if(current !=null)
		list.push(current);

	// first slot
	submissiondate = submissiondate.toLDAPString().left(8);

	// if the review is empty or did not have reviewers in the first day, start by an empty backlog	
	if(list.length==0 || !submissiondate.equals(list[0].date)) {
		r = {};
		r.date = formatDate(submissiondate);
		r.status = 'todo';
		r.nb = dataset.total.get();		
		ret.push(r);
			
		r = {};
		r.date = formatDate(submissiondate);
		r.status = 'update';
		r.nb = 0;		
		ret.push(r);
	
		r = {};
		r.date = formatDate(submissiondate);
		r.status = 'ok';
		r.nb = 0;		
		ret.push(r);
	
		r = {};
		r.date = formatDate(submissiondate);
		r.status = 'revoke';
		r.nb = 0;		
		ret.push(r);

		r = {};
		r.date = formatDate(submissiondate);
		r.status = 'not reviewed';
		r.nb = 0;		
		ret.push(r);
	}
		
	// prepare results table
	var i=0;
	var r = null;
	var counters = {};
	var prevdate = null;
	while(i<list.length) {
		var d = list[i];
		
		if(i>0) {
			prevdate = list[i-1].date;
			fillBlanks(prevdate, d.date, todo, counters.update, counters.ok, counters.revoke, counters.not_reviewed);		
		}
		else {
			if(list.length>0) {
				// we start the iteration and fill in the blanks because nothing had been reviewed on the first day
				prevdate = submissiondate;
				fillBlanks(prevdate, d.date, dataset.total.get(), 0, 0, 0);		
			}
		}

		var date = formatDate(d.date);
		var todo = d.status.todo;
		var ok = (d.status.ok === undefined)?0:d.status.ok;
		var revoke = (d.status.revoke === undefined)?0:d.status.revoke;
		var update = (d.status.update === undefined)?0:d.status.update;
		var not_reviewed = (d.status.not_reviewed === undefined)?0:d.status.not_reviewed;

		if(i==0) {
			counters.ok = ok;	
			counters.revoke = revoke;	
			counters.update = update;	
			counters.not_reviewed = not_reviewed;	
		}
		else {
			counters.ok = counters.ok + ok;	
			counters.revoke = counters.revoke + revoke;	
			counters.update = counters.update + update;	
			counters.not_reviewed = counters.not_reviewed + not_reviewed;	
		}		

				
		r = {};
		r.date = date;
		r.status = 'todo';
		r.nb = todo;		
		ret.push(r);
		
		r = {};
		r.date = date;
		r.status = 'update';
		r.nb = counters.update!=null?counters.update:0;		
		ret.push(r);

		r = {};
		r.date = date;
		r.status = 'ok';
		r.nb = counters.ok!=null?counters.ok:0;		
		ret.push(r);

		r = {};
		r.date = date;
		r.status = 'revoke';
		r.nb = counters.revoke!=null?counters.revoke:0;		
		ret.push(r);

		r = {};
		r.date = date;
		r.status = 'not reviewed';
		r.nb = counters.not_reviewed!=null?counters.not_reviewed:0;		
		ret.push(r);
	
		i = i+1;	
	}
}

function read() {
	if(!initDone) {
		initDone = true;
		onInit();
	}

	if(index>=ret.length)
		return null;
		
	var data = ret[index];
	index = index + 1;

	if(result == null) {
		result = new DataSet();
		result.add("date", "String", false);
		result.add("status", "String", false);
		result.add("nb", "Number", false);
	}	
	result.bucket = data.date;
	result.status = data.status;
	result.nb = data.nb;
	
	return result;		
}

function dispose() {
}
