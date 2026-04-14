/**
 * filteridentities keeps only the identities who don't already have the tag
 *
 * @return 
 */
function filteridentities() {
	// prepare filtered list
	var result = new Array();
	var len = dataset.identities.length;
	for(var i=0;i<len;i++) {
		var identity = dataset.identities.get(i);
		if(dataset.identitieswithtag.indexOf(identity)==-1) {
			result.push(identity);
		}	
	}

	// replace identities with filtered list
	var tag = dataset.tag.get();
	dataset.tags.clear();
	dataset.identities.clear();
	var len = result.length;
	for(var i=0;i<len;i++) {
		var r = result[i];
		dataset.identities.add(r);	
		dataset.tags.add(tag);	
	}
}
