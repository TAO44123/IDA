var /*Boolean*/ debug = 'true'.equalsIgnoreCase( config.ias_debug );

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