var /*Boolean*/ debug = false;

function ini() {
	debug = 'true'.equalsIgnoreCase( config.ias_debug );
}

ini();


/*
	Print debug information if the ias_debug configuration variable is set to True
	Does not print message otherwise
*/
function printDebug( /*String*/ message ) {
	if ( debug ) {
		print( 'DEBUG: ' + message );
	}
	return 0;
}

/*
	Truncate input 'string' if it's longer than the 'maxlength' value
	Return 'string' as is otherwise
*/
function truncateString() {
	var /*String*/ string = '';
	var /*Integer*/ maxlength = 999;	
	var /*String*/ res = '';
	// Retrieve values from Dataset
	if ( !dataset.isEmpty( 'string' ) ) {
		string = dataset.string.get();
		printDebug( 'truncateString -> string: ' + string);
	}
	if ( !dataset.isEmpty( 'maxlength' ) ) {
		maxlength = dataset.maxlength.get();
		printDebug( 'truncateString -> maxlength: ' + maxlength);
	}
	// Somehow, even if the dataset attribute is not empty, string can be null
	if ( null != string && string.length > 0) {
		res = string;
		if ( string.length > maxlength ) {
			res = string.left( maxlength );
			res = res + '...';
		}
	}
	printDebug( 'truncateString -> res: ' + res);
	return res;
}

/*
	Return the first N entries of the input
*/
function getFirstNEntries() {
	ini();
	var /*Number*/ cursor;
	var /*Number*/ size = 2000;
	var /*Attribute<Number>*/ sizeAttr;
	var /*Number*/ nbEntries = 0;
	var /*Attribute<String>*/ entriesAttr;
	var /*Attribute<String>*/ resultAttr;
	if ( !dataset.isEmpty( 'size' ) ) {
		sizeAttr = dataset.get( 'size' );
		size = sizeAttr.get();
	}
	printDebug( 'getFirstNEntries(): size=' + size);
	if ( !dataset.isEmpty( 'entries' ) ) {
		entriesAttr = dataset.get( 'entries' );
		nbEntries = entriesAttr.length;
	}
	printDebug( 'getFirstNEntries(): nb entries=' + nbEntries);
	var /*Number*/ cursor = Math.min( size, nbEntries);
	resultAttr = dataset.get( 'result' );
	for ( var /*Number*/ i = 0; i < cursor; i ++ ) {
		printDebug( ' - i = ' + i );
		printDebug( ' - entriesAttr.lenght = ' + entriesAttr.length );
		var /*String*/ entry = entriesAttr.get(0);
		printDebug( ' - entry = ' + entry );
		entriesAttr.remove( 0 );
		resultAttr.add(entry);
		printDebug( ' - resultAttr.lenght = ' + resultAttr.length );
	}
}