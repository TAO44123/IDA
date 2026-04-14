function cleanup() {
	if(dataset.isEmpty('intArray'))
		return null;

	for(var i = 0; i < dataset.intArray.length;i++) {
		var /*Number*/ val = dataset.intArray.get(i);
		if(val>=0)
			dataset.result.add(val);
	}
}