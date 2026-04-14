var /*boolean*/ firstTime = true;
var /*Array*/ groups = [];
var /*java.util.Map*/ output = new java.util.HashMap();

var /*Number*/ MAX_IN_LIST = 8;

function fillDefaultValues(/*String*/ suffix) {
	var new_name = 'nb_new' + suffix;
	var deleted_name = 'nb_removed' + suffix;
	var new_list_name = 'list_new' + suffix;
	var deleted_list_name = 'list_removed' + suffix;
	for (var i = 0; i < groups.length; i++) {
		var /*java.util.Map*/ group = output.get('' + groups[i]);
		if (group == null) {
			group = new java.util.HashMap();
			output.put('' + groups[i], group);
		}
		var value = group.get(new_name);
		if (value == null || isNaN(value)) {
			group.put(new_name, 0);
		}
		value = group.get(deleted_name);
		if (value == null || isNaN(value)) {
			group.put(deleted_name, 0);
		}
		var list = group.get(new_list_name);
		if (list == null) {
			group.put(new_list_name, "");
		}
		list = group.get(deleted_list_name);
		if (list == null) {
			group.put(deleted_list_name, "");
		}
	}
}

function computeSafeTrends() {
	var suffix = '_safes';
	var result = businessview.executeView(null, "bwpam_group_trends_safe_trends");
	if (result != null) {
		for (var i = 0; i < result.length; i++) {
			var /*java.util.Map*/ entry = result[i];
			var /*java.util.Map*/ group = output.get('' + entry.get('group_uid'));
			if (group == null) {
				group = new java.util.HashMap();
				output.put('' + entry.get('group_uid'), group);
			}
			var /*String*/ status = entry.get('status');
			var /*String*/ name = 'nb_' + status.toLowerCase() + suffix;
			var value = group.get(name);
			if (value == null || isNaN(value)) {
				value = 1;
			}
			else {
				value = Number(value) + 1;
			}
			group.put(name, value);
			if (value < (MAX_IN_LIST + 2)) {
				var /*String*/ displayname = entry.get('displayname');
				name = 'list_' + status.toLowerCase() + suffix;
				var /*String*/ list = group.get(name);
				if (list == null || list == '') {
					list = displayname;
				}
				else {
					if (value < (MAX_IN_LIST + 1)) {
						var /*String*/ newList = list + ", " + displayname;
						if (newList.length < 995) {
							list = newList;
						}
					}
					else {
						list = list + "...";
					}
				}
				group.put(name, list);
			}
		}
	}
	fillDefaultValues(suffix);
}

function computeSecretTrends() {
	var suffix = '_credentials';
	var result = businessview.executeView(null, "bwpam_group_trends_secret_trends");
	if (result != null) {
		for (var i = 0; i < result.length; i++) {
			var /*java.util.Map*/ entry = result[i];
			var /*java.util.Map*/ group = output.get('' + entry.get('group_uid'));
			if (group == null) {
				group = new java.util.HashMap();
				output.put('' + entry.get('group_uid'), group);
			}
			var /*String*/ status = entry.get('status');
			var /*String*/ name = 'nb_' + status.toLowerCase() + suffix;
			var value = group.get(name);
			if (value == null || isNaN(value)) {
				value = 1;
			}
			else {
				value = Number(value) + 1;
			}
			group.put(name, value);
			if (value < (MAX_IN_LIST + 2)) {
				var /*String*/ displayname = entry.get('displayname');
				name = 'list_' + status.toLowerCase() + suffix;
				var /*String*/ list = group.get(name);
				if (list == null || list == '') {
					list = displayname;
				}
				else {
					if (value < (MAX_IN_LIST + 1)) {
						var /*String*/ newList = list + ", " + displayname;
						if (newList.length < 995) {
							list = newList;
						}
					}
					else {
						list = list + "...";
					}
				}
				group.put(name, list);
			}
		}
	}
	fillDefaultValues(suffix);
}

function computeGroupTrends() {
	var suffix = '_groups';
	var result = businessview.executeView(null, "bwpam_group_trends_group_trends");
	if (result != null) {
		for (var i = 0; i < result.length; i++) {
			var /*java.util.Map*/ entry = result[i];
			var /*java.util.Map*/ group = output.get('' + entry.get('group_uid'));
			if (group == null) {
				group = new java.util.HashMap();
				output.put('' + entry.get('group_uid'), group);
			}
			var /*String*/ status = entry.get('status');
			var /*String*/ name = 'nb_' + status.toLowerCase() + suffix;
			var value = group.get(name);
			if (value == null || isNaN(value)) {
				value = 1;
			}
			else {
				value = Number(value) + 1;
			}
			group.put(name, value);
			if (value < (MAX_IN_LIST + 2)) {
				var /*String*/ displayname = entry.get('displayname');
				name = 'list_' + status.toLowerCase() + suffix;
				var /*String*/ list = group.get(name);
				if (list == null || list == '') {
					list = displayname;
				}
				else {
					if (value < (MAX_IN_LIST + 1)) {
						var /*String*/ newList = list + ", " + displayname;
						if (newList.length < 995) {
							list = newList;
						}
					}
					else {
						list = list + "...";
					}
				}
				group.put(name, list);
			}
		}
	}
	fillDefaultValues(suffix);
}

function computeAccountTrends() {
	var suffix = '_accounts';
	var result = businessview.executeView(null, "bwpam_group_trends_account_trends");
	if (result != null) {
		for (var i = 0; i < result.length; i++) {
			var /*java.util.Map*/ entry = result[i];
			var /*java.util.Map*/ group = output.get('' + entry.get('group_uid'));
			if (group == null) {
				group = new java.util.HashMap();
				output.put('' + entry.get('group_uid'), group);
			}
			var /*String*/ status = entry.get('status');
			var /*String*/ name = 'nb_' + status.toLowerCase() + suffix;
			var value = group.get(name);
			if (value == null || isNaN(value)) {
				value = 1;
			}
			else {
				value = Number(value) + 1;
			}
			group.put(name, value);
			if (value < (MAX_IN_LIST + 2)) {
				var /*String*/ displayname = entry.get('login');
				name = 'list_' + status.toLowerCase() + suffix;
				var /*String*/ list = group.get(name);
				if (list == null || list == '') {
					list = displayname;
				}
				else {
					if (value < (MAX_IN_LIST + 1)) {
						var /*String*/ newList = list + ", " + displayname;
						if (newList.length < 995) {
							list = newList;
						}
					}
					else {
						list = list + "...";
					}
				}
				group.put(name, list);
			}
		}
	}
	fillDefaultValues(suffix);
}

function computeIdentityTrends() {
	var suffix = '_identities';
	var suffixcontractors = '_contractors';
	var result = businessview.executeView(null, "bwpam_group_trends_identity_trends");
	if (result != null) {
		for (var i = 0; i < result.length; i++) {
			var /*java.util.Map*/ entry = result[i];
			var /*java.util.Map*/ group = output.get('' + entry.get('group_uid'));
			if (group == null) {
				group = new java.util.HashMap();
				output.put('' + entry.get('group_uid'), group);
			}
			var /*String*/ status = entry.get('status');
			var /*String*/ internal = entry.get('internal');
			var /*String*/ iscontractor = (internal == false || internal == 'false' || internal == 0 || internal == '0');
			var /*String*/ name = 'nb_' + status.toLowerCase() + suffix;
			var value = group.get(name);
			if (value == null || isNaN(value)) {
				value = 1;
			}
			else {
				value = Number(value) + 1;
			}
			group.put(name, value);
			if (value < (MAX_IN_LIST + 2)) {
				var /*String*/ displayname = entry.get('fullname');
				name = 'list_' + status.toLowerCase() + suffix;
				var /*String*/ list = group.get(name);
				if (list == null || list == '') {
					list = displayname;
				}
				else {
					if (value < (MAX_IN_LIST + 1)) {
						var /*String*/ newList = list + ", " + displayname;
						if (newList.length < 995) {
							list = newList;
						}
					}
					else {
						list = list + "...";
					}
				}
				group.put(name, list);
			}
			if (iscontractor) {
				name = 'nb_' + status.toLowerCase() + suffixcontractors;
				value = group.get(name);
				if (value == null || isNaN(value)) {
					value = 1;
				}
				else {
					value = Number(value) + 1;
				}
				group.put(name, value);
				if (value < (MAX_IN_LIST + 2)) {
					var /*String*/ displayname = entry.get('fullname');
					name = 'list_' + status.toLowerCase() +  + suffixcontractors;
					var /*String*/ list = group.get(name);
					if (list == null || list == '') {
						list = displayname;
					}
					else {
						if (value < (MAX_IN_LIST + 1)) {
							var /*String*/ newList = list + ", " + displayname;
							if (newList.length < 995) {
								list = newList;
							}
						}
						else {
							list = list + "...";
						}
					}
					group.put(name, list);
				}
			}
		}
	}
	fillDefaultValues(suffix);
	fillDefaultValues(suffixcontractors);
}

function computeOrgTrends() {
	var suffix = '_org';
	var result = businessview.executeView(null, "bwpam_group_trends_org_trends");
	if (result != null) {
		for (var i = 0; i < result.length; i++) {
			var /*java.util.Map*/ entry = result[i];
			var /*java.util.Map*/ group = output.get('' + entry.get('group_uid'));
			if (group == null) {
				group = new java.util.HashMap();
				output.put('' + entry.get('group_uid'), group);
			}
			var /*String*/ status = entry.get('status');
			var /*Boolean*/ tag = entry.get('bwa_organisationtags_tag');
			var /*String*/ org_type = (tag == 'IT-PROD') ? '_it' : '_non_it';
			var /*String*/ name = 'nb_' + status.toLowerCase() + org_type + suffix;
			var value = group.get(name);
			if (value == null || isNaN(value)) {
				value = 1;
			}
			else {
				value = Number(value) + 1;
			}
			group.put(name, value);
			if (value < (MAX_IN_LIST + 2)) {
				var /*String*/ displayname = entry.get('displayname');
				name = 'list_' + status.toLowerCase() + suffix;
				var /*String*/ list = group.get(name);
				if (list == null || list == '') {
					list = displayname;
				}
				else {
					if (value < (MAX_IN_LIST + 1)) {
						var /*String*/ newList = list + ", " + displayname;
						if (newList.length < 995) {
							list = newList;
						}
					}
					else {
						list = list + "...";
					}
				}
				group.put(name, list);
			}
		}
	}
	fillDefaultValues('_it' + suffix);
	fillDefaultValues('_non_it' + suffix);
}

var /*Array*/ listOfCompute = [
	computeSafeTrends,
	computeSecretTrends,
	computeGroupTrends,
	computeAccountTrends,
	computeIdentityTrends,
	computeOrgTrends
];

function onComputeTrends() {
	if (firstTime) {
		firstTime = false;
		var /*DataSet*/ result = businessview.getNextRecord();
		while (result != null) {
			groups.push('' + result.uid.get());
			result = businessview.getNextRecord();
		}
		// output is a map of map: first level key is group, second level key is a trend code, second level value is the KPI
		for (var i = 0; i < listOfCompute.length; i++) {
			listOfCompute[i]();
		}
	}
	while (groups.length > 0) {
		var /*String*/ group_uid = groups.pop();
		var /*java.util.Map*/ group = output.get('' + group_uid);
		if (group != null) {
			var /*DataSet*/ record = new DataSet();
			var iterator = group.keySet().iterator();
			while (iterator.hasNext()) {
				var /*String*/ name = iterator.next();
				if (name.left(2) == 'nb') {
					var /*Number*/ value = Number(group.get('' + name));
					record.add('' + name, 'Number', false).set(value);
				}
				else {
					var /*String*/ list = group.get('' + name);
					record.add('' + name, 'String', false).set(list);
				}
			}
			record.group_uid = group_uid;
			return record;
		}
	}
	return null;
}
