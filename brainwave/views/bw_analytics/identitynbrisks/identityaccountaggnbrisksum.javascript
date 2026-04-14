var /*String*/ lastKey = null;
var /*DataSet*/ lastRecord = null;
var /*Array*/ orgList = new Array();
var /*boolean*/ noMoreRecord = false;
var /*number*/ count = 0; 
function init() {
}

function read() {
    // check if the source has no more record
    if (noMoreRecord) {
        return null;
    }
    else if (lastRecord == null) {
        // this is the first time a record is read to initiate the buffering
        count = 0;
        lastRecord = businessview.getNextRecord();
        if (lastRecord == null) {
            noMoreRecord = true;
            return null;
        }
        lastKey = lastRecord.uid.get()
        if (! lastRecord.isEmpty('peraccountnb')) {
            count = count + lastRecord.peraccountnb.get();
        }
    }
    // read all the records with the same key
    record = businessview.getNextRecord();
    while (record != null) {
        // check the identity key
        var /*String*/ key = record.uid.get();
        if (lastKey == key) {
            // keep the org code in the list
            if (! lastRecord.isEmpty('peraccountnb')) {
                count = count + record.peraccountnb.get();
            }
        }
        else {
            // keep this new identity in the buffer
            var /*DataSet*/ previousRecord = lastRecord;
            lastRecord = record;
            lastKey = key;
            // the last buffered record is then returned with the org list
            previousRecord.accountnb = count;
            count = 0;
            if (! lastRecord.isEmpty('peraccountnb')) {
                count = count + record.peraccountnb.get();
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
        record.accountnb = count;
        count = 0;
    }
    return record;
}

function dispose() {
}