
function init() {
}

var done = false;
var error = ''; // error pretty string
var message = ''; // error details
var errorcounter = 0;

function read() {
	// only one record
	if(done)
		return null;
	done = true;	
	
	// do the job
	job();
	
	// return errors if any
	if(error.length>0) {
		record = new DataSet();
		var /*Attribute<String>*/ attribute = record.add("message", "String", false);
	    attribute.set(message);
		attribute = record.add("error", "String", false);
	    attribute.set(error);
	    return record;
	}
	else {
		return null;
	}
}

function dispose() {
}

// ////////////////////////////////////////////////

// ///////////////////////////////////////////////////////
// Copy source file to destination file
function job() {
	var /*String*/ sourcepath = dataset.sourcefile.get();
	var /*String*/ destpath = dataset.destinationfile.get();

	if(sourcepath==null || sourcepath.length==0) {
		error = 'Cannot copy file - source file not set';
		message = '';
		return;	
	}
	if(destpath==null || destpath.length==0) {
		error = 'Cannot copy file - destination file not set';
		message = '';
		return;	
	}

	var /*java.io.File*/ file = new java.io.File(sourcepath);
	if(!file.exists() || !file.isFile()) {
		error = 'Cannot copy file - file not found ['+sourcepath+']';
		message = '';
		return;	
	}

	copyFile(sourcepath, destpath);
}

function copyFile(sourceFile, destFile) {
	print('---> sourcefile:'+sourceFile);
	print('---> destFile:'+destFile);
	
 	var /*java.io.File*/ sourceFile = new java.io.File(sourceFile); 
 	var /*java.io.File*/ destFile = new java.io.File(destFile); 
 	
     if(!destFile.exists()) {
      destFile.createNewFile();
     }

     var /*java.nio.channels.FileChannel*/ source = null;
     var /*java.nio.channels.FileChannel*/ destination = null;
     try {
      source = new java.io.RandomAccessFile(sourceFile,"r").getChannel();
      destination = new java.io.RandomAccessFile(destFile,"rw").getChannel();

      var position = 0;
      var count = source.size();

      source.transferTo(position, count, destination);
     }
     catch(e) {
		error = 'Error while copying file ['+sourceFile+'] to ['+destFile+']';
		message = e;
     }
     finally {
      if(source != null) {
       source.close();
      }
      if(destination != null) {
       destination.close();
      }
    }
}