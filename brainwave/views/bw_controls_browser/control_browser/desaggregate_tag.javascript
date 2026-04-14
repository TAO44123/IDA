var values=null

function desaggregate ()
{
	if (values == null || values.length == 0) {
		var dataSet = businessview.getNextRecord();
		if (dataSet == null) {
			return null;
		}
		var attr = dataSet.get("controltagapplication");
		if (attr != null && ! dataSet.isEmpty("controltagapplication")) {
            values = attr.getAsString().split(",");
        }
    }
    if (values != null && values.length > 0) {
        attr = dataSet.get("controltagapplication");
        var value = values.shift();
        attr.set(0, value);
    }
    return dataSet;
}