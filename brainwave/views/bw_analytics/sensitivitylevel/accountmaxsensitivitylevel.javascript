
function compute() {
	var record= businessview.getNextRecord();
	if(record == null)
		return null;
	
	var /*Number*/ max = -1;
	
	var app_sensitivitylevel = record.isEmpty('app_sensitivitylevel')?-1:record.app_sensitivitylevel.get();
	var folder_sensitivitylevel = record.isEmpty('folder_sensitivitylevel')?-1:record.folder_sensitivitylevel.get();
	var group_sensitivitylevel = record.isEmpty('group_sensitivitylevel')?-1:record.group_sensitivitylevel.get();
	var perm_sensitivitylevel = record.isEmpty('perm_sensitivitylevel')?-1:record.perm_sensitivitylevel.get();
	var repo_sensitivitylevel = record.isEmpty('repo_sensitivitylevel')?-1:record.repo_sensitivitylevel.get();
	var share_sensitivitylevel = record.isEmpty('share_sensitivitylevel')?-1:record.share_sensitivitylevel.get();

	if(app_sensitivitylevel>max)
		max = app_sensitivitylevel;
	if(folder_sensitivitylevel>max)
		max = folder_sensitivitylevel;
	if(group_sensitivitylevel>max)
		max = group_sensitivitylevel;
	if(perm_sensitivitylevel>max)
		max = perm_sensitivitylevel;
	if(repo_sensitivitylevel>max)
		max = repo_sensitivitylevel;
	if(share_sensitivitylevel>max)
		max = share_sensitivitylevel;

	if(max>-1)
		record.maxsensitivitylevel.set(max);
	
	return record;
}
