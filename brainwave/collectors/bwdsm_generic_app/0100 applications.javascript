/*
   retrievs the first file that matches the silo file pattern in the genericapp folder subfolder for this datasource
*/

function computeFilePath(){
	var /*String*/ code = dataset.code.get();
	var /*String*/ sourcePath = config.bwdsm_genericapp_sourceFolder + "/"+ code; 
   // could also be compted generically:  var /*String*/ sourcePath = config[dataset.destpathvar.get()]+ "/" + code; 
	var /*String*/ filepattern = dataset.filepattern.get();
	var /*java.io.File*/ datasourceDir = new java.io.File(sourcePath);	
	var /*java.io.File[]*/ elements = datasourceDir.listFiles();
	if (elements !== null){
		for(var i=0;i<elements.length;i++) {
			var /*java.io.File*/ element = elements[i];
			if(!element.isDirectory()){
				// use same matcher class than silo 
				if (com.brainwave.iaudit.database.tools.WildcardMatcher.wildcardMatch(element.getName(),filepattern )) {
	            	var /*String*/filepath = element.getCanonicalPath(); 
	            	dataset.filepath.set(filepath);
	            	return;
				}
			}
		}
	}
	// file not found
}