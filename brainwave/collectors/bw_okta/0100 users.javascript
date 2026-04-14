
function getSilo() {
	var /*String*/ file = config.siloIteratedFileFullname;
	file = file.replace("\\","/","g");
	var data = 	file.split('/');
	var /*String*/ silo = data[data.length-2];
	dataset.siloName = silo;
	config.siloName = silo; 
}
