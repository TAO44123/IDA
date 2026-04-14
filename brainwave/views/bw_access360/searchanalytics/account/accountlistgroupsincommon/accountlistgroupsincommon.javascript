
function init() {
}

var index = 0;
var identitylist = new Array();
var lastbucketkey = null
prepared = false
function prepareData() {
	prepared = true;

	
	var record = businessview.getNextRecord();
	if(record==null) {
		// dataset vide, on osrt 
		return null;	
	}
	
	var /*String*/ key = ''+record.key.get();
	var /*String*/ bucketkey = ''+record.bucketkey.get();
	var entry = {};
	
	if(lastbucketkey==null) {
		lastbucketkey = bucketkey; 
		// on initialise la premiere liste d'identités sur la base de la premiere permission trouvée
		entry = {};	// on sauvegarde la premiere entrée
		entry.key = key;
		entry.record = record;
		identitylist.push(entry);
		
		while(true) {
			record = businessview.getNextRecord();
			if(record == null) {
				return; // plus de records... il n'y avait donc qu'une permission dans la liste
			}
			key = ''+record.key.get();
			bucketkey = ''+record.bucketkey.get();
			if(!bucketkey.equals(lastbucketkey)) {
				lastbucketkey = bucketkey; 
				break; // on passe au record suivant	
			}
			
			entry = {}; // on sauvegarde l'entrée
			entry.key = key;
			entry.record = record;
			identitylist.push(entry);
		}
	}
	
	// a ce stade, on regarde les autres permissions et on réduit la liste d'identités en conséquence
	// une optimisation possible serait de travailler avec une approche en double curseur pour identifier les différences entre les deux listes
	var nomorerecords = false;
	while(!nomorerecords) {
		// on charge dans templist la liste des uid d'identités pour la permission suivante
		var templist = new java.util.HashSet(); 
		while(true) {
			templist.add(''+key);
	
			record = businessview.getNextRecord();
			if(record == null) {
				nomorerecords = true;
				break; // plus de records...
			}
			key = ''+record.key.get();
			bucketkey = ''+record.bucketkey.get();
			if(!bucketkey.equals(lastbucketkey)) {
				lastbucketkey = bucketkey; 
				break; // on passe au record suivant	
			}
		}
		
		// on réduit la liste d'identités pour ne garder que celles qui ont aussi cette permission
		var newlist = new Array();
		for(var i=0;i<identitylist.length;i++) {
			entry = identitylist[i];
			if(templist.contains(entry.key)) {
				newlist.push(entry);			
			}
		}
		identitylist = newlist;
	}	
}

function read() {
	if(!prepared) {
		prepareData();
	}
	if(index>=identitylist.length)
		return null;
	return identitylist[index++].record;
}

function dispose() {
}
