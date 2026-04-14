var /*java.util.HashSet*/ set = null; // this will contains all the possible values
var /*java.util.Iterator*/ it = null; // iterator over the set

var /*Array*/ values = null;
var /*DataSet*/ dataSet = null;

var /*String*/ lastKey = null;
var /*DataSet*/ lastDataSet = null;

var /*java.util.HashMap*/ hash = null; // HashMap (key, values (SUM))
var /*java.util.HashMap*/ datasets = null; // Set of datasets (key, datasets)

/*
 * Sums the values of the aggr_attr_name attribute for each key_attr_name
 * Call the aggregateSumRead afterwards to retrieve the results
 * Designed to work with unsorted views (using a computed column for instance)
*/
function aggregateSumIni(/*BusinessView*/ bv, /*String*/ key_attr_name, /*String*/ aggr_attr_name) {
	var /*Attribute*/ key;
	var /*String*/ keyStr;
	var /*Attribute*/ value;
	var /*Number*/ nb;
	if( hash == null)
		hash = new java.util.HashMap();
	if( datasets == null)
		datasets = new java.util.HashMap();
	dataSet = bv.getNextRecord();
	while ( dataSet != null) {
		if( dataSet.isEmpty(key_attr_name) || dataSet.isEmpty(aggr_attr_name))
			continue;
		key = dataSet.get(key_attr_name);
		keyStr = key.getAsString(0);
		value = dataSet.get(aggr_attr_name);
		//nb = Number(value.get());	
		nb = 1;
		if( hash.containsKey(keyStr) ) {
			nb += Number(hash.get(keyStr));
			hash.replace(keyStr, nb);
		} else {
			hash.put(keyStr, nb);
			datasets.put(keyStr, dataSet);
		}
		dataSet = bv.getNextRecord();
	}
}

/*
 * The function called by the onScriptRead in the BusinessView
 * returns one dataset for each key (key_attr_name in the aggregateSumIni function)
 * with the SUM for the aggr_attr_name values
 * and the other attributes of the datasets as is
*/
function /*DataSet*/ aggregateSumRead(/*String*/ aggr_attr_name){
	var /*String*/ key;
	var /*Attribute*/ value;
	var /*Number*/ nb;
	it = hash.keySet().iterator();
	while ( it.hasNext() ) {
		key = it.next().toString();
		if( datasets.containsKey(key) ) {
			if( hash.containsKey(key) ) {
				nb = Number (hash.get(key));
				hash.remove(key);
				if( nb != null ) {
					var dataSet = datasets.get(key);
					if( dataSet != null) {
						value = dataSet.get(aggr_attr_name);
						if( value != null) {
							value.set(0, nb.toFixed(0));
						}
						return dataSet;
					}
				}
			}
		}
	}
	return null;
}