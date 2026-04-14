function strSplit(){
	var /*String*/ str = dataset.str.get();
	var /*Attribute*/ partsAttr = dataset.parts;
	var sep = dataset.isEmpty("separator")? ',': dataset.separator.get();
	var parts = str.split(sep,-1); //don't remove empty strings
	partsAttr.clear();
	var i;
	for ( i=0; i<parts.length ;i++) {
		partsAttr.add(parts[i]);
	}	
}

/* duration */

var _duration_NLS = {
	en: {
		days:  " day(s)" ,
		hours:" hour(s)"  ,
		minutes: " minute(s)" ,
		seconds: " second(s)" ,  
	},
	fr: {
		days:  " jour(s)" ,
		hours:" heure(s)"  ,
		minutes: " minute(s)" ,
		seconds: " seconde(s)" , 		
	}
};

var _durationShort_NLS = {
	en: {
		days:  "d" ,
		hours:"hr"  ,
		minutes: "min" ,
		seconds: "s" ,  
	},
	fr: {
		days:  "j" ,
		hours:"hr"  ,
		minutes: "min" ,
		seconds: "s" ,   		
	}
};


/* var from : Date
var to: Date ( now if ommitted
returns: duration string
*/
function durationString(){
	var nls = _getLocalizedNls(_duration_NLS);
  	return _durationString( nls); 
}

function durationShortString(){
	var nls = _getLocalizedNls(_durationShort_NLS);
  	return _durationString( nls); 
}

/* duration in seconds
returns pretty string of duration
*/
function _durationString( nls ){
	if (dataset.isEmpty("from") || dataset.from.get() == null ) 
	   return ""; 
  	var /*Date*/ from = Date.fromLDAPString(dataset.from.get());
  	var /*Date*/ to = !dataset.isEmpty("to") ? Date.fromLDAPString(dataset.to.get()): new Date();
  	//rint ("[DEBUG]from="+ from + " to=" + to ); 
  	var duration = to.diff(from, 's');
  	//rint ("[DEBUG] duration="+ duration ); 
  		
	var rest = duration;
  	var durDays = Math.floor(rest / 86400);
  	rest = rest % 86400; 
  	var durHours = Math.floor(rest / 3600);
  	rest = rest % 3600;
  	var /*Number*/ durMin = Math.floor( rest / 60);
  	rest = rest % 60;
  	var durSec = rest; 
  	var parts = [];
  	if (durDays > 0)  parts.push(durDays+ nls.days);
  	if (durHours > 0) parts.push(durHours+ nls.hours);
  	if (durMin > 0) parts.push(durMin + nls.minutes);
  	if (durSec > 0) parts.push(durSec + nls.seconds);
    return parts.join(" "); 
}

var cronPartsRE = new RegExp("\\s+");


function parseCron() {
	var /*String*/ cron = dataset.cron.get();
	var /*Object*/ res = _parseCron(cron);
	dataset.frequency.set(res.frequency);
	dataset.minute.set(res.minute);
	dataset.hour.set(res.hour);
	dataset.dom.set(res.dom);
	dataset.dow.set(res.dow);
		
	//rint( "[DEBUG] cron="+ cron+ " frequency="+ res.frequency );
}

var _cronDescription_NLS = {
	en: {
		daily1:  "Daily, at {0}" ,
		weekly2:" Weekly, on {0}, at {1}"  ,
		monthly2: "Monthly, on {0} day , at {1}" ,
		special1: "Special ({0})", 
		notScheduled: "Not Scheduled" ,
		time2: "{0}:{1}"	,	
	},
	fr: {
		daily1:  "Tous les jours à {0}" ,
		weekly2: "Tous les {0} � {1}"  ,
		monthly2: "Le {0} de chaque mois à {1}" ,
		special1: "Spécial ({0})", 
		notScheduled: "Non programmé" ,
		time2: "{0}:{1}"	,	
	},
};

var _dowLabels_NLS = {
  en: {
  	0: "Sunday",
  	1: "Monday",
  	2: "Tuesday",
  	3: "Wednesday",
  	4: "Thursday",
  	5: "Friday",
  	6: "Saturday"
  },
  fr: {
  	0: "dimanche",
  	1: "lundi",
  	2: "mardi",
  	3: "mercredi",
  	4: "jeudi",
  	5: "vendredi",
  	6: "samedi"
  }   	
};

var _domLabels_NLS = {
  en: {
  	  "1": "1st",
	  "2": "2nd",
	  "3": "3rd",
	  "4": "4th",
	  "5": "5th",
	  "6": "6th",
	  "7": "7th",
	  "8": "8th",
	  "9": "9th",
	  "10": "10th",
	  "11": "11th",
	  "12": "12th",
	  "13": "13th",
	  "14": "14th",
	  "15": "15th",
	  "16": "16th",
	  "17": "17th",
	  "18": "18th",
	  "19": "19th",
	  "20": "20th",
	  "21": "21st", 
	  "22": "22nd",
	  "23": "23rd",
	  "24": "24th",
	  "25": "25th",
	  "26": "26th",
	  "27": "27th",
	  "28": "28th",
	  "29": "29th",	  
	  "30": "30th",
	  "31": "31st",	  	   
	  "L": "last"
    },
   fr: {
  	  "1": "1er",
	  "2": "2ème",
	  "3": "3ème",
	  "4": "4ème",
	  "5": "5ème",
	  "6": "6ème",
	  "7": "7ème",
	  "8": "8ème",
	  "9": "9ème",
	  "10": "10ème",
	  "11": "11ème",
	  "12": "12ème",
	  "13": "13ème",
	  "14": "14ème",
	  "15": "15ème",
	  "16": "16ème",
	  "17": "17ème",
	  "18": "18ème",
	  "19": "19ème",
	  "20": "20ème",
	  "21": "21ème", 
	  "22": "22ème",
	  "23": "23ème",
	  "24": "24ème",
	  "25": "25ème",
	  "26": "26ème",
	  "27": "27ème",
	  "28": "28ème",
	  "29": "29ème",
	  "30": "30ème",
	  "31": "31ème", 	   
	  "L": "dernier" 
    },   
    	
}

function cronDescriptionString(){
	var /*String*/ cron = dataset.cron.get();
	var /*Object*/ res = _parseCron(cron);
	var frequency = res.frequency;
	var nls = _getLocalizedNls(_cronDescription_NLS);
	if (frequency === "N")
	 return nls.notScheduled;	
	if (frequency === "S")
	   return _N(nls.special1, cron) ;
	var minStr = ("00"+res.minute).slice(-2);   
	var timeStr = _N( nls.time2, res.hour, minStr) ;  
	switch(frequency){
	  case "D":  return _N(nls.daily1, timeStr);
	  case "W": 
	    var dowLabels = _getLocalizedNls(_dowLabels_NLS);
	    return _N( nls.weekly2, dowLabels[res.dow], timeStr);
	  case "M": 
	     var domLabels = _getLocalizedNls(_domLabels_NLS);
	     return _N( nls.monthly2, domLabels[res.dom] , timeStr);
	}	
}

function computeCron(){	
	switch( dataset.frequency.get()){
	  case "N": return "";
	  case "D": return dataset.minute.get() + " "+ dataset.hour.get() + " * * *"; 
	  case "W": return dataset.minute.get() + " "+ dataset.hour.get() + " * * "+dataset.dow.get();
	  case "M": return dataset.minute.get() + " "+ dataset.hour.get() + " "+ dataset.dom.get() +" * *";
	  default: return dataset.cron.get();
	}
}

/*return object { frequency: N|D|W|M|S , minute, hour, dom, month, dow } */
function _parseCron( /*String*/cron){
	if (cron == "" || cron == null ) 
	  	return { frequency:  "N"} ;
	var parts = cron.split(cronPartsRE , 5);			
	if (parts.length == 5 ){
		var /* String */ minute = parts[0];
		var /* String */ hour = parts[1];
		var /* String */ dom = parts[2];
		var /* String */ month = parts[3];
		var /* String */ dow = parts[4];
		if (minute.isNumeric() && hour.isNumeric()) {
		  if (dom == "*" && month== "*" && dow=="*"){
		  	return { frequency: "D", hour: hour, minute: minute }; 
		  }
		  else if ( dom == "*" && month=="*" && dow.isNumeric()){
		  	return { frequency: "W", dow: dow, hour: hour, minute: minute };
		  }
		  else if ( (dom.isNumeric() || dom == "L") && month== "*" && dow=="*") {
		  	return { frequency: "M", dom: dom, hour: hour, minute: minute };
		  }
	   }		  
	}
   return { frequency: "S" } ;
}

/* File utils */
function fileDelete(){
	var /*String*/ filename = dataset.filename.get();
	print ("Deleting " + filename);
	java.nio.file.Files.deleteIfExists(java.nio.file.Paths.get(filename));
}

function cleanFolder(){
	var path = dataset.path.get();
	var sourceDir = new java.io.File(path);
	var elements = sourceDir.listFiles();
	if (elements !== null){
		for(var i=0;i<elements.length;i++) {
			var elementpath = elements[i].getCanonicalPath();
			print ("Deleting " + elementpath);
			java.nio.file.Files.deleteIfExists(java.nio.file.Paths.get(elementpath));
		}
	}	
}


/*NLS utils */
function _getLocalizedNls( nls){
   var lang = !dataset.isEmpty("lang")? dataset.lang.get() : "en";
	var labels = nls[lang];
	if (!labels) labels = nls.en; 	
	return labels; 	
}

function _N( /*String*/ str) {	
	var args = arguments;  // first arg is str, next are dynamic arguments
	//rint("[DEBUG] replacements="+args);
    return str.replace(/\{(\d+)\}/g, function() {
        return args[parseInt(arguments[1])+1];
    });
}

