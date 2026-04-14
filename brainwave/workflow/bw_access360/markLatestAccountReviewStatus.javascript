import '_lib.javascript';

/**
 * compile the lists to remove entries who do not need to be updated
 */
 
function computeTicketsToUpdate() {
	var cursor1 = 0;
	var cursor2 = 0;
	printDebug( 'bwa_markLatestAccountReviewStatus: computeTicketsToUpdate() -> Size of ticketstoreset before cleanup: ' + dataset.ticketstoreset.length );
	printDebug( 'bwa_markLatestAccountReviewStatus: computeTicketsToUpdate() -> Size of ticketstoupdate before cleanup: ' + dataset.ticketstoupdate.length );
	while(cursor1<dataset.ticketstoreset.length && cursor2<dataset.ticketstoupdate.length) {
		var val1 = dataset.ticketstoreset.get(cursor1);
		var val2 = dataset.ticketstoupdate.get(cursor2);
		printDebug( 'bwa_markLatestAccountReviewStatus: computeTicketsToUpdate() -> cursor1: ' + cursor1 + ', val1: ' + val1 );
		printDebug( 'bwa_markLatestAccountReviewStatus: computeTicketsToUpdate() -> cursor2: ' + cursor2 + ', val2: ' + val2 );
		if(val1 == val2) {
			// present in both lists = no updates required 
			dataset.ticketstoreset.remove(cursor1);	
			dataset.resetvalues.remove(cursor1);	

			dataset.ticketstoupdate.remove(cursor2);	
			dataset.setvalues.remove(cursor2);	
			dataset.accountsuid.remove(cursor2);
			dataset.accountablefullname.remove(cursor2);
			dataset.actorfullname.remove(cursor2);
			dataset.actiondate.remove(cursor2);
			dataset.comment.remove(cursor2);
			dataset.status.remove(cursor2);
		}
		else {
			if(val1<val2)
				cursor1 = cursor1 + 1;	
			else
				cursor2 = cursor2 + 1;	
		}
	}
	dataset.nbTicketsToUpdate.set( dataset.ticketstoupdate.length );
	printDebug( 'bwa_markLatestAccountReviewStatus: computeTicketsToUpdate() -> Number of tickets to update after cleanup: ' + dataset.nbTicketsToUpdate.get() );
}
