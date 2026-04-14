/*computes the initialScheduled date, 
which could be either on the same day or the following day

ex: schedule for 13:00, and it's currently 14h => next day

*/
function computeInitialSchedule() {
  var /* Date*/ scheduledDate = new Date();
  scheduledDate.setHours(dataset.scheduleHourOfDay, dataset.scheduleMinute, 0, 0 );	
  var now = new Date();
  // two cases, start today or tomorrow
  if ( now.getTime() > scheduledDate.getTime()){
     scheduledDate = scheduledDate.add("d", 1);
  }
  dataset.initialScheduledDate.set(scheduledDate);
  print("Scheduler initial iteration on "+scheduledDate.toString());
}

function runLoop() {
  dataset.lastExecutionDate.set( new Date()); 	
  dataset.loopCounter.set( dataset.loopCounter.get()+1);	
  print("Scheduler iteration #" + dataset.loopCounter.get() );  	
}
