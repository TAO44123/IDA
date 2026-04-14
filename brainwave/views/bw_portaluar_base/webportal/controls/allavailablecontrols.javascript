
listControlCode = []
hashDisplayname = {}
hashID = {}
hashFilename = {}


function init() {
	print ( "Project path :" + config.projectPath )
	walkDir ( config.projectPath + '/controls'  );
}

function walkDir ( /*String*/ path ){
	var /*java.io.File*/ dir = new java.io.File( path );
	var list = dir.listFiles();
	for ( var i=0 ; i < list.length ; i++ ){
		if (list[i].isDirectory()){
			walkDir ( list[i].getAbsolutePath()  )
		}
		else {
			if ( list[i].getName().endsWith('.control') ) {
				print ( list[i].getName() );
				try {
					readControlXML ( list[i].getAbsolutePath() );
				} catch (e) {} 
			}
		}
	}
}

function findAttributeValue(/*java.lang.StringBuilder*/ buf, /*String*/ attr) {
	var /*String*/ content = "" + buf.toString();
	var /*String*/ searchStr = attr + '="';
	var /*Number*/ firstIndex = content.indexOf(searchStr);
	if (firstIndex == -1) {
		return null;
	}
	var /*Number*/ lastIndex = content.indexOf('"', firstIndex + searchStr.length);
	var /*String*/ rawText = content.substring(firstIndex + searchStr.length, lastIndex);
	var /*String*/ text = rawText.replace("&lt;", "<", "gm").replace("&gt;", ">", "gm").replace("&quot;", '"', "gm").replace("&apos;", "'", "gm");
	return text;
}

function readControlXML ( /*String*/ filepath ) {
	print ("Reading file " + filepath )
	var /*java.io.BufferedReader*/ reader = null;
	try {
		reader = new java.io.BufferedReader(new java.io.InputStreamReader(new java.io.FileInputStream('' + filepath), "UTF-8"));
		var content = new java.lang.StringBuilder(4096);
		var /*String*/ line = reader.readLine();
		while (line != null) {
			content.append("" + line);
			content.append('\n');
			line = reader.readLine();
		}
		var /*String*/ controlcode = findAttributeValue(content, "code");
		if (controlcode == null) {
			throw "Attribute 'code' not found in control file"
		}
		listControlCode.push(controlcode);
		var /*String*/ filename = filepath.substring(filepath.replace('\\', '/').lastIndexOf('/'));
		hashFilename[controlcode] = filename;
		hashID[controlcode] = findAttributeValue(content, "name");
		hashDisplayname[controlcode] = findAttributeValue(content, "displayname");
	}
	catch (e) {
		print("ERROR reading " + filepath + ": " + e.toString());
	}
	finally {
		if (reader != null) {
			reader.close();
		}
	}
}

function read() {
	var item = listControlCode.pop()
	if ( item != null ){
		var ds = new DataSet();
		ds.controlcode = item;
		ds.displayname = hashDisplayname[ item ];
		ds.filename = hashFilename[ item ];
		ds.controlid = hashID [ item ]
		return ds;
	}
	return null;
}
