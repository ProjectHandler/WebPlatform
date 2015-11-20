(function ($) {
	var settings = {};
	var cache = {};
	
	$.fn.selectivityUserGroup = function (options) {
		settings = $.extend({
			groupElement: '#groupSelection',
			messageGroup: 'Type to search a group'
		}, options);
		
		$.fn.selectivityUser(options);
		
		$(settings.groupElement).selectivity({
			multiple : true,
			placeholder : settings.messageGroup
		})
		cache.groupSelection = $(settings.groupElement);
		cache.groupSelection.on('selectivity-selected' , selectivityGroupChanged);
	};

	$.fn.selectivityUser = function (options) {
		settings = $.extend(
			settings, {
				userElement: '#userSelection',
				messageUser: 'Type to search a user',
		});
		settings = $.extend(settings, options);
		
		cache.userSelection = $(settings.userElement);
		cache.userSelection.selectivity({
			multiple : true,
			placeholder : settings.messageUser
		});
	}
	
	function selectivityCheckGroupUsers(user) {
		var found = false;
		var idToAdd = null;
		var txtToAdd = null;
		var data = cache.groupSelection.selectivity('data');
		
		if (data != null && data !== undefined)
			$.each(data, function f(i, val) {
				if (user.id == val.id)
					found = true;
			});
		
		if (!found) {
			idToAdd = user.id;
			txtToAdd = user.firstName + ' ' + user.lastName;
			cache.userSelection.selectivity('add', {id: idToAdd, text: txtToAdd});
		}
	}
	
	function selectivityGroupChanged(item) {
		var url = CONTEXT_PATH + "/project/fetchGroupUsers";
		var groupId;
		var usersInGroup;
	
		groupId = item.id;
		$.ajax({
				type: "GET",
				url: url,
				data: {groupId: groupId}, 
	    		success: function(data) {
	    				if (data == "KO")
		    				alert("error: " + data);
	    				else {
		    				usersInGroup = jQuery.parseJSON(data);
		    				$.each(usersInGroup, function f2(i, val) {
		    					selectivityCheckGroupUsers(val);
		    				});
	    				}
	    		}
	    });
		cache.groupSelection.selectivity('remove', item);
	}
}(jQuery));