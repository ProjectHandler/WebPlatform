//
// REDCSS
//

// ANIMATING
(function($, undefined) {
	"use strict";
	
	function animateEventInit() {
		
		var settings = {
			triggeredClass : "animating-event",				// activating class
			actionVar : "data-action",						// event type : toggle-event - open-event - close-event
			animationVar : "data-animation",				// animation type : pop-event - collapse-event - reveal-event - slide-event
			targetVar : "data-target",						// target element : id of the target
			directionVar : "data-direction",				// directions for slide and reveal : ***-top - ***-bottom - ...
			optionVar : "data-option",						// optional informations when needed (for reveal)
			focusStatement : "focus-sensitive",				// focus sensitive statement
			activeStatement : "active",						// active statement
			preventStatement : "no-preventDefault",			// preventDefault statement
			openatlaunchStatement : "open-at-launch",		// openatlaunch statement
			animationEventpeed : 250						// animation speed
		};

		var actionEvent = {
			toggle : "toggle-event",
			open : "open-event",
			close : "close-event"
		};
		
		var animationEvent = {
			pop : "pop-event",
			collapse : "collapse-event",
			reveal : "reveal-event",
			slide : "slide-event"
		};
		
		function toggleOn(area, triggers, event) {
			if (event == animationEvent.pop) { area.show(); }
			else if (event == animationEvent.collapse) {
				var autoHeight = area.css("height","auto").height(); 
				area.height(0);
				area.animate({height:autoHeight}, settings.animationEventpeed);
			}
			else if (event == animationEvent.reveal) {
				var direction = triggers.attr(settings.directionVar);
				var affectedArea = $("#" + triggers.attr(settings.optionVar));
				var marginValue = "margin-left";
				var cssValues = {};
				if (direction == "reveal-top") { marginValue = "margin-top"; }
				else if (direction == "reveal-bottom") { marginValue = "margin-bottom"; }
				else if (direction == "reveal-left") { marginValue = "margin-left"; }
				else if (direction == "reveal-right") { marginValue = "margin-right"; }
				area.show();
				cssValues[marginValue] = area.width() * -1;
				affectedArea.animate(cssValues, settings.animationEventpeed); 
			}
			else if (event == animationEvent.slide) {
				var direction = triggers.attr(settings.directionVar);
				var marginValue = "margin-left";
				var cssValues = {};
				if (direction == "slide-top") { marginValue = "margin-bottom"; }
				else if (direction == "slide-bottom") { marginValue = "margin-top"; }
				else if (direction == "slide-left") { marginValue = "margin-right"; }
				else if (direction == "slide-right") { marginValue = "margin-left"; }
				area.css(marginValue, area.width() * -1);
				area.show();
				cssValues[marginValue] = 0;
				area.animate(cssValues, settings.animationEventpeed); 
			}
		}
		
		function toggleOff(area, triggers, event) {
			if (event == animationEvent.pop) { area.hide(); }
			else if (event == animationEvent.collapse) { area.animate({height:"0"}, settings.animationEventpeed); }
			else if (event == animationEvent.reveal) {
				var direction = triggers.attr(settings.directionVar);
				var affectedArea = $("#" + triggers.attr(settings.optionVar));
				var marginValue = "margin-left";
				var cssValues = {};
				if (direction == "reveal-top") { marginValue = "margin-top"; }
				else if (direction == "reveal-bottom") { marginValue = "margin-bottom"; }
				else if (direction == "reveal-left") { marginValue = "margin-left"; }
				else if (direction == "reveal-right") { marginValue = "margin-right"; }
				cssValues[marginValue] = 0;
				affectedArea.animate(cssValues, settings.animationEventpeed, function() {
					area.hide();
				});
			}
			else if (event == animationEvent.slide) {
				var direction = triggers.attr(settings.directionVar);
				var marginValue = "margin-left";
				var cssValues = {};
				if (direction == "slide-top") { marginValue = "margin-bottom"; }
				else if (direction == "slide-bottom") { marginValue = "margin-top"; }
				else if (direction == "slide-left") { marginValue = "margin-right"; }
				else if (direction == "slide-right") { marginValue = "margin-left"; }
				cssValues[marginValue] = area.width() * -1;
				area.animate(cssValues, settings.animationEventpeed, function() {
					area.hide();
					area.css(marginValue, area.width() * -1);					
				});
			}
		}
		
		function handleActionOpen(area, triggers, toggles, event) {
			area.addClass(settings.activeStatement);
			// active state only on toggles, not open and close
			toggles.addClass(settings.activeStatement);	
			toggleOn(area, triggers, event);
		}
		
		function handleActionClose(area, triggers, toggles, event) {
			area.removeClass(settings.activeStatement);
			// active state only on toggles, not open and close
			toggles.removeClass(settings.activeStatement);					
			toggleOff(area, triggers, event); 
		}
		
		function handleActionEvent(triggeredElement) {
			var areaId = triggeredElement.attr(settings.targetVar);
			var actionType = triggeredElement.attr(settings.actionVar);
			var area = $("#" + areaId);
			var triggers = $("." + settings.triggeredClass + "[" + settings.targetVar + "='" + areaId + "']");
			var toggles = $("." + settings.triggeredClass + "[" + settings.targetVar + "='" + areaId + "']" + "[" + settings.actionVar + "='" + actionEvent.toggle + "']");
			var event = triggers.attr(settings.animationVar);
			if (actionType == actionEvent.toggle) {
				if (triggeredElement.is("." + settings.activeStatement)) { handleActionClose(area, triggers, toggles, event); }
				else { handleActionOpen(area, triggers, toggles, event); }
			}
			else if (actionType == actionEvent.open) { handleActionOpen(area, triggers, toggles, event); }
			else if (actionType == actionEvent.close) { handleActionClose(area, triggers, toggles, event); }
		}

		function handleFocusLoss(triggeredElement) {
			// fetching all active and focus-sensitive area
			$("." + settings.focusStatement + "." + settings.activeStatement).each( function( index, element ){
				var toClose = true;
				// if we hit the box
				if (triggeredElement.is($(this))) { toClose = false; }
				// if we hit inside
				if (triggeredElement.parents().is($(this))) { toClose = false; }
				// if we hit the affiliated btn(s)
				if (triggeredElement.is("." + settings.triggeredClass + "[" + settings.targetVar + "='" + $(this).attr("id") + "']")) { toClose = false; }
				// if we didnt hit inside the area or the affiliated btn(s), we close it
				if (toClose == true) { 
					var areaId = $(this).attr("id");
					var area = $("#" + areaId);
					var triggers = $("." + settings.triggeredClass + "[" + settings.targetVar + "='" + areaId + "']");
					var toggles = $("." + settings.triggeredClass + "[" + settings.targetVar + "='" + areaId + "']" + "[" + settings.actionVar + "='" + actionEvent.toggle + "']");
					var event = triggers.attr(settings.animationVar);
					handleActionClose(area, triggers, toggles, event);
				}
			});
		}
		
		function openAtLaunch() {
			$("." + settings.openatlaunchStatement).each( function( index, element ){
				var areaId = $(this).attr("id");
				var area = $("#" + areaId);
				var triggers = $("." + settings.triggeredClass + "[" + settings.targetVar + "='" + areaId + "']");
				var toggles = $("." + settings.triggeredClass + "[" + settings.targetVar + "='" + areaId + "']" + "[" + settings.actionVar + "='" + actionEvent.toggle + "']");
				var event = triggers.attr(settings.animationVar);
				handleActionOpen(area, triggers, toggles, event);
			});
		}
		
		openAtLaunch();
		
		$(document).on("click", function(event) {
			var triggeredElement = $(event.target);
			// if i hit a toggle children
			if (triggeredElement.parents().is("." + settings.triggeredClass)) { triggeredElement = triggeredElement.parents("." + settings.triggeredClass); }
			handleFocusLoss(triggeredElement);
			// if the triggered element is a btn
			if (triggeredElement.is("." + settings.triggeredClass)) {
				if (!triggeredElement.is("." + settings.preventStatement)) { event.preventDefault(); }
				handleActionEvent(triggeredElement);
			}
		});

	}

	$(document).ready(function() { animateEventInit(); });
	
})(jQuery);


// SCROLLSPY
(function($, undefined) {
	"use strict";
	
	function scrollspyInit(options) {

		var defaults = {
			triggeredClass : "scrollspy-container",
			targetVar : "scrollspy-section"
		};
		
		var settings = $.extend({}, defaults, options || {});
		
		$("." + settings.triggeredClass ).scroll(function (event) {
			var last = null;
			var scroll = $("." + settings.triggeredClass).position().top;
			var isScrollBottom = $("." + settings.triggeredClass).scrollTop() + $("." + settings.triggeredClass).innerHeight() >= $("." + settings.triggeredClass)[0].scrollHeight;
			$("." + settings.targetVar).each(function(i) {
				var target = $(this).position().top;
				if (target <= scroll)
					last = $(this).attr("id");
			});
			if (isScrollBottom == true)	
				last = $("." + settings.targetVar).last().attr("id");
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

// SWITCHES
(function($, undefined) {
	"use strict";
	
	function switchesInit(options) {

		var settings = {
			checkbox : "checkbox-switch",
			radio : "radio-switch",
			select : "select-switch"
		};
		
		function stringify(list, toEscape) {
			var str = "";
			$.each(list, function(i, n){ if (n != toEscape) { str += " " + n ; } });
			return str;
		}
		
		function buildCheckbox() {
			$("." + settings.checkbox).each( function( index, element ){
				var classList = $(this).attr('class').split(" ");
				var classListString = stringify(classList, settings.checkbox);
				var trigger = $("<div/>").append($(this).clone()).html();
				$(this).replaceWith("<div class=\"checkbox-switched" + classListString + "\"><label>" + trigger + "<div class=\"switch\"></div></label></div>");
			})
		}

		function buildRadio() {
			$("." + settings.radio).each( function( index, element ){
				var classList = $(this).attr('class').split(" ");
				var classListString = stringify(classList, settings.radio);
				var trigger = $("<div/>").append($(this).clone()).html();
				$(this).replaceWith("<div class=\"radio-switched" + classListString + "\"><label>" + trigger + "<div class=\"switch\"></div></label></div>");
			})
		}
		
		buildCheckbox();
		buildRadio();
		
	}

	$(document).ready(function() { switchesInit();});
	
})(jQuery);
