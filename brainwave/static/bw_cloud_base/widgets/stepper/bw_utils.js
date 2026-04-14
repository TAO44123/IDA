"use strict";
window.BWUtils = {

    element: function (name, props) {
        let node = document.createElement(name);
        let prop, value;
        if (props) {
            if (typeof props === 'string')
                node.className = props;
            else {
                for (prop in props) {
                    value = props[prop];
                    switch (prop) {
                        case "className" :
                            node.className = value;
                            break;
                        case "textContent":
                            node.textContent = value;
                            break;
                        case "innerHTML":
                            node.innerHTML = value;
                            break;
                        case "width":
                            node.style.width = typeof value === "string" ? value : value + "px";
                            break;
                        case "height":
                            node.style.height = typeof value === "string" ? value : value + "px";
                            break;
                        case "maxWidth":
                            node.style.maxWidth = typeof value === "string" ? value : value + "px";
                            break;
                        case "minWidth":
                            node.style.minWidth = typeof value === "string" ? value : value + "px";
                            break;
                        case "fontSize":
                            node.style.fontSize = value;
                            break;
                        default:
                            if (value != null)
                                node.setAttribute(prop, value);
                            else
                                node.removeAttribute(prop);
                    }
                }
            }

        }
        if (arguments.length > 2) {
            for (let i = 2; i < arguments.length; i++) {
                let child = arguments[i];
                if (child !== null)
                    node.appendChild(child);
            }
        }
        return node;
    },


};
    
