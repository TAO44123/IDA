import './utils.javascript'


function get_permission_values(){
    var multiple_attributes = false;
    var app_schema = dataset.appschema.get();
    var permission_values = [];
    if(dataset.get("_ent_attr").isMultivalued() && dataset.get("_ent_attr").length >= 2){
        var entitlement_attribute = dataset.get("_ent_attr");
        multiple_attributes = true;
    } else {
        var entitlement_attribute = dataset._ent_attr.get();
    }
    print(app_schema);
    app_schema = parseSchema(app_schema);

    if(multiple_attributes){
        for(var i = 0; i < entitlement_attribute.length; i++){
            var attribute = entitlement_attribute[i];
            print(attribute);
            var val = app_schema[attribute];
            if (Object.prototype.toString.call(val) === '[object Array]') {
                permission_values = permission_values.concat(val);
            } else if (val !== undefined && val !== null) {
                permission_values.push(val);
            }
        }  
    } else {
        print(entitlement_attribute);
        var val = app_schema[entitlement_attribute];
        if (Object.prototype.toString.call(val) === '[object Array]') {
            permission_values = permission_values.concat(val);
        } else if (val !== undefined && val !== null) {
            permission_values.push(val);
        }
    }
    // Ensure one-dimensional array
    permission_values = flatten(permission_values);
    AddAttributeWithValues(dataset, 'permission_values', 'String', true, permission_values);
}