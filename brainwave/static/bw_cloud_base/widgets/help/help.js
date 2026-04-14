
bw_registerWidget( {
    id: "bw_help",
    bindings: ["url","opened", "title", "width", "locales"],
    datasets: [  ],
    events: [ ],
  } );

bw_help = function(  properties) {
    this.url = null;
    this.locales = null;
    this.title = "Help";
    this.opened= false;
    this.width = 300;
    this.$container = null;
    this.iframe = null;
};

bw_help.prototype= {

    destroy: function(){

    },

    // properties

    setUrl: function( url){
        this.url = "static/"+ url;
        if (this.iframe)
           this.iframe.setAttribute("src", url);
        else
          this.scheduleRender();
    },

    setLocales: function(str){
      this.locales = str.split(",");
       this.scheduleRender();
    },

    setTitle: function (value){
        this.title = value;
    },

    setWidth: function (value){
        this.width = value;
    },

    setOpened: function( opened){
       this.opened = opened;
       if (this.$container){
           this.$container.slideReveal(opened? "show":"hide");
       }
       else
           this.scheduleRender();
    },

    // handlers
    onRender: function( el ){
        if (!this.url) {
            return;
        }
        var close_btn ;
        var that = this;
        var url = this.computeUrl();
        this.container.appendChild(el ( "div", { className: "title", textContent: this.title},
          close_btn = el("span", { className:"close-button",   title: "Close" })));
        $(close_btn).click( function() {
          that.setOpened(false);
          that.notifyVariableChange( "opened", false);
        });
        this.iframe = el ( "iframe", { src: url , className: "content"} );
        this.container.appendChild(this.iframe);
        this.$container = $(this.container);
        var top= this.$container.offset().top + 5 ;
        this.$container.slideReveal( {
              width: this.width,
              top: top,
              zIndex: 200000});

   },

   computeUrl: function() {
       var url = this.url;
       if (this.locales == null)
           return url;
       // compute url by adding "_" lang before extension
       var lang = this.locales.indexOf(this.language) >= 0 ? this.language : this.locales[0];
       var extPos = url.lastIndexOf(".");
       var localeUrl= url.substr(0,extPos)+"_"+lang+url.substr(extPos);
       return localeUrl;
   }

};




