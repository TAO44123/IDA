

var nblines = 0;

function limit() {
	var data = businessview.getNextRecord();
	if (++nblines > 1000) return null;
	return data;
}