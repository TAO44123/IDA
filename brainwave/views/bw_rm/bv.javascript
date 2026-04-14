
/**
* ## Aggregate script filter ##
* 
* This script is a generic version of the aggreate sample script (@see 
* https://support.brainwavegrc.com/jira/expertexchange/Ader/docs/igrc-platform/business-view/components/index.html#example-1-aggregate )
* 
* It can aggregate multiple lines wich have a column ("key column") with an identical value.
* 
* To use it,
* 1. change the value of the following variables :
* @param key_column_name (String): name of the column containing the key. All
*   lines with an identical value will be aggregates. Note: the dataset need
*   to be sorted on this column to work properly.
* @param aggregate_column_names (String array): names of the columns to 
*   aggregate. For columns not listed in this array, only the value of the
*   last record will be kept.
* @param separator (String): separator between aggregated values.
* @param keepEmpty (boolean): true to keep empties values and preserve
*   cardinality.
*   For exemple if in a column, for 3 lines, the first one has the value "xx",
*   the second one is empty, the last one has the value "yy" and the 
*   separator is "/", the aggregated value will be "xx//yy" if keepEmpty is
*   true, "xx/yy" otherwise.
* 
* 2. add a script filter to the end of your BV.
* 
* 3. configure the script filter to call the "init" and "read" functions.
* 
* 4. do not forget to sort the previous view on the key column.
* 
* Note: if your key is not on a unique column, edit the getKey() function to use a key that spread on multiple columns.
* 
*/

/**
* Configuration variables
*/
var /*String*/ key_column_name = "code";
var /*Array*/ aggregate_column_names = ["role_code", "role_name", "role_color"];
var /*String*/ separator = ", ";
var /*boolean*/ keepEmpty = false;

/****************************/


var /*Object*/ lastKey = null;
var /*DataSet*/ lastRecord = null;
var /*boolean*/ noMoreRecord = false;
var /*Array*/ list = new Array();

/**
* Get the key for a record (modify this function to use a key that spread on multiple columns)
* @param record
*/
function /*Object*/ getKey(/*DataSet*/ record) {
	return record.get(key_column_name).get();
}

/**
* Initialise lists
*/
function initList() {
	for (var i = 0; i < aggregate_column_names.length; i++) {
		list[i] = new Array();
	}
}

/**
* Add a values to aggregated columns lists
* @param record
*/
function pushColsToList(/*DataSet*/ record) {
	for (var i = 0; i < aggregate_column_names.length; i++) {
        if (! record.isEmpty(aggregate_column_names[i])) {
            list[i].push(record.get(aggregate_column_names[i]).get());
        } else if (keepEmpty) {
        	list[i].push("");
        }
	}
}

/**
 * Concat list items to a String
 * @param list 
 * @return concatenated string
 */
function /*String*/ convertListToString(/*Array*/ list) {
    var /*String*/ fullList = '';
    for (var i = 0; i < list.length; i++) {
        if (i > 0) {
            fullList = fullList + separator;
        }
        fullList = fullList + list[i];
    }
    return fullList;
}

/**
 * Fill record with aggregated values and reset lists
 * @param record 
 */
function fillRecordWithAggregatedValues(record) {
	for (var i = 0; i < aggregate_column_names.length; i++) {
	    record.get(aggregate_column_names[i]).set(convertListToString(list[i]));
	}
	initList();
}

/**
 * return the next record
 * @return 
 */
function /*DataSet*/ read() {
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
		pushColsToList(lastRecord);
    }
    // read all the records with the same key
    var /*DataSet*/record = businessview.getNextRecord();
    while (record != null) {
        // check the entry key
        var /*String*/ key = getKey(record);
        if (lastKey == key) {
            // keep the code in the list
			pushColsToList(record);
        }
        else {
            // keep this new entry in the buffer
            var /*DataSet*/ previousRecord = lastRecord;
            lastRecord = record;
            lastKey = key;
            // the last buffered record is then returned with the list
            fillRecordWithAggregatedValues(previousRecord);
			pushColsToList(record);
            return previousRecord;
        }
        record = businessview.getNextRecord();
    }
    noMoreRecord = true;
    record = lastRecord;
    // the last buffered record is then returned with the list
    if (lastRecord != null) {
        lastRecord = null;
        fillRecordWithAggregatedValues(record);
    }
    return record;
}

/**
 * init
 */
function init() {
	initList();
}

