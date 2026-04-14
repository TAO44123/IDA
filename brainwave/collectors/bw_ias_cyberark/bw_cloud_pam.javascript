
function readObjectProperties() {
	if(dataset._objectpropertyname != null){
		dataset.cc_automaticmanagementenabled = true;
		for (var i = 0; i < dataset._objectpropertyname.length; i++) {
			var objectName = dataset._objectpropertyname.get(i);
			var objectValue = dataset._objectpropertyvalue.get(i);
			switch (objectName) {
				case "UserName":
					dataset.cc_username = objectValue;
					break;
					
				case "Address":
					dataset.cc_address = objectValue;
					break;
	
				case "PolicyID":
					dataset.cc_platformid = objectValue;
					break;
	
				case "CPMDisabled":
					dataset.cc_automaticmanagementenabled = false;
					dataset.cc_manualmanagementreason = objectValue;
					break;
	
				case "CPMStatus":
					dataset.cc_status = objectValue;
					break;
	
				case "LastSuccessReconciliation":
					if(objectValue != null && objectValue.length > 0){
						//toLDAPString()
						var date_attr = new Attribute("date_attr", "Date", false);
						var /*java.lang.Long*/ timestamp = java.lang.Long.parseLong(objectValue);
						var /*java.util.Date*/ date = new java.util.Date(timestamp * 1000);
						var /*java.text.SimpleDateFormat*/ dateFormat = new java.text.SimpleDateFormat("yyyyMMddHHmmss");
						dataset.cc_lastreconciledtime = dateFormat.format(date)
					}
					break;
	
				case "LastSuccessVerification":
					if(objectValue != null && objectValue.length > 0){
						var date_attr = new Attribute("date_attr", "Date", false);
						var /*java.lang.Long*/ timestamp = java.lang.Long.parseLong(objectValue);
						var /*java.util.Date*/ date = new java.util.Date(timestamp * 1000);
						var /*java.text.SimpleDateFormat*/ dateFormat = new java.text.SimpleDateFormat("yyyyMMddHHmmss");
						dataset.cc_lastverifiedtime = dateFormat.format(date)
					}
					break;
	
				default:
					break;
			}
			
		}		
	}

}

function otherDirectory() {
	throw "Only Entra ID external directory is supported";
}
