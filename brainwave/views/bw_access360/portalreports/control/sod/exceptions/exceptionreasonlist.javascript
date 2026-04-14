var /*java.util.HashMap*/ exceptions;
// Hashmap keyset iterator
var iterator;

function ini() {
	exceptions = new java.util.HashMap();
	exceptions.put( 'Resource constraints', 'Resource constraints' );
	exceptions.put( 'Business Continuity or Urgency', 'Business Continuity or Urgency' );
	exceptions.put( 'Specialized Roles or High Security Clearance', 'Specialized Roles or High Security Clearance' );
	exceptions.put( 'Temporary Needs', 'Temporary Needs' );
	exceptions.put( 'Audit-Driven Justifications', 'Audit-Driven Justifications' );
}

function read() {
	if ( iterator == null ) {
		iterator = exceptions.keySet().iterator();
	}
	if ( iterator.hasNext() ) {
		var /*String*/ currentKey = iterator.next().toString();
		var /*String*/ currentValue = exceptions.get( '' + currentKey );
		var /*DataSet*/ results = new DataSet();
		results.add( 'exception_code', 'String', false );
		results.add( 'exception_name', 'String', false );
		results.get( 'exception_code' ).set(0, currentKey );
		results.get( 'exception_name' ).set(0, currentValue );
		return results;
	}
	return null;
}