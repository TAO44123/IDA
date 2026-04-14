
function init(){
	dataset.identity_repo = searchIdentityRepo();
}

function searchIdentityRepo() {
	var /*java.io.File*/ sourceDir = new java.io.File(config.bw_cyberark_model_sourceFolder).listFiles();
	var isRightRepo = false;
	var identityRepoName = "";
	if (sourceDir == null){
		return false;
	}
	for(var i = 0; i < sourceDir.length; i++){
		if(sourceDir[i].getName().toUpperCase().contains(dataset._REPOSITORY_CODE_)) {
			isRightRepo = true;
		}
		if(sourceDir[i].isFile() && sourceDir[i].getName().endsWith("_Repository_Mapping.csv")){
			identityRepoName = sourceDir[i].getName().substring(0, sourceDir[i].getName().indexOf("_Repository_Mapping.csv"));
		}
		if(isRightRepo && (!identityRepoName.isEmpty())){
			return identityRepoName;
		}
		if(sourceDir[i].isDirectory()){
			isRightRepo = false;
			identityRepoName = "";
			var /*java.io.File*/ subDirList = new java.io.File(config.bw_cyberark_model_sourceFolder + "/" + sourceDir[i].getName()).listFiles();
			if (subDirList != null) {
				for(var j = 0; j < subDirList.length; j++){
					if(subDirList[j].getName().toUpperCase().contains(dataset._REPOSITORY_CODE_)) {
						isRightRepo = true;
					}
					if(subDirList[j].isFile() && subDirList[j].getName().endsWith("_Repository_Mapping.csv")){
						identityRepoName = subDirList[j].getName().substring(0, subDirList[j].getName().indexOf("_Repository_Mapping.csv"));
					}
					if(isRightRepo && (!identityRepoName.isEmpty())) {
						return identityRepoName;
					}
				}
			}
		}
	}
	return "";
}
