/* API to read and write multivalues variables to a CSV file*/

/* public function, do not call from page
write values of multivalued vars to filePath
all vars must be of same size */
/**
 * writeVariablesToCSVFile
 * @param filePath path to file
 * @param varNames names of multivalued variables containing the values to write
 * @param colNames [optional] if csv column names are different than varNames
 *
 * Note: can accept single valued variables, in which case it will use the same value for all rows 
 */
function writeVariablesToCSVFile( /*String*/ filePath, /*Array*/ varNames, /*Array*/ colNames) {
	
   var /*org.supercsv.io.CsvListWriter*/ writer = null;
  // first try to create parent directories if not exists
   var /*java.io.File */ f = (new java.io.File( filePath));   
   f.getParentFile().mkdirs();
/*   if (!f.mkdirs()) {
     print("Failed to create directories for: "+ f);
   	 return; // failed to creat parent directories 	 
   }*/
   
    try {     
		   var /*java.io.FileWriter */ fw = new java.io.FileWriter(  f );
		   writer = new Packages.org.supercsv.io.CsvListWriter( fw, Packages.org.supercsv.prefs.CsvPreference.EXCEL_NORTH_EUROPE_PREFERENCE) ;
		   var nbRows = dataset.get(varNames[0]).length; 
		   var /*int*/nbCols  = varNames.length ; 
		   var /*Attribute*/mvattr  ; 
		   var len ; 
		   var /*java.util.List<Object>*/ row; 
		   var val; 
		   // write headers
		   if (!colNames) colNames = varNames; 
		   writer.write(  arrayToList(colNames));   
		   // write variables values
		   for (var r=0;r<nbRows;r++) {
		   	  row = new Packages.java.util.ArrayList(nbCols); 
		   	  for ( var c=0; c < nbCols; c++){
		        mvattr = dataset.get(varNames[c]); // multivalued attribute 		        
		        if (mvattr != null && ((len=mvattr.length) > r || len == 1)){
		   	  	      val = mvattr.get(len>1?r:0);  // get first item for mono-valued 
		   	  	      if (val == null) val = "";
		        }
		   	  	else {
		   	  	   print("Warning. Cannot read variable:"+varNames[c]+ " at line: "+ r );
		   	  	   val = "";
		   	  	}
		   	  	row.add(val); 
		   	  }   	    
		   	  writer.write(row);
		   }
    }
    finally {
    	if (writer != null)
    	    writer.close();
    }
 
}

/* public function
read content of csv filePath, and fill  result into variables at varNames
*/
 function readVariablesFromCSVFile(/*String*/ filePath, /*Array*/ varNames ){	

  var /*java.io.FileReader*/ fr ;
  var /*org.supercsv.io.CsvMapReader */ reader = null; 
  var nbCols  = varNames.length ;
  var /*Attribute*/ v  ; 
  var /*int*/ c; 
  // clear vars
  for ( c=0; c < nbCols; c++){
        v = dataset.get(varNames[c]);
        if (v!= null){
        	v.clear();
        }
  }  

   try {
    	  fr = new java.io.FileReader(filePath);
    }
    catch (e) {    	
       // return quietly if file not found
        return; 
    } 
  try {	
	    reader = new Packages.org.supercsv.io.CsvMapReader(fr,  Packages.org.supercsv.prefs.CsvPreference.EXCEL_NORTH_EUROPE_PREFERENCE);      
	   var header = reader.getCSVHeader(true);
	   var /*java.util.Map*/ row ; 
	   var /*String*/varName ; 
	   while ( (row = reader.read(header)) != null){
	   	    for ( c=0; c < nbCols; c++){
	   	      varName = varNames[c];
	           v = dataset.get(varName);
		        if (v!= null){
		        	v.add(row.get(varName));
		        }
	        }  
	   }
  }
  finally {	
  	 if (reader != null) 
         reader.close();
  }
  }

/*java.util.ArrayList*/ function arrayToList( /*Array*/array ) {
	var len = array.length;
	var list = new Packages.java.util.ArrayList(len); 
	for each ( var item in array ) {
		list.add(item);
	}
	return list; 
}

