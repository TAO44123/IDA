function processUpdate() {
	
	
	// Get what has been received in the dataset 
	var input_uids = dataset.object;
	var input_description = dataset.description;
	var input_managed = dataset.managed;
	var input_sensitivityreason = dataset.sensitivityreason;
	
	
	// Output
	dataset.resultingUids.clear();
	dataset.resultingManaged.clear();
	dataset.resultingDescription.clear();
	dataset.ticket_descriptions.clear();

	// Loop to calculate the sensitivity level
	for ( var i=0; i< input_uids.length;i++) {
		
		var ticketDescription = "Object was marked as ";
		
		// Add the UID
		dataset.resultingUids.add (  input_uids.get(i) );
		
		// Add managed
		dataset.resultingManaged.add (  input_managed.get(i) );
		
		// Add the description
		dataset.resultingDescription.add(input_description.get(i));	
		
		// If not managed
		if ( input_managed.get(i) == false ) {
			
			ticketDescription = ticketDescription + "not managed";
		}
		else {
			ticketDescription = ticketDescription + "managed";
		}
		
		
		// Add the description
		dataset.resultingDescription.add(input_description.get(i));
		
		if ( input_description.get(i) != null ) {
			// Ticket description
			ticketDescription = ticketDescription + ". Description: " + input_description.get(i) ;
		}
		else {
			ticketDescription = ticketDescription + ".";
		}
		
		dataset.ticket_descriptions.add ( ticketDescription);
	}
	
	// Set what to update
	dataset.whattoupdate = "M,D";
}
