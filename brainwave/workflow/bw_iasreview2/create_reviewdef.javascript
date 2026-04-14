
import "../bw_portaluar_base/JSON.javascript"

function computeTags() {
	var /*Attribute<String>*/ configAttr = dataset.cfg;
	dataset.tags.clear();
	var i; 
	for (i=0;i<configAttr.length;i++ ){
		var json = configAttr.get(i);
		var config = JSON.parse(json);
		var /* Array */ tagsArray = config.information.compliance.tags;
		dataset.tags.add(tagsArray.join(","));
	}	
}
