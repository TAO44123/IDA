
function filter_on_application() {
	var item = businessview.getNextRecord();
	var filter_applications = dataset.isEmpty("applications") ? null : dataset.applications;
	
	if (item == null)
		return null;
	if (filter_applications==null) {
		return item;
	}
	if (item.isEmpty("controltagapplication")) {
		return filter_on_application();
	}
	var control_applications = item.controltagapplication.get().split(',');
	for (var index = 0; index < control_applications.length; index++) {
		var control_application = control_applications[index];
		if (filter_applications.indexOf(control_application , true) >= 0)
			return item;
	}
	return filter_on_application();
}

function filter_entities_type() {
	
	var item = businessview.getNextRecord();
	if (item==null)
	{
		return null;
	}
	var getShare = dataset.applicationType.indexOf("Share");
	var getApp = dataset.applicationType.indexOf("Application");
	var getSharedfolder = dataset.permissionType.indexOf("Sharedfolder");
	var getPermission = dataset.permissionType.indexOf("Permission");
	
	if (item.controlentity.get()!="Application"&& item.controlentity.get()!="Permission")
	{
		return item;
	}
	if (item.controlentity.get()=="Application" && (!item.isEmpty("controltagtype") && item.controltagtype.get()=="DataGov"))
	{
		if (getShare != -1)
		{
			return item;
		}
	}
	if (item.controlentity.get()=="Application" && (item.isEmpty("controltagtype") || item.controltagtype.get()!="DataGov"))
	{
		if (getApp != -1)
		{
			return item;
		}
	}
	if (item.controlentity.get()=="Permission" && (!item.isEmpty("controltagtype") &&item.controltagtype.get()=="DataGov"))
	{
		if (getSharedfolder != -1)
		{
			return item;
		}
	}
	if (item.controlentity.get()=="Permission" && (item.isEmpty("controltagtype") ||item.controltagtype.get()!="DataGov"))
	{
		if (getPermission != -1)
		{
			return item;
		}
	}
	
	return filter_entities_type()
}