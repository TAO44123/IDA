var cipherpack = JavaImporter(
	Packages.com.brainwave.utils.AESUtils
);

var prefixsize = 4;

/**
 *  Pages wrappers
 */
function  pages_cipher() {
	var /*String*/ str = dataset.str.get();
	return cipher(str);
}

/**
 * decipher
 */
function pages_decipher() {
	var /*String*/ str = dataset.str.get();
	return decipher(str);
}

/**
 * encryptFields encrypts ITSM attributes in the database
 * @return 
 */
function encryptFields(/*Array*/ fields) {
	for (var i=0; i<fields.length;i++) {
		process(fields[i], false);
	}
}

/**
 * encryptFields encrypts ITSM attributes in the database
 * @return 
 */
function decryptFields(/*Array*/ fields) {
	for (var i=0; i<fields.length;i++) {
		process(fields[i], true);
	}
}

function getEncryptedFieldValue(fieldName, /*boolean*/ decrypt) {
	if(dataset.isEmpty(fieldName)) {
		return '';	
	}

	var str = ''+dataset.get(fieldName);
	
	var encStr;
	if ("true".equalsIgnoreCase(''+decrypt)) {
		encStr = decipher(str);
	} else {
		encStr = cipher(str);
	}
	return encStr;
}

function process(fieldName, /*boolean*/ decrypt) {
	var encStr = getEncryptedFieldValue(fieldName, decrypt);
	if(encStr!=null && encStr.length>0) {
		dataset.get(fieldName).set(encStr);
	}
}


// /////////////////////////////////////////////////////////////////////
/**
 * cipher a string
 * 
 * @param str 
 * @return ciphered string
 */
function  cipher(/*String*/ str) {
	if(str.startsWith("nomacro:{secret}"))
		return str; // already ciphered...

	with(cipherpack) {
		var /*String*/ key = getKey();

		var /*String*/ prefix = makeprefix(prefixsize);

		var crypto = new AESUtils();
		var encrypted = crypto.encrypt(prefix+str, key);
		
		return "nomacro:{secret}"+encrypted;
	}
}

/**
 * decipher a string
 * 
 * @param str 
 * @return deciphered string
 */
function decipher(/*String*/ str) {
	with(cipherpack) {
		var /*String*/ key = getKey();

		if(!str.startsWith("nomacro:{secret}"))
			return str;
		else
			str = str.substring("nomacro:{secret}".length);

		var crypto = new AESUtils();
		var decrypted = crypto.decrypt(str, key);
		
		return decrypted.substring(prefixsize);
	}
}


function getKey() {
	var defaultkey="Gfsz54f8DFqsq*!R"

	var key = config.ias_secretpassword;
	if(key==null || key.length==0)
		key = defaultkey;
		
	return key;
}

function makeprefix(length) {
    var result           = '';
    var characters       = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    var charactersLength = characters.length;
    for ( var i = 0; i < length; i++ ) {
      result += characters.charAt(Math.floor(Math.random() * charactersLength));
   }
   return result;
}
