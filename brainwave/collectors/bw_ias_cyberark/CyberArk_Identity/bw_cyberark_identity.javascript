function getPcloudRepo() {
	dataset.pcloud_reponame = getPCloudPrefix();
}

function convertDate() {
	dataset.lastlogin = formatDateFunc();
}

function getPCloudPrefix() {
	var /*java.io.File[]*/ sourceDir = new java.io.File(config.bw_cyberark_model_sourceFolder).listFiles();
	var /*String*/ res = "";
	var /*String*/ currentRepoName = dataset._REPOSITORY_CODE_.get().substring(2);
	var /*boolean*/ isCurrentIdentity = false;
	var /*boolean*/ found = false;
	if (sourceDir == null) {
		return "";
	}
	for(var i = 0; i < sourceDir.length ; i++){
		if(sourceDir[i].isFile() && sourceDir[i].getName().toUpperCase().equals(currentRepoName + "_Repository_Mapping.csv".toUpperCase())) {
			isCurrentIdentity = true;
		}
		if(sourceDir[i].isFile() && sourceDir[i].getName().endsWith("_export-mode.csv")) {
			res = sourceDir[i].getName().substring(0, sourceDir[i].getName().indexOf("_"));
			found = true;
		}
		if(found && isCurrentIdentity) {
			return res;
		}
		if(sourceDir[i].isDirectory()) {
			found = false;
			isCurrentIdentity = false;
			var /*java.io.File[]*/ subDirList = new java.io.File(config.bw_cyberark_model_sourceFolder + "/" + sourceDir[i].getName()).listFiles();
			if (subDirList != null) {
				for(var j = 0; j < subDirList.length; j++) {
					var currentfile = subDirList[j].getName();
					var test = subDirList[j]
					if(subDirList[j].isFile() && subDirList[j].getName().toUpperCase().equals(currentRepoName + "_Repository_Mapping.csv".toUpperCase())) {
						isCurrentIdentity = true;
					}
					if(subDirList[j].isFile() && subDirList[j].getName().endsWith("_export-mode.csv")) {
						res = sourceDir[i].getName() + "/" + subDirList[j].getName().substring(0, subDirList[j].getName().indexOf("_"));
						found = true;
					}
					if(found && isCurrentIdentity) {
						return res;
					}
				}			
			}

		}
	}
	return "";
}

function formatDateFunc() {
	if(dataset.lastlogin == null) {
		return null;
	}
	var currentDate = dataset.lastlogin.get()
	if(currentDate.contains("PM") || currentDate.contains("AM")){
		var parts = currentDate.split(" ");
		var time = parts[1].split(":");
		var hour = java.lang.Integer.parseInt(time[0]);
		if (currentDate.contains("AM") && hour == 12) {
			hour = 0;
		} else if (currentDate.contains("PM") && hour != 12) {
			hour += 12;
		}
		var date = currentDate.split(" ");
		var date2 = date[0].split("/");
		currentDate = date2[1] + "/" + date2[0] + "/" + date2[2] + " " + hour + ":" + time[1] + ":" + time[2];
	}
	return currentDate;
}


