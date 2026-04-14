var records = [];

var /*Number*/ MAX_IN_LIST = 8;

function onAggregate() {
	var previousKey = null;
	var previousRecord = null;
	var nbNew = 0;
	var nbRemoved = 0;
	var listNew = "";
	var listRemoved = "";
	var record = businessview.getNextRecord();
	while (record != null) {
		var key = record.key.get();
		var status = record.status.get();
		var item = record.item.get();
		if (previousKey != key) {
			if (previousRecord != null) {
				if ((! previousRecord.isEmpty('vault_importaction') && previousRecord.vault_importaction.get() == 'C') ||
					(! previousRecord.isEmpty('safe_importaction') && previousRecord.safe_importaction.get() == 'C')) {
					nbNew = 0;
					nbRemoved = 0;
					listNew = "";
					listRemoved = "";
				}
				previousRecord.add("nb_new_defects", "Number", false).set(nbNew);
				previousRecord.add("nb_removed_defects", "Number", false).set(nbRemoved);
				previousRecord.add("list_new_defects", "String", false).set(listNew);
				previousRecord.add("list_removed_defects", "String", false).set(listRemoved);
				records.push(previousRecord);
			}
			previousKey = key;
			previousRecord = record;
			nbNew = 0;
			nbRemoved = 0;
			listNew = "";
			listRemoved = "";
		}
		if (status == 'New') {
			nbNew = nbNew + 1;
			if (nbNew < (MAX_IN_LIST + 2)) {
				if (listNew == null || listNew == '') {
					listNew = item;
				}
				else {
					if (nbNew < (MAX_IN_LIST + 1)) {
						var /*String*/ newListNew = listNew + ", " + item;
						if (newListNew.length < 995) {
							listNew = newListNew;
						}
					}
					else {
						listNew = listNew + "...";
					}
				}
			}
		}
		else if (status = 'Removed') {
			nbRemoved = nbRemoved + 1;
			if (nbRemoved < (MAX_IN_LIST + 2)) {
				if (listRemoved == null || listRemoved == '') {
					listRemoved = item;
				}
				else {
					if (nbRemoved < (MAX_IN_LIST + 1)) {
						var /*String*/ newListRemoved = listRemoved + ", " + item;
						if (newListRemoved.length < 995) {
							listRemoved = newListRemoved;
						}
					}
					else {
						listRemoved = listRemoved + "...";
					}
				}
			}
		}
		record = businessview.getNextRecord();
	}
	if (previousRecord != null) {
		if ((! previousRecord.isEmpty('vault_importaction') && previousRecord.vault_importaction.get() == 'C') ||
			(! previousRecord.isEmpty('safe_importaction') && previousRecord.safe_importaction.get() == 'C')) {
			nbNew = 0;
			nbRemoved = 0;
			listNew = "";
			listRemoved = "";
		}
		previousRecord.add("nb_new_defects", "Number", false).set(nbNew);
		previousRecord.add("nb_removed_defects", "Number", false).set(nbRemoved);
		previousRecord.add("list_new_defects", "String", false).set(listNew);
		previousRecord.add("list_removed_defects", "String", false).set(listRemoved);
		records.push(previousRecord);
		previousRecord = null;
	}
	if (records.length > 0) {
		return records.pop();
	}
	return null;
}
