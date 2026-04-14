/*
*	General use library for SailPoint IIQ preprocess, parsing and collect scripts.
*	To be imported in relevant javascript files.
*/

// Flattens multi-dimensional arrays into a 1-dimension array
function flatten(arr) {
    var out = [];
    for (var i = 0; i < arr.length; i++) {
        if (Object.prototype.toString.call(arr[i]) === '[object Array]') {
            out = out.concat(flatten(arr[i]));
        } else if (arr[i] !== undefined && arr[i] !== null) {
            out.push(arr[i]);
        }
    }
    return out;
}

// Add an attribute to a dataset, and set its value
function AddAttributeWithValue( /*DataSet*/ ds, /*String*/ attributeName, /*String*/ attributeType, /*Boolean*/ multivalued, value ) {
	print( 'Adding to dataset, attribute: ' + attributeName + ', of type: ' + attributeType + ', mutlivalued: ' + multivalued + ', value: ' + value );
	if ( ds == null ) {
		debugPrint( 'Empty DataSet provided');
		return;	
	}
	var /*Attribute*/ attr;
	// If not multivalued or multivalued but empty
	if ( !multivalued || ds.isEmpty( attributeName ) ) {
		print('creating attribute with name : ' + attributeName);
		attr = ds.add( attributeName, attributeType, multivalued );
		if ( attr == null ) {
			print( "ds.isEmpty( " + attributeName + " )?: " + ds.isEmpty( attributeName ) );
			print( "Failed to add Attribute " + attributeName + " (type: " + attributeType + ", multivalued: " + multivalued + ") to dataset" );	
		} else {
			print('giving it value : ' + value);
			attr.set( value );
		}
	} else {
		print('adding value : ' + value + ' to attribute : ' + attributeName)
		attr = ds.get( attributeName );
		attr.add( value );
	}
}

// Add mutliple values to an attribute in a dataset
function AddAttributeWithValues( /*DataSet*/ ds, /*String*/ attributeName, /*String*/ attributeType, /*Boolean*/ multivalued, /*Array*/ values ) {
	print( 'Adding to dataset, attribute: ' + attributeName + ', of type: ' + attributeType + ', mutlivalued: ' + multivalued + ', values: ' + values );
	if ( values != null ) {
		for ( var /*Number*/ i = 0; i < values.length; i++ ) {
			AddAttributeWithValue( ds, attributeName, attributeType, multivalued, values[i] );
		}
	} else {
		print( 'No values provided for AddAttributeWithValues()');
	}
}

// Parses JSON/Python style string into a native JS object
// Handles scalars, multi-dimensional arrays and sub-objects
function parseSchema(str) {
    str = str.trim();
    if (str.charAt(0) === '{' && str.charAt(str.length - 1) === '}') {
        str = str.substring(1, str.length - 1);
    }
    var i = 0, len = str.length, obj = {};
    while (i < len) {
        while (i < len && (str.charAt(i) === ',' || /\s/.test(str.charAt(i)))) i++;
        if (i >= len) break;
        var key = "";
        if (str.charAt(i) === "'" || str.charAt(i) === '"') {
            var quote = str.charAt(i++);
            while (i < len && str.charAt(i) !== quote) key += str.charAt(i++);
            i++;
        }
        while (i < len && /\s/.test(str.charAt(i))) i++;
        if (str.charAt(i) === ':') i++;
        while (i < len && /\s/.test(str.charAt(i))) i++;
        var value;
        if (str.charAt(i) === '{') {
            var open = i, depth = 1;
            i++;
            while (i < len && depth > 0) {
                if (str.charAt(i) === '{') depth++;
                else if (str.charAt(i) === '}') depth--;
                i++;
            }
            var inner = str.substring(open, i);
            value = parseSchema(inner);
        } else if (str.charAt(i) === '[') {
            var open = i, depth = 1;
            i++;
            while (i < len && depth > 0) {
                if (str.charAt(i) === '[') depth++;
                else if (str.charAt(i) === ']') depth--;
                i++;
            }
            var inner = str.substring(open + 1, i - 1);
            value = parseList(inner);
        } else if (str.charAt(i) === "'" || str.charAt(i) === '"') {
            var quoteVal = str.charAt(i++);
            var val = '';
            while (i < len && str.charAt(i) !== quoteVal) val += str.charAt(i++);
            i++;
            value = val;
        } else {
            var start = i;
            while (i < len && !/[,}]/.test(str.charAt(i))) i++;
            value = parseListValue(str.substring(start, i).trim());
        }
        obj[key] = value;
        // Skip non-string after value
        while (i < len && (/\s/.test(str.charAt(i)) || str.charAt(i) === ',')) i++;
    }
    return obj;
}

// Parses arrays as strings into nativs JS array
// Handles multi dimesional arrays and lists of objects
function parseList(str) {
    var i = 0, len = str.length, elements = [];
    while (i < len) {
        while (i < len && (str.charAt(i) === ',' || /\s/.test(str.charAt(i)))) i++;
        if (i >= len) break;
        var value;
        if (str.charAt(i) === '{') {
            var open = i, depth = 1;
            i++;
            while (i < len && depth > 0) {
                if (str.charAt(i) === '{') depth++;
                else if (str.charAt(i) === '}') depth--;
                i++;
            }
            var inner = str.substring(open, i);
            value = parseSchema(inner);
        } else if (str.charAt(i) === '[') {
            var open = i, depth = 1;
            i++;
            while (i < len && depth > 0) {
                if (str.charAt(i) === '[') depth++;
                else if (str.charAt(i) === ']') depth--;
                i++;
            }
            var inner = str.substring(open + 1, i - 1);
            value = parseList(inner);
        } else if (str.charAt(i) === "'" || str.charAt(i) === '"') {
            var quoteVal = str.charAt(i++);
            var val = '';
            while (i < len && str.charAt(i) !== quoteVal) val += str.charAt(i++);
            i++;
            value = val;
        } else {
            var start = i;
            while (i < len && !/[,]]/.test(str.charAt(i))) i++;
            value = parseListValue(str.substring(start, i).trim());
        }
        elements.push(value);
        while (i < len && (/\s/.test(str.charAt(i)) || str.charAt(i) === ',')) i++;
    }
    return elements;
}

// Makes sure scalars from Python are converted to JS scalars
function parseListValue(value) {
    value = value.trim();
    if (value === "" || value === undefined) return null;
    if (value === "null" || value === "None") return null;
    if (value === "true" || value === "True") return true;
    if (value === "false" || value === "False") return false;
    if (!isNaN(Number(value))) return Number(value);
    return value;
}