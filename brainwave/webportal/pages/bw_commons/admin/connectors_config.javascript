import "../utils/CSVWriter.javascript"
import "../utils/utils.javascript"

/*
   uid = Input {  multivalued: True mandatory:  True}
   address = Input {  multivalued: True mandatory:  True}
   port= Input {  multivalued: True mandatory:  True}
   password = Input {  multivalued: True mandatory:  True}
   timeOut = Input {  multivalued: True mandatory:  True}
   searchDir =  Input {  multivalued: True mandatory:  True}
   workDir =  Input {  multivalued: True mandatory:  True}
   archiveDir =  Input {  multivalued: True mandatory:  True}
   scriptDir =  Input {  multivalued: True mandatory:  True}  
   paramsDir =  Input {  multivalued: True mandatory:  True}
     
*/

function saveConnectorServersConfig(){
    cypherPasswordsIfNecessary( dataset.password);
	writeVariablesToCSVFile( getConnectorConfigPath() ,  [ "uid","address","port","password","timeOut","searchDir","workDir","archiveDir","scriptDir","paramsDir"]); 
    
    saveADLogsConfigs(); // will create the MV attributes   
	 	  		     
}

function loadConnectorServersConfig(){
		readVariablesFromCSVFile( getConnectorConfigPath(), [ "uid","address","port","password","timeOut","searchDir","workDir","archiveDir","scriptDir","paramsDir"]); 
}

function getConnectorConfigPath() {  
   var path = config.projectPath+ "/webportal/data/ConnectorServer_Config.csv" ;
   return path; 
}


function extractConnectorsAdd( connectorIP, connectorPort, connectorPassword,  connectorTimeOut,connectorSearchDir, connectorArchiveDir, connectorParamsDir, frequency){
	var /*Attribute */ logs_connectorIP = dataset.get("logs_connectorIP"); 
//	print("[DEBUG] connectorIP=" + connectorIP); 
//	print("[DEBUG]logs_connectorIP=" + logs_connectorIP);
	if (logs_connectorIP.indexOf(connectorIP) == -1) {
		   dataset.get("logs_connectorIP").add( connectorIP); 
		    dataset.get("logs_uid").add(connectorIP);
		    dataset.get("logs_frequency").add(frequency);	    
			dataset.get("logs_connectorPort").add(connectorPort);		
		    dataset.get("logs_connectorPassword").add(connectorPassword);
		    dataset.get("logs_connectorTimeOut").add(connectorTimeOut);
		    dataset.get("logs_connectorSearchDir").add(connectorSearchDir);
		    dataset.get("logs_connectorArchiveDir").add(connectorArchiveDir);
		    dataset.get("logs_connectorParamsDir").add(connectorParamsDir);
	}	
}

function saveExtractConnectorsConfig( configFilePath){
	 writeVariablesToCSVFile(  configFilePath , 
	    [ "logs_uid", "logs_filePattern", "logs_cfgFile", "logs_cfgDestFile",    "logs_frequency"
	    , "logs_connectorIP", "logs_connectorPort", "logs_connectorPassword","logs_connectorTimeOut","logs_connectorSearchDir","logs_connectorArchiveDir", "logs_connectorParamsDir" ],
	    [ "uid",  "filePattern",  "configFile",  "configDestFile",  "frequency"
	     , "connectorIP",   "connectorPort",    "connectorPassword",    "connectorTimeOut","connectorSearchDir","connectorArchiveDir","connectorParamsDir" ]
	 ); 
}

/**
 * saveLogsConfigBase
 * @param filePattern : file pattern of extracted files to retrieve ( eg. "NALogs_*.zip") 
 * @param configDestFile:  name of the config file when copied to connector params
 * @param selectConnectorCB : callback|null to select connectors in this configuration. signature must be bool mySelector(i) and returns true if item at row i must be selected for extraction
 *      
 * @return 
 */
function saveLogsConfigBase(filePattern, configDestFile , selectConnectorCB ){
	
    var /*Attribute*/ uids = dataset.get("uid");
    var /*Attribute*/ logsEnableds = dataset.get("logsEnabled");
   var /*Attribute*/ logsFrequencys = dataset.get("logsFrequency");
    var /*Attribute*/ connectorIPs = dataset.get("connectorIP");
    var /*Attribute*/ connectorPorts = dataset.get("connectorPort");
    var /*Attribute*/ connectorPasswords = dataset.get("connectorPassword");
    var /*Attribute*/ connectorTimeOuts = dataset.get("connectorTimeOut");
    var /*Attribute*/ connectorSearchDirs = dataset.get("connectorSearchDir");
    var /*Attribute*/ connectorArchiveDirs = dataset.get("connectorArchiveDir");
    var /*Attribute*/ connectorWorkDirs = dataset.get("connectorWorkDir");
    var /*Attribute*/ connectorParamsDirs = dataset.get("connectorParamsDir"); 
    
    /*
 "logs_uid", "filePattern", "logs_cfgFile", "logs_cfgDestFile",    "logs_frequency"
	    , "logs_connectorIP", "logs_connectorPort", "logs_connectorPassword","logs_connectorTimeOut","logs_connectorSearchDir","logs_connectorArchiveDir", "logs_connectorParamsDir" ],
 */       
 /*create MV consolidated variables, to hold per server values*/
   var /*Attribute*/ logs_uid = dataset.add( "logs_uid", "String", true);
	var /*Attribute*/ logs_connectorIP = dataset.add( "logs_connectorIP", "String", true);	
	var /*Attribute*/ logs_connectorPort = dataset.add( "logs_connectorPort", "String", true);
	var /*Attribute*/ logs_connectorPassword = dataset.add( "logs_connectorPassword", "String", true);
	var /*Attribute*/ logs_connectorTimeOut = dataset.add( "logs_connectorTimeOut", "String", true);
	var /*Attribute*/ logs_connectorSearchDir = dataset.add( "logs_connectorSearchDir", "String", true);
	var /*Attribute*/ logs_connectorArchiveDir = dataset.add( "logs_connectorArchiveDir", "String", true);
	var /*Attribute*/ logs_connectorParamsDir = dataset.add( "logs_connectorParamsDir", "String", true);
	var /*Attribute*/ logs_frequency = dataset.add( "logs_frequency", "String", true);
	var /*Attribute*/ logs_cfgFile = dataset.add( "logs_cfgFile", "String", true);
	
	// Single-values attributes 
	var /*Attribute*/ logs_cfgDestFile = dataset.add( "logs_cfgDestFile", "String", false);
	var /*Attribute*/ logs_filePattern = dataset.add("logs_filePattern","String", false);
	logs_filePattern.set(filePattern);
	logs_cfgDestFile.set(configDestFile);		
		
	var logsEnabled ;
	var selectOK ; 
	var nbids = uids.length; 
	var i;
	
	/* 1)  collect the list of different connector IPs that have at least one log enabled logs enabled, and prefill lists */
	for (i=0; i < nbids; i++) {
	  logsEnabled = logsEnableds.get(i);	  
	  selectOK = selectConnectorCB == null || selectConnectorCB(i);

		if (logsEnabled && selectOK ) {  // add if not found and logs enabled 
		   extractConnectorsAdd( connectorIPs.get(i),  connectorPorts.get(i), connectorPasswords.get(i), connectorTimeOuts.get(i), connectorSearchDirs.get(i), connectorArchiveDirs.get(i)  , connectorParamsDirs.get(i),logsFrequencys.get(i));
		}
	}		
	
}

