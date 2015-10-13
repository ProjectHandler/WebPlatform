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
	$(document).ready(function() {
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

		$('#addSubTask-div').hide();

		$("#progressTask${task.id}").progressbar({
			value: parseInt("${task.progress}", 10)
		});
	});

	function createNewTicket() {
		var url = CONTEXT_PATH + "/ticket/new/${task.project.id}?title=[${task.name}]";
		window.open(url);
	}
	
	function validateAddSubTask() {
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
	}
	
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
		var desc = $("#subTaskDescription-" + id).val();
		if (desc != "") {
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
		// TODO else error message => description can't be empty
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

	function reloadPage() {
		location.reload();
	}
	
	function switchTextareaForSubTaskDescription() {
		if (newSubTaskDescriptionShown)
			$("#addSubTask-div").hide();
		else
			$("#addSubTask-div").show();
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
						"<textarea id='subTaskDescription-" + id + "' disabled='disabled' maxlength='200'>" + data.description + " </textarea></div>";
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
		if ($(itemName).val() != savedSubTaskDescription && $(itemName).val() != "") {
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
		savedSubTaskDescription = null;
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
	<div class="container display-table full-width">
		
		<div id="task-tag-list" class="display-table-cell vertical-align padding-right">
			<div class="display-none STATUS_DONE" title="Tâche terminée"><div class="display-table" style="width:30px;height:30px;"><div class="display-table-cell vertical-align full-width full-height util2-primary-bg inverted-text text-center circle text-h4"><span class="icon-checkmark"></span></div></div></div>
			<div class="display-none STATUS_ACTIVE" title="Tâche en cours"><div class="display-table" style="width:30px;height:30px;"><div class="display-table-cell vertical-align full-width full-height util3-primary-bg inverted-text text-center circle text-h4"><span class="icon-loop"></span></div></div></div>
			<div class="display-none STATUS_SUSPENDED" title="Tâche suspendue"><div class="display-table" style="width:30px;height:30px;"><div class="display-table-cell vertical-align full-width full-height util5-primary-bg inverted-text text-center circle text-h4"><span class="icon-history"></span></div></div></div>
			<div class="display-none STATUS_FAILED" title="Tâche abandonnée"><div class="display-table" style="width:30px;height:30px;"><div class="display-table-cell vertical-align full-width full-height util6-primary-bg inverted-text text-center circle text-h4"><span class="icon-cross"></span></div></div></div>
			<div class="display-none STATUS_UNDEFINED" title="Tâche indéterminée"><div class="display-table" style="width:30px;height:30px;"><div class="display-table-cell vertical-align full-width full-height util1-primary-bg inverted-text text-center circle text-h4">?</div></div></div>
			<script>
				$("#task-tag-list").find("." + '${task.status}').show();
			</script>
		</div>	
		
		<h1 class="text-h1 theme3-darken1-text display-table-cell vertical-align padding-right full-width">${task.name}</h1>
		
		
		<div class="display-table-cell vertical-align small-padding-right">
			<spring:message code="projecthandler.taskBoxView.priority"/>
		</div>
		
		<div class="taskDetails display-table-cell vertical-align padding-right">
			<div class="priority">
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
		
		<div class="display-table-cell vertical-align">
			<button id="refreshTaskBoxView-Button" class="default-btn-shape text-h1 theme3-primary-text theme1-lighten2-btn-style6" onClick="reloadPage();" title="<spring:message code="projecthandler.taskBoxView.refreshView"/>">
				<span class="icon-loop2"></span>
			</button>
		</div>
		
	</div>
	
	<button id="newTicketForTask-Button" class="default-btn-shape theme2-primary-btn-style1 display-none" onClick="createNewTicket();">
		<spring:message code="projecthandler.taskBoxView.sendTicketForTask"/>
	</button>
	
	<div class="padding-left padding-right">
		<hr class="theme3-lighten1-bg">
	</div>
	
	<div class="container">
	
		<div class="small-container margin-bottom">									
			<div class="">
				<div class="display-table-cell vertical-align theme3-darken1-text small"><div class="fixedwidth-64 text-left">Deadline</div></div>	
				<div class="display-table-cell vertical-align full-width hard-surrounded theme3-lighten1-bdr rounded theme3-lighten1-bg" role="progressbar" aria-valuemin="0" aria-valuemax="100" aria-valuenow="0">
					<div class="surrounded rounded theme3-darken1-bdr theme3-darken1-bg" style="width: ${task.progress}%;" ></div>
				</div>
				<div class="display-table-cell vertical-align theme3-darken1-text small"><div class="text-right" style="width:45px;">${task.progress}%</div></div>	
			</div>
		</div>	
		
		<div class="container radius theme3-lighten1-bg">
			${task.description}
		</div>

		<div class="small-margin-top display-table full-width">
			<div class="text-right">
				<div id="projectInfoBox" class="display-inline-block">
					<div id="usersAccessBox" class="clearfix">
						<c:forEach var='userInList' items='${task.users}'>
							<div class="float-left small-margin-right position-relative">
								<div class="circle img-as-background" style="width:32px;height:32px;background-image:url(${pageContext.request.contextPath}/resources/img/no-img.png);" title="${userInList.firstName} ${userInList.lastName}">	
									<div class="full-width full-height circle img-as-background" style="background-image:url(<%=request.getContextPath() %>/downloadAvatar/${userInList.id});"></div>
								</div>
							</div>
						</c:forEach>
					</div>
				</div>										
			</div>
		</div>	
		
	</div>
	
	<div class="addSubTask-Box">
		<div>
			<button class="default-btn-shape theme2-primary-btn-style1" id="addSubTask" onClick="switchTextareaForSubTaskDescription();">
				<spring:message code="projecthandler.taskBoxView.addSubTask"/>
			</button>
		</div>
		<div id="addSubTask-div">
			<textarea id="addSubTaskBox-description" maxlength="200" rows="10" class="fixedmaxwidth-256 textfield surrounded theme3-primary-bdr"></textarea>
			<button class="default-btn-shape theme2-primary-btn-style1" onClick="validateAddSubTask();">
				<spring:message code="projecthandler.taskBoxMessages.validateComment"/>
			</button>
			<button class="default-btn-shape theme2-primary-btn-style1" onClick="switchTextareaForSubTaskDescription();">
				<spring:message code="projecthandler.taskBoxMessages.cancelComment"/>
			</button>
		</div>
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
				<textarea id="subTaskDescription-${subTask.id}" disabled="disabled" maxlength="200">${subTask.description}</textarea>
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
	---------------------------------------------
	<jsp:include page="./taskBoxMessages.jsp" />
	---------------------------------------------
	<jsp:include page="./taskBoxActivity.jsp" />
</body>
</html>