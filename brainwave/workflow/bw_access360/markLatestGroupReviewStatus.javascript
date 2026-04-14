
/**
 * compile the lists to remove entries who do not need to be updated
 */
 
function computeTicketsToUpdate() {
	var cursor1 = 0;
	var cursor2 = 0;
	while(cursor1<dataset.entriestoreset.length && cursor2<dataset.entriestoset.length) {
		var val1 = dataset.entriestoreset.get(cursor1);
		var val2 = dataset.entriestoset.get(cursor2);

		if(val1 == val2) {
			// present in both lists = no updates required 
			dataset.entriestoreset.remove(cursor1);	
			dataset.resetvalues.remove(cursor1);	
			dataset.entriestoset.remove(cursor2);	
			dataset.resetvalues.remove(cursor2);	
		}
		else {
			if(val1<val2)
				cursor1 = cursor1 + 1;	
			else
				cursor2 = cursor2 + 1;	
		}
	}
}

