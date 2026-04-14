import './aggregate_and_count.javascript';

function ini_nbhistory(){
	aggregateSumIni( businessview, 'timeslotuid', 'nb');
}

function /*DataSet*/ read_nbhistory(){
	return aggregateSumRead('nb');
}

function ini_risklevel(){
	aggregateSumIni( businessview, 'risklevelcode', 'nb');
}

function /*DataSet*/ read_risklevel(){
	return aggregateSumRead('nb');
}