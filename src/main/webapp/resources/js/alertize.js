//////////////////////////////////////////////////////////////////////
// POPUPISE
//////////////////////////////////////////////////////////////////////
//
// simple toggler which add your content to <body>
// main use is for modal handling and other popup patterns
//
// can only show one frame at once
// if you dont close it before your next opening instruction
// the next instruction will be ignored 
//
// open({yourcontent}, [callback])
// close([callback])
// toggle({yourcontent}, [callback])
// isDown()
//
// {yourcontent} should be a javascript string
// oserwhise, if you link to an existing element on the DOM
// the close() event will destroy it
// YOU MUST ADD THE CLASS "popupize-frame" TO THE FIRST CONTAINER !
// open("<div class="popupize-frame">i like popup</div>")
//
// [callback] is optional
//
// toggle() = open if closed and close if opened
//
// isDown() = running
// so you must close it with close() or toggle()
//
// example :
//
// popupize.open(
//		"<div class="popupize-frame">i like popup</div>",
//		function() { alert("this popup has just opened !"); }
//	);
//
// // this one will be ignored because a popup is already running
// // isDown() will return TRUE
// popupize.open(
//		"<div class="popupize-frame">i like popup too</div>",
//		function() { alert("this popup will never be seen !"); }
//	);
//
// popupize do not provide any style
// it's up to you to design {yourcontent}

var popupize = (function() {
	"use strict";

    var isDown = function() {
    	return $(".popupize-frame").length;
    };

    var runCallback = function(callback) {
		if(typeof callback == 'function') {
			callback.call(this);
		}
    };

	var toggleOpen = function(data, callback) {
		if(!isDown()) {
			$("body").append(data);
			runCallback(callback);
		}
	};

	var toggleClose = function(callback) {
		$(".popupize-frame").remove();
		runCallback(callback);
	};

	var activate = function(action, data, callback) {
		switch(action) {
			case "open": toggleOpen(data, callback); break;
			case "close": toggleClose(callback); break;
			case "toggle":
				if (!isDown())
	 				toggleOpen(data, callback);
	 			else if (isDown())
	 				toggleClose(callback);
	 			break;
			}
	};

	return {
		open: function(data, callback) { activate("open", data, callback); },
 		close: function(callback) { activate("close", 0, callback); },
 		toggle: function(data, callback) { activate("toggle", data, callback); },
 		isDown: function() { return isDown(); }
	};

})(jQuery);

//////////////////////////////////////////////////////////////////////
// ALERTISE
//////////////////////////////////////////////////////////////////////
//
// simple alternative to alert() window
// REQUIRE POPEPIZE
//
// alertise provide style for informative, success,
// warning and error messages
//
// info({yourmsg})
// valid({yourmsg})
// warn({yourmsg})
// err({yourmsg})
//
// {yourmsg} must be a string
//
// example :
//
// alertize.err("you are trying to do something dangerous");
//
// considerations :
//
// because alertize is build on popupize, only one alert can be
// thrown at once. But alertize has a remote event which will be
// triggered on the previous alert's closure.
// 
// the first way to use :
// you merge all your messages in one string and you fire it at
// the end with an alertize event of your choice
//
// the second way to use :
// you fire an alertize event each time you want throw a message
// it will give something like :
// alertize.error("this input is not ok");
// alertize.error("this one too");
// alertize.error("this one is ugly");
// -> the second alertize event will be triggered only at the
// first one closure, and the third will be fired at the
// second one closure (see below about remote and closure)
// -> spaming the user with several alerts should be avoided
// so, consider the first way before using it
// 
// if you plan to build your own alert template, you must consider :
// - to add the class "popupize-frame" on the main container
//		because it use popupize events (see popupize doc)
// - to add a close() event
// - consider remote() event
//
// close() is used to close the alert, so it call popupize.close()
// but it also need to know if there is something in the remote list
// that havent been fired and if yes, to fire it again
// so it adds a callback too popupize.close() :
// 	popupize.close(function() {
//		alertize.remote();
//	});
//
// remote() will fire the first element of the remote list
// if it fail, the element will come back at the end of the list
// you dont need to use it because it will used by the close() event
// this function is public only for popepize access
//
// so, the minimal required elements are :
// <yourHTMLtag class="popepize-frame">
//		<yourHTMLtag onclick="alertize.close()"></yourHTMLtag>
// </yourHTMLtag>

var alertize = (function() {
	"use strict";

	var remote = [];

	var getPopupTemplate = function(title, mode, msg) {
		return "" +
			"<div style=\"z-index:9999999;\" class=\"popupize-frame position-absolute position-top position-left full-width full-height overflow-hidden inverted-transpbg\">" +
				"<a href=\"#\" onclick=\"alertize.close();\" class=\"cover-btn-shape\"></a>" +
				"<div class=\"display-table full-width full-height\">" +
					"<div class=\"display-table-cell full-width full-height vertical-align\">" +
						"<div class=\"container " + mode + " \">" +
							"<div class=\"fixedwidth-512 margin-auto text-center inverted-text padding-top padding-bottom\">" +
								"<h1 style=\"font-size:50px;\" class=\"margin-bottom padding-bottom\">" + title + "</h1>" +
								"<div class=\"container surrounded inverted-bdr margin-bottom\">" +
									"<p class=\"text-h2\">" + msg + "</p>" +
								"</div>" +
								"<p class=\"text-h4 padding-top\">(click to close)</p>" +
							"</div>" +
						"</div>" +
					"</div>" +
				"</div>" +
			"</div>" +
		"";
	};

	var closePopup = function() {
		popupize.close(function() {
			alertize.remote();
		});
	};

	var showPopup = function(data) {
		if(popupize.isDown())
			remote[remote.length] = data;
		else
			popupize.open(data, function() { $(".alertize-frame").show(); });
	};

	var checkRemoteData = function() {
		if(remote.length != 0) {
			var data = remote.shift();
			showPopup(data);
		}
	}

	return {
		info: function(msg) { showPopup(getPopupTemplate("Information", "popup-information", msg)); },
 		valid: function(msg) { showPopup(getPopupTemplate("Success", "popup-success", msg)); },
 		warn: function(msg) { showPopup(getPopupTemplate("Warning", "popup-warning", msg)); },
		err: function(msg) { showPopup(getPopupTemplate("Error", "popup-error", msg)); },
		remote: function() { checkRemoteData(); },
		close: function() { closePopup(); }
	};

})(jQuery);
