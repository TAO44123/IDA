/* services for auditLog pages*/

function makePattern() {
	var str = dataset.str.get();
	return str ? "%"+str+"%": str; 
}