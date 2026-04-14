
function IsMappingFile() {
	var /*String*/ file = config.bw_servicenowcimapping_sourcefolder;
	if(file == null)
		return;
	file = file + "/sncmdbcimapping/idamapping.csv";
	var /*java.io.File*/ test = new java.io.File(file);
	dataset.mappingExists.set(test.exists());
}
