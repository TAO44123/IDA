
/*
concatQuotedStrings = StringService {

	strings = Input { multivalued: True mandatory: True}
	quote = Input { default: "\"" }
	separator = Input { default: ","}	
}
*/

function concatQuotedStrings(){
	var /*Attribute*/ strings = dataset.strings;
	var /*Attribute*/ nbaccounts = dataset.nbaccounts;
	var /*String*/ quote = dataset.quote.get();
	var /*String*/ sep = dataset.separator.get();
	var /*String*/ result = "";
	var /*int*/ i=0;
	for ( i=0; i < strings.length; i++) {
	   if (i > 0) result += sep; 	
	   result += quote + strings.get(i)+ quote;
	}
	return result; 
}


function b64_sha1() {
	var /*String*/ b64digest = "";
	var /*String*/ str = dataset.string.get();
	if (str != null && str.length > 0) {
		var /*java.security.MessageDigest*/ msgDigest = java.security.MessageDigest.getInstance("SHA-1");
		var /*byte[]*/ digest = msgDigest.digest(getBytes(str));
		var /*String*/ b64digest = java.util.Base64.getEncoder().encodeToString(digest);
		print(digest);
		print(b64digest);
	}
	return b64digest;	
}

// use java reflect to get bytearray from a String as it's not possible to call getBytes directly on a java.lang.String !
function /*byte[]*/ getBytes(/*String*/ str) {
	var /*java.util.Class*/ cls = java.lang.Class.forName("java.lang.String");
	var /*java.reflect.Method*/ method = cls.getMethod("getBytes", cls);
	var /*byte[]*/ res = method.invoke(str, "UTF-8");
	return res;
}