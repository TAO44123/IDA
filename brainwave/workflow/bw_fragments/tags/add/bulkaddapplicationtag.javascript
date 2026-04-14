/**
 * filter keeps only the entries who don't already have the tag
 *
 * @return 
 */
function filter() {
	// prepare filtered list
	var result = new Array();
	var len = dataset.uids.length;
	for(var i=0;i<len;i++) {
		var application = dataset.uids.get(i);
		if(dataset.applicationswithtag.indexOf(application)==-1) {
			result.push(application);
		}	
	}

	// replace applications with filtered list
	var tag = dataset.tag.get();
	dataset.tags.clear();
	dataset.uids.clear();
	var len = result.length;
	for(var i=0;i<len;i++) {
		var r = result[i];
		dataset.uids.add(r);	
		dataset.tags.add(tag);	
	}
}
