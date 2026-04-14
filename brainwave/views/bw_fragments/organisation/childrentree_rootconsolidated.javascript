var /*String*/ lastKey = null;
var /*DataSet*/ lastRecord = null;
var /*Array*/ managerList = new Array();
var /*boolean*/ noMoreRecord = false;

function init() {
}

// only the first 3 in the list...
function /*String*/ convertmanagerListToString() {
    var /*String*/ fullList = '';
    var resultList;
    
    if(managerList.length==4) {
    	resultList = managerList.slice(0, 3);
    }
    else if(managerList.length>4) {
    	resultList = managerList.slice(0, 3);
    	resultList.push('...');
    }
    else {
    	resultList = managerList;
    }
    
    for (var i = 0; i < resultList.length; i++) {
        if (i > 0) {
            fullList = fullList + ', ';
        }
        fullList = fullList + resultList[i];
    }
    managerList = new Array();
    return fullList;
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
        if (! lastRecord.isEmpty('managerfullname')) {
            managerList[managerList.length] = lastRecord.managerfullname.get();
        }
    }
    // read all the records with the same key
    record = businessview.getNextRecord();
    while (record != null) {
        // check the identity key
        var /*String*/ key = record.uid.get();
        if (lastKey == key) {
            // keep the org code in the list
            if (! lastRecord.isEmpty('managerfullname')) {
                managerList[managerList.length] = record.managerfullname.get();
            }
        }
        else {
            // keep this new identity in the buffer
            var /*DataSet*/ previousRecord = lastRecord;
            lastRecord = record;
            lastKey = key;
            // the last buffered record is then returned with the org list
            previousRecord.managerfullname = convertmanagerListToString();
            if (! lastRecord.isEmpty('managerfullname')) {
                managerList[managerList.length] = record.managerfullname.get();
            }
            return previousRecord;
        }
        record = businessview.getNextRecord();
    }
    noMoreRecord = true;
    var /*DataSet*/ record = lastRecord;
    // the last buffered record is then returned with the org list
    if (lastRecord != null) {
        lastRecord = null;
        record.managerfullname = convertmanagerListToString();
    }
    return record;
}

function dispose() {
}