var /*java.util.HashMap*/ keys;
// Hashmap keyset iterator
var iterator;

function ini() {
	keys = new java.util.HashMap();
	for(i=0;i<dataset.get("matrixcode").length;i++) {
		keys.put(i, [
			dataset.matrixcode.get(i),
			dataset.permission1code.get(i),
			dataset.application1code.get(i),
			dataset.permission2code.get(i),
			dataset.application2code.get(i),
			dataset.matrixenabled.get(i),
			dataset.risklevels.get(i)
		]);
	}
}

function read() {
	if ( iterator == null ) {
		iterator = keys.keySet().iterator();
	}
	if ( iterator.hasNext() ) {
		var /*Number*/ currentKey = Number ( iterator.next() );
		currentKey = currentKey.toFixed(0);
		var /*String*/ currentValue = keys.get(Number(currentKey));
		var /*DataSet*/ results = new DataSet();
		results.add( 'matrixcode', 'String', false );
		results.add( 'permission1key', 'String', false );
		results.add( 'permission2key', 'String', false );
		results.add( 'matrixenabled', 'Boolean', false );
		results.add( 'risklevels', 'Number', false );
		results.get( 'matrixcode' ).set(0, currentValue[0] );
		results.get( 'permission1key' ).set(0, currentValue[1]+"$$$"+currentValue[2]);
		results.get( 'permission2key' ).set(0, currentValue[3]+"$$$"+currentValue[4]);
		results.get( 'matrixenabled' ).set(0, currentValue[5]);
		results.get( 'risklevels' ).set(0, currentValue[6]);
		
		return results;
	}
	return null;
}