
function Node ( data ) {
	this.data = data;
	this.display = null;
	this.links = [];
}

function NodeStack () {
	this.nodes = [];
}

function Context () {
	this.loops = [];
	this.table = null;
	this.root = null;
}

function Item ( uid, parent_uid , display) {
	this.uid = uid;
	this.parentUid = parent_uid;
	this.display = display;
}

Node.prototype = { 
	equals: function( node ){
		return ( node.data && this.data==node.data);
	},
	equalsdata: function( data ){
		return ( data && this.data==data);
	}
}

NodeStack.prototype = {
	contains: function(node) {
		for ( var i in this.nodes ) {
			if (this.nodes[i].equals(node)){
				return true;
			}
		}
		return false;
	},
	containsdata: function(data) {
		for ( var i in this.nodes ) {
			if (this.nodes[i].equalsdata(data)){
				return true;
			}
		}
		return false;
	},
	getnode: function (data){
		for ( var i in this.nodes ) {
			if (this.nodes[i].equalsdata(data)){
				return this.nodes[i];
			}
		}
		return null;
	},
	remove: function(node) {
		for ( var i in this.nodes ) {
			if (this.nodes[i].equals(node)){
				this.nodes.splice ( i,1);
				return;
			}
		}
		return false;
	}
}


function findLoops () {
	
	// The uid is mandatory param
	if ( dataset.isEmpty("rootuid") ){
		return;
	}
	
	// Get the root uid
	var uid = dataset.rootuid.get();
	
	// Prepare context object
	var context = new Context();
	
	// Call view to get all hierarchy
	params = new java.util.HashMap();
	params.put("rootuid", uid );
	context.table = connector.executeView(null, "ad_group_hierarchy", params );
	context.root = new Node( "root" );
	
	// Recursion stack
	var stack = new NodeStack();
	
	// Find the group with the given uid to launch recursion
	for ( var i=0 ; i< context.table.length ; i++ ){
		if (context.table[i].get("uid")==uid){
			visitTree( context , i, stack, context.root);
			break;
		}
	}
	
	var finalOutput = "";
	
	// if any loop was found, prepare output
	if ( context.loops.length > 0 ) {
		
		loop = context.loops[0];
		
		var sb = java.lang.StringBuilder();
		sb.append("{  \"data\" : [ ");
		
		var count = 0;
		
		for ( var i in loop ){
		//	print ( "o " +  loop[i].uid + " p " + loop[i].parentUid + " d " + loop[i].display );
			
			sb.append ("{");
			sb.append ( "\"uid\" : \""+loop[i].uid+"\"");
			sb.append (",");
			sb.append ( "\"parent_uid\" : \""+loop[i].parentUid+"\"");
			sb.append (",");
			sb.append ( "\"displayname\" : \""+loop[i].display+"\"");
			sb.append ("}");
			sb.append (",");
			count = count + 1;
		}
		
		if ( count > 0 ) {
			sb.deleteCharAt( sb.length()-1 );
		}
		
		sb.append("] }");
		
		finalOutput = sb.toString();
	}
	
	return finalOutput;
}

function output ( results, stack , node, thisparent ) {
	
	// visit
	var it = new Item ( node.data.toString(), thisparent.toString(), node.display.toString());
	results.push ( it );
	
	// recurse
	for ( var i in node.links ) {
		if (stack.containsdata ( node.links[i].data )) {
			output ( results, stack, node.links[i] , node.data);
		}
	}
}

function saveOutput ( stack, root, prev ) {
	
	var results = [];
	output ( results, stack , root, 'none' );
	
	// Add the backlink
	var it = new Item ( root.data.toString(), prev.data.toString(), root.display.toString());
	results.push ( it );
	
	return results;
	
}

function visitTree (context , pos , stack , prev) {
	// Visit
	var node = new Node ( context.table[pos].get( "uid").toString() );
	node.display = context.table[pos].get( "displayname").toString();
	
	// is a back link ?
	if ( stack.contains (node) ){
		
		// found a loop
		var out = saveOutput (stack , stack.getnode(node.data), prev );
		context.loops.push (out);
		
		//stop
		return;
	}
	else {
		// put node in the stack
		stack.nodes.push ( node );
		if ( prev!=null ){
			prev.links.push ( node );
		}
	}
	
	// Recurse
	for ( var k=0 ; k< context.table.length ; k++ ){
		if ( node.equalsdata ( context.table[k].get("parent_uid").toString()) ){
			visitTree (context, k, stack, node);	
		}
	}
	
	// Out
	stack.remove ( node );
}


