/*! slidereveal - v1.1.2 - 2016-05-16
* https://github.com/nnattawat/slidereveal
* Copyright (c) 2016 Nattawat Nonsung; Licensed MIT */
/*! slidereveal - v1.1.1 - 2016-03-04
* https://github.com/nnattawat/slidereveal
* Copyright (c) 2016 Nattawat Nonsung; Licensed MIT */
/* Modified by MAM to fix many bugs */
(function ($) {

  var SlideReveal = function($el, options) {
    // Define default setting
    var setting = {
      width: 250,
      autoEscape: false,
      top: 0,
      "zIndex": 1049,
    };

    // Attributes
    this.setting = $.extend(setting, options);
    this.element = $el;

    this.init();
  };

  // Public methods
  $.extend(SlideReveal.prototype, {
    init: function() {
      var self = this;
      var setting = this.setting;
      var $el = this.element;
      $el.css({
        position: "fixed",
        width: setting.width,
        height: setting.top > 0 ? "calc(100% - "+setting.top+"px)": "100%",
        top: setting.top
      });
      // Add close stage
      $el.data("slide-reveal", false);

      // Bind hide event to ESC
      if (setting.autoEscape) {
        $(document).on('keydown.slideReveal', function(e) {
          if ($('input:focus, textarea:focus').length === 0) {
            if (e.keyCode === 27 && $el.data("slide-reveal")) { // ESC
              self.hide();
            }
          }
        });
      }
    },

    show: function(triggerEvents) {
      var $el = this.element;
      if (!$el.data('slide-reveal')) {
        $el.addClass("is-visible");
        $el.data("slide-reveal", true);
      }
    },

    hide: function(triggerEvents) {
      var $el = this.element;
      if ($el.data('slide-reveal')) {
        $el.data("slide-reveal", false);
        $el.removeClass("is-visible");
      }
    },

    remove: function() {
      this.element.removeData('slide-reveal-model');
    }

  });

  // jQuery collection methods
  $.fn.slideReveal = function (options, triggerEvents) {
    if (options !== undefined && typeof(options) === "string") {
      this.each(function() {
        var slideReveal = $(this).data('slide-reveal-model');

        if (options === "show") {
          slideReveal.show(triggerEvents);
        } else if (options === "hide") {
          slideReveal.hide(triggerEvents);
        }
      });
    } else {
      this.each(function() {
        if ($(this).data('slide-reveal-model')) {
          $(this).data('slide-reveal-model').remove();
        }
        $(this).data('slide-reveal-model', new SlideReveal($(this), options));
      });
    }

    return this;
  };

}(jQuery));
