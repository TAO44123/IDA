var content = new Array();
var titles = new Array();
var url = new Array();

function crawlContent(/*String*/ path) {
 	var /*java.io.File*/ f = new java.io.File(path);
	var /*java.io.File[]*/ pathnames = f.listFiles();

	for(var i=0;i<pathnames.length;i++) {
		var /*java.io.File*/ pathname = pathnames[i];
		var canonicalPath = pathname.getCanonicalPath();
	 	if(pathname.isDirectory()) {
			crawlContent(canonicalPath);	 		
		}
		else {
			if(canonicalPath.indexOf('generated_doc')!=-1) {
				if(canonicalPath.indexOf('doclibrary.html')!=-1) {
					// skip this one
				}
				else if(canonicalPath.indexOf('.html')!=-1) {
					content.push(canonicalPath);
				}
			}		
		}
	}
}

function getTitles() {
	for(var i=0;i<content.length;i++) {
		var /*String*/ filepath = content[i];

		var title = getTitle(filepath);
		titles.push(title);
	}	
}

function getTitle(/*String*/ filepath) {
	var /*java.io.File*/ file = new java.io.File(filepath); 
  	var /*java.io.BufferedReader*/ br = new java.io.BufferedReader(new java.io.FileReader(file)); 
  
	var /*String*/ title = file.getName();
	title = title.left(title.length-5);
	title = title.replace('_', ' ', 'g');
	var /*String*/ st;
  	while ((st = br.readLine()) != null) {
  		var titleIndex = st.indexOf('<title>');
  		var headIndex = st.indexOf('</head>');

		if(headIndex!=-1)
			break;
		if(titleIndex!=-1) {
			title = st.substring(titleIndex+7);
			title = title.substring(0, title.indexOf('<'));
			break;
		}
	}
	
	br.close(); 
	return title;
}

function convertContent(/*Integer*/ nbCarsToSkip) {
	for(var i=0;i<content.length;i++) {
		var /*String*/ c = content[i];
		c = c.substring(nbCarsToSkip);	
		c = c.replace('\\', '/', 'g');
		c = 'static/static/'+c;
		url.push(c);
	}	
}

function init() {
	
	var /*String*/ projectPath = config.projectPath;
	var /*String*/ staticPath = projectPath+'/static/';
	
	crawlContent(staticPath);
	getTitles();
	convertContent(staticPath.length);
	
	var deb = 0;
	deb = 1;
}

var i = 0;
function read() {
	if(i>=content.length)
		return null;
		
	var /*Attribute<String>*/ attribute;
 	var /*DataSet*/ record = new DataSet();
    attribute = record.add("path", "String", false);
    attribute.set(content[i]);
    attribute = record.add("title", "String", false);
    attribute.set(titles[i]);
    attribute = record.add("url", "String", false);
    attribute.set(url[i]);
	i = i + 1;

    return record;	
}

function dispose() {
}