/*  Some parts of this code are based on D3 Radial progress chart
 * copyright  2015 Pablo Molnar under MIT License
 * http://pablomolnar.github.io/radial-progress-chart/
 *
 * */

'use strict';

var _createClass = function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; }();

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

var d3;
var brainwave;

if (!brainwave) brainwave = {};

/*
 * config:
mode: radial|numeric|row
title: string
unit: string
valueColor: object
*/

brainwave.IndicatorGroup = function () {
    function IndicatorGroup(table, config, parentId, clickCB) {
        _classCallCheck(this, IndicatorGroup);

        this.config = config;
        this._id = parentId;
        this.editing = false;
        this.clickCallback = clickCB;

        // build DOM
        this.gaugeMode = config.mode === "radial";
        this.rowMode = config.mode === "row";
        var $container = d3.select(table);
        this.$container = $container;
        this.destroy();
        $container.attr("class", this.rowMode ? "ind-group tv" : "ind-group th");
        this.indicators = [];
        this.$containers = [];
        var configs = config.configs;
        var nb = configs.length;
        var _config = void 0;
        var ind = void 0;
        if (this.rowMode) {
            for (var i = 0; i < nb; i++) {
                _config = configs[i];
                _config.mode = config.mode;
                _config.imagePath = config.imagePath;
                _config.animation = config.animation;
                var $tr = $container.append("div").attr("class", "ind");
                this.$containers.push($tr);
                ind = new brainwave.Indicator($tr, _config, i, parentId, clickCB);
                this.indicators.push(ind);
            }
        } else {
            var $row = $container.append("div").attr("class", "row");
            var widthprc = Math.floor(100.0 / nb) + "%";
            for (var _i = 0; _i < nb; _i++) {
                _config = configs[_i];
                _config.mode = config.mode;
                _config.imagePath = config.imagePath;
                _config.animation = config.animation;
                var $cell = $row.append("div");
                $cell.style("width", widthprc);
                this.$containers.push($cell);
                ind = new brainwave.Indicator($cell, _config, _i, parentId, clickCB);
                this.indicators.push(ind);
            }
        }
    }

    _createClass(IndicatorGroup, [{
        key: "setData",
        value: function setData(index, data) {
            //onsole.log("data index=", index, " value", data.value);
            this.indicators[index].setData(data);
        }
    }, {
        key: "setEditing",
        value: function setEditing(editing) {
            var self = this;
            if (this.editing !== editing) {
                this.editing = editing;
                if (editing) {
                    this.$addBtn = this.$container.append("div").attr("class", "btn-icon add").on("click", function (event) {
                        self.clickCallback({ type: "add", index: 0 });
                    });
                } else {
                    this.$addBtn.remove();
                    this.$addBtn = null;
                }

                this.indicators.forEach(function (ind) {
                    ind.setEditing(editing);
                });
            }
        }
    }, {
        key: "resize",
        value: function resize(w, h) {
            //onsole.log( "resize w=",w, " h=", h);
            var cw = Math.floor(w / this.indicators.length);
            this.indicators.forEach(function (ind) {
                ind.resize(cw, h);
            });
        }
    }, {
        key: "destroy",
        value: function destroy() {
            // check memory leak
            this.$container.select("*").remove();
        }
    }]);

    return IndicatorGroup;
}();
'use strict';

var _createClass = function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; }();

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

if (!window.brainwave) {
    window.brainwave = {};
}

// stylesheet is handled in the java side, using requireCSS
if (window.rap) rap.registerTypeHandler("brainwave.IndicatorGroup", {

    factory: function factory(properties) {
        return new brainwave.IndicatorGroupHandler(properties);
    },
    destructor: "destroy",
    properties: ["editing"],
    methods: ["updateData"],
    events: ["render", "edit"]
});

brainwave.IndicatorGroupHandler = function () {
    function IndicatorGroupHandler(properties) {
        _classCallCheck(this, IndicatorGroupHandler);

        bindAll(this, ["onResize", "onReady", "onRender"]);
        this.parent = rap.getObject(properties.parent);
        this.createControls(this.parent, properties);
        this.parent.addListener("Resize", this.onResize);
        rap.on("render", this.onRender);
        this.ready = false;
    }

    _createClass(IndicatorGroupHandler, [{
        key: "createControls",
        value: function createControls(parent, properties) {
            // create root container
            var container = document.createElement("div");
            parent.append(container);
            this.container = container;
            //create child indicator with default options
            var self = this;
            this.indicatorGroup = new brainwave.IndicatorGroup(container, properties.config, properties.parent, function (editInfo) {
                self.handleEdit(editInfo);
            });
        }
    }, {
        key: "onReady",
        value: function onReady() {
            this.ready = true;
            this.onResize();
            if (this._data) {
                this.setData(this._data);
            }
        }
    }, {
        key: "onRender",
        value: function onRender() {
            if (this.container.parentNode) {
                rap.off("render", this.onRender);
                this.onReady();
                rap.on("send", this.onSend);
            }
        }
    }, {
        key: "onSend",
        value: function onSend() {}
    }, {
        key: "onResize",
        value: function onResize() {
            try {
                if (this.ready) {
                    var area = this.parent.getClientArea();
                    this.indicatorGroup.resize(area[2], area[3]);
                }
            } catch (e) {
                console.log(e);
            }
        }
    }, {
        key: "handleEdit",
        value: function handleEdit(editInfo) {
            var remoteObject = rap.getRemoteObject(this);
            remoteObject.notify("edit", editInfo);
        }
    }, {
        key: "destroy",
        value: function destroy() {
            //TODO check memory leak
            //nsole.debug("indicator.destroy()+ this.container=", this.container );
            rap.off("send", this.onSend);
            $(this.container).remove();
            this.indicatorGroup.destroy();
        }

        // data = { value,  valueString, prevValue, status  }

    }, {
        key: "updateData",
        value: function updateData(data) {
            if (this.ready) {
                this.indicatorGroup.setData(data.index, data);
            } else {
                this._data = data;
            }
        }
    }, {
        key: "setEditing",
        value: function setEditing(editing) {
            this.indicatorGroup.setEditing(editing);
        }
    }]);

    return IndicatorGroupHandler;
}();

var bind = function bind(context, method) {
    return function () {
        return method.apply(context, arguments);
    };
};

var bindAll = function bindAll(context, methodNames) {
    for (var i = 0; i < methodNames.length; i++) {
        var method = context[methodNames[i]];
        context[methodNames[i]] = bind(context, method);
    }
};
/*  Some parts of this code are based on D3 Radial progress chart
 * copyright  2015 Pablo Molnar under MIT License
 * http://pablomolnar.github.io/radial-progress-chart/
 *
 * */

'use strict';

var _typeof = typeof Symbol === "function" && typeof Symbol.iterator === "symbol" ? function (obj) { return typeof obj; } : function (obj) { return obj && typeof Symbol === "function" && obj.constructor === Symbol && obj !== Symbol.prototype ? "symbol" : typeof obj; };

var _createClass = function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; }();

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

var d3;
var brainwave;

if (!brainwave) brainwave = {};

/*
 * config:
mode: radial|numeric|row
title: string
unit: string
valueColor: object
*/

brainwave.Indicator = function () {
    function Indicator($container, config, index, parentId, clikCB) {
        _classCallCheck(this, Indicator);

        this.config = this.initializeConfig(config);
        this._id = parentId + "_" + index;
        this.index = index;
        this.gaugeMode = config.mode === "radial";
        this.numericMode = config.mode === "numeric";
        this.rowMode = config.mode === "row";
        this.clickCallback = clikCB;
        this.editing = false;
        this.$editButtons = null;

        // internal  variables
        this.$container = $container;
        $container.attr("class", this.rowMode ? "ind row" : this.numericMode ? "ind num" : "ind gauge");

        //remove previous content
        this.destroy();
        this.renderContent($container);
    }

    _createClass(Indicator, [{
        key: "renderContent",
        value: function renderContent($container) {
            if (this.rowMode) {
                this.renderTitle($container);
                this.renderValue($container);
                this.renderTrend($container);
            } else {
                // gauge and numeric
                if (this.gaugeMode) this.renderRings($container);
                // add center content
                this.$center = $container.append("div").attr("class", "center-text");
                //value line
                this.renderValue(this.$center);
                this.renderTrend(this.$center);
                if (this.config.title) {
                    this.renderTitle($container);
                }
                var thresholds = this.config.thresholds;
                if (thresholds) this.renderTooltips(this.$container, thresholds);
            }
        }
    }, {
        key: "renderRings",
        value: function renderRings() {
            var self = this; // to reference in inner functions
            var config = this.config;
            var serie = config.serie;
            var width = 15 + (config.diameter / 2 + config.stroke.width) * 2;
            var height = width + 0;
            var dim = "0 0 " + height + " " + width;
            var twopi = 2 * Math.PI;

            var innerRadius = config.diameter / 2;
            var outerRadius = innerRadius + config.stroke.width;

            this.$svg = this.$container.append("svg").attr("class", "chart")
            // .attr("preserveAspectRatio","xMidYMid meet")
            .attr("viewBox", dim);

            // add ring structure
            this.$rings = this.$svg.append("g").datum(serie).attr("transform", "translate(" + width / 2 + "," + height / 2 + ")");

            // add gradients defs
            if (serie.color.linearGradient || serie.color.radialGradient) {
                var defs = this.$svg.append("svg:defs");
                var gradient = this.gradientToSVGElement('gradient' + this._id, serie.color);
                defs.node().appendChild(gradient);
            }

            //create value arc
            this.progressArcFn = d3.arc().startAngle(0).endAngle(function (serie) {
                    var a = serie.percentage / 100 * twopi;
                    //   if (a <= 0) a = 0.1;
                    return a;
                })
                .innerRadius(innerRadius).outerRadius(outerRadius).cornerRadius(function (serie) {
                    // Workaround for d3 bug https://github.com/mbostock/d3/issues/2249
                    // Reduce corner radius when corners are close each other
                    var m = serie.percentage >= 95 ? (100 - serie.percentage) * 0.1 : 1;
                    return self.config.stroke.width / 2 * m;
                });

            // create value ring
            this.$rings.append("path").attr("class", "progress");

            // background ring
            this.$rings.append("path").attr("class", "bg").style("fill", serie.color.background).style("opacity", 0.2).attr("d", d3.arc().startAngle(0).endAngle(twopi).innerRadius(innerRadius).outerRadius(outerRadius));

            // add thresholds
            var thresholds = config.thresholds;
            if (thresholds) {
                this.thresholdArcFn = d3.arc().innerRadius(innerRadius * 0.9).outerRadius(innerRadius).startAngle(function (thr) {
                        return thr.start / 100 * twopi;
                    }).endAngle(function (thr) {
                        return thr.stop / 100 * twopi;
                    });

                this.$rings.selectAll(".threshold").data(thresholds.values).enter().append("path").attr("class", "threshold").style("fill", function (thr) {
                        return thr.color;
                    }).style("opacity", 0.3);
            }
        }
    }, {
        key: "renderTooltips",
        value: function renderTooltips($parent, thresholds) {
            var self = this;
            // add tooltiptext
            var $tooltip = $parent.append("div").attr("class", "tooltiptext");
            var tips = $tooltip.selectAll("div").data(thresholds.values).enter().append("div");

            tips.append("img").attr("src", function (thr) {
                return thr.img;
            });
            tips.append("span").text(function (thr) {
                return thr.value + " " + self.config.unit;
            });
            this.$tooltip = $tooltip;
        }
    }, {
        key: "renderValue",
        value: function renderValue($parent) {
            var index = this.index;
            var self = this;
            this.$valueLine = $parent.append("div").attr("class", this.config.link ? "values link" : "values");
            if (this.config.link) {
                this.$valueLine.on("click", function (event) {
                    self.clickCallback({ type: "link", index: index });
                });
            }
            this.$valueTag = this.$valueLine.append("span").attr('class', "value").text("-");
            this.$valueLine.append("span").attr("class", "unit").text(this.config.unit);
        }
    }, {
        key: "renderTrend",
        value: function renderTrend($parent) {
            this.$trendTag = $parent.append("div").attr("class", "trend");
            this.$trendTag.append("img").attr("class", "icon");
            this.$trendTag.append("span").attr("class", "text");
        }
    }, {
        key: "renderTitle",
        value: function renderTitle($parent) {
            this.$title = $parent.append("div").attr("class", "title").text(this.config.title ? this.config.title : "");
        }

        /**
         * Update data to be visualized in the chart.
         *
         @param data: optional object { value: int  [denominator: int ] prevValue: int prevDenominator: int ]
        *
        */

    }, {
        key: "setData",
        value: function setData(data) {
            // update content with transition
            console.log("data:", data);
            var config = this.config;
            var serie = config.serie;

            if (!data) return;

            serie.value = data.value;
            serie.trendValue = data.trendValue;

            if (data.max) {
                config.max = data.max;
                config.thresholds = this.normalizeThresholds(config.thresholds, config.max);
            }

            // compute status if thresholds
            serie.status = this.computeStatus(serie.value);

            serie.fromPercentage = serie.percentage || 0;
            serie.percentage = (serie.value || 0.1) * 100 / config.max;
            this.$valueTag.text(serie.value);

            //update trend value and icon
            var trendValue = serie.trendValue;
            var img = void 0;
            var txt = void 0;
            if (trendValue !== undefined) {
                if (trendValue > 0) {
                    img = this.imagePath("trend_up.svg");
                    txt = "+" + trendValue;
                } else if (trendValue < 0) {
                    img = this.imagePath("trend_dn.svg");
                    txt = trendValue;
                } else {
                    img = this.imagePath("trend_eq.svg");
                    txt = "";
                }
                this.$trendTag.select("img").attr("src", img);
                this.$trendTag.select("span").text(txt);
            }

            if (this.gaugeMode) {
                // draw thresholds
                if (config.thresholds) {
                    var thresholdArcFn = this.thresholdArcFn;
                    this.$rings.selectAll("path.threshold").data(config.thresholds.values).attr("d", thresholdArcFn);
                }

                // update progress with animation
                var animation = config.animation; // to use in inner functions
                var progressArcFn = this.progressArcFn;
                var _id = this._id;

                var ringsOp = this.$rings.select("path.progress").style("fill", function (serie) {
                    if (serie.color.solid) {
                        return serie.color.solid;
                    }

                    if (serie.color.linearGradient || serie.color.radialGradient) {
                        return "url(#gradient" + _id + ")";
                    }
                });
                if ( animation){
                    ringsOp.transition().duration(animation.duration).delay(0).attrTween("d", function (serie) {
                        var interpolator = d3.interpolateNumber(serie.fromPercentage, serie.percentage);
                        return function (t) {
                            //onsole.log("id: " + _id + " t:" + t);
                            serie.percentage = interpolator(t);
                            return progressArcFn(serie);
                        };
                    }).styleTween("fill", function (serie) {
                        if (serie.color.interpolate && serie.color.interpolate.length === 2) {
                            var colorInterpolator = d3.interpolateHsl(serie.color.interpolate[0], serie.color.interpolate[1]);

                            return function (t) {
                                var color = colorInterpolator(serie.percentage / 100);
                                d3.select(this.parentNode).select('path.bg').style('fill', color);
                                return color;
                            };
                        }
                    });
                }
                else {
                    ringsOp.attr("d", progressArcFn(serie));
                }

            }
            // update text color based on status after animation
            if (serie.status !== undefined && config.thresholds) {
                this.$valueLine.selectAll("span").style("color", config.thresholds.statusColors[serie.status]);
            }
        }
    }, {
        key: "setEditing",
        value: function setEditing(editing) {
            this.editing = editing;
            var index = this.index;
            var self = this;
            if (editing) {
                var $editBtn = this.$container.append("div").attr("class", "btn-icon edit").on("click", function (event) {
                    self.clickCallback({ type: "edit", index: index });
                });
                var $deleteBtn = this.$container.append("div").attr("class", "btn-icon delete").on("click", function (event) {

                    self.clickCallback({ type: "delete", index: index });
                });
                this.$editButtons = [$editBtn, $deleteBtn];
            } else {
                this.$editButtons.forEach(function ($btn) {
                    return $btn.remove();
                });
                this.$editButtons = null;
            }
        }

        /* return 0, 1 ou 2 */

    }, {
        key: "computeStatus",
        value: function computeStatus(value) {
            var thrs = this.config.thresholds;
            if (thrs) {
                if (thrs.high) {
                    if (value >= thrs.critical.value) return 2;else if (value >= thrs.warning.value) return 1;else return 0;
                } else {
                    // Lo eval
                    if (value <= thrs.critical.value) return 2;else if (value <= thrs.warning.value) return 1;else return 0;
                }
            } else return 0;
        }
    }, {
        key: "resize",
        value: function resize(w, h) {
            if (this.rowMode) return;
            var wpx = w + "px";
            var hpx = h + "px";
            this.$container.style("width", wpx).style("height", hpx);

            if (this.$title) {
                h -= 30; // hack, remplacer par une valeur calculée
            }
            var minExtent = w > h ? Math.max(h, 50) : Math.max(w, 50);
            //onsole.debug("minExtent:", minExtent);

            if (this.gaugeMode) {
                var fontSize = Math.ceil(minExtent * 0.26);
                //onsole.debug("fontSize-gauge:", fontSize);
                var sizepx = minExtent + "px";
                this.$svg.attr("width", minExtent).attr("height", minExtent);
                this.$center.style("width", wpx).style("font-size", fontSize + "px");
            } else {
                // numeric mode
                var _fontSize = minExtent > 100 ? 48 : Math.ceil(minExtent * 0.48);
                //onsole.debug("fontSize-num:", fontSize);
                this.$center.style("font-size", _fontSize + "px");
            }
            // center tooltips with margins ( because otherwise they position regarding the table, not the cell
            if (this.$tooltip) {
                this.$tooltip.style("margin-left", (w - 105) + "px");
            }
        }
    }, {
        key: "destroy",
        value: function destroy() {
            // check memory leak
            this.$container.select("*").remove();
        }

        /* STATIC UTILS */

        /**
         * Detach and normalize user's config input.
         */

    }, {
        key: "initializeConfig",
        value: function initializeConfig(config) {

            var self = this;
            // set imagePath or config init will not work
            this.config = { imagePath: config.imagePath || "rwt-resources/indicator/img/" };

            var _config = {
                diameter: 100,
                imagePath: this.config.imagePath,
                link: config.link,
                stroke: {
                    width: 10
                },
                animation: config.animation?
                    {  duration: 1000,  delay: 0  }: false ,
                round: config.round !== undefined ? !!config.round : true,
                center: { x: 0, y: 0 },
                max: config.max || 100,
                title: config.title,
                unit: config.unit || "",
                serie: { color: this.normalizeColor(config.serieColor) }
            };

            _config.thresholds = this.normalizeThresholds(config.thresholds, _config.max);

            this.config = _config;
            return _config;
        }
    }, {
        key: "imagePath",
        value: function imagePath(file) {
            return this.config.imagePath + file;
        }

        // make:  { warning: { value, color } critical { value, color} values [ { start, stop, color, value, image ]

    }, {
        key: "normalizeThresholds",
        value: function normalizeThresholds(thresholds, max) {
            if (thresholds) {
                if (typeof thresholds.warning === 'number') thresholds.warning = { value: thresholds.warning, color: "orange" };
                if (typeof thresholds.critical === 'number') thresholds.critical = { value: thresholds.critical, color: "red" };
                var norm = 100 / max;
                if (thresholds.high) {
                    thresholds.values = [{
                        value: thresholds.warning.value,
                        start: thresholds.warning.value * norm,
                        stop: thresholds.critical.value * norm,
                        color: thresholds.warning.color,
                        img: this.imagePath("thr_hi_warning.svg")
                    }, {
                        value: thresholds.critical.value,
                        start: thresholds.critical.value * norm,
                        stop: max * norm,
                        color: thresholds.critical.color,
                        img: this.imagePath("thr_hi_critical.svg")
                    }];
                } else {
                    thresholds.values = [{
                        value: thresholds.critical.value,
                        start: 0,
                        stop: thresholds.critical.value * norm,
                        color: thresholds.critical.color,
                        img: this.imagePath("thr_lo_critical.svg")
                    }, {
                        value: thresholds.warning.value,
                        start: thresholds.critical.value * norm,
                        stop: thresholds.warning.value * norm,
                        color: thresholds.warning.color,
                        img: this.imagePath("thr_lo_warning.svg")
                    }];
                }
                thresholds.statusColors = [null, d3.hcl(thresholds.warning.color).darker(0.5).toString(), d3.hcl(thresholds.critical.color).darker(0.5).toString()];
            }
            return thresholds;
        }

        /**
         * Normalize different notations of color property
         *
         * @param {String|Array|Object} color
         * @example '#fe08b5'
         * @example { solid: '#fe08b5', background: '#000000' }
         * @example ['#000000', '#ff0000']
         * @example {
                    linearGradient: { x1: '0%', y1: '100%', x2: '50%', y2: '0%'},
                    stops: [
                      {offset: '0%', 'stop-color': '#fe08b5', 'stop-opacity': 1},
                      {offset: '100%', 'stop-color': '#ff1410', 'stop-opacity': 1}
                    ]
                  }
         * @example {
                    radialGradient: {cx: '60', cy: '60', r: '50'},
                    stops: [
                      {offset: '0%', 'stop-color': '#fe08b5', 'stop-opacity': 1},
                      {offset: '100%', 'stop-color': '#ff1410', 'stop-opacity': 1}
                    ]
                  }
         *
         */

    }, {
        key: "normalizeColor",
        value: function normalizeColor(color) {

            if (!color) {
                color = { solid: "#1774FF" };
            } else if (typeof color === 'string') {
                color = { solid: color };
            } else if (Array.isArray(color)) {
                color = { interpolate: color };
            } else if ((typeof color === "undefined" ? "undefined" : _typeof(color)) === 'object') {
                if (!color.solid && !color.interpolate && !color.linearGradient && !color.radialGradient) {
                    color.solid = "#1774FF";
                }
            }

            // Validate interpolate syntax
            if (color.interpolate) {
                if (color.interpolate.length !== 2) {
                    throw new Error('interpolate array should contain two colors');
                }
            }

            // Validate gradient syntax
            if (color.linearGradient || color.radialGradient) {
                if (!color.stops || !Array.isArray(color.stops) || color.stops.length !== 2) {
                    throw new Error('gradient syntax is malformed');
                }
            }

            // Set background when is not provided
            if (!color.background) {
                if (color.solid) {
                    color.background = color.solid;
                } else if (color.interpolate) {
                    color.background = color.interpolate[0];
                } else if (color.linearGradient || color.radialGradient) {
                    color.background = color.stops[0]['stop-color'];
                }
            }
            return color;
        }
    }, {
        key: "gradientToSVGElement",
        value: function gradientToSVGElement(id, props) {
            var gradientType = props.linearGradient ? 'linearGradient' : 'radialGradient';
            var gradient = d3.select(document.createElementNS(d3.namespaces.svg, gradientType)).attr(props[gradientType]).attr('id', id);

            props.stops.forEach(function (stopAttrs) {
                gradient.append("svg:stop").attr(stopAttrs);
            });

            this.background = props.stops[0]['stop-color'];

            return gradient.node();
        }
    }]);

    return Indicator;
}();