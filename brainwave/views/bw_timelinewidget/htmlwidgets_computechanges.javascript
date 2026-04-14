/**
 * Compute the changes that occured between the different timeslots for a given object
 * Only 4 attributes are required: timeslotuid, timeslotcommitdate and uid
 * the dataset MUST be ordered by timeslotuid, trends will be computed on timeslotuid per timeslotuid basis
 * You just have to provide a view with all the values, this filter will aggregate the result with two new attributes for each timeslot:
 * nbadded and nbremoved
 */

var /*java.util.HashSet*/ reftsids = null;
var /*java.util.HashSet*/ curtsids = new java.util.HashSet();
var currentTimeslot = null;
var timeslotStack = [null];
var timeslotdateStack = [null];

var /*DataSet*/ lastRecord = null;
var /*DataSet*/ bufferedRecord = null;

var labeladded = '<nbadded> added';
var labelremoved = '<nbremoved> removed';
var descriptionadded  = '<nbadded> entries added';
var descriptionremoved = '<nbremoved> entries removed';

function init() {
	if(dataset.labeladded!=null)
		labeladded = dataset.labeladded;
	if(dataset.labelremoved!=null)
		labelremoved = dataset.labelremoved;
	if(dataset.descriptionadded!=null)
		descriptionadded = dataset.descriptionadded;
	if(dataset.descriptionremoved!=null)
		descriptionremoved = dataset.descriptionremoved;
}

function read() {
    var /*DataSet*/ record;
    if(lastRecord!=null)
    	record = lastRecord;
    else
    	record = businessview.getNextRecord();
	if(record == null)
		return null;
		
	var /*String*/ timeslotuid = record.timeslotuid.get();
	var /*String*/ uid = null;
	if(record.timeslotuid.get() != timeslotStack[0])
		timeslotStack.unshift(record.timeslotuid.get());
	if(record.timeslotcommitdate.get().toLDAPString() != timeslotdateStack[0])
		timeslotdateStack.unshift(record.timeslotcommitdate.get().toLDAPString());

	if(currentTimeslot == null)
		currentTimeslot = timeslotuid;

	var newEntries = 0;
	var removedEntries = 0;

	while(record!=null && currentTimeslot == timeslotuid) {
		bufferedRecord = record;
		uid = record.uid.get();
		if(reftsids!=null) {
			if(!reftsids.contains(uid)) {
				// compute added entries
				newEntries++;
			}
			else {
				reftsids.remove(uid);
			}
		}

		curtsids.add(uid);

	    record = businessview.getNextRecord();
	    if(record!=null)
			timeslotuid = record.timeslotuid.get();
	}

	// compute removed entries
	if(reftsids!=null)
		removedEntries = reftsids.size();

	// prepare for next round
	lastRecord = record;
	currentTimeslot = timeslotuid;
	reftsids = curtsids;
	curtsids = new java.util.HashSet();

	var attr = new Attribute("nbadded", "Number", false);
	attr.set(newEntries);
	bufferedRecord.add(attr);
	attr = new Attribute("nbremoved", "Number", false);
	attr.set(removedEntries);
	bufferedRecord.add(attr);
	attr = new Attribute("previoustimeslotuid", "String", false);
	attr.set(timeslotStack[1]);
	bufferedRecord.add(attr);
	attr = new Attribute("previoustimeslotcommitdate", "Date", false);
	attr.set(timeslotdateStack[1]);
	bufferedRecord.add(attr);
	bufferedRecord.uid = null;

	var label = '';
	if(newEntries>0) {
		if(label.length>0)
			label = label + ', ';
		label = label + patch(bufferedRecord, labeladded);
	}
	if(removedEntries>0) {
		if(label.length>0)
			label = label + ', ';
		label = label + patch(bufferedRecord, labelremoved);
	}

	var description = '';
	if(newEntries>0) {
		if(description.length>0)
			description = description + ', ';
		description = description + patch(bufferedRecord, descriptionadded);
	}
	if(removedEntries>0) {
		if(description.length>0)
			description = description + ', ';
		description = description + patch(bufferedRecord, descriptionremoved);
	}


	label = patch(bufferedRecord, label);
	description = patch(bufferedRecord, description);

	attr = new Attribute("label", "String", false);
	attr.set(label);
	bufferedRecord.add(attr);
	attr = new Attribute("description", "String", false);
	attr.set(description);
	bufferedRecord.add(attr);

    return bufferedRecord;
}

function dispose() {
}

function patch(data, str) {
	var ret = '';
	
	while(str.length>0) {
		var i = str.indexOf('<');
		if(i>=0) {
			var beg = str.substring(0, i);
			str = str.substring(i+1);
			ret+=beg;
			
			i = str.indexOf('>');
			if(i>=0) {
				var content = str.substring(0, i);
				str = str.substring(i+1);
				
				var patchedcontent = data.get(content);
				if(patchedcontent!=null)
					ret+=patchedcontent;
			}
		}
		else {
			ret += str;
			str = '';
		}
	}
	
	return ret;
}