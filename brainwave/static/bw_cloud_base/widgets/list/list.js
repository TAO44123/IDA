/*
bw_list = JsWidgetTemplate {
	source-directory: "static/bw_cloud_base/widgets/list"
	bindings:
	  sortable as in Boolean ,
	  sorted as in out multivalued String
	datasets: listData( uid as String, displayName as String)
	widget-events:
	  onmove ( indices as Integer )
}
 */

bw_registerWidget( {
    id: "bw_list",
    bindings: ["columns",  "headers","widths", "styles","sortable", "sorted"],
    datasets: [ "config" , "listData" ],
    events: [ "selectionChanged" ]
} );

bw_list = function(  properties) {
    this.sortable = true;
    this.listData = null;
    this.config = null;
    this.listDataTypes = null;
    this.initialSortedIds = null;
    this.columns = [];
    this.headers = [];
    this.widths = [];
    this.styles = [];
    this.textFunctions = [];
    // DOM
    this.listContainer = null;

};

bw_list.prototype= {

    destroy: function(){

    },

    // properties

    setColumns: function (value){
        this.columns = value;
        this.scheduleRender();
    },

    setHeaders: function (value){
        this.headers = value;
        this.scheduleRender();
    },

    setWidths: function (value){
        this.widths = value;
        this.scheduleRender();
    },


    setSortable: function( value){
        this.sortable = value;
        this.scheduleRender();
    },

    setSorted: function (values){
        this.initialSortedIds = values;
    },

    setListData: function( dataset) {
        this.listData = dataset.rows;
        this.listDataTypes = dataset.types ;
        this.scheduleRender();
    },

    setConfig: function ( dataset){
        var cfg;
        this.config = dataset.rows;
          // par config


         for (var i=0; i< this.config.length; i++){
             cfg = this.config[i];
             this.columns.push ( cfg.column );
             this.headers.push ( cfg.header ? cfg.header : cfg.column );
             this.widths.push ( cfg.width? cfg.width: "100px" );
             this.styles.push ( cfg.style? cfg.style : "" );
             var fn = cfg.text ? eval( "(function txt( value, current ) { return "+ cfg.text + "; })"): null;
             this.textFunctions.push(fn);
         }
        this.scheduleRender();
    },

    // handlers
    onRender: function( createElement ){
        if (!this.listData)
            return;
        if (!this.columns)
            return ;
        // sort list data
        this._sortListData();
        var self = this;
        var c, span, img, col, type, val, style ;
        // header
        var headerDiv = createElement("div", {className: "header"});
        for (c=0; c < this.columns.length; c++){
            type = this.listDataTypes[this.columns[c]] ;
            style =  "width: "+ ( this.widths[c] ? this.widths[c] : "100px") + ";" ;
            if ( type == "INT"){
                style += "text-align: right;";
            }
            span = createElement("span", { textContent:  this.headers[c] , style: style  });
            headerDiv.appendChild(span);
        }
        this.container.appendChild(headerDiv );
        this.listContainer = createElement("ul");
        this.container.appendChild(this.listContainer );
        for ( var i=0; i < this.listData.length;i++){
            var item = this.listData[i];
            var itemDiv = createElement("li", { "data-uid": item["uid"]});
            for (c=0; c < this.columns.length; c++){
                col = this.columns[c];
                type = this.listDataTypes[col] ;
                val = item[ col];
                var fn = this.textFunctions[c];
                if ( fn != null){
                    try {
                        val = fn( val, item);
                    }
                    catch( e){
                        console.error( "error in evaluation of text ", e);
                        val ="?";
                    }
                }
                style =  "width: "+ ( this.widths[c] ? this.widths[c] : "100px") + ";" ;
                if (type == "INT") {
                    style += "text-align: right;";
                }
                style+= this.styles[c];
                switch( type){
                    case "IMAGE":  span = createElement("span", { width: this.widths[c] }, img = createElement( "img", { src: val, style: style}));
                      break;
                    default:   span = createElement("span", { textContent: val, style: style });
                }
                itemDiv.appendChild(span);
            }
            this.listContainer.appendChild(itemDiv);
        }
        $(this.listContainer).sortable({
            stop: function (event, ui) {
                self._notifySortChange();
            }
        }) ;
        this._notifySortChange();
    },

    _notifySortChange: function(){
        var i; var item;
        var sortedIds = [];
        var children = this.listContainer.children;
        for ( i=0; i <children.length;i++){
            sortedIds.push( children[i].dataset["uid"]);
        }
        this.notifyVariableChange( "sorted", sortedIds);
    },

    _sortListData: function () {
        var dataByUid = new Map();
        var data = this.listData;
        var uid ;
        for (var i=0; i < data.length; i++){
            uid = data[i].uid.toString();
            dataByUid.set( uid , data[i]);
        }
        var newData = [];
        for (i=0; i< this.initialSortedIds.length;i++){
            uid  =  this.initialSortedIds[i].toString();
            if (dataByUid.has( uid)) {
                newData.push(dataByUid.get(uid));
                dataByUid.delete(uid);
            }
        }
        // ajouter le reste
       if ( dataByUid.size > 0){
           for (var i=0; i < data.length; i++){
               uid = data[i].uid.toString();
               if (dataByUid.has( uid)){
                   newData.push( data[i]);
                   this.initialSortedIds.push(uid);
               }
           }
       }
        // mettre à jour
        this.listData = newData;
    }


};