/*
bw_stepper = JsWidgetTemplate {
	source-directory: "static/bw_cloud_base/jswidgets/stepper_js"
		datasets: stepsdata ( id as String , label as String, description as String, icon as Image , order as Integer, available as Integer, done as Integer, hidden as Boolean, status as String)
		bindings:
			orientation as in String,
			popupHelp as in Boolean,
			showIcons as in Boolean,
			showState as in Boolean,
			debugLinks as in Boolean,
			sort as in Boolean,
			currentStep as in String
		widget-events:
			onlabelclick ( id as String, index as Integer)
}
*/

bw_registerWidget( {
    id: "bw_stepper",
    bindings: ["orientation","currentStep", "popupHelp", "showIcons", "showState", "debugLinks", "sort"],
    datasets: [ "stepsdata"  ],
    events: ["onlabelclick"],
    tag: "ul"
  } );

bw_stepper = function(  properties) {

    this.vertical = false;
    this.popupHelp= false;
    this.showIcons= false;
    this.debugLinks= false;
    this.showState= true;
    this.stepsData= null;
    this.sort= false;
    this._initialStep= null;
    this.currentStepIndex= null;
    this.stepsDivs= [];
	this.descDiv = null; 
};

bw_stepper.prototype= {

    destroy: function(){

    },

    // properties

    setStepsdata: function( dataset) {
        this.stepsData = dataset.rows.filter( function(e) { return e.hidden !== true});
        if (this.sort) {
            this.stepsData.sort( function(o1, o2) {
                var value1 = o1.order  ;
                var value2 = o2.order  ;
                return value1 - value2 ;
            });
        }
        this.scheduleRender();
    },

    setOrientation: function( value){
        this.vertical = value === "vertical";
    },

    setCurrentStep: function( stepId){
        if (this.stepsData !== null){
            var index = -1;
            for (var i = 0; i < this.stepsData.length;i++){
                if (this.stepsData[i].id === stepId) {
                    index = i;
                    break;
                }
            }
            if (index !== -1)
                this._setCurrentStepIndex(index);
        }
        else {
            this._initialStep = stepId;
            this.scheduleRender();
        }
    },

    setPopupHelp: function( value){
        this.popupHelp = value;
    },

    setShowIcons: function( value ){
        this.showIcons = value;
    },

    setShowState: function( value ){
        this.showState = value;
    },

    setDebugLinks: function( value ){
        this.debugLinks = value;
    },

    setSort: function( value) {
        this.sort = true;
    },

    // handlers
    onRender: function( create ){
        if (!this.stepsData) {
            return;
        }

        this.container.innerHTML = "";
        this.container.classList.add( this.vertical?"v" : "h");
        this.container.classList.add(  this.showIcons ? "show-icons": "show-numbers");
        if (this.popupHelp){
            this.container.classList.add("popup-help");
        }
        this.stepsDivs = [];
        // Search for the root node and insert it
        for (var i=0; i < this.stepsData.length; i++ ){
            var stepData = this.stepsData[i];
            var stepClass =  this._getStepClass( i );
            var stepDiv =
                create( "li",   {className: stepClass} ,
                    i < this.stepsData.length -1 ? create ("div", "line"): null  ,
                    this.showIcons ? create ("div", "icon-wrapper", create ("img", { src: stepData.icon})): create ("div", {className: "number", textContent: i+1}) ,
                    create("div", { className: "title", textContent: stepData.label, "data-index": i , onclick: this.onStepClick.bind(this) } ),
                    this.showState? create("span", "status"): null ,
                    this.vertical ?  create("div", { className: "desc" , textContent: stepData.description, "data-index": i  , onclick: this.onStepClick.bind(this) } ) : null
                    );
            this.container.appendChild(stepDiv);
            this.stepsDivs.push(stepDiv);
        }
		if (!this.vertical) {
			this.descDiv = create("div", { className: "desc" });
			this.container.appendChild( this.descDiv);
		}
        if (this._initialStep !== null){
            this.setCurrentStep(this._initialStep);
            this._initialStep = null;
        }
    },

    // notifications
    onStepClick: function( event){
        var index = parseInt(event.currentTarget.dataset.index) ;
        var stepData = this.stepsData[index];
        if ( this.debugLinks || (this.currentStepIndex === null && stepData.available === true) ||  (this.currentStepIndex !== null && index <= this.currentStepIndex)){
            var id = stepData.id;
            this.notifyEvent("onlabelclick", {id: id, index: index});
        }
  } ,

    // private
    _setCurrentStepIndex: function( index){
        if (index !== this.currentStepIndex){
            this.currentStepIndex = index;
            for (var i = 0; i < this.stepsDivs.length;i++){
                this.stepsDivs[i].className = this._getStepClass(i);
            }
			if (this.descDiv !== null) {
				this.descDiv.innerHTML=this.stepsData[index].description;
			}
       }
		
    },

    _getStepClass: function(idx) {
        return "step "+this._getStepStatusClass(idx) +  (this.popupHelp && (idx !== this.currentStepIndex) ? " popup-help": "") ;
    },

    _getStepStatusClass: function( i ){
        var stepData = this.stepsData[i];
        if (this.currentStepIndex === null){
            return (stepData.available === true ? "link": "todo") + (stepData.done ? " done" : "") ; //TODO manage error
        }
        else {
            if (i === this.currentStepIndex)
                return "link active todo "+ (stepData.status || "");
            else  if ( i > this.currentStepIndex)
                return "todo";
            else
                return "link "+ (stepData.status || "done");
        }
    }

};




