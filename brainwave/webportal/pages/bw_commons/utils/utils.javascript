
/* cypher a multivalued list of passwords:
replaces each value by its crypted one if not already crypted
*/
function cypherPasswordsIfNecessary( /* Attribute */ passwords) {
    var /*int*/ count = passwords.length;
    var /*String*/ pwd ;
     var /*String*/ cypher; 
    for (var i=0; i < count; i++) {
        pwd = passwords.get(i);
        // crypt and replace if not already crypted, and not empty 
        if (pwd.length > 0 && pwd.left(8) !="{crypt2}") {
              cypher = connector.cipherPassword(pwd);
              passwords.set(i, cypher);
        }	
        else cypher = pwd;             
      //  print( "[DEBUG] password="+pwd + " cypher="+cypher);
    }
}

function percentageLabel( ) {
    var ratio= percentageInternal(  dataset.val.get() , dataset.total.get() );
    return ratio.toFixed(0) + "%";
}

function percentage( ) {
	return percentageInternal(  dataset.val.get() , dataset.total.get() );
}

/*Number */ function sumList( ) {
	var list = dataset.get("list");
	var /*Number*/ sum = 0;
	for ( var i=0; i < list.length;i++){
		sum = sum + list.get([i]);
	}
	return sum;
}
/*  copy list2 to list1 if it's not null 
    list1 = 	Input { multivalued: True mandatory: True }
    list2 = Input {multivalued: True mandatory: True }
    result = Output { multivalued: True  }
*/
function transferDataIfNotNull() {
	
    var /*Attribute */ list1 = dataset.get("list1");
    var /*Attribute */ list2= dataset.get("list2"); 
    var /*Attribute */ result= dataset.get("result"); 
    var val; 
    result.clear();
    for ( var i=0; i< list1.length;i++) {
    	val = list1.get(i);
    	if (list2.get(i) != null) val = list2.get(i);
    	result.add( val);
    }
 //   print( "transferDataIfNotNull list1="+list1.toString()+ " list2="+list2.toString()+  " result="+ result.toString());
}

/* Array*/  function multiValuedToArray( /*Attribute*/ attribute ){
    var values = [];
    for (var i=0; i<attribute.length ; i++)
        values.push( attribute.get(i));
    return values; 
}

function percentageInternal( val, total ) {
	return  (total == 0 ) ? 0: (val* 100 / total) | 0; 
}
