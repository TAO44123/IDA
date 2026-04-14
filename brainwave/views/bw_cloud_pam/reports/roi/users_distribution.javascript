var previousJob = "";
var previousJobUid = "";
var previousOrg = "";
var previousOrgUid = "";
var nbUsers = 0;
var projectionResult = [];
var flatResult = [];
var mostRecentDay = 0;
var firstDone = false;

function onReadJob() {
	var record = businessview.getNextRecord();
	while (record != null) {
		var newJobUid = record.isEmpty("jobtitleuid") ? "N/A" : record.jobtitleuid.get();
		var newJob = record.isEmpty("jobtitledisplayname") ? "N/A" : record.jobtitledisplayname.get();
		if (newJobUid == previousJobUid) {
			nbUsers++;
		}
		else if (nbUsers == 0) {
			previousJob = newJob;
			previousJobUid = newJobUid;
			nbUsers = 1;
		}
		else {
			var records = new DataSet();
			records.jobdisplayname = previousJob;
			records.jobuid = previousJobUid;
			records.add('nb_users', 'Number', false).set(nbUsers);
			previousJob = newJob;
			previousJobUid = newJobUid;
			nbUsers = 1;
			return records;
		}
		record = businessview.getNextRecord();
	}
	if (nbUsers > 0) {
		records = new DataSet();
		records.jobdisplayname = previousJob;
		records.jobuid = previousJobUid;
		records.add('nb_users', 'Number', false).set(nbUsers);
		nbUsers = 0;
		return records;
	}
	return null;
}

function onReadOrg() {
	var record = businessview.getNextRecord();
	while (record != null) {
		var newOrgUid = record.isEmpty("organizationuid") ? "N/A" : record.organizationuid.get();
		var newOrg = record.isEmpty("organizationdisplayname") ? "N/A" : record.organizationdisplayname.get();
		if (newOrgUid == previousOrgUid) {
			nbUsers++;
		}
		else if (nbUsers == 0) {
			previousOrg = newOrg;
			previousOrgUid = newOrgUid;
			nbUsers = 1;
		}
		else {
			var records = new DataSet();
			records.orgdisplayname = previousOrg;
			records.orguid = previousOrgUid;
			records.add('nb_users', 'Number', false).set(nbUsers);
			previousOrg = newOrg;
			previousOrgUid = newOrgUid;
			nbUsers = 1;
			return records;
		}
		record = businessview.getNextRecord();
	}
	if (nbUsers > 0) {
		records = new DataSet();
		records.orgdisplayname = previousOrg;
		records.orguid = previousOrgUid;
		records.add('nb_users', 'Number', false).set(nbUsers);
		nbUsers = 0;
		return records;
	}
	return null;
}

function computeLineParameters(/*Array*/ values_x, /*Array*/ values_y) {
    var sum_x = 0.0;
    var sum_y = 0.0;
    var sum_xy = 0.0;
    var sum_xx = 0.0;
    var count = 0.0;

    /*
     * We'll use those variables for faster read/write access.
     */
    var x = 0.0;
    var y = 0.0;
    var values_length = values_x.length;

    if (values_length != values_y.length) {
        throw new Error('The parameters values_x and values_y need to have same size!');
    }

    /*
     * Nothing to do.
     */
    if (values_length === 0) {
        return [0.0, 0.0];
    }

    /*
     * Calculate the sum for each of the parts necessary.
     */
    for (var v = 0; v < values_length; v++) {
        x = Math.floor(values_x[v]);
        y = Math.floor(values_y[v]);
        sum_x += x;
        sum_y += y;
        sum_xx += (x * x);
        sum_xy += (x * y);
        count++;
    }

    /*
     * Calculate m and b for the formular:
     * y = x * m + b
     */
    var div = count*sum_xx - sum_x*sum_x;
    var m = 1;
    if (div != 0) {
        m = (count*sum_xy - sum_x*sum_y) / div;
    }
    var b = (sum_y/count) - ((m*sum_x)/count);
//    var m = (count*sum_xy - sum_x*sum_y) / (count*sum_xx - sum_x*sum_x);
//    var b = (sum_y/count) - (m*sum_x)/count;
//    var r2 = Math.pow((count*sum_xy - sum_x*sum_y)/Math.sqrt((count*sum_xx-sum_x*sum_x)*(count*sum_yy-sum_y*sum_y)),2);
    return [m, b];
}

function onReadLinearRegression() {

	if (projectionResult.length == 0) {

		/*
		 * Collect all values from the main view and aggregate on commitday
		 */
		var /*java.util.Map*/ map = new java.util.HashMap();
		var record = businessview.getNextRecord();
		var mostRecentRecord = null;
		while (record != null) {
			var day = record.timeslotcommitday.get();
			var /*java.util.Map*/ entry = map.get(day);
			if (entry == null) {
				entry = new java.util.HashMap();
				map.put(day, entry);
				if (day > mostRecentDay) {
					mostRecentRecord = entry;
				}
			}
			if (day > mostRecentDay) {
				mostRecentDay = day;
			}
			var user_type = record.user_type.get();
			var nb_users = record.nb_users.get();
			entry.put("" + user_type, nb_users);
			record = businessview.getNextRecord();
		}
		if (map.size() >= 2) {

			/*
			 * fill arrays for the algorithm computeLineParameters
			 */
			var values_x = [];
			var values_y_other = [];
			var values_y_epv = [];
			var values_y_app = [];
			var values_y_builtin = [];
			var values_y_all = [];
			var iterator = map.keySet().iterator();
			while (iterator.hasNext()) {
				var day = iterator.next();
				entry = map.get(day);
				var nb_other = entry.get(dataset.other_type.get());
				if (nb_other == null) {
					nb_other = 0;
				}
				var nb_epv = entry.get('EPV');
				if (nb_epv == null) {
					nb_epv = 0;
				}
				var nb_app = entry.get('Application');
				if (nb_app == null) {
					nb_app = 0;
				}
				var nb_builtin = entry.get('Built-in');
				if (nb_builtin == null) {
					nb_builtin = 0;
				}
				var nb_all = Math.floor(Number(nb_other) + Number(nb_epv) + Number(nb_app) + Number(nb_builtin));
				values_x.push(day);
				values_y_other.push(nb_other);
				values_y_epv.push(nb_epv);
				values_y_app.push(nb_app);
				values_y_builtin.push(nb_builtin);
				values_y_all.push(nb_all);
			}

			if (values_x.length > 0) {
				/*
				 * compute the line vector for each category (LDAP, Applcation...)
				 */
				var result_other = computeLineParameters(values_x, values_y_other);
				var result_epv = computeLineParameters(values_x, values_y_epv);
				var result_app = computeLineParameters(values_x, values_y_app);
				var result_builtin = computeLineParameters(values_x, values_y_builtin);
				// var result_all = computeLineParameters(values_x, values_y_all);

				/*
				 * compute the projection for several dates
				 */
				var projection = [ 0/*most recent real data*/, 91/*3 months*/, 182/*6 months*/, 273/*9 months*/, 365/*1 year*/ ];
				if (! dataset.isEmpty('days')) {
					projection = [ dataset.days.get() ];
				}
				var today = mostRecentDay;
				for (var i = 0; i < projection.length; i++) {
					if (projection[i] == 0) {
						/*
						 * add real data from the latest timeslot for graph
						 */
						nb_other = mostRecentRecord.get(dataset.other_type.get());
						if (nb_other == null) {
							nb_other = 0;
						}
						nb_epv = mostRecentRecord.get('EPV');
						if (nb_epv == null) {
							nb_epv = 0;
						}
						nb_app = mostRecentRecord.get('Application');
						if (nb_app == null) {
							nb_app = 0;
						}
						nb_builtin = mostRecentRecord.get('Built-in');
						if (nb_builtin == null) {
							nb_builtin = 0;
						}
						//nb_all = Math.floor(Number(nb_other) + Number(nb_epv) + Number(nb_app) + Number(nb_builtin));
					}
					else {
						day = today + projection[i];
						nb_other = Math.floor((day * result_other[0]) + result_other[1]);
						nb_epv = Math.floor((day * result_epv[0]) + result_epv[1]);
						nb_app = Math.floor((day * result_app[0]) + result_app[1]);
						nb_builtin = Math.floor((day * result_builtin[0]) + result_builtin[1]);
						// nb_all = Math.floor((day * result_all[0]) + result_all[1]);
					}
					projectionResult.push([projection[i], nb_other, nb_epv, nb_app, nb_builtin]);
				}
			}
		}
	}

	/*
	 * return next result from projectionResult
	 */
	if (flatResult.length > 0) {
		firstDone = true;
		return flatResult.pop();
	}
	if (projectionResult.length > 0) {
		var /*Array*/ result = projectionResult.shift();
		var theDate = new Date();
		theDate.setTime((mostRecentDay + result[0]) * 3600000 * 24);
		var theShortDate = theDate.toLDAPString().substring(0,4) + '-' + theDate.toLDAPString().substring(4,6) + '-' + theDate.toLDAPString().substring(6,8)
		if (dataset.isEmpty('mode') || (dataset.mode.get() == 'Aggregate')) {
			var records = new DataSet();
			records.add('days', 'Number', false).set(mostRecentDay + result[0]);
			records.add('thedate', 'Date', false).set(theDate);
			records.add('theshortdate', 'String', false).set(theShortDate);
			records.add('nb_other', 'Number', false).set(result[1]);
			records.add('nb_epv', 'Number', false).set(result[2]);
			records.add('nb_app', 'Number', false).set(result[3]);
			records.add('nb_builtin', 'Number', false).set(result[4]);
			nb_all = result[1] + result[2] + result[3] + result[4];
			records.add('nb_all', 'Number', false).set(nb_all);
			firstDone = true;
			return records;
		}
		else { // mode 'Full' for graph
			records = new DataSet();
			records.add('days', 'Number', false).set(mostRecentDay + result[0]);
			records.add('thedate', 'Date', false).set(theDate);
			records.add('theshortdate', 'String', false).set(theShortDate);
			records.add('nb_users', 'Number', false).set(Number(result[1]));
			records.add('user_type', 'String', false).set(dataset.other_type.get());
			flatResult.push(records);
			records = new DataSet();
			records.add('days', 'Number', false).set(mostRecentDay + result[0]);
			records.add('thedate', 'Date', false).set(theDate);
			records.add('theshortdate', 'String', false).set(theShortDate);
			records.add('nb_users', 'Number', false).set(Number(result[2]));
			records.add('user_type', 'String', false).set('EPV');
			flatResult.push(records);
			records = new DataSet();
			records.add('days', 'Number', false).set(mostRecentDay + result[0]);
			records.add('thedate', 'Date', false).set(theDate);
			records.add('theshortdate', 'String', false).set(theShortDate);
			records.add('nb_users', 'Number', false).set(Number(result[3]));
			records.add('user_type', 'String', false).set('Application');
			flatResult.push(records);
			records = new DataSet();
			records.add('days', 'Number', false).set(mostRecentDay + result[0]);
			records.add('thedate', 'Date', false).set(theDate);
			records.add('theshortdate', 'String', false).set(theShortDate);
			records.add('nb_users', 'Number', false).set(Number(result[4]));
			records.add('user_type', 'String', false).set('Built-in');
			flatResult.push(records);
			firstDone = true;
			return flatResult.pop();
		}
	}
	if (! firstDone) {
		firstDone = true;
		records = new DataSet();
		records.add('days', 'Number', false).set(0);
		records.add('diff', 'Number', false).set(0);
		records.add('thedate', 'Date', false).set(new Date());
		records.add('theshortdate', 'String', false).set('');
		records.add('nb_users', 'Number', false).set(0);
		records.add('user_type', 'String', false).set('');
		return records;
	}
	return null;
}

function onReadSafeLinearRegression() {

	if (! dataset.isEmpty('days')) {

		/*
		 * Collect all values from the main view and aggregate on commitday
		 */
		var values_x = [];
		var values_y = [];
		var record = businessview.getNextRecord();
		while (record != null) {
			var day = record.timeslotcommitday.get();
			if (day > mostRecentDay) {
				mostRecentDay = day;
			}
			var nb_safes = record.nb_safes.get();
			values_x.push(day);
			values_y.push(nb_safes);
			record = businessview.getNextRecord();
		}

		/*
		 * compute the line vector and the estimate
		 */
		if (values_x.length >= 2) {
			var result = computeLineParameters(values_x, values_y);
			var today = mostRecentDay;
			day = today + dataset.days.get();
			nb_safes = Math.floor((day * result[0]) + result[1]);
			theDate = new Date();
			theDate.setTime(day * 3600000 * 24);
			var theShortDate = theDate.toLDAPString().substring(0,4) + '-' + theDate.toLDAPString().substring(4,6) + '-' + theDate.toLDAPString().substring(6,8)
			var records = new DataSet();
			records.add('days', 'Number', false).set(day);
			records.add('thedate', 'Date', false).set(theDate);
			records.add('theshortdate', 'String', false).set(theShortDate);
			records.add('nb_safes', 'Number', false).set(nb_safes);
			return records;
		}
	}
	return null;
}

function onReadSecretLinearRegression() {

	if (! dataset.isEmpty('days')) {

		/*
		 * Collect all values from the main view and aggregate on commitday
		 */
		var values_x = [];
		var values_y = [];
		var record = businessview.getNextRecord();
		while (record != null) {
			var day = record.timeslotcommitday.get();
			if (day > mostRecentDay) {
				mostRecentDay = day;
			}
			var nb_secrets = record.nb_secrets.get();
			values_x.push(day);
			values_y.push(nb_secrets);
			record = businessview.getNextRecord();
		}

		/*
		 * compute the line vector and the estimate
		 */
		if (values_x.length >= 2) {
			var result = computeLineParameters(values_x, values_y);
			var today = mostRecentDay;
			day = today + dataset.days.get();
			nb_secrets = Math.floor((day * result[0]) + result[1]);
			theDate = new Date();
			theDate.setTime(day * 3600000 * 24);
			var theShortDate = theDate.toLDAPString().substring(0,4) + '-' + theDate.toLDAPString().substring(4,6) + '-' + theDate.toLDAPString().substring(6,8)
			var records = new DataSet();
			records.add('days', 'Number', false).set(day);
			records.add('thedate', 'Date', false).set(theDate);
			records.add('theshortdate', 'String', false).set(theShortDate);
			records.add('nb_secrets', 'Number', false).set(nb_secrets);
			return records;
		}
	}
	return null;
}

function onReadResourceLinearRegression() {

	if (! dataset.isEmpty('days')) {

		/*
		 * Collect all values from the main view and aggregate on commitday
		 */
		var values_x = [];
		var values_y = [];
		var record = businessview.getNextRecord();
		while (record != null) {
			var day = record.timeslotcommitday.get();
			if (day > mostRecentDay) {
				mostRecentDay = day;
			}
			var nb_resources = record.nb_resources.get();
			values_x.push(day);
			values_y.push(nb_resources);
			record = businessview.getNextRecord();
		}

		/*
		 * compute the line vector and the estimate
		 */
		if (values_x.length >= 2) {
			var result = computeLineParameters(values_x, values_y);
			var today = mostRecentDay;
			day = today + dataset.days.get();
			nb_resources = Math.floor((day * result[0]) + result[1]);
			theDate = new Date();
			theDate.setTime(day * 3600000 * 24);
			var theShortDate = theDate.toLDAPString().substring(0,4) + '-' + theDate.toLDAPString().substring(4,6) + '-' + theDate.toLDAPString().substring(6,8)
			var records = new DataSet();
			records.add('days', 'Number', false).set(day);
			records.add('thedate', 'Date', false).set(theDate);
			records.add('theshortdate', 'String', false).set(theShortDate);
			records.add('nb_resources', 'Number', false).set(nb_resources);
			return records;
		}
	}
	return null;
}

function onReadPlatformLinearRegression() {

	if (! dataset.isEmpty('days')) {

		/*
		 * Collect all values from the main view and aggregate on commitday
		 */
		var values_x = [];
		var values_y = [];
		var record = businessview.getNextRecord();
		while (record != null) {
			var day = record.timeslotcommitday.get();
			if (day > mostRecentDay) {
				mostRecentDay = day;
			}
			var nb_platforms = record.nb_platforms.get();
			values_x.push(day);
			values_y.push(nb_platforms);
			record = businessview.getNextRecord();
		}

		/*
		 * compute the line vector and the estimate
		 */
		if (values_x.length >= 2) {
			var result = computeLineParameters(values_x, values_y);
			var today = mostRecentDay;
			day = today + dataset.days.get();
			nb_platforms = Math.floor((day * result[0]) + result[1]);
			theDate = new Date();
			theDate.setTime(day * 3600000 * 24);
			var theShortDate = theDate.toLDAPString().substring(0,4) + '-' + theDate.toLDAPString().substring(4,6) + '-' + theDate.toLDAPString().substring(6,8)
			var records = new DataSet();
			records.add('days', 'Number', false).set(day);
			records.add('thedate', 'Date', false).set(theDate);
			records.add('theshortdate', 'String', false).set(theShortDate);
			records.add('nb_platforms', 'Number', false).set(nb_platforms);
			return records;
		}
	}
	return null;
}

function onReadRoiLinearRegression() {

	if (projectionResult.length == 0) {

		/*
		 * Collect all values from the main view and aggregate on commitday
		 */
		var /*java.util.Map*/ map = new java.util.HashMap();
		var record = businessview.getNextRecord();
		var mostRecentRecord = null;
		while (record != null) {
			var day = record.timeslotcommitday.get();
			var /*java.util.Map*/ entry = map.get(day);
			if (entry == null) {
				entry = new java.util.HashMap();
				map.put(day, entry);
				if (day > mostRecentDay) {
					mostRecentRecord = entry;
				}
			}
			if (day > mostRecentDay) {
				mostRecentDay = day;
			}
			var user_type = record.user_type.get();
			var nb_users = record.nb_users.get();
			entry.put("" + user_type, nb_users);
			record = businessview.getNextRecord();
		}
		if (map.size() >= 2) {

			/*
			 * fill arrays for the algorithm computeLineParameters
			 */
			var values_x = [];
			var values_y_other = [];
			var values_y_epv = [];
			var values_y_app = [];
			var values_y_service = [];			
			var values_y_builtin = [];
			var values_y_all = [];
			var iterator = map.keySet().iterator();
			while (iterator.hasNext()) {
				var day = iterator.next();
				entry = map.get(day);
				var nb_other = entry.get(dataset.other_type.get());
				if (nb_other == null) {
					nb_other = 0;
				}
				var nb_epv = entry.get('EPV');
				if (nb_epv == null) {
					nb_epv = 0;
				}
				var nb_app = entry.get('Application');
				if (nb_app == null) {
					nb_app = 0;
				}
				var nb_service = entry.get('CA Id Service');
				if (nb_service == null) {
					nb_service = 0;
				}				
				var nb_builtin = entry.get('Built-in');
				if (nb_builtin == null) {
					nb_builtin = 0;
				}
				var nb_all = Math.floor(Number(nb_other) + Number(nb_epv) + Number(nb_app) + Number(nb_service) + Number(nb_builtin));
				values_x.push(day);
				values_y_other.push(nb_other);
				values_y_epv.push(nb_epv);
				values_y_app.push(nb_app);
				values_y_service.push(nb_service);
				values_y_builtin.push(nb_builtin);
				values_y_all.push(nb_all);
			}

			if (values_x.length > 0) {
				/*
				 * compute the line vector for each category (LDAP, Applcation...)
				 */
				var result_other = computeLineParameters(values_x, values_y_other);
				var result_epv = computeLineParameters(values_x, values_y_epv);
				var result_app = computeLineParameters(values_x, values_y_app);
				var result_service = computeLineParameters(values_x, values_y_service);
				var result_builtin = computeLineParameters(values_x, values_y_builtin);
				var result_all = computeLineParameters(values_x, values_y_all);

				/*
				 * compute the projection for several dates
				 */
				if (dataset.isEmpty('maxusers')) {
					var projection = [ 0/*most recent real data*/, 91/*3 months*/, 182/*6 months*/, 273/*9 months*/, 365/*1 year*/ ];
					var today = mostRecentDay;
					for (var i = 0; i < projection.length; i++) {
						if (projection[i] == 0) {
							/*
							 * add real data from the latest timeslot for graph
							 */
							nb_other = mostRecentRecord.get(dataset.other_type.get());
							if (nb_other == null) {
								nb_other = 0;
							}
							nb_epv = mostRecentRecord.get('EPV');
							if (nb_epv == null) {
								nb_epv = 0;
							}
							nb_app = mostRecentRecord.get('Application');
							if (nb_app == null) {
								nb_app = 0;
							}
							nb_service = mostRecentRecord.get('CA Id Service');
							if (nb_service == null) {
								nb_service = 0;
							}							
							nb_builtin = mostRecentRecord.get('Built-in');
							if (nb_builtin == null) {
								nb_builtin = 0;
							}
							//nb_all = Math.floor(Number(nb_other) + Number(nb_epv) + Number(nb_app) + Number(nb_builtin));
						}
						else {
							day = today + projection[i];
							nb_other = Math.floor((day * result_other[0]) + result_other[1]);
							nb_epv = Math.floor((day * result_epv[0]) + result_epv[1]);
							nb_app = Math.floor((day * result_app[0]) + result_app[1]);
							nb_service = Math.floor((day * result_service[0]) + result_service[1]);
							nb_builtin = Math.floor((day * result_builtin[0]) + result_builtin[1]);
							// nb_all = Math.floor((day * result_all[0]) + result_all[1]);
						}
						projectionResult.push([projection[i], nb_other, nb_epv, nb_app, nb_service, nb_builtin]);
					}
				}
				else {
					var maxUsers = dataset.maxusers.get();
					if (result_all[0] != 0) {
						day = Math.floor((maxUsers - result_all[1]) / result_all[0]);
					}
					else {
						day = Math.floor(mostRecentDay + 1234); // more than 3 years
					}
					var offset = Math.floor(day - mostRecentDay);
					if (offset < 0) {
						offset = 0;
					}
					nb_other = Math.floor((day * result_other[0]) + result_other[1]);
					nb_epv = Math.floor((day * result_epv[0]) + result_epv[1]);
					nb_app = Math.floor((day * result_app[0]) + result_app[1]);
					nb_service = Math.floor((day * result_service[0]) + result_service[1]);
					nb_builtin = Math.floor((day * result_builtin[0]) + result_builtin[1]);
					projectionResult.push([offset, nb_other, nb_epv, nb_app, nb_service, nb_builtin]);
				}
			}
		}
	}

	/*
	 * return next result from projectionResult
	 */
	if (flatResult.length > 0) {
		firstDone = true;
		return flatResult.pop();
	}
	if (projectionResult.length > 0) {
		var /*Array*/ result = projectionResult.shift();
		var theDate = new Date();
		theDate.setTime((mostRecentDay + result[0]) * 3600000 * 24);
		var theShortDate = theDate.toLDAPString().substring(0,4) + '-' + theDate.toLDAPString().substring(4,6) + '-' + theDate.toLDAPString().substring(6,8)
		if (dataset.isEmpty('mode') || (dataset.mode.get() == 'Aggregate')) {
			var records = new DataSet();
			records.add('days', 'Number', false).set(mostRecentDay + result[0]);
			records.add('diff', 'Number', false).set(result[0]);
			records.add('thedate', 'Date', false).set(theDate);
			records.add('theshortdate', 'String', false).set(theShortDate);
			records.add('nb_other', 'Number', false).set(result[1]);
			records.add('nb_epv', 'Number', false).set(result[2]);
			records.add('nb_app', 'Number', false).set(result[3]);
			records.add('nb_service', 'Number', false).set(result[4]);
			records.add('nb_builtin', 'Number', false).set(result[5]);
			nb_all = result[1] + result[2] + result[3] + result[4] + result[5];
			records.add('nb_all', 'Number', false).set(nb_all);
			firstDone = true;
			return records;
		}
		else { // mode 'Full' for graph
			records = new DataSet();
			records.add('days', 'Number', false).set(mostRecentDay + result[0]);
			records.add('diff', 'Number', false).set(result[0]);
			records.add('thedate', 'Date', false).set(theDate);
			records.add('theshortdate', 'String', false).set(theShortDate);
			records.add('nb_users', 'Number', false).set(Number(result[1]));
			records.add('user_type', 'String', false).set(dataset.other_type.get());
			flatResult.push(records);
			records = new DataSet();
			records.add('days', 'Number', false).set(mostRecentDay + result[0]);
			records.add('diff', 'Number', false).set(result[0]);
			records.add('thedate', 'Date', false).set(theDate);
			records.add('theshortdate', 'String', false).set(theShortDate);
			records.add('nb_users', 'Number', false).set(Number(result[2]));
			records.add('user_type', 'String', false).set('EPV');
			flatResult.push(records);
			records = new DataSet();
			records.add('days', 'Number', false).set(mostRecentDay + result[0]);
			records.add('diff', 'Number', false).set(result[0]);
			records.add('thedate', 'Date', false).set(theDate);
			records.add('theshortdate', 'String', false).set(theShortDate);
			records.add('nb_users', 'Number', false).set(Number(result[3]));
			records.add('user_type', 'String', false).set('Application');
			flatResult.push(records);
			records = new DataSet();
			records.add('days', 'Number', false).set(mostRecentDay + result[0]);
			records.add('diff', 'Number', false).set(result[0]);
			records.add('thedate', 'Date', false).set(theDate);
			records.add('theshortdate', 'String', false).set(theShortDate);
			records.add('nb_users', 'Number', false).set(Number(result[4]));
			records.add('user_type', 'String', false).set('CA Id Service');
			flatResult.push(records);			
			records = new DataSet();
			records.add('days', 'Number', false).set(mostRecentDay + result[0]);
			records.add('diff', 'Number', false).set(result[0]);
			records.add('thedate', 'Date', false).set(theDate);
			records.add('theshortdate', 'String', false).set(theShortDate);
			records.add('nb_users', 'Number', false).set(Number(result[5]));
			records.add('user_type', 'String', false).set('Built-in');
			flatResult.push(records);
			firstDone = true;
			return flatResult.pop();
		}
	}
	if (! firstDone) {
		firstDone = true;
		records = new DataSet();
		records.add('days', 'Number', false).set(0);
		records.add('diff', 'Number', false).set(0);
		records.add('thedate', 'Date', false).set(new Date());
		records.add('theshortdate', 'String', false).set('');
		records.add('nb_users', 'Number', false).set(0);
		records.add('user_type', 'String', false).set('');
		return records;
	}
	return null;
}

function onAggregateUserType() {

	if (! firstDone) {
		firstDone = true;

		/*
		 * Collect all values from the main view and aggregate on commitday
		 */
		var types = [0, 0, 0, 0, 0];
		var record = businessview.getNextRecord();
		while (record != null) {
			var type = record.user_type.get();
			switch (type) {
				case dataset.other_type.get(): types[0]++; break;
				case 'EPV': types[1]++; break;
				case 'Application': types[2]++; break;
				case 'CA Id Service': types[3]++; break;				
				case 'Built-in': types[4]++; break;
				default: types[5]++; break;
			}
			record = businessview.getNextRecord();
		}

		/*
		 * Fill output buffer with the 5 records
		 */
		var records = new DataSet();
		records.add('nb_users', 'Number', false).set(Number(types[0]));
		records.add('user_type', 'String', false).set(dataset.other_type.get());
		flatResult.push(records);
		records = new DataSet();
		records.add('nb_users', 'Number', false).set(Number(types[1]));
		records.add('user_type', 'String', false).set('EPV');
		flatResult.push(records);
		records = new DataSet();
		records.add('nb_users', 'Number', false).set(Number(types[2]));
		records.add('user_type', 'String', false).set('Application');
		flatResult.push(records);
		records = new DataSet();
		records.add('nb_users', 'Number', false).set(Number(types[3]));
		records.add('user_type', 'String', false).set('CA Id Service');
		flatResult.push(records);		
		records = new DataSet();
		records.add('nb_users', 'Number', false).set(Number(types[4]));
		records.add('user_type', 'String', false).set('Built-in');
		flatResult.push(records);
	}

	if (flatResult.length > 0) {
		return flatResult.pop();
	}
	return null;
}

function onAggregateUserTypeHistory() {

	if (! firstDone) {
		firstDone = true;

		/*
		 * Collect all values from the main view and aggregate on commitday
		 * WARNING: data MUST be sorted on timeslot
		 */
		var old_day = -1;
		var old_timeslotuid = "";
		var types = ['Built-in', 'EPV', 'Application', 'CA Id Service', dataset.other_type.get() ];
		var /*java.util.Map*/ map = new java.util.HashMap();
		var record = businessview.getNextRecord();
		while (record != null) {
			var day = record.timeslotcommitday.get();
			var timeslotuid = record.timeslotuid.get();
			var user_type = record.user_type.get();
			var user = record.uid.get();
			if (old_day != -1) {
				if (day == old_day) {
					var /*java.util.Set*/ set = map.get(user_type);
					if (set == null) {
						set = new java.util.HashSet();
						map.put(user_type, set);
					}
					set.add("" + user);
				}
				else {
					for each (var type in types) {
						var set = map.get(type);
						if (set != null) {
							var records = new DataSet();
							var theDate = new Date();
							theDate.setTime(old_day * 3600000 * 24);
							var theShortDate = theDate.toLDAPString().substring(0,4) + '-' + theDate.toLDAPString().substring(4,6) + '-' + theDate.toLDAPString().substring(6,8)
							records.add('timeslotuid', 'String', false).set(old_timeslotuid);
							records.add('thedate', 'Date', false).set(theDate);
							records.add('theshortdate', 'String', false).set(theShortDate);
							records.add('timeslot_date', 'String', false).set(theShortDate);
							records.add('nb_users', 'Number', false).set(Number(set.size()));
							records.add('user_type', 'String', false).set(type);
							flatResult.push(records);
						}
					}
					map.clear();
					old_day = day;
					old_timeslotuid = timeslotuid;
					set = new java.util.HashSet();
					set.add("" + user);
					map.put(user_type, set);
				}
			}
			else {
				old_day = day;
				old_timeslotuid = timeslotuid;
				set = new java.util.HashSet();
				set.add("" + user);
				map.put(user_type, set);
			}
			record = businessview.getNextRecord();
		}
		if (old_day != -1) {
			for each (var type in types) {
				var set = map.get(type);
				if (set != null) {
					records = new DataSet();
					var theDate = new Date();
					theDate.setTime(old_day * 3600000 * 24);
					var theShortDate = theDate.toLDAPString().substring(0,4) + '-' + theDate.toLDAPString().substring(4,6) + '-' + theDate.toLDAPString().substring(6,8)
					records.add('timeslotuid', 'String', false).set(old_timeslotuid);
					records.add('thedate', 'Date', false).set(theDate);
					records.add('theshortdate', 'String', false).set(theShortDate);
					records.add('timeslot_date', 'String', false).set(theShortDate);
					records.add('nb_users', 'Number', false).set(Number(set.size()));
					records.add('user_type', 'String', false).set(type);
					flatResult.push(records);
				}
			}
		}
	}

	if (flatResult.length > 0) {
		return flatResult.shift();
	}
	return null;
}

function onCountUsers() {
	if (! firstDone) {
		firstDone = true;
		var nb = 0;
		var record = businessview.getNextRecord();
		while (record != null) {
			nb++;
			record = businessview.getNextRecord();
		}
		records = new DataSet();
		records.add('nb_users', 'Number', false).set(Number(nb));
		return records
	}
	return null;
}

function onCountIdentities() {
	if (! firstDone) {
		firstDone = true;
		var /*java.util.Set*/ set = new java.util.HashSet();
		var record = businessview.getNextRecord();
		while (record != null) {
			var identityuid = record.identityuid.get();
			set.add('' + identityuid);
			record = businessview.getNextRecord();
		}
		records = new DataSet();
		records.add('nb_identities', 'Number', false).set(Number(set.size()));
		return records
	}
	return null;
}

function onReadIdentitiesJob() {
	if (! firstDone) {
		firstDone = true;

		/*
		 * Group all identities by job
		 */
		var /*java.util.Map*/ jobs = new java.util.HashMap();
		var /*java.util.Map*/ map = new java.util.HashMap();
		var record = businessview.getNextRecord();
		while (record != null) {
			var identityuid = record.identityuid.get();
			var jobtitleuid = record.isEmpty('jobtitleuid') ? 'N/A' : record.jobtitleuid.get();
			var jobtitledisplayname = record.isEmpty('jobtitledisplayname') ? 'N/A' : record.jobtitledisplayname.get();
			jobs.put('' + jobtitleuid, '' + jobtitledisplayname);
			var /*java.util.Set*/ set = map.get('' + jobtitleuid);
			if (set == null) {
				set = new java.util.HashSet();
				map.put('' + jobtitleuid, set);
			}
			set.add('' + identityuid);
			record = businessview.getNextRecord();
		}

		/*
		 * Generate all identities for each job
		 */
		var iterator = map.keySet().iterator();
		while (iterator.hasNext()) {
			jobtitleuid = iterator.next();
			set = map.get('' + jobtitleuid);
			var records = new DataSet();
			records.add('nb_identities', 'Number', false).set(Number(set.size()));
			records.add('jobtitleuid', 'String', false).set(jobtitleuid);
			records.add('jobtitledisplayname', 'String', false).set(jobs.get('' + jobtitleuid));
			flatResult.push(records);
		}
	}

	if (flatResult.length > 0) {
		return flatResult.shift();
	}
	return null;
}

function onReadIdentitiesOrg() {
	if (! firstDone) {
		firstDone = true;

		/*
		 * Group all identities by org
		 */
		var /*java.util.Map*/ orgs = new java.util.HashMap();
		var /*java.util.Map*/ map = new java.util.HashMap();
		var record = businessview.getNextRecord();
		while (record != null) {
			var identityuid = record.identityuid.get();
			var organizationuid = record.isEmpty('organizationuid') ? 'N/A' : record.organizationuid.get();
			var organizationdisplayname = record.isEmpty('organizationdisplayname') ? 'N/A' : record.organizationdisplayname.get();
			orgs.put('' + organizationuid, '' + organizationdisplayname);
			var /*java.util.Set*/ set = map.get('' + organizationuid);
			if (set == null) {
				set = new java.util.HashSet();
				map.put('' + organizationuid, set);
			}
			set.add('' + identityuid);
			record = businessview.getNextRecord();
		}

		/*
		 * Generate all identities for each org
		 */
		var iterator = map.keySet().iterator();
		while (iterator.hasNext()) {
			organizationuid = iterator.next();
			set = map.get('' + organizationuid);
			var records = new DataSet();
			records.add('nb_identities', 'Number', false).set(Number(set.size()));
			records.add('organizationuid', 'String', false).set(organizationuid);
			records.add('organizationdisplayname', 'String', false).set(orgs.get('' + organizationuid));
			flatResult.push(records);
		}
	}

	if (flatResult.length > 0) {
		return flatResult.shift();
	}
	return null;
}

function onReadSafeFullLinearRegression() {
	if (! firstDone) {
		firstDone = true;

		/*
		 * Collect all values from the main view and aggregate on commitday
		 */
		var /*java.util.Map*/ map = new java.util.HashMap();
		var record = businessview.getNextRecord();
		var mostRecentNbSafes = null;
		while (record != null) {
			var day = record.timeslotcommitday.get();
			var nb_safes = record.nb_safes.get();
			if (day > mostRecentDay) {
				mostRecentDay = day;
				mostRecentNbSafes = nb_safes;
			}
			map.put(day, nb_safes);
			record = businessview.getNextRecord();
		}
		if (map.size() >= 2) {

			/*
			 * fill arrays for the algorithm computeLineParameters
			 */
			var values_x = [];
			var values_y = [];
			var iterator = map.keySet().iterator();
			while (iterator.hasNext()) {
				day = iterator.next();
				nb_safes = map.get(day);
				if (nb_safes == null) {
					nb_safes = 0;
				}
				values_x.push(day);
				values_y.push(nb_safes);
			}

			if (values_x.length > 0) {
				/*
				 * compute the line vector
				 */
				var result = computeLineParameters(values_x, values_y);

				/*
				 * compute the projection for several dates
				 */
				var projection = [ 0/*most recent real data*/, 91/*3 months*/, 182/*6 months*/, 273/*9 months*/, 365/*1 year*/ ];
				var today = mostRecentDay;
				for (var i = 0; i < projection.length; i++) {
					if (projection[i] == 0) {
						/*
						 * add real data from the latest timeslot for graph
						 */
						nb_safes = mostRecentNbSafes;
						if (nb_safes == null) {
							nb_safes = 0;
						}
					}
					else {
						day = today + projection[i];
						nb_safes = Math.floor((day * result[0]) + result[1]);
					}
					projectionResult.push([projection[i], nb_safes]);
				}
			}
		}
	}

	/*
	 * return next result from projectionResult
	 */
	if (projectionResult.length > 0) {
		var /*Array*/ result = projectionResult.shift();
		var theDate = new Date();
		theDate.setTime((mostRecentDay + result[0]) * 3600000 * 24);
		var theShortDate = theDate.toLDAPString().substring(0,4) + '-' + theDate.toLDAPString().substring(4,6) + '-' + theDate.toLDAPString().substring(6,8)
		records = new DataSet();
		records.add('days', 'Number', false).set(mostRecentDay + result[0]);
		records.add('thedate', 'Date', false).set(theDate);
		records.add('theshortdate', 'String', false).set(theShortDate);
		records.add('nb_safes', 'Number', false).set(Number(result[1]));
		return records;
	}
	return null;
}
