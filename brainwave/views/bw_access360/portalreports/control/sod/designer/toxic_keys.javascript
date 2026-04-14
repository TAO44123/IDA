var /*java.util.HashMap*/ keys;
// Hashmap keyset iterator
var iterator;

function ini() {
	keys = new java.util.HashMap();
	if (dataset.duplicatekeys.get()) {
		for(i=0;i<dataset.get("toxickeys").length;i++) {
			keys.put(2*i, [dataset.toxickeys.get(i), dataset.risklevels.get(i)]);
			newkkey = dataset.toxickeys.get(i).split("$$$")[1]+"$$$"+dataset.toxickeys.get(i).split("$$$")[0];
			keys.put(2*i+1, [newkkey, dataset.risklevels.get(i)]);
		}
	}
	else {
		for(i=0;i<dataset.get("toxickeys").length;i++) {
			keys.put(i, [dataset.toxickeys.get(i), dataset.risklevels.get(i)]);
		}
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
		var /*Boolean*/ isduplicate = false;
		if (dataset.duplicatekeys.get()) {
			if (currentKey % 2 == 1) {
				isduplicate = true;
			}
		}
		results.add( 'toxicKey', 'String', false );
		results.add( 'permission1uid', 'String', false );
		results.add( 'permission2uid', 'String', false );
		results.add( 'risklevels', 'Number', false );
		results.add( 'isduplicate', 'Boolean', false );
		results.get( 'toxicKey' ).set(0, currentValue[0] );
		results.get( 'permission1uid' ).set(0, currentValue[0].split("$$$")[0]);
		results.get( 'permission2uid' ).set(0, currentValue[0].split("$$$")[1]);
		results.get( 'risklevels' ).set(0, currentValue[1]);
		results.get( 'isduplicate' ).set(0, isduplicate);
		
		return results;
	}
	return null;
}