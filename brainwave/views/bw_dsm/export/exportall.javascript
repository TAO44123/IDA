
function filter_read() {
	var current = businessview.getNextRecord();
	if (current!=null ) {
		current.keep = false;
		if (dataset.isEmpty("ds_codes") == false) {	
			var code_list = dataset.ds_codes.get().split("¶");
			for (i=0;i<code_list.length;i++){
				if ((current.subkey.get() == code_list[i]) || (current.parent_subkey.get() == code_list[i]) ) {
					current.keep = true;
				}
			}
		}
	}
	return current;
}
