
function compute() {
	var record= businessview.getNextRecord();
	if(record == null)
		return null;
	
	var /*Number*/ max = -1;
	
	var org_sensitivitylevel = record.isEmpty('org_maxsensitivitylevel')?-1:record.org_maxsensitivitylevel.get();
	var account_sensitivitylevel = record.isEmpty('account_maxsensitivitylevel')?-1:record.account_maxsensitivitylevel.get();

	if(org_sensitivitylevel>max)
		max = org_sensitivitylevel;
	if(account_sensitivitylevel>max)
		max = account_sensitivitylevel;

	if(max>-1)
		record.maxsensitivitylevel.set(max);
	
	return record;
}
