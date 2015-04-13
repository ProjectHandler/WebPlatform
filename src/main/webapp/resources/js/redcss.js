//
// REDCSS
//

// ANIMATING
(function($, undefined) {
	"use strict";
	
	function toggleInit(options) {
		
		var defaults = {
			triggeredClass : "toggle-event",
			trigerredClassType : "data-toggle",
			trigerredClassTarget : "data-target",
			trigerredClassDir : "data-direction",
			trigerredClassOption : "data-option",
			focusingClass : "focus-sensitive",
			activeStatement : "active",
			eventSpeed : 250
		};
		
		var settings = $.extend({}, defaults, options || {});
		
		var events = {
			pop : "pop-event",
			collapse : "collapse-event",
			reveal : "reveal-event",
			slide : "slide-event"
		};
		
		function toggleOn(areaId) {
			var area = $("#" + areaId);
			var toggles = $("." + settings.triggeredClass + "[" + settings.trigerredClassTarget + "='" + areaId + "']");
			var event = toggles.attr(settings.trigerredClassType);
			// run the animation
			if (event == events.pop) { area.show(); }
			else if (event == events.collapse) {
				var autoHeight = area.css("height","auto").height(); 
				area.height(0);
				area.animate({height:autoHeight}, settings.eventSpeed);
			}
			else if (event == events.reveal) {
				var direction = toggles.attr(settings.trigerredClassDir);
				var affectedArea = $("#" + toggles.attr(settings.trigerredClassOption));
				var marginValue = "margin-left";
				var cssValues = {};
				if (direction == "reveal-top") { marginValue = "margin-top"; }
				else if (direction == "reveal-bottom") { marginValue = "margin-bottom"; }
				else if (direction == "reveal-left") { marginValue = "margin-left"; }
				else if (direction == "reveal-right") { marginValue = "margin-right"; }
				area.show();
				cssValues[marginValue] = area.width() * -1;
				affectedArea.animate(cssValues, settings.eventSpeed); 
			}
			else if (event == events.slide) {
				var direction = toggles.attr(settings.trigerredClassDir);
				var marginValue = "margin-left";
				var cssValues = {};
				if (direction == "slide-top") { marginValue = "margin-bottom"; }
				else if (direction == "slide-bottom") { marginValue = "margin-top"; }
				else if (direction == "slide-left") { marginValue = "margin-right"; }
				else if (direction == "slide-right") { marginValue = "margin-left"; }
				area.css(marginValue, area.width() * -1);
				area.show();
				cssValues[marginValue] = 0;
				area.animate(cssValues, settings.eventSpeed); 
			}
			else { console.log("unknown event"); }
			// set the area and the toggle(s) as active
			area.addClass(settings.activeStatement);
			toggles.addClass(settings.activeStatement);
		}
		
		function toggleOff(areaId) {
			var area = $("#" + areaId);
			var toggles = $("." + settings.triggeredClass + "[" + settings.trigerredClassTarget + "='" + areaId + "']");
			var event = toggles.attr(settings.trigerredClassType);
			// run the animation
			if (event == events.pop) { area.hide(); }
			else if (event == events.collapse) { area.animate({height:"0"}, settings.eventSpeed); }
			else if (event == events.reveal) {
				var direction = toggles.attr(settings.trigerredClassDir);
				var affectedArea = $("#" + toggles.attr(settings.trigerredClassOption));
				var marginValue = "margin-left";
				var cssValues = {};
				if (direction == "reveal-top") { marginValue = "margin-top"; }
				else if (direction == "reveal-bottom") { marginValue = "margin-bottom"; }
				else if (direction == "reveal-left") { marginValue = "margin-left"; }
				else if (direction == "reveal-right") { marginValue = "margin-right"; }
				cssValues[marginValue] = 0;
				affectedArea.animate(cssValues, settings.eventSpeed, function() {
					area.hide();
				});
			}
			else if (event == events.slide) {
				var direction = toggles.attr(settings.trigerredClassDir);
				var marginValue = "margin-left";
				var cssValues = {};
				if (direction == "slide-top") { marginValue = "margin-bottom"; }
				else if (direction == "slide-bottom") { marginValue = "margin-top"; }
				else if (direction == "slide-left") { marginValue = "margin-right"; }
				else if (direction == "slide-right") { marginValue = "margin-left"; }
				cssValues[marginValue] = area.width() * -1;
				area.animate(cssValues, settings.eventSpeed, function() {
					area.hide();
					area.css(marginValue, area.width() * -1);					
				});
			}
			else { console.log("unknown event"); }
			// set the area and the toggle(s) as inactive
			area.removeClass(settings.activeStatement);
			toggles.removeClass(settings.activeStatement);
		}
		
		function handleToggleEvent(triggeredElement) {
			var areaId = triggeredElement.attr(settings.trigerredClassTarget);
			// if the toggle is already on, we want to close it
			if (triggeredElement.is("." + settings.activeStatement)) { toggleOff(areaId); }
			// else, it means we want to open it
			else { toggleOn(areaId); }
		}

		function handleFocusLoss(triggeredElement) {
			// fetching all active and focus-sensitive area
			$("." + settings.focusingClass + "." + settings.activeStatement).each( function( index, element ){
				var toClose = true;
				// if we hit the box
				if (triggeredElement.is($(this))) { toClose = false; }
				// if we hit inside
				if (triggeredElement.parents().is($(this))) { toClose = false; }
				// if we hit the affiliated toggle(s)
				if (triggeredElement.is("." + settings.triggeredClass + "[" + settings.trigerredClassTarget + "='" + $(this).attr("id") + "']")) { toClose = false; }
				// if we didnt hit inside the area or the affiliated toogle(s), we close it
				if (toClose == true) { toggleOff($(this).attr("id")); }
			});
		}
		
		$(document).on("click", function(event) {
			var triggeredElement = $(event.target);
			// if i hit a toggle children
			if (triggeredElement.parents().is("." + settings.triggeredClass)) { triggeredElement = triggeredElement.parents("." + settings.triggeredClass); }
			handleFocusLoss(triggeredElement);
			// if the triggered element is a toggle
			if (triggeredElement.is("." + settings.triggeredClass)) {
				event.preventDefault();
				handleToggleEvent(triggeredElement);
			}
		});

	}

	$(document).ready(function() { toggleInit(); });
	
})(jQuery);


// SCROLLSPY
(function($, undefined) {
	"use strict";
	
	function scrollspyInit(options) {

		var defaults = {
			triggeredClass : "scrollspy-container",
			trigerredClassTarget : "scrollspy-section"
		};
		
		var settings = $.extend({}, defaults, options || {});
		
		$("." + settings.triggeredClass ).scroll(function (event) {
			var last = null;
			var scroll = $("." + settings.triggeredClass).position().top;
			var isScrollBottom = $("." + settings.triggeredClass).scrollTop() + $("." + settings.triggeredClass).innerHeight() >= $("." + settings.triggeredClass)[0].scrollHeight;
			$("." + settings.trigerredClassTarget).each(function(i) {
				var target = $(this).position().top;
				if (target <= scroll)
					last = $(this).attr("id");
			});
			if (isScrollBottom == true)	
				last = $("." + settings.trigerredClassTarget).last().attr("id");
			if (history && history.replaceState) {
				if (last == null)
					history.replaceState({}, "", "#");
				else
					history.replaceState({}, "", "#" + last);	
			}
		});

	}

	$(document).ready(function() { scrollspyInit();});
	
})(jQuery);