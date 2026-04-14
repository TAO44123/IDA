function controller_api_url( /*String */part ) {	
	return config.bwdsm_controller_url +"/"+ part; 
}


function listDsCfgRest (mode, start, limit, sorting) {	
	print( "listDS mode="+mode + " start="+start + " limit=" + limit + " sort="+sorting[0])
	var /*String*/ category = dataset.category.get();
	if (category == 'all') category = null; 		
	var result = connector.sendHttpRequest( "GET", controller_api_url("connector")  );
	
	var /*java.util.List*/ list;
	if (result!==null) {
		list =  result.connectors;
		// filter by category
		if ( list !== null && category != null){
			var /*java.util.List*/ newList = new java.util.ArrayList();
			var /*java.util.Map*/ ds ; 
			for (var i=0;i<list.size();i++){
				ds =list.get(i);
				if ( ds.get("category") == category)
				  newList.add(ds);
			}
			list = newList;
		}
	}
	else {
	    list = null; 
	}	
	return mode == "data"? list : ( list !== null  ? list.size(): 0) ;		
}

function getDsCfgRest ( ){
	var id = dataset.pid.get();
	var result = id !== null ? connector.sendHttpRequest( "GET", controller_api_url("connector/"+id) ) : null;
    return result; 
}

/* returns the id of the created DS , chaine vide si error*/
//TODO gérer les erreurs
function createDsCfgRest() {
	var data = { 
		type: dataset.type.get(),
		category: dataset.category.get(),
		name: dataset.name.get(),
		description: dataset.description.get(),
		enabled: dataset.enabled.get() ,
		config: dataset.config.get(),
		scheduling: dataset.scheduling.get()
	};	
	print("create ds: data="+data);
	var result = connector.sendHttpRequest("POST",controller_api_url("connector") , null, data);
	// result is org.json.simple.JSONObject 	
	print("result="+result);
	if (result != null){
		if (result.connector != null) 
		  return result.connector.id;
	}  
	return null; 
}

function updateFullDsCfgRest() {
	var id = dataset.pid.get();
	var data = { 
		type: dataset.type.get(),
		category: dataset.category.get(),
		name: dataset.name.get(),
		description: dataset.description.get(),
		enabled: dataset.enabled.get() ,
		config: dataset.config.get(),
		scheduling: dataset.scheduling.get()
	};	
	print("updating full ds: data="+data);
	var result = connector.sendHttpRequest("PATCH",controller_api_url( "connector/"+id) , null, data);
	return result.success ? "OK" : result.errors.get(0).detail ; 
}

/*
pid = Input{ mandatory: True  type: Integer}
   title = Input 
   description = Input
   disabled = Input { type: Boolean }
   options = Input 
*/
function updateDsCfgRest() {
	var id = dataset.pid.get();
	var data = { 
		description: dataset.description.get(),
		enabled: dataset.enabled.get() ,
		config: dataset.config.get(),
		scheduling: dataset.scheduling.get()
	};	
	var result = connector.sendHttpRequest("PATCH",controller_api_url( "connector/"+id) , null, data);
	print( "[DEBUG] update DS@"+id+ " data { " + " scheduled:" + data.scheduling + " description:" + data.description + " } => " + result);
	return result.success ? "OK" : result.errors.get(0).detail ; 
}

function toggleDsEnabledRest() {
	var id = dataset.pid.get();
	var data = {
		enabled: dataset.enabled.get() ,
	};
	var result = connector.sendHttpRequest("PATCH",controller_api_url( "connector/"+id) , null, data);
	print( "[DEBUG] toggle enabled for DS@"+id+ " data { " + " enabled:" + data.enabled + " } => " + result);
	return result.success ? "OK" : result.errors.get(0).detail ; 
}

function deleteDsCfgRest() {
	var id = dataset.pid.get();	
	var result = connector.sendHttpRequest("DELETE",controller_api_url("connector/"+id) );
	print("[DEBUG] Delete datasource "+id+ " ->" + result );
	if (result != null){
		return result.success == true? "OK": result.error;
	}
	else 
	  return result; // error
}

/* BATCHES*/

function listBatches (mode, start, limit, sorting) {	
	print( "listBatch mode="+mode + " start="+start + " limit=" + limit + " sort="+sorting)
	var result = connector.sendHttpRequest( "GET", controller_api_url( "batch/list")  );
	var /*java.util.List*/ list = result!= null? result.batches: null; 
	return mode == "data"? list : ( list != null  ? list.size(): 0) ;		
}

function getCurrentBatch () {		
	var result = connector.sendHttpRequest( "GET", controller_api_url("batch")  );
	return result;		
}

/* get first non-submitted */
function getLastCompletedBatch(){
	var /* java.util.Map */ result = connector.sendHttpRequest( "GET", controller_api_url( "batch/list")  );
	var /*java.util.List*/ batches = result != null? result.batches: null ;
	if (batches == null)
	  return null; 
	var batch;
	var status;
	var result = null;
	var max_id = -1;
	for (var i=batches.size()-1;i>=0;--i){
		batch = batches.get(i);
		status = batch.status;
		//print ( "i="+ i+ " batch="+ batch.get("id")+ " status="+status);
		if ( status !='S' && status != 'R'){
			if (Number(batch.get("id")) > max_id ){
				max_id = Number(batch.get("id"))
				result = batches.get(i);
			}
		}
	}
	return result;
}

function startBatch(){
	var data = { 
		principal: dataset.principal.get(),		
	};	
	print("start batch principal="+dataset.principal.get());
	var result = connector.sendHttpRequest("POST",controller_api_url( "batch") , null, data);
	// result is java.util.Map 	
	print("start batch result="+result);
	if (result != null){
		dataset.id.set( result.id);
		dataset.message.set(result.message);
		dataset.success.set(result.success);
	}
	else {
		dataset.message.set("api_failure");
		dataset.success.set(false);
	}  
}


/* files*/

var staticFiles = [ 
	  { name: "mock_file1.ldif", path: "ad_1", size: 12000 } ,
	  { name: "mock_file2.csv", path: "hr_1", size: 5000 } 	  
	]

function listFiles (mode, start, limit, sorting) {	
	print( "listFiles mode="+mode + " start="+start + " limit=" + limit + " sort="+sorting)
	//var result = connector.sendHttpRequest( "GET", config.bwdsm_controller_url+ "importfiles/list" , null );
	//var /*java.util.List*/ list = result.batches; 
	//return mode == "data"? list : ( list != null  ? list.size(): 0) ;	
	return mode="data"? staticFiles: staticFiles.length; 
}

function uploadZipFile( ){
  var /*String*/ filePath = dataset.file.get();
  	var query = {
  	   source:  dataset.source.get()
  	}
  	var config = {
  		headers: {
  		  "Content-Type" : "application/x-zip-compressed"	
  		}
  	};
  	var /*java.io.File*/ body = new java.io.File( filePath);
	var result = connector.sendHttpRequest("POST",controller_api_url("upload"),query, body, config);	
	print( "send POST to "+ controller_api_url("upload")+ " with file: "+ body.getCanonicalPath())
	print( "Deleting zip " + body.getCanonicalPath() );
	java.nio.file.Files.deleteIfExists(java.nio.file.Paths.get( body.getCanonicalPath() ));
	return result; 
}


/* both implementations of zipToFile are rejected by the controller with the following error:
(Zstream.Unzip.Error) Zip files with data descriptor record are not supported
*/
function buildZipFile() {
	var /*String*/ filePath = dataset.filepath.get();
	var /*String*/ localFilePath = dataset.localfilepath.get();
	var /*java.util.zip.ZipOutputStream*/ zipOut = null; 
	try {
		var /*java.io.File*/ fileToZip = new java.io.File(filePath); 
		var /*java.io.File*/ zipFile = java.io.File.createTempFile("upload_data_", ".zip");
		var /*java.nio.channels.FileChannel*/ fc = java.nio.channels.FileChannel.open(zipFile.toPath(), java.nio.file.StandardOpenOption.WRITE);
		zipOut = new java.util.zip.ZipOutputStream(fc);
	    var /* java.util.zip.ZipEntry*/ zipEntry = new java.util.zip.ZipEntry(localFilePath);
	    // add entry
	    zipOut.putNextEntry(zipEntry);
	    //write bytes
	     java.nio.file.Files.copy(fileToZip.toPath(), zipOut);
	     zipOut.closeEntry();
	     dataset.zipfilepath.set(zipFile.getCanonicalPath());	    		    
	}
	catch( e){
		dataset.zipfilepath.set("");
		print("Error while zipping files: "+ e);		
	}
	finally {
		if (zipOut !== null)
		  zipOut.close();
	}
}


function buildZipFile2() {
	var /*String*/ filePath = dataset.filepath.get();
	var /*String*/ dir = dataset.dir.get();
	var /*org.apache.commons.compress.archivers.zip.ZipArchiveOutputStream*/ zipOut = null; 
	try {
		var /*java.io.File*/ fileToZip = new java.io.File(filePath); 
		var /*java.io.File*/ zipFile = java.io.File.createTempFile(dir+"_", ".zip");
		zipOut = new org.apache.commons.compress.archivers.zip.ZipArchiveOutputStream(new java.io.FileOutputStream(zipFile));
		zipOut.putArchiveEntry(zipOut.createArchiveEntry(fileToZip, fileToZip.getName()));
	    java.nio.file.Files.copy(fileToZip.toPath(), zipOut);
	    zipOut.closeArchiveEntry();
	    zipOut.finish();
	    dataset.zipfilepath.set(zipFile.getCanonicalPath());	    		    
	}
	catch( e){
		dataset.zipfilepath.set("");
		print("Error while zipping files: "+ e);		
	}
	finally {
		if (zipOut !== null)
		  zipOut.close();
	}
}


