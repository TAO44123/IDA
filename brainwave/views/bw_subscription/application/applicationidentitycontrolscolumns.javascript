var /*String*/ lastKey = null;
var /*DataSet*/ lastRecord = null;
var /*Array*/ aggList = new Array();
var /*boolean*/ noMoreRecord = false;

var controls = [ "ACC17" ]

function init() {
}

function /*String*/ getKey(/*Dataset*/ record) {
	return ''+record.identityuid.get();
}

function /*String*/ getValue(/*Dataset*/ record) {
	return ''+record.control.get();
}

function hasValue(val) {
	for(var i=0;i<aggList.length;i++) {
		var col = aggList[i];
		if(val.equals(col))
			return true;
	}
	return false
}

/**
 * createColumns met a jour les colonnes de controle avec les valeurs
 * @param record 
 * @return 
 */
function updateColumns(record) {
	for(var i=0;i<controls.length;i++) {
		var ctrl = ''+controls[i];
		if(record.get(ctrl)==null) {
			record.add(ctrl, "Number", false);
		}
		
		if(hasValue(ctrl)) {
			record.get(ctrl).set(1);
		}
		else {
			record.get(ctrl).set(0);
		}
	}
	aggList = new Array();
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
        lastKey = getKey(lastRecord);
        var val = getValue(lastRecord);
        if(val!=null)
        	aggList[aggList.length] = val; 
    }
    // read all the records with the same key
    record = businessview.getNextRecord();
    while (record != null) {
        // check the identity key
        var /*String*/ key = getKey(record);
        if (lastKey == key) {
        	var val = getValue(record);
        	if(val!=null)
            	aggList[aggList.length] = val;
        }
        else {
            // keep this new identity in the buffer
            var /*DataSet*/ previousRecord = lastRecord;
            lastRecord = record;
            lastKey = key;
            // the last buffered record is then returned with the org list
            updateColumns(previousRecord);
            var val = getValue(record);
            if(val!=null)
            	aggList[aggList.length] = val;
            return previousRecord;
        }
        record = businessview.getNextRecord();
    }
    noMoreRecord = true;
    var /*DataSet*/ record = lastRecord;
    // the last buffered record is then returned with the org list
    if (lastRecord != null) {
        lastRecord = null;
        updateColumns(record);
    }
    return record;
}

function dispose() {
}