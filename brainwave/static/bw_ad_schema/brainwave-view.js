

			
( function ($) {

	$.urlParam = function(name){
		var results = new RegExp('[\?&]' + name + '=([^&#]*)').exec(window.location.href);
		if (results==null){
		   return null;
		}
		else{
		   return results[1] || 0;
		}
	}

	$.fn.bwViewResolveSync = function () {
		jQuery.ajaxSetup({async: false });
		return $(this).bwViewResolve ();
	};
	
	$.fn.bwViewResolve = function ( callback ) {
	
		var rootObj = $(this)
		
		$(".brainwave-view",rootObj).each ( function(index, source ){ 

			var viewid = $(source).attr("id");
			var paramlist = $(source).attr("paramlist");
			var format = $(source).attr("format");
			var key = $(source).attr("key");
			var value = $(source).attr("value");
			var parentkey = $(source).attr("parentkey");
			var rootkey = $(source).attr("rootkey");
			var args = {};
			
			
			
			
			var paramString = ""
			var paramSplit = paramlist.split(",");
			
			if ( paramSplit.length > 0 ){
				for ( i=0; i<paramSplit.length;i++){
					paramString = paramString + "&" + paramSplit[i] + "=" + $.urlParam(paramSplit[i]);
					
					if ( rootkey == paramSplit[i] ) {
						rootkey = $.urlParam(paramSplit[i]) ;
					}
				}
			}
			
			args["viewid"] = viewid;
			args["key"] = key;
			args["value"] = value;
			args["parentkey"] = parentkey;
			args["rootkey"] = rootkey;
			
			
			if (format =="ul") {
				callBrainwaveView ( viewid , paramString, processResultsUl, args , callback)
			}
			
			if (format =="ultree") {
				callBrainwaveView ( viewid , paramString, processResultsUlTree, args, callback)
			}
	
		
		});
	
	};
	
	function processResultsUlTree ( results, args, callback ) {
		// Identify the placeholder
		var source = $( "div[id*='"+args['viewid']+"']" );
		
		// Create the root container ul
		topul = $(document.createElement('ul'));
		topul.attr("id","view_" +args['viewid'] );
		topul.insertAfter ( source );
		
		// Search for the root node and insert it
		for ( i=0; i < results.length; i++ ){
			if ( results[i][args["key"]] == args["rootkey"] ){
				lielement = $(document.createElement('li'));
				lielement.attr ( "id", results[i][args["key"]] );

				itema = $(document.createElement('a'));
				itema.text ( results[i][args["value"]] );
				itema.appendTo(lielement);
				
				lielement.appendTo ( topul );
				break;
			}
		}
		
		// Make a list of nodes that we need to place
		inScope = [];
		for ( i=0; i < results.length; i++ ){
			if ( jQuery.inArray ( results[i][args["key"]], inScope ) == -1 ){
					inScope.push ( results[i][args["key"]] );
			}
		}
		
		var cont = true;
		
		while ( cont ) {
			
			cont = false;
			
			for ( i=0; i < results.length; i++ ){
				
				
				// Is it already placed?
				placed = false;
				topul.find ( '#' + results[i][args["key"]] ).each(function (j,jitem){
					itid = $(jitem).attr("id");
					parentid = $(jitem).parent().parent().attr("id");
					
					if ((itid == results[i][args["key"]] ) && (parentid == results[i][args["parentkey"]] )) {
						
						placed = true;
					}
				});
				
				
				// Is it well placed ?
				if (placed == false ){
					
					// Its not well placed, can we place it ?
					if ( topul.find ( '#' + results[i][args["parentkey"]] ).length>0){
						// We place it
				
						topul.find ( '#' + results[i][args["parentkey"]] ).each(function (j, jparent){
							
							// Does not have an ul ?
							if ( $(this).find('ul').length == 0 ){
								newul = $(document.createElement('ul'));
								newul.appendTo ( $(this) );
							}
							parentul = $(this).find('ul').get(0);
						
							lielement = $(document.createElement('li'));
							lielement.attr ( "id", results[i][args["key"]] );
							
							itema = $(document.createElement('a'));
							itema.text ( results[i][args["value"]] );
							itema.appendTo(lielement);
							
							lielement.appendTo ( parentul );
						});
					}
					else {
						// Cannot place, is it in our scope?
						if ( jQuery.inArray ( results[i][args["parentkey"]], inScope ) != -1 ){
							// We must continue
							cont = true;
						}
					}
				}
			}
		}
		
		topul.attr("class","tree");
		source.remove();
		callback();
	}
	
	function processResultsUl ( results, args , callback) {
		var source = $('#'+args['viewid']);
		
		ulelement = $(document.createElement('ul'));
		ulelement.attr("id","view_" +args['viewid'] );
		ulelement.insertAfter ( source );
		
		for ( i=0; i < results.length; i++ ){
			
			lielement = $(document.createElement('li'));
			lielement.attr ( "id", results[i][args["key"]] );
			lielement.text ( results[i][args["value"]] );
			lielement.appendTo ( ulelement );
		}
		
		source.remove();
		
		if (callback != null){
			callback();
		}
		
	};
	
	function callBrainwaveView ( viewname , customParams ,callback, args, callback2 ) {
		
		var results = [];
		
		if (   viewname.indexOf("/") > 0 ){
			var rootUrl = "../../../"
			var resultingUrl = rootUrl + viewname + "?" + customParams.replace(/\?/g,"&") ;
		}
		else {
			var rootUrl = "../../../ws/results/";
			var standardParams = "_limit=1000";
			var resultingUrl = rootUrl + viewname + "?" + standardParams + customParams.replace(/\?/g,"&") ;
		}
		
		$.getJSON( resultingUrl , function( data ) {
			$.each( data.data, function( key, val ) {
				results.push ( val );
			});
		})
			.done ( function () { callback( results, args , callback2  );} );
	}

}(jQuery));