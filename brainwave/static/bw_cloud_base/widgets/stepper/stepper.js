
var el = BWUtils.element;

// Binding Variables
var vertical = false;
var popupHelp = false;
var showIcons = false;
var debugLinks = false;
var showState = true;
var stepsData = null;
var sort = false;
var _initialStep = null;
var currentStepIndex = null;
var stepsDivs = [];
var ds_id = [];
var ds_label = [];
var ds_description  = [];
var ds_iconclass  = [];
var ds_order  = [];
var ds_available  = [];
var ds_done  = [];
var ds_status  = [];

Pages.listenInit(function(varName, initialValue) {
    switch( varName){
        case "orientation": vertical = initialValue == "vertical"; break;
        case "currentStep": setCurrentStep( initialValue); break;
        case "popupHelp" : popupHelp = initialValue ; break;
        case "showIcons" : showIcons = initialValue ; break;
        case "showState" : showState = initialValue ; break;
        case "debugLinks" : debugLinks = initialValue ; break;
        case "sort" : sort = initialValue ; break;
        case "ds_id" : ds_id = initialValue; break;
        case "ds_label" : ds_label = initialValue; break;
        case "ds_description" : ds_description = initialValue; break;
        case "ds_iconclass" : ds_iconclass = initialValue; break;
        case "ds_order" : ds_order = initialValue; break;
        case "ds_available" : ds_available = initialValue; break;
        case "ds_done" : ds_done = initialValue; break;
        case "ds_status" : ds_status = initialValue; break;
    }
});

Pages.listenTo('currentStep', function(newValue) {
    setCurrentStep( newValue);
});

Pages.listenTo('ds_available', function(newValue) {
    ds_available = newValue;
    initData();
});

Pages.listenTo('ds_done', function(newValue) {
    ds_done = newValue;
    initData();
});

Pages.listenTo('ds_status', function(newValue) {
    ds_status = newValue;
    initData();
});

// Fetch Data
function initData() {
    stepsData = [];
    for ( var i =0; i < ds_id.length;i++){
        stepsData.push( {
            id: ds_id[i],
            label: ds_label[i],
            description: ds_description[i] ,
            iconclass: ds_iconclass[i],
            order: ds_order[i],
            available: ds_available[i],
            done: ds_done[i],
            status: ds_status[i]});
    }

    if (sort) {
        stepsData.sort( function(o1, o2) {
            var value1 = o1.order  ;
            var value2 = o2.order  ;
            return value1 - value2 ;
        });
    }
            
    processData (  ) ;

}

Pages.listenInitDone(function() {
    initData();
});


// Function to display the tree in a list
function processData ( ) {
    var container = document.getElementById("container");
    container.innerHTML = "";
    container.classList.add( vertical?"v" : "h");
    container.classList.add(  showIcons ? "show-icons": "show-numbers");
    if (popupHelp){
        container.classList.add("popup-help");
    }

    stepsDivs = [];
    // Search for the root node and insert it
    for ( i=0; i < stepsData.length; i++ ){
        var stepData = stepsData[i];
        var stepClass =  _getStepClass( i );
        var iconClass = showIcons ? _sanitizeIconClass(stepData.iconclass) : null ;
        var stepDiv =
            el( "li",   {className: stepClass, "data-id": stepData.id} ,
                i < stepsData.length -1 ? el ("div", "line"): null  ,
                showIcons ? el ("div", "icon-wrapper", el ("span", "icon "+iconClass)): el ("div", {className: "number", textContent: i+1}) ,
                el("div", { className: "title", textContent: stepData.label, onclick: "onStepClick("+i+")"  }),
                showState? el("span", "status"): null ,
                vertical ? el("div", { className: "desc" , textContent: stepData.description,  onclick: "onStepClick("+i+")"  }) : null
            );
        container.appendChild(stepDiv);
        stepsDivs.push(stepDiv);
    }
    if (_initialStep !== null){
        setCurrentStep(_initialStep);
        _initialStep = null;
    }
}

function setCurrentStep( stepId){
    if (stepsData !== null){
        index = -1;
        for (i = 0; i < stepsData.length;i++){
            if (stepsData[i].id === stepId) {
                index = i;
                break;
            }
        }
        if (index != -1)
            setCurrentStepIndex(index);
    }
    else {
        _initialStep = stepId;
    }
}

function setCurrentStepIndex( index){
    if (index !== currentStepIndex){
        currentStepIndex = index;
        for (i = 0; i < stepsDivs.length;i++){
            stepsDivs[i].className = _getStepClass(i);
        }
    }
}

function onStepClick( index){
    var stepData = stepsData[index];

    if ( debugLinks || (currentStepIndex === null && stepData.available === true) ||  (currentStepIndex !== null && index <= currentStepIndex)){
        var id = stepData.id;
        Pages.sendEvent('onlabelclick', {id: id, index: index});
    }
}

function _getStepClass(idx) {
    return "step "+_getStepStatusClass(idx) +  (popupHelp && (idx !== currentStepIndex) ? " popup-help": "") ;
}

function _getStepStatusClass( i ){
    var stepData = stepsData[i];
    if (currentStepIndex === null){
            return (stepData.available === true ? "link": "todo") + (stepData.done ? " done" : "") ; //TODO manage error
    }
    else {
        if (i === currentStepIndex)
            return "link active todo "+ (stepData.status || "");
        else  if ( i > currentStepIndex)
            return "todo";
        else
            return "link "+ (stepData.status || "done");
    }
}

/**
 * if str is of the form /..../ filename [ | ext } , then return icon-filename_noext, return string
 */
function _sanitizeIconClass( str){
    if (!str)
        return str;
    var regex = /.*\/([^\/]+)\.\w+(\|.*)*/gm;
    var match = regex.exec(str);
    return "icon-"+ (match !== null ?  match[1] : str) ;
}
