var /*boolean*/ firstTime = true;
var /*Array*/ vaults = [];
var /*Array*/ repositories = [];
var /*java.util.Map*/ output = new java.util.HashMap();

var /*Number*/ MAX_IN_LIST = 8;

function fillDefaultValues(/*String*/ suffix) {
	var new_name = 'nb_new' + suffix;
	var deleted_name = 'nb_removed' + suffix;
	var new_list_name = 'list_new' + suffix;
	var deleted_list_name = 'list_removed' + suffix;
	for (var i = 0; i < vaults.length; i++) {
		var /*java.util.Map*/ vault = output.get('' + vaults[i]);
		if (vault == null) {
			vault = new java.util.HashMap();
			output.put('' + vaults[i], vault);
		}
		var value = vault.get(new_name);
		if (value == null || isNaN(value)) {
			vault.put(new_name, 0);
		}
		value = vault.get(deleted_name);
		if (value == null || isNaN(value)) {
			vault.put(deleted_name, 0);
		}
		var list = vault.get(new_list_name);
		if (list == null) {
			vault.put(new_list_name, "");
		}
		list = vault.get(deleted_list_name);
		if (list == null) {
			vault.put(deleted_list_name, "");
		}
	}
}

function setVaultUid(/*java.util.Map*/ entry, /*String*/ source) {
	var /*String*/ vault_code = entry.get('vault_code');
	if (vault_code == null) {
		throw 'ERROR: vault_code not found in entry for ' + source;
	}
	vault_code = '' + vault_code;
	for (var i = 0; i < repositories.length; i++) {
		if (vault_code == repositories[i]) {
			entry.put('vault_uid', '' + vaults[i]);
			return;
		}
	}
	throw 'ERROR: vault uid not found for code ' + vault_code + ' for ' + source;
}

function computeSafeTrends() {
	var suffix = '_safes';
	var result = businessview.executeView(null, "bwpam_vault_trends_safe_trends");
	if (result != null) {
		for (var i = 0; i < result.length; i++) {
			var /*java.util.Map*/ entry = result[i];
			setVaultUid(entry, 'safe trends');
			var /*java.util.Map*/ vault = output.get('' + entry.get('vault_uid'));
			if (vault == null) {
				vault = new java.util.HashMap();
				output.put('' + entry.get('vault_uid'), vault);
			}
			var /*String*/ status = entry.get('status');
			var /*String*/ name = 'nb_' + status.toLowerCase() + suffix;
			var value = vault.get(name);
			if (value == null || isNaN(value)) {
				value = 1;
			}
			else {
				value = Number(value) + 1;
			}
			vault.put(name, value);
			if (value < (MAX_IN_LIST + 2)) {
				var /*String*/ displayname = entry.get('displayname');
				name = 'list_' + status.toLowerCase() + suffix;
				var /*String*/ list = vault.get(name);
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
				vault.put(name, list);
			}
		}
	}
	fillDefaultValues(suffix);
}

function computeGroupTrends() {
	var suffix = '_groups';
	var result = businessview.executeView(null, "bwpam_vault_trends_group_trends");
	if (result != null) {
		for (var i = 0; i < result.length; i++) {
			var /*java.util.Map*/ entry = result[i];
			setVaultUid(entry, 'group trends');
			var /*java.util.Map*/ vault = output.get('' + entry.get('vault_uid'));
			if (vault == null) {
				vault = new java.util.HashMap();
				output.put('' + entry.get('vault_uid'), vault);
			}
			var /*String*/ status = entry.get('status');
			var /*String*/ name = 'nb_' + status.toLowerCase() + suffix;
			var value = vault.get(name);
			if (value == null || isNaN(value)) {
				value = 1;
			}
			else {
				value = Number(value) + 1;
			}
			vault.put(name, value);
			if (value < (MAX_IN_LIST + 2)) {
				var /*String*/ displayname = entry.get('displayname');
				name = 'list_' + status.toLowerCase() + suffix;
				var /*String*/ list = vault.get(name);
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
				vault.put(name, list);
			}
		}
	}
	fillDefaultValues(suffix);
}

function computeUserTrends() {
	var suffix = '_users';
	var result = businessview.executeView(null, "bwpam_vault_trends_user_trends");
	if (result != null) {
		for (var i = 0; i < result.length; i++) {
			var /*java.util.Map*/ entry = result[i];
			setVaultUid(entry, 'user trends');
			var /*java.util.Map*/ vault = output.get('' + entry.get('vault_uid'));
			if (vault == null) {
				vault = new java.util.HashMap();
				output.put('' + entry.get('vault_uid'), vault);
			}
			var /*String*/ status = entry.get('status');
			var /*String*/ user_type = entry.get('user_type');
			// update specificuser type count
			var /*String*/ name = 'nb_' + status.toLowerCase() + '_' + user_type.toLowerCase() + suffix;
			var value = vault.get(name);
			if (value == null || isNaN(value)) {
				value = 1;
			}
			else {
				value = Number(value) + 1;
			}
			vault.put(name, value);
			if (value < (MAX_IN_LIST + 2)) {
				var /*String*/ displayname = entry.get('login');
				name = 'list_' + status.toLowerCase() + '_' + user_type.toLowerCase() + suffix;
				var /*String*/ list = vault.get(name);
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
				vault.put(name, list);
			}
			// update general count
			name = 'nb_' + status.toLowerCase() + suffix;
			value = vault.get(name);
			if (value == null || isNaN(value)) {
				value = 1;
			}
			else {
				value = Number(value) + 1;
			}
			vault.put(name, value);
			if (value < (MAX_IN_LIST + 2)) {
				displayname = entry.get('login');
				name = 'list_' + status.toLowerCase() + suffix;
				list = vault.get(name);
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
				vault.put(name, list);
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
	var result = businessview.executeView(null, "bwpam_vault_trends_org_trends");
	if (result != null) {
		for (var i = 0; i < result.length; i++) {
			var /*java.util.Map*/ entry = result[i];
			setVaultUid(entry, 'org trends');
			var /*java.util.Map*/ vault = output.get('' + entry.get('vault_uid'));
			if (vault == null) {
				vault = new java.util.HashMap();
				output.put('' + entry.get('vault_uid'), vault);
			}
			var /*String*/ status = entry.get('status');
			var /*Boolean*/ tag = entry.get('bwa_organisationtags_tag');
			var /*boolean*/ isItProd = (tag == 'IT-PROD');
			if (! isItProd) {
				var /*String*/ name = 'nb_' + status.toLowerCase() + '_non_it' + suffix;
				var value = vault.get(name);
				if (value == null || isNaN(value)) {
					value = 1;
				}
				else {
					value = Number(value) + 1;
				}
				vault.put(name, value);
				if (value < (MAX_IN_LIST + 2)) {
					var /*String*/ displayname = entry.get('displayname');
					name = 'list_' + status.toLowerCase() + '_non_it' + suffix;
					var /*String*/ list = vault.get(name);
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
					vault.put(name, list);
				}
			}
			name = 'nb_' + status.toLowerCase() + suffix;
			value = vault.get(name);
			if (value == null || isNaN(value)) {
				value = 1;
			}
			else {
				value = Number(value) + 1;
			}
			vault.put(name, value);
			if (value < (MAX_IN_LIST + 2)) {
				displayname = entry.get('displayname');
				name = 'list_' + status.toLowerCase() + suffix;
				list = vault.get(name);
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
				vault.put(name, list);
			}
		}
	}
	fillDefaultValues(suffix);
	fillDefaultValues('_non_it' + suffix);
}

function computeIdentityTrends() {
	var suffix = '_identities';
	var result = businessview.executeView(null, "bwpam_vault_trends_identity_trends");
	if (result != null) {
		for (var i = 0; i < result.length; i++) {
			var /*java.util.Map*/ entry = result[i];
			setVaultUid(entry, 'identity trends');
			var /*java.util.Map*/ vault = output.get('' + entry.get('vault_uid'));
			if (vault == null) {
				vault = new java.util.HashMap();
				output.put('' + entry.get('vault_uid'), vault);
			}
			var /*String*/ status = entry.get('status');
			var /*String*/ name = 'nb_' + status.toLowerCase() + suffix;
			var value = vault.get(name);
			if (value == null || isNaN(value)) {
				value = 1;
			}
			else {
				value = Number(value) + 1;
			}
			vault.put(name, value);
			if (value < (MAX_IN_LIST + 2)) {
				var /*String*/ displayname = entry.get('fullname');
				name = 'list_' + status.toLowerCase() + suffix;
				var /*String*/ list = vault.get(name);
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
				vault.put(name, list);
			}
		}
	}
	fillDefaultValues(suffix);
}

function computeContractorTrends() {
	var suffix = '_contractors';
	var result = businessview.executeView(null, "bwpam_vault_trends_contractor_trends");
	if (result != null) {
		for (var i = 0; i < result.length; i++) {
			var /*java.util.Map*/ entry = result[i];
			setVaultUid(entry, 'contractor trends');
			var /*java.util.Map*/ vault = output.get('' + entry.get('vault_uid'));
			if (vault == null) {
				vault = new java.util.HashMap();
				output.put('' + entry.get('vault_uid'), vault);
			}
			var /*String*/ status = entry.get('status');
			var /*String*/ name = 'nb_' + status.toLowerCase() + suffix;
			var value = vault.get(name);
			if (value == null || isNaN(value)) {
				value = 1;
			}
			else {
				value = Number(value) + 1;
			}
			vault.put(name, value);
			if (value < (MAX_IN_LIST + 2)) {
				var /*String*/ displayname = entry.get('fullname');
				name = 'list_' + status.toLowerCase() + suffix;
				var /*String*/ list = vault.get(name);
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
				vault.put(name, list);
			}
		}
	}
	fillDefaultValues(suffix);
}

function computeContractorSafeTrends() {
	var suffix = '_safe_to_contractors';
	var result = businessview.executeView(null, "bwpam_vault_trends_contractor_safe_trends");
	if (result != null) {
		for (var i = 0; i < result.length; i++) {
			var /*java.util.Map*/ entry = result[i];
			setVaultUid(entry, 'contractor safe trends');
			var /*java.util.Map*/ vault = output.get('' + entry.get('vault_uid'));
			if (vault == null) {
				vault = new java.util.HashMap();
				output.put('' + entry.get('vault_uid'), vault);
			}
			var /*String*/ status = entry.get('status');
			var /*String*/ name = 'nb_' + status.toLowerCase() + suffix;
			var value = vault.get(name);
			if (value == null || isNaN(value)) {
				value = 1;
			}
			else {
				value = Number(value) + 1;
			}
			vault.put(name, value);
			if (value < (MAX_IN_LIST + 2)) {
				var /*String*/ displayname = entry.get('displayname');
				name = 'list_' + status.toLowerCase() + suffix;
				var /*String*/ list = vault.get(name);
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
				vault.put(name, list);
			}
		}
	}
	fillDefaultValues(suffix);
}

function computeCredentialTrends() {
	var suffix = '_credentials';
	var result = businessview.executeView(null, "bwpam_vault_trends_credential_trends");
	if (result != null) {
		for (var i = 0; i < result.length; i++) {
			var /*java.util.Map*/ entry = result[i];
			setVaultUid(entry, 'credential trends');
			var /*java.util.Map*/ vault = output.get('' + entry.get('vault_uid'));
			if (vault == null) {
				vault = new java.util.HashMap();
				output.put('' + entry.get('vault_uid'), vault);
			}
			var /*String*/ status = entry.get('status');
			var /*String*/ name = 'nb_' + status.toLowerCase() + suffix;
			var value = vault.get(name);
			if (value == null || isNaN(value)) {
				value = 1;
			}
			else {
				value = Number(value) + 1;
			}
			vault.put(name, value);
			if (value < (MAX_IN_LIST + 2)) {
				var /*String*/ displayname = entry.get('displayname');
				name = 'list_' + status.toLowerCase() + suffix;
				var /*String*/ list = vault.get(name);
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
				vault.put(name, list);
			}
		}
	}
	fillDefaultValues(suffix);
}

var /*Array*/ listOfCompute = [
	computeSafeTrends,
	computeGroupTrends,
	computeUserTrends,
	computeOrgTrends,
	computeIdentityTrends,
	computeContractorTrends,
	computeContractorSafeTrends,
	computeCredentialTrends
];

function onComputeTrends() {
	if (firstTime) {
		firstTime = false;
		var /*DataSet*/ result = businessview.getNextRecord();
		while (result != null) {
			repositories.push('' + result.code.get());
			vaults.push('' + result.uid.get());
			result = businessview.getNextRecord();
		}
		// output is a map of map: first level key is vault, second level key is a trend code, second level value is the KPI
		for (var i = 0; i < listOfCompute.length; i++) {
			listOfCompute[i]();
		}
	}
	while (vaults.length > 0) {
		var /*String*/ vault_uid = vaults.pop();
		var /*java.util.Map*/ vault = output.get('' + vault_uid);
		if (vault != null) {
			var /*DataSet*/ record = new DataSet();
			var iterator = vault.keySet().iterator();
			while (iterator.hasNext()) {
				var /*String*/ name = iterator.next();
				if (name.left(2) == 'nb') {
					var /*Number*/ value = Number(vault.get('' + name));
					record.add('' + name, 'Number', false).set(value);
				}
				else {
					var /*String*/ list = vault.get('' + name);
					record.add('' + name, 'String', false).set(list);
				}
			}
			record.vault_uid = vault_uid;
			return record;
		}
	}
	return null;
}
