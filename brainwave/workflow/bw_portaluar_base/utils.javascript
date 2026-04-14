function truncateDate( /*Date*/ date) {
	date.setHours(0);
	date.setMinutes(0);
	date.setSeconds(0);
	date.setMilliseconds(0);
	return date; 
}

function toISODateString( /*Date*/ date) {
  var res=  date.getFullYear()+"-"+padNumber(date.getMonth()+1, 2)+"-"+padNumber(date.getDate(),2);
  return res; 
}

function padNumber( /*Number*/num, /*Number*/ pad) {
   var res= ("0000"+num).right(pad);
   return res; 
}
