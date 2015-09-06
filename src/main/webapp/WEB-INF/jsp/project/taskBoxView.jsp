<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<html xmlns:th="http://www.thymeleaf.org">
<head>
	<jsp:include page="../template/head.jsp" />
	<spring:url value="/resources/js/jquery.tristate.js" var="tristate"/>
	<script type="text/javascript" src="${tristate}"></script>
	<title><spring:message code="projecthandler.taskBoxView.title"/></title>
	<script>
	var CONTEXT_PATH = "<%=request.getContextPath() %>";
	var newSubTaskDescriptionShown = false;
	var savedSubTaskDescription = null;
	$(document).ready(function(){
		$( document ).tooltip();

		$('#prioritySelect').selectivity({
		    multiple: false,
		    placeholder: 'Change task priority'
		});

		$('#prioritySelect').on("change", changePriority);

		$('.tristate').tristate({
	        checked: "validated",
	        unchecked: "empty",
	        indeterminate: "taken",
	        change: function(state, value) {
	        	var tmp = $(this).attr("id").split("-");
	        	changeSubTaskState(tmp[1]);
	        }
	    });

		$('#addSubTaskBox-description').hide();
		
		$('#addSubTaskBox-description').focusout(function() {
			var desc = $('#addSubTaskBox-description').val();
			if (desc != "") {
				$.ajax({type: "GET",
		  			url: CONTEXT_PATH + "/subTask/save",
		  			data: { description: desc,
		  					userId: "${user.id}",
		  					taskId: "${task.id}"}, 
		    				success: function(data) {
		    					if (data.indexOf("KO:") != -1) {
		    	    				var msg = data.replace("KO:", "");
		    	    				alert(msg);
		    	    			}
								else {
									var subTask = jQuery.parseJSON(data);
				    				createSubTask(subTask.id, subTask);
									switchTextareaForSubTaskDescription();
									$('#addSubTaskBox-description').val('');
									updateTaskProgress();
								}
				    		},
			    		error: function(data) {
			    			alert("error: " + data);
			    		}
		    	});
			}
			else
				switchTextareaForSubTaskDescription();
		});
		
		$("#progressTask${task.id}").progressbar({
			value: parseInt("${task.progress}", 10)
		});
	});

	function changePriority(item) {
		var res = item.value.split("/");
	  	$.ajax({type: "GET",
	  			url: CONTEXT_PATH + "/task/changePriority",
	  			data: { taskId: res[0],
	  					priorityId: res[1]
	  			},
	    		success: function(data) {
	    			if (data.indexOf("KO:") != -1) {
	    				var msg = data.replace("KO:", "");
	    				alert(msg);
	    			}
	    		},
	    		error: function(data) {
	    			alert("error: " + data);
	    		}
	    });
	}

	// TODO : maybe only compute server side ??
	function updateTaskProgress() {
		var percentage = 0;
		var count = 0;
		var subTaskNumber = 0;
		$(".tristate").each(function(key, value) {
			console.log("KEY=" + key + "\nVALUE=" + value.id);
			subTaskNumber++;
			if ($(value).val() == "validated")
				count++;
		});
		percentage = (count / subTaskNumber) * 100;

		$("#progressTask${task.id}").progressbar("option", "value", parseInt(percentage.toFixed(0), 10));
		$("#progressTask-Span").text(percentage.toFixed(0) + "%");

		$.ajax({type: "GET",
				url: CONTEXT_PATH + "/task/updateProgress",
				data: {
				   	taskId: "${task.id}",
				    progress: parseInt(percentage.toFixed(0), 10)
				},
			success: function(data) {
				if (data.indexOf("KO:") != -1) {
    				var msg = data.replace("KO:", "");
    				alert(msg);
    			}
			},
			error: function(data) {
				alert("error: " + data);
			}
		});
	}

	function changeSubTaskState(id) {
    	$.ajax({type: "GET",
  				url: CONTEXT_PATH + "/subTask/update/state",
  				data: {
  					userId: "${user.id}",
  				   	subTaskId: id,
  				    state: $("#tristate-" + id).val()
  				},
    			success: function(data) {
    				if (data.indexOf("KO:") != -1) {
	    				var msg = data.replace("KO:", "");
	    				alert(msg);
	    			}
					else {
				    	console.log($("#tristate-" + id).val());
				    	if ($("#tristate-" + id).val() == "validated")
				    		updateTaskProgress();
	    				refreshSubTask(id, jQuery.parseJSON(data));
					}
    			},
    			error: function(data) {
    				alert("error: " + data);
    			}
    	});
    }

	function changeSubTaskDescription(id) {
		$.ajax({type: "GET",
				url: CONTEXT_PATH + "/subTask/update/description",
				data: {
				    description: $("#subTaskDescription-" + id).val(),
					subTaskId: id
				},
				success: function(data) {
					if (data.indexOf("KO:") != -1) {
	    				var msg = data.replace("KO:", "");
	    				alert(msg);
	    			}
				},
				error: function(data) {
					alert("error: " + data);
				}
		});
	}

	function deleteSubTask(id) {
		if (confirm("<spring:message code='projecthandler.taskBoxView.confirmDeleteSubTask'/>")) {
			$.ajax({type: "GET",
				url: CONTEXT_PATH + "/subTask/delete",
				data: {
					userId: "${user.id}",
					subTaskId: id
				},
				success: function(data) {
					console.log(data);
					if (data.indexOf("KO:") != -1) {
	    				var msg = data.replace("KO:", "");
	    				alert(msg);
	    			}
					else {
						$("#subTaskContent-" + id).remove();
						updateTaskProgress();
					}
				},
				error: function(data) {
					alert("error: " + data);
				}
			});
		}
	}

	function switchTextareaForSubTaskDescription() {
		if (newSubTaskDescriptionShown)
			$("#addSubTaskBox-description").hide();
		else
			$("#addSubTaskBox-description").show();
		newSubTaskDescriptionShown = !newSubTaskDescriptionShown;
	}

	// Id is the subtask id and data is the content of the subtask
	// TODO : make a separate .jsp file and use jquery.load() instead of doing this uggly thing!
	function generateSubTaskDiv(id, data) {
		// Main div
		var htmlString = "<div id='subTaskContent-" + id + "' class='subTaskContent display-inline-block'>";
		// tristate checkbox div
		htmlString += "<div class='display-inline-block'><input class='tristate' id='tristate-" + id + "' type='checkbox' value=";
		if (data.validated == true) {
			htmlString += "'validated' checked='checked'></div>";
		} else if (data.taken == true) {
			htmlString += "'taken' indeterminate='intermediate'></div>";
		} else {
			htmlString += "'empty'></div>";
		}
		// description textarea div
		htmlString += 	"<div class='display-inline-block'>" +
						"<textarea id='subTaskDescription-" + id + "' disabled='disabled'>" + data.description + "</textarea></div>";
		// Done editing button div
		htmlString +=	"<button id='doneEditingButton-" + id +"' class='display-none default-btn-shape theme2-primary-btn-style1' onClick='doneEditingSubTask(" + id + ");'>" +
						"<spring:message code='projecthandler.taskBoxView.doneEditingSubTask'/></button>";
		// Cancel editing button div
		htmlString +=	"<button id='cancelEditingButton-" + id + "' class='display-none default-btn-shape theme2-primary-btn-style1' onmousedown='cancelEditingSubTask(" + id + ");'>" +
						"<spring:message code='projecthandler.taskBoxView.cancelEditSubTask'/></button>";
		// User image div
		htmlString += 	"<div class='display-inline-block vertical-align small-padding-right'>" +
						"<div class='fixedwidth-64 fixedheight-64 circle img-as-background' style='background-image:url(" +
								CONTEXT_PATH + "/resources/img/no-img.png);' title='" + data.lastUserActivity.firstName + " " +
								data.lastUserActivity.lastName + "'>" +
						"<div class='full-width full-height circle img-as-background' style='background-image:url(" +
								CONTEXT_PATH + "/downloadAvatar/" + data.lastUserActivity.id + ");' title='" +
								data.lastUserActivity.firstName + " " + data.lastUserActivity.lastName + "'>" +
						"</div></div></div>";
		// Edit button div
		htmlString +=	"<button id='editSubTaskButton-" + id + "' class='default-btn-shape theme2-primary-btn-style1' onClick='startEditingSubTask(" + id + ");'>" +
						"<spring:message code='projecthandler.taskBoxView.editSubTask'/></button>";
		// Delete button div
		htmlString +=	"<button class='default-btn-shape theme2-primary-btn-style1' onClick='deleteSubTask(" + id + ");'>" +
						"<spring:message code='projecthandler.taskBoxView.deleteSubTask'/></button>";

		// Closing main div
		htmlString += "</div>";

		return htmlString;
	}
	
	function refreshSubTask(id, data) {
		var htmlString = generateSubTaskDiv(id, data);
		$('#subTaskContent-' + id).html(htmlString);

		$('#tristate-' + id).tristate({
	        checked: "validated",
	        unchecked: "empty",
	        indeterminate: "taken",
	        change: function(state, value) {
	        	var tmp = $(this).attr("id").split("-");
	        	changeSubTaskState(tmp[1]);
	        }
	    });
	}

	// Add subTask to subTaskList-Box once successfully added in db.
	// Called when focus is lost from addSubTask textarea. (add a validation button better?)
	function createSubTask(id, data) {
		var htmlString = generateSubTaskDiv(id, data);
		$(htmlString).appendTo('#subTaskList-Box');

		$('#tristate-' + id).tristate({
	        checked: "validated",
	        unchecked: "empty",
	        indeterminate: "taken",
	        change: function(state, value) {
	        	var tmp = $(this).attr("id").split("-");
	        	changeSubTaskState(tmp[1]);
	        }
	    });
	}

	// Called when a user clicks edit button on a subTask.
	function startEditingSubTask(id) {
		var itemName = "#subTaskDescription-" + id;
		savedSubTaskDescription = $(itemName).val();
		switchSubTaskEditing(id, itemName);

		// if focus is lost => changes are saved
		// if canceled is clicked => mousedown event triggers before and focusout event won't be triggered.
		// because it has been unbinded (".off()") in cancelEditingSubTask
		// Note: timeout is required in order to let the browser set the next focused item.
		$("#subTaskContent-" + id).focusout(function(event){
			var $elem = $(this);
		    setTimeout(function () {
		        if (!$elem.find(':focus').length) {
		            doneEditingSubTask(id);
		        }
		    }, 0);
		});
	}

	// Called when a user clicks done button on a subTask or focus on the parent div is lost.
	function doneEditingSubTask(id) {
		var itemName = "#subTaskDescription-" + id;
		$(itemName).attr("disabled", "disabled");
		$("#doneEditingButton-" + id).addClass("display-none");
		$("#cancelEditingButton-" + id).addClass("display-none");
		if ($(itemName).val() != savedSubTaskDescription) {
			changeSubTaskDescription(id);
		}
		savedSubTaskDescription = null;
		$("#subTaskContent-" + id).off('focusout');
	}

	// Called when a user clicks cancel button on a subTask.
	// Note: called onmousedown event so it s triggerd before focusout of the parent div.
	function cancelEditingSubTask(id) {
		var itemName = "#subTaskDescription-" + id;
		$("#subTaskContent-" + id).off('focusout');
		$(itemName).val(savedSubTaskDescription);
		switchSubTaskEditing(id, itemName);
	}

	function switchSubTaskEditing(id, itemName) {
		var disabled = $(itemName).attr("disabled");
		if (disabled == "disabled") {
			$(itemName).removeAttr("disabled");
			$("#doneEditingButton-" + id).removeClass("display-none");
			$("#cancelEditingButton-" + id).removeClass("display-none");
		}
		else {
			$(itemName).attr("disabled", "disabled");
			$("#doneEditingButton-" + id).addClass("display-none");
			$("#cancelEditingButton-" + id).addClass("display-none");
		}
	}
	</script>
</head>
<body>
	<div class="taskDescription small-container">
		<div class="display-inline-block">
			Name: ${task.name}
		</div>
		<div class="display-inline-block">
			Statut: ${task.status}
		</div>
		<div id="progressTask${task.id}">
			<span id="progressTask-Span" style="color:black">
				${task.progress}%
			</span>
		</div>
		<div>
			Description:
		</div>
		<div>
			 ${task.description}
		</div>
	</div>
	<div class="taskDetails">
		<div class="members display-inline-block">
			<spring:message code="projecthandler.taskBoxView.taskMembers"/>: 
			<c:forEach var="userInList" items="${task.users}">
				<div class="display-table-cell vertical-align small-padding-right">
					<div class="fixedwidth-64 fixedheight-64 circle img-as-background" style="background-image:url(${pageContext.request.contextPath}/resources/img/no-img.png);" title="${userInList.firstName} ${userInList.lastName}">	
						<div class="full-width full-height circle img-as-background" style="background-image:url(<%=request.getContextPath() %>/downloadAvatar/${userInList.id});" title="${userInList.firstName} ${userInList.lastName}"></div>
					</div>
				</div>
			</c:forEach>
		</div>
		<div class="priority display-inline-block">
			<spring:message code="projecthandler.taskBoxView.priority"/>:
			<select id="prioritySelect">
				<c:forEach var="priority" items="${priorities}">
					<c:choose>
					<c:when test="${task.priority.name != null}">
						<option selected="selected" value="${task.id}/${priority.id}">
							${priority.name}
						</option>
					</c:when>
					<c:otherwise>
						<option id="${task.id}/${priority.id}" value="${task.id}/${priority.id}">
							${priority.name}
						</option>
					</c:otherwise>
					</c:choose>
				</c:forEach>
			</select>
		</div>
	</div>
	<div class="addSubTask-Box">
		<div>
			<button class="default-btn-shape theme2-primary-btn-style1" id="addSubTask" onClick="switchTextareaForSubTaskDescription();">
				<spring:message code="projecthandler.taskBoxView.addSubTask"/>
			</button>
		</div>
		<textarea id="addSubTaskBox-description" maxlength="200" rows="10" class="fixedmaxwidth-256 textfield surrounded theme3-primary-bdr"></textarea>
	</div>
	<div class="subTaskList-Box" id="subTaskList-Box">
		<div>
			<spring:message code="projecthandler.taskBoxView.subTaskList"/>
		</div>
		<c:forEach var='subTask' items='${subTasks}'>
		<div id="subTaskContent-${subTask.id}" class="subTaskContent display-inline-block">
			<div class="display-inline-block">
				<c:if test="${subTask.validated == true}">
					<input class="tristate" id="tristate-${subTask.id}" type="checkbox" value="validated" checked="checked">
				</c:if>
				<c:if test="${subTask.taken == true}">
					<input class="tristate" id="tristate-${subTask.id}" type="checkbox" value="taken" indeterminate="intermediate">
				</c:if>
				<c:if test="${subTask.validated == false && subTask.taken == false}">
					<input class="tristate" id="tristate-${subTask.id}" type="checkbox" value="empty">
				</c:if>
			</div>
			<div class="display-inline-block">
				<textarea id="subTaskDescription-${subTask.id}" disabled="disabled">${subTask.description}</textarea>
			</div>
			<button id="doneEditingButton-${subTask.id}" class="display-none default-btn-shape theme2-primary-btn-style1" onClick="doneEditingSubTask(${subTask.id});">
				<spring:message code="projecthandler.taskBoxView.doneEditingSubTask"/>
			</button>
			<button id="cancelEditingButton-${subTask.id}" class="display-none default-btn-shape theme2-primary-btn-style1" onmousedown="cancelEditingSubTask(${subTask.id});">
				<spring:message code="projecthandler.taskBoxView.cancelEditSubTask"/>
			</button>
			<div class="display-inline-block vertical-align small-padding-right">
				<div class="fixedwidth-64 fixedheight-64 circle img-as-background" style="background-image:url(${pageContext.request.contextPath}/resources/img/no-img.png);" title="${subTask.lastUserActivity.firstName} ${subTask.lastUserActivity.lastName}">	
					<div class="full-width full-height circle img-as-background" style="background-image:url(<%=request.getContextPath() %>/downloadAvatar/${subTask.lastUserActivity.id});" title="${subTask.lastUserActivity.firstName} ${subTask.lastUserActivity.lastName}"></div>
				</div>
			</div>
			<button id="editSubTaskButton-${subTask.id}" class="default-btn-shape theme2-primary-btn-style1" onClick="startEditingSubTask(${subTask.id});">
				<spring:message code="projecthandler.taskBoxView.editSubTask"/>
			</button>
			<button class="default-btn-shape theme2-primary-btn-style1" onClick="deleteSubTask(${subTask.id});">
				<spring:message code="projecthandler.taskBoxView.deleteSubTask"/>
			</button>
		</div>
		</c:forEach>
	</div>
	<div class="taskActivityBox">
		<div class="openNewTicket">
			<!-- TODO : open a new ticket with task information pre registred -->
		</div>
	</div>
</body>
</html>