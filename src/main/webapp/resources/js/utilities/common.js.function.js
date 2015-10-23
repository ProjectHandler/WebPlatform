/** global ajax handling **/
$(function() {	
	jQuery.ajaxSetup({
		error: function(xhr, textStatus, error) {
			if (xhr.status == 401 || xhr.status == 405) {
				window.location = CONTEXT_PATH + "/login";
			} else if (xhr.status == 403) {
				window.location = CONTEXT_PATH + "/accessDenied";
			} else {
				console.log("Ajax error, status: " + xhr.status + " JSON.error: " + xhr.responseJSON.error);
				alert("error during the ajax call (status: " + xhr.status + ").");
			}
		}
	});
});