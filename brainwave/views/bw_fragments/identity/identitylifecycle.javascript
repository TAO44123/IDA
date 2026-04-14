
var firstline = true;
var prev = '';
var prevactive = '';
var previnternal = '';
var prevjob = '';
var prevorg = '';


/**
 * deduplicate based on the previous dataset value
 * @return 
 */
function onRead() {
	while(true) {
		var data = businessview.getNextRecord();	
		if(data == null)
			return null;
		var key = data.dedup.get();
			
		if(firstline) {
			firstline = false;
			prevactive = data.active.get();			
			previnternal = data.internal.get();			
			prevjob = data.jobtitleuid.get();			
			prevorg = data.organisationuid.get();
			prev = key;
			return data;
		}
		else {
			if(key!=prev) {
				prev = key;
	
				var active = data.active.get();			
				var internal = data.internal.get();			
				var job = data.jobtitleuid.get();			
				var org = data.organisationuid.get();
				
				if(prevactive!=active)
					data.activechanged.set(true);
				if(previnternal!=internal)
					data.internalchanged.set(true);
				if(prevjob!=job)
					data.jobchanged.set(true);
				if(prevorg!=org)
					data.orgchanged.set(true);
	
				prevactive = active;
				previnternal = internal;
				prevjob = job;
				prevorg = org;
							
				return data;	
			}
		}
	}
}
