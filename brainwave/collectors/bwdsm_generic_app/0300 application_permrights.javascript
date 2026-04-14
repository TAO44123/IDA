
var /*Boolean*/ isInitialized = false;
function write() {
	var /*String*/ externalrepositoryid = dataset.externalrepositoryid.get();
	if(externalrepositoryid == null)
		return;

	var /*String*/ ad_sourceFolder = config.ad_sourceFolder;
	if(ad_sourceFolder == null)
		return;

	// init cache
	if(!isInitialized) {
		var /*java.io.File*/ dir = new java.io.File(ad_sourceFolder);
		crawl(dir);
		isInitialized = true;
	}
	
	var /*java.util.Map*/ directory = directories.get(externalrepositoryid);
	if(directory==null) // external directory not found, not an AD domain? abort!
		return;
		
	var /*String*/ identifier = dataset.identifier.get();
	if(identifier.indexOf(',')!=-1) // we found a "," in the identifier, we assume that it is a DN, abort!
		return;

	// let's retrieve the dn from the login thanks to the cache
	var /*String*/ login = dataset.login.get();
	var /*String*/ dn = directory.get(login);

	// let's replace the identifier by the DN in case of an Active Directory external repository
	// as the collect is (unfortunately) not resolving logins in the case of AD
	dataset.identifier.set(dn);
}


/**
 * Local cache of samaccountname/dn pairs per domain
 * This map contains one submap per domain
 * each submap contains samaccountname as keys and dn as values
 */
var /*java.util.Map*/ directories = new java.util.HashMap();

/**
 * Crawl subdirectories to look for AD LDIF files
*/
function crawl(/*java.io.File*/ directory) {
	var /*java.io.File[]*/ elements = directory.listFiles();
	
	for(var i=0;i<elements.length;i++) {
		var /*java.io.File*/ element = elements[i];
		if(element.isDirectory())
			crawl(element);
		
		// we found an ldif file
		var /*String*/ strFilename = element.getName();
		if(strFilename.toLowerCase().endsWith(".ldif")) {
			var /*String*/ strFile = element.getCanonicalPath();
			parse(strFile, strFilename);
		}	
	}
}

/**
 * Parse an AD LDIF file to retrieve logins & DNs and save them in a local cache
*/
function parse(/*String*/ canonicalPath, /*String*/ filename) {
	var /*String*/ domain = filename.left(filename.length-5); // remove ".ldif" suffix to get the domain
	var parser = provisioning.getFileParser("LDIF");
	parser.encoding = "UTF-8";
	parser.objectclass = "user";
	parser.onelevel = false;
	parser.strictlist = false;
	var /*java.util.Map*/ entry = null;

	var /*java.util.HashMap*/ directory = directories.get(domain);
	// register directory in the map
	if(directory == null) {
		directory = new java.util.HashMap();
		directories.put(domain, directory);	
	}
	
	parser.open(canonicalPath);
	while((entry=parser.readLine())!=null) {
		var v;
		var dn = null;
		var samaccountname = null;
		
		v = entry.get('dn');
		if(v!=null && v.length>0)
			dn = ''+v[0];
		v = entry.get('samaccountname');		
		if(v!=null && v.length>0)
			samaccountname = ''+v[0];
		
		if(samaccountname!=null && dn!=null)
			directory.put(samaccountname, dn);
	}
	
	parser.close();
}