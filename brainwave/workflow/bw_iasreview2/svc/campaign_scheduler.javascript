import "../../bw_portaluar_base/JSON.javascript"
import "../../bw_portaluar_base/utils.javascript"

function computeNextScheduledDate( /*Object*/ frequency, /*Date*/ date ) {
	switch( frequency) {
	  case "weekly": return date.add("d", 7);
	  case "monthly":	return date.add("M", 1);
	  case "quarterly":	return date.add("M", 3);
	  case "semi-annual": return date.add("M", 6);
	  case "yearly": return date.add("M", 12);
	}
	return date; 
}


function computeTasksToRun() {
	
	var /*boolean*/ simulate = dataset.simulate.get();
	var /* Date*/dateNow = dataset.simulateNow.get();
	if (dateNow === null ) {
		dateNow = new Date(); 
	    truncateDate( dateNow);
	}
	
	// list campaign configuration & last instance
	var /*Array*/ defs = workflow.executeView(null, "bwr_listreviewdef" );
	if (defs.length == 0)
	   return;
	var /*Array<String>*/ instancesRecordids = defs.map( function(def) { 
		var  ruid = def.lastinst_recorduid;
		return ruid? ruid.toString() : "-1";  //attention à bien transformer en string, sinon , la bv ne marche pas
	 } );  
	var /* Array */ insts = workflow.executeView(null, "bwaccess360_accessreviewcampaignsbv",  {  campaignid: instancesRecordids, includecounters: false} );
	var /*java.util.HashMap*/ instsById = new java.util.HashMap();
	insts.forEach( function(inst){
		instsById.put(inst.recorduid, inst);
	} );
	 
   var /*String*/ runTasksMsg = "Review campaign scheduler running today="+dateNow.toDateString() + " simulate="+simulate+":";   
   print(runTasksMsg);
  defs.forEach( function(/*java.util.Map*/ def) {	
     	var /*String*/jsConfig = def.cfg_json;     
        var /*Object*/ cfg = JSON.parse(jsConfig);
     	var /*Object*/ schedulingCfg = cfg.schedule.scheduling;
     	var /*Object*/ notifCfg = cfg.schedule.notification;
     	var /*Object*/ informationCfg = cfg.information; 
        var /*Object*/ campaignOwner = informationCfg.reviewOwner;  
     	var /*String*/ label =  def.label ;
     	var /*String*/ uid = def.uid; 
     	var /*Number*/ lastInstRecorduid = def.lastinst_recorduid;
     	var /*java.util.Map*/lastInst = instsById.get(lastInstRecorduid);
     	var lastInstStatus = lastInst ? lastInst.campaigninstancecurrentstatus : null; 
     	print("Processing campaign: "+label+ " last instance status="+lastInstStatus)	;
     	// auto scheduling => compute start campaign, start notif and before notif   		
     	if (schedulingCfg.mode === "auto" && !informationCfg.disableReview ){
     	    var /*boolean*/ willStart; 
     		var /*Date*/ firstStartDate =  Date.fromISOString(schedulingCfg.startDate);
     		truncateDate(firstStartDate);
     		var /*java.util.Date*/ lastStartDate = lastInst !== null ? lastInst.submissiondate: null;
     		if (lastStartDate){
     			  truncateDate( lastStartDate); 
     		}
     		var /*Date*/ 	nextDate =  lastStartDate ?  computeNextScheduledDate(schedulingCfg.autoFrequency, lastStartDate ) :  firstStartDate; 
     		var noActiveInstance =  !lastInst || lastInst.campaigninstancecurrentstatus == "closed";
      		willStart = dateNow.getTime() >= nextDate.getTime() && noActiveInstance ;     
      		
      		print("Campaign next scheduling '"+label+ "' firstStart:"+firstStartDate.toDateString() +" lastStart:"+(lastStartDate?lastStartDate.toDateString():"-")  +  " simulate:"+simulate+" => nextStart:"+nextDate.toDateString()+" no active instance:"+noActiveInstance+" now:"+dateNow.toDateString() + " willStart:"+willStart);     		
      		if (willStart) {
      			var /*Date*/ deadlineDate =  dateNow.add("d", schedulingCfg.duration); 
      			dataset.campaignUids.add(uid);
      			dataset.campaignLabels.add( label );
      			dataset.campaignNextDates.add( nextDate );
      			runTasksMsg += "\n- Start review Campaign ["+label +"] scheduled on "+nextDate.toDateString() ;
      			// sent start notification always
				dataset.notifyStartOwnerUids.add(campaignOwner.uid);
				dataset.notifyStartCampaignLabels.add(label);
      			dataset.notifyStartCampaignDueDates.add(deadlineDate);      				
      			runTasksMsg += "\n- Send notification to campaign owner "+campaignOwner.fullname+" for starting campaign "+label ;
      		}
      		//before notification
      		if (schedulingCfg.notifyBefore){
      			var /*Number*/ notifNbDaysBefore = schedulingCfg.notifNbDaysBefore;
      			var /*Date*/ notifyBeforeDate = nextDate.add("d", -notifNbDaysBefore);
      			if ( dateNow.getTime() == notifyBeforeDate.getTime()){
      				dataset.notifyBeforeStartOwnerUids.add(campaignOwner.uid);
					dataset.notifyBeforeStartCampaignLabels.add(label);
					dataset.notifyBeforeStartCampaignStartDates.add(nextDate)	;
					dataset.notifyBeforeStartNbDays.add(notifNbDaysBefore);
					runTasksMsg += "\n- Send notification to campaign owner "+campaignOwner.fullname+" "+notifNbDaysBefore+" days before starting campaign "+label ;
      			}
      		}    		
     	}
     	//finalize notificaiton
     	if ( lastInst && ( lastInst.campaigninstancecurrentstatus == "active" ||  lastInst.campaigninstancecurrentstatus == "pause") ) {
      			var  /* Date */instDueDate = lastInst.duedate ;
      			 truncateDate(instDueDate) ;
      			var instLabel =  lastInst.title;
      			if ( instDueDate.getTime() == dateNow.getTime()	) {
	       			// sent finalize notification
					dataset.ndOwnerUids.add(campaignOwner.uid);
					dataset.ndCampaignLabels.add(instLabel);
	      			dataset.ndCampaignDeadlines.add(instDueDate);      				
	      			runTasksMsg += "\n- Send notification to campaign owner "+campaignOwner.fullname+" for finalizing campaign "+instLabel ;     			
      		   }
      		}
     	
     	// compute notification reminder fields, the reminders were set when the instance was created ( campaign launch) 
     	//  all information must be taken from instance, not definition
     	
     	if (lastInst && lastInst.campaigninstanceinfo && lastInst.campaigninstancecurrentstatus == "active"  ){    	
     		var /*Object*/ inst_info =JSON.parse( lastInst.campaigninstanceinfo );
     		var /*Object*/ inst_notifCfg = inst_info.cfg.schedule.notification;    		
     		var /*Object */ reminderMail = inst_notifCfg.reminderMessage; 	
     		var reminderMailContent = "{$''}"+ reminderMail.content.en; //this is to ensure the dynamic body is correctly parsed if contains variables.     		
     		var reminderMailContentFR = "{$''}"+ reminderMail.content.fr;
     		var reminderMailContentES = "{$''}"+ reminderMail.content.es;
     		 var /*Array<String>*/ reminderDates = inst_info.instance.reminderDates;    
     		 		 
     		 reminderDates.forEach( function( dstr) {
     		 	var inst = lastInst;
     		 	var /*Date*/ reminderDate = Date.fromISOString(dstr);
     		 	print("Processing reminder date:" +reminderDate.toString()+ " now="+dateNow.toString() );
     		 	if ( reminderDate.getTime() == dateNow.getTime()){
     		 		/* compute remaining reviewers, will consider delegations */
     		 		var /* Array */ reviewers = workflow.executeView(null, "bwaccess360_applicationreviewersforcampaignbv",  {  campaignid: lastInstRecorduid, filternotsignedofonly: true,} );
     		 		reviewers.forEach( function(reviewer) {
     		 			dataset.nrReviewerUids.add(reviewer.uid);
     		 			dataset.nrReviewerMails.add(reviewer.mail) ;
     		 			dataset.nrCampaignIds.add(lastInstRecorduid);
						dataset.nrCampaignNames.add(label);
						dataset.nrCampaignDescriptions.add(lastInst.title);
						dataset.nrCampaignDeadlines.add(lastInst.duedate);
						dataset.nrMailSubjects.add( reminderMail.title.en);
						dataset.nrMailSubjectsFR.add( reminderMail.title.fr);
						dataset.nrMailSubjectsES.add( reminderMail.title.es);
						dataset.nrMailCC.add( reminderMail.cc);	
						dataset.nrMailBCCs.add( reminderMail.bcc);						
						dataset.nrMailContents.add( reminderMailContent);
						dataset.nrMailContentsFR.add( reminderMailContentFR);
						dataset.nrMailContentsES.add( reminderMailContentES);
				        dataset.nrDelegatorUids.add(reviewer.delegatoruid);
				        dataset.nrDelegatorMails.add(reviewer.delegatormail);
				        dataset.nrDelegatorHrCodes.add(reviewer.delegatorhrcode);
				        dataset.nrDelegatorFullnames.add(reviewer.delegatorfullname);
				        dataset.nrDelegatorPreferredLanguages.add(reviewer.delegatorpreferredlanguage);
				        dataset.nrDelegatorActives.add(reviewer.isdelegated);

     		 		});	 				
					runTasksMsg += "\n- Send notification reminder to all remaining reviewers for campaign "+label ;		    		 		
     		 	}
     		 });
     	}
       print("Done processing campaign: "+label)	;
     }); 
     dataset.runTasks.set(runTasksMsg)  ;
}

