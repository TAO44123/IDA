

var FULL_CONTROL = 0x3FFF; //1111111111111
var MODIFY             = 0x1FEC; //1111111101100
var READ_EXECUTE       = 0x1E04; //1111000000100
var READ               = 0x0E04; //00111000000100
var WRITE              = 0x01E4; //00000111100100 

var BASIC_PERM_MASKS = [ 
  {mask: FULL_CONTROL, label: "Full Control", code: "F"},
  {mask: MODIFY, label: "Modify", code: "M"},
  {mask: READ_EXECUTE, label: "Read & Execute", code: "X"},
  {mask: READ, label: "Read", code: "R"},
  {mask: WRITE, label: "Write", code: "W"} 
 ];
   
var SPECIAL_PERM = { label: "Special Authorizations", code: "S"};
  
/*  identifies set of basic permissions from action letters
input: action : letter string of permissions
return: String of basic permissions codes (FMXRWS);
*/

function getBasicPermissionsFromRights(){
	
	//print("rights="+dataset.action.get());
	var /*Boolean*/ fmtLabel = dataset.get("fmt") != null && dataset.fmt.get() == 'label';   // if not found, then code
	var /*Number*/ permBits = convertActionToPermBits(dataset.action.get());	
	var /*Number*/ permBitsSpecial = permBits; // used for computing special auths
		
	var /*Array*/ basicPermissions = [];
	for each ( var rightsMask in BASIC_PERM_MASKS){
        //print("rightsMask.mask="+ rightsMask.mask.toString(2) + " and:"+ (allowBits & rightsMask.mask).toString(2));
		if ( (permBits & rightsMask.mask)  == rightsMask.mask){ // all bits of mask are set
		    basicPermissions.push(fmtLabel?rightsMask.label: rightsMask.code);
		    permBitsSpecial &=  ~rightsMask.mask; // clear found mask from special
		}
	}
	// if something left in special bits, then add to permission
	if (permBitsSpecial != 0)
	   basicPermissions.push(fmtLabel? SPECIAL_PERM.label: SPECIAL_PERM.code);
   	    
	return basicPermissions.join(fmtLabel?"\n":"");
}

/*Boolean*/ function hasSpecialPermission() {

	var /*Boolean*/ special = getBasicPermissionsFromRights().right(1) == "S";	
	return special? (dataset.negative.get() ? "2":"1" ) : "0";
}

/* utils */

var WIN_RIGHTS = "OPGDSMLAWFERX";  // in bit order O=0, X=12

// turns action permission (letters as RWXGASPFOEMDL) to bit field number in windows order X=12 R E F W A L M S D G P O=0
// return number 
function convertActionToPermBits( /*String*/ action){
    var bits = 0;
    var pos;  
    if (action == null ) { return bits; }
    for (var /*int */i = 0; i < action.length; i++) {
		 pos = WIN_RIGHTS.indexOf(action[i] );
		// print("i="+i+" c="+action[i]+ " pos="+pos);
		 // if found, set bit
		 if (pos >= 0)
		    bits |= (1 << pos);
	}	
	//print( "action="+action+" bits="+bits.toString(2));  
	return bits; 
}

