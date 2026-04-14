var labelType, useGradients, nativeTextSupport, animate;

(function() {
  var ua = navigator.userAgent,
      iStuff = ua.match(/iPhone/i) || ua.match(/iPad/i),
      typeOfCanvas = typeof HTMLCanvasElement,
      nativeCanvasSupport = (typeOfCanvas == 'object' || typeOfCanvas == 'function'),
      textSupport = nativeCanvasSupport 
        && (typeof document.createElement('canvas').getContext('2d').fillText == 'function');
  //I'm setting this based on the fact that ExCanvas provides text support for IE
  //and that as of today iPhone/iPad current text support is lame
  labelType = (!nativeCanvasSupport || (textSupport && !iStuff))? 'Native' : 'HTML';
  nativeTextSupport = labelType == 'Native';
  useGradients = nativeCanvasSupport;
  animate = !(iStuff || !nativeCanvasSupport);
})();

/*
var Log = {
  elem: false,
  write: function(text){
    if (!this.elem) 
      this.elem = document.getElementById('log');
    this.elem.innerHTML = text;
    this.elem.style.left = (500 - this.elem.offsetWidth / 2) + 'px';
  }
};
*/

var lastclick=null;
function init(){

	var html = document.documentElement;
	var infovis = document.getElementById('infovis');
	var divwidth = html.clientWidth;
	var divheight = html.clientHeight;
	infovis.style.width = divwidth;
	infovis.style.height = divheight;

//	var offsetX = document.documentElement.clientWidth / 3;
	var offsetX = 0;

    //end
    //init Spacetree
    //Create a new ST instance
    var st = new $jit.ST({
        //id of viz container element
        injectInto: 'infovis',
        //set duration for the animation
        duration: 800,
        //set animation transition type
        transition: $jit.Trans.Quart.easeInOut,
        //set distance between node and its children
        levelDistance: 20,
        offsetX: offsetX,

	    orientation: "top",
	    indent:0,
	    align:"center",

		constrained: false,
		levelsToShow : 2, // 1 or 2

		width:divwidth,
		height:divheight,

		Canvas: {
			width:divwidth,
			height:divheight
		},
        //enable panning
        Navigation: {
          enable:true,
          panning:true,
		  zooming : false
        },
        //set node and edge styles
        //set overridable=true for styling individual
        //nodes or edges
        Node: {
			align: 'left',
		    autoHeight: true,
		    autoWidth: true,
            type: 'rectangle',
            color: '#d5dadc', // default node color
            overridable: true
        },
        
        Edge: {
            type: 'bezier',
            overridable: true
        },
        
        Tips: {
        	enable: true,
        	onShow: function(tip, node){ if(node.id == lastclick) tip.innerHTML = 'Click to see the details'; else  tip.innerHTML = 'Extra stuff'; }
        },
        onBeforeCompute: function(node){
            // Log.write("loading " + node.name);
        },
        
        onAfterCompute: function(){
            // Log.write("done");
        },
        
        //This method is called on DOM label creation.
        //Use this method to add event handlers and styles to
        //your node.
        onCreateLabel: function(label, node){
            label.id = node.id;
            label.innerHTML = node.name;
            label.onclick = function(){
             	if(lastclick==node.id) {
             		alert('bingo');
             	}
             	lastclick = node.id;
        	    st.onClick(node.id);
            };
            //set label styles
            var style = label.style;
            style.height = 34 + 'px';            
            style.cursor = 'pointer';
            style.color = '#333';
            style.fontSize = '0.8em';
            style.textAlign= 'center';
            style.paddingTop = '3px';
            style["vertical-align"] = "middle";
        },
        
        //This method is called right before plotting
        //a node. It's useful for changing an individual node
        //style properties before plotting it.
        //The data properties prefixed with a dollar
        //sign will override the global node style properties.
        onBeforePlotNode: function(node){
            //add some color to the nodes in the path between the
            //root node and the selected node.
            if (node.selected) {
                node.data.$color = "#bac1c4"; // selected nodes
            }
            else {
                delete node.data.$color;
                //count children number
                var count = 0;
                node.eachSubnode(function(n) { count++; });
                if(count>0)
                	node.data.$color = '#d5dadc'; // nodes with children
            }
        },
        
        //This method is called right before plotting
        //an edge. It's useful for changing an individual edge
        //style properties before plotting it.
        //Edge data proprties prefixed with a dollar sign will
        //override the Edge global style properties.
        onBeforePlotLine: function(adj){
            if (adj.nodeFrom.selected && adj.nodeTo.selected) {
                adj.data.$color = "#bac1c4";
                adj.data.$lineWidth = 10;
            }
            else {
                //delete adj.data.$color;
                adj.data.$color = "#d5dadc";
                delete adj.data.$lineWidth;
            }
        }
    });
    //load json data
    st.loadJSON(json);
    //compute node positions and layout
    st.compute();
    //optional: make a translation of the tree
    st.geom.translate(new $jit.Complex(-200, 0), "current");
    //emulate a click on the root node.
    st.onClick(st.root);
    //end
    //Add event handlers to switch spacetree orientation.
    /*
    var top = $jit.id('r-top'), 
        left = $jit.id('r-left'), 
        bottom = $jit.id('r-bottom'), 
        right = $jit.id('r-right'),
        normal = $jit.id('s-normal');
        
    function changeHandler() {
        if(this.checked) {
            top.disabled = bottom.disabled = right.disabled = left.disabled = true;
            st.switchPosition(this.value, "animate", {
                onComplete: function(){
                    top.disabled = bottom.disabled = right.disabled = left.disabled = false;
                }
            });
        }
    };
    
    top.onchange = left.onchange = bottom.onchange = right.onchange = changeHandler;
    //end
	*/

}

