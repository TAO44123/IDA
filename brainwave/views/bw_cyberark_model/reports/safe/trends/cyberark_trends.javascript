var /*boolean*/ firstTime = true;
var /*Array*/ safes = [];
var /*java.util.Map*/ output = new java.util.HashMap();

var /*Number*/ MAX_IN_LIST = 8;

function fillDefaultValues(/*String*/ suffix) {
	var new_name = 'nb_new' + suffix;
	var deleted_name = 'nb_removed' + suffix;
	var new_list_name = 'list_new' + suffix;
	var deleted_list_name = 'list_removed' + suffix;
	for (var i = 0; i < safes.length; i++) {
		var /*java.util.Map*/ safe = output.get('' + safes[i]);
		if (safe == null) {
			safe = new java.util.HashMap();
			output.put('' + safes[i], safe);
		}
		var value = safe.get(new_name);
		if (value == null || isNaN(value)) {
			safe.put(new_name, 0);
		}
		value = safe.get(deleted_name);
		if (value == null || isNaN(value)) {
			safe.put(deleted_name, 0);
		}
		var list = safe.get(new_list_name);
		if (list == null) {
			safe.put(new_list_name, "");
		}
		list = safe.get(deleted_list_name);
		if (list == null) {
			safe.put(deleted_list_name, "");
		}
	}
}

// ajouter : secrets sans CPM
function computeSecretTrends() {
	var suffix = '_credentials';
	var result = businessview.executeView(null, "bwpam_safe_trends_secret_trends");
	if (result != null) {
		for (var i = 0; i < result.length; i++) {
			var /*java.util.Map*/ entry = result[i];
			var /*java.util.Map*/ safe = output.get('' + entry.get('safe_uid'));
			if (safe == null) {
				safe = new java.util.HashMap();
				output.put('' + entry.get('safe_uid'), safe);
			}
			var /*String*/ status = entry.get('status');
			var /*Boolean*/ cpm = entry.get('cpm');
			var /*String*/ no_cpm = (cpm == false || cpm == 'false' || cpm == 0 || cpm == '0') ? '' : '_no_cpm';
			var /*String*/ name = 'nb_' + status.toLowerCase() + suffix + no_cpm;
			var value = safe.get(name);
			if (value == null || isNaN(value)) {
				value = 1;
			}
			else {
				value = Number(value) + 1;
			}
			safe.put(name, value);
			if (value < (MAX_IN_LIST + 2)) {
				var /*String*/ displayname = entry.get('displayname');
				name = 'list_' + status.toLowerCase() + suffix + no_cpm;
				var /*String*/ list = safe.get(name);
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
				safe.put(name, list);
			}
		}
	}
	fillDefaultValues(suffix + "_no_cpm");
	fillDefaultValues(suffix);
}

function computeGroupTrends() {
	var suffix = '_groups';
	var result = businessview.executeView(null, "bwpam_safe_trends_group_trends");
	if (result != null) {
		for (var i = 0; i < result.length; i++) {
			var /*java.util.Map*/ entry = result[i];
			var /*java.util.Map*/ safe = output.get('' + entry.get('safe_uid'));
			if (safe == null) {
				safe = new java.util.HashMap();
				output.put('' + entry.get('safe_uid'), safe);
			}
			var /*String*/ status = entry.get('status');
			var /*String*/ name = 'nb_' + status.toLowerCase() + suffix;
			var value = safe.get(name);
			if (value == null || isNaN(value)) {
				value = 1;
			}
			else {
				value = Number(value) + 1;
			}
			safe.put(name, value);
			if (value < (MAX_IN_LIST + 2)) {
				var /*String*/ displayname = entry.get('displayname');
				name = 'list_' + status.toLowerCase() + suffix;
				var /*String*/ list = safe.get(name);
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
				safe.put(name, list);
			}
		}
	}
	fillDefaultValues(suffix);
}

function computeUserTrends() {
	var suffix = '_users';
	var result = businessview.executeView(null, "bwpam_safe_trends_user_trends");
	if (result != null) {
		for (var i = 0; i < result.length; i++) {
			var /*java.util.Map*/ entry = result[i];
			var /*java.util.Map*/ safe = output.get('' + entry.get('safe_uid'));
			if (safe == null) {
				safe = new java.util.HashMap();
				output.put('' + entry.get('safe_uid'), safe);
			}
			var /*String*/ status = entry.get('status');
			var /*String*/ user_type = entry.get('user_type');
			// update specificuser type count
			var /*String*/ name = 'nb_' + status.toLowerCase() + '_' + user_type.toLowerCase() + suffix;
			var value = safe.get(name);
			if (value == null || isNaN(value)) {
				value = 1;
			}
			else {
				value = Number(value) + 1;
			}
			safe.put(name, value);
			if (value < (MAX_IN_LIST + 2)) {
				var /*String*/ displayname = entry.get('login');
				name = 'list_' + status.toLowerCase() + '_' + user_type.toLowerCase() + suffix;
				var /*String*/ list = safe.get(name);
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
				safe.put(name, list);
			}
			// update general count
			name = 'nb_' + status.toLowerCase() + suffix;
			value = safe.get(name);
			if (value == null || isNaN(value)) {
				value = 1;
			}
			else {
				value = Number(value) + 1;
			}
			safe.put(name, value);
			if (value < (MAX_IN_LIST + 2)) {
				displayname = entry.get('login');
				name = 'list_' + status.toLowerCase() + suffix;
				list = safe.get(name);
				if (list == null || list == '') {
					list = displayname;
				}
				else {
					if (value < (MAX_IN_LIST + 1)) {
						newList = list + ", " + displayname;
						if (newList.length < 995) {
							list = newList;
						}
					}
					else {
						list = list + "...";
					}
				}
				safe.put(name, list);
			}
		}
	}
	fillDefaultValues('_other' + suffix);
	fillDefaultValues('_epv' + suffix);
	fillDefaultValues('_application' + suffix);
	fillDefaultValues('_built-in' + suffix);
	fillDefaultValues(suffix);
}

function computeOrgTrends() {
	var suffix = '_organizations';
	var result = businessview.executeView(null, "bwpam_safe_trends_org_trends");
	if (result != null) {
		for (var i = 0; i < result.length; i++) {
			var /*java.util.Map*/ entry = result[i];
			var /*java.util.Map*/ safe = output.get('' + entry.get('safe_uid'));
			if (safe == null) {
				safe = new java.util.HashMap();
				output.put('' + entry.get('safe_uid'), safe);
			}
			var /*String*/ status = entry.get('status');
			var /*Boolean*/ tag = entry.get('bwa_organisationtags_tag');
			var /*boolean*/ isItProd = (tag == 'IT-PROD');
			if (! isItProd) {
				var /*String*/ name = 'nb_' + status.toLowerCase() + '_non_it' + suffix;
				var value = safe.get(name);
				if (value == null || isNaN(value)) {
					value = 1;
				}
				else {
					value = Number(value) + 1;
				}
				safe.put(name, value);
				if (value < (MAX_IN_LIST + 2)) {
					var displayname = entry.get('displayname');
					name = 'list_' + status.toLowerCase() + '_non_it' + suffix;
					var list = safe.get(name);
					if (list == null || list == '') {
						list = displayname;
					}
					else {
						if (value < (MAX_IN_LIST + 1)) {
							var newList = list + ", " + displayname;
							if (newList.length < 995) {
								list = newList;
							}
						}
						else {
							list = list + "...";
						}
					}
					safe.put(name, list);
				}
			}
			name = 'nb_' + status.toLowerCase() + suffix;
			value = safe.get(name);
			if (value == null || isNaN(value)) {
				value = 1;
			}
			else {
				value = Number(value) + 1;
			}
			safe.put(name, value);
			if (value < (MAX_IN_LIST + 2)) {
				displayname = entry.get('displayname');
				name = 'list_' + status.toLowerCase() + suffix;
				list = safe.get(name);
				if (list == null || list == '') {
					list = displayname;
				}
				else {
					if (value < (MAX_IN_LIST + 1)) {
						newList = list + ", " + displayname;
						if (newList.length < 995) {
							list = newList;
						}
					}
					else {
						list = list + "...";
					}
				}
				safe.put(name, list);
			}
		}
	}
	fillDefaultValues(suffix);
	fillDefaultValues('_non_it' + suffix);
}

function computeIdentityTrends() {
	var suffix = '_identities';
	var result = businessview.executeView(null, "bwpam_safe_trends_identity_trends");
	if (result != null) {
		for (var i = 0; i < result.length; i++) {
			var /*java.util.Map*/ entry = result[i];
			var /*java.util.Map*/ safe = output.get('' + entry.get('safe_uid'));
			if (safe == null) {
				safe = new java.util.HashMap();
				output.put('' + entry.get('safe_uid'), safe);
			}
			var /*String*/ status = entry.get('status');
			var /*String*/ name = 'nb_' + status.toLowerCase() + suffix;
			var value = safe.get(name);
			if (value == null || isNaN(value)) {
				value = 1;
			}
			else {
				value = Number(value) + 1;
			}
			safe.put(name, value);
			if (value < (MAX_IN_LIST + 2)) {
				var /*String*/ displayname = entry.get('fullname');
				name = 'list_' + status.toLowerCase() + suffix;
				var list = safe.get(name);
				if (list == null || list == '') {
					list = displayname;
				}
				else {
					if (value < (MAX_IN_LIST + 1)) {
						var newList = list + ", " + displayname;
						if (newList.length < 995) {
							list = newList;
						}
					}
					else {
						list = list + "...";
					}
				}
				safe.put(name, list);
			}
		}
	}
	fillDefaultValues(suffix);
}

function computeContractorTrends() {
	var suffix = '_contractors';
	var result = businessview.executeView(null, "bwpam_safe_trends_contractor_trends");
	if (result != null) {
		for (var i = 0; i < result.length; i++) {
			var /*java.util.Map*/ entry = result[i];
			var /*java.util.Map*/ safe = output.get('' + entry.get('safe_uid'));
			if (safe == null) {
				safe = new java.util.HashMap();
				output.put('' + entry.get('safe_uid'), safe);
			}
			var /*String*/ status = entry.get('status');
			var /*String*/ name = 'nb_' + status.toLowerCase() + suffix;
			var value = safe.get(name);
			if (value == null || isNaN(value)) {
				value = 1;
			}
			else {
				value = Number(value) + 1;
			}
			safe.put(name, value);
			if (value < (MAX_IN_LIST + 2)) {
				var /*String*/ displayname = entry.get('fullname');
				name = 'list_' + status.toLowerCase() + suffix;
				var list = safe.get(name);
				if (list == null || list == '') {
					list = displayname;
				}
				else {
					if (value < (MAX_IN_LIST + 1)) {
						var newList = list + ", " + displayname;
						if (newList.length < 995) {
							list = newList;
						}
					}
					else {
						list = list + "...";
					}
				}
				safe.put(name, list);
			}
		}
	}
	fillDefaultValues(suffix);
}

var /*Array*/ listOfCompute = [
	computeSecretTrends,
	computeGroupTrends,
	computeUserTrends,
	computeOrgTrends,
	computeIdentityTrends,
	computeContractorTrends
];

function onComputeTrends() {
	if (firstTime) {
		firstTime = false;
		var /*DataSet*/ result = businessview.getNextRecord();
		while (result != null) {
			safes.push('' + result.uid.get());
			result = businessview.getNextRecord();
		}
		// output is a map of map: first level key is safe, second level key is a trend code, second level value is the KPI
		for (var i = 0; i < listOfCompute.length; i++) {
			listOfCompute[i]();
		}
	}
	while (safes.length > 0) {
		var /*String*/ safe_uid = safes.pop();
		var /*java.util.Map*/ safe = output.get('' + safe_uid);
		if (safe != null) {
			var /*DataSet*/ record = new DataSet();
			var iterator = safe.keySet().iterator();
			while (iterator.hasNext()) {
				var /*String*/ name = iterator.next();
				if (name.left(2) == 'nb') {
					var /*Number*/ value = Number(safe.get('' + name));
					record.add('' + name, 'Number', false).set(value);
				}
				else {
					var /*String*/ list = safe.get('' + name);
					record.add('' + name, 'String', false).set(list);
				}
			}
			record.safe_uid = safe_uid;
			return record;
		}
	}
	return null;
}
