var /*boolean*/ initDone = false;
var /*DataSet*/ result = null;

var /*Integer*/ min = 99999;
var /*Integer*/ max = 0;
var /*Integer*/ sum = 0;
var /*Integer*/ count = 0;
var listVals = new Array();

var /*Integer*/ avg = 0;
var /*Integer*/ med = 0;
var /*Integer*/ percentile10 = 0;
var /*Integer*/ percentile90 = 0;

var /*String*/ minStr = '';
var /*String*/ maxStr = '';
var /*String*/ avgStr = '';
var /*String*/ medStr = '';

/**
 * init
 * @return 
 */
function init() {

}

/**
 * onInit
 * @return 
 */
function onInit() {
	var /*DataSet*/ data = null;
	
	// compute KPIs
	while( (data=businessview.getNextRecord()) != null) {
		if(result == null) // save dataset for later
			result = data;

		tp = data.nb.get();
		listVals.push(tp);
					
		count = count + 1;
		sum = sum + tp;

		if(count>0) {
			avg = sum/count;
		
			listVals.sort(function(a, b) {
		  		return a - b;
			});
		
			if(count%2 == 1)
				med = listVals[Math.floor(count/2)];
			else {
				var v1 = listVals[Math.floor(count/2)-1];	
				var v2 = listVals[Math.floor(count/2)];	
				med = (v1+v2)/2;
			}
	
			if(tp<min) min = tp;
			if(tp>max) max = tp;

			min = Math.floor(min);
			max = Math.floor(max);
			avg = Math.floor(avg);
			med = Math.floor(med);
	
			percentile10 = listVals[Math.round(count*0.1)];
			percentile90 = listVals[Math.round(count*0.9-1)];
		}
		else {
			min = 0;
			max = 0;
			avg = 0;
			med = 0;	
		}
	}
}

/**
 * read
 * @return 
 */
function read() {
	if(!initDone) {
		initDone = true;
		onInit();		
		
		if(result==null)
			return null;
		
		result.min = min;
		result.max = max;
		result.avg = avg;
		result.med = med;
		result.sum = sum;
		result.percentile10 = percentile10;
		result.percentile90 = percentile90;
		result.nb  = count;
		
		return result;	
	}
	else {
		return null;	
	}

	var debug = 0;

}

/**
 * dispose
 * @return 
 */
function dispose() {

}
