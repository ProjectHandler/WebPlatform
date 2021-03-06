<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@taglib prefix="e" uri="https://www.owasp.org/index.php/OWASP_Java_Encoder_Project" %>
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
	var currTaskStatus = '${e:forJavaScript(task.status)}';
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
	        indeterminate: "taken"
	    });
		
		initTristateClickEventHandler();

		$('#addSubTask-div').hide();

		$("#progressTask${task.id}").progressbar({
			value: parseInt("${task.progress}", 10)
		});
	});

	function initTristateClickEventHandler() {
		$('.tristate').click(function() {
			var state = $(this).tristate('state');
			var tmp = $(this).attr("id").split("-");
			
			if (state === null) {
				$(this).tristate('state', true);
				$(this).tristate('value', "validated");
			}
			else if (state === true) {
				$(this).tristate('state', false);
				$(this).tristate('value', "empty");
			} else {
				$(this).tristate('state', null);
				$(this).tristate('value', "taken");
			}

			changeSubTaskState(tmp[1]);
		});
	}
	
	function setTristateClickEventHandler(id) {
		$('#tristate-' + id).click(function() {
			var state = $(this).tristate('state');
			var tmp = $(this).attr("id").split("-");
			
			if (state === null) {
				$(this).tristate('state', true);
				$(this).tristate('value', "validated");
			}
			else if (state === true) {
				$(this).tristate('state', false);
				$(this).tristate('value', "empty");
			} else {
				$(this).tristate('state', null);
				$(this).tristate('value', "taken");
			}

			changeSubTaskState(tmp[1]);
		});
	}
	
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
   	    			} else {
						var subTask = jQuery.parseJSON(data);
						var url = CONTEXT_PATH + "/project/viewProject/${task.project.id}/tasks/${task.id}";
	    				$("#subTaskList-BoxContainer").load(url + " #subTaskList-Box",
	    											function () {
								    					$('.tristate').tristate({
								    				        checked: "validated",
								    				        unchecked: "empty",
								    				        indeterminate: "taken"
								    				    });
														switchTextareaForSubTaskDescription();
														$('#addSubTaskBox-description').val('');
														updateTaskProgress();
														initTristateClickEventHandler();
	    				});
	    				
					}
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
	    			} else {
						if (percentage == 100) {
							$("#task-tag-list").find("." + currTaskStatus).hide();
							$("#task-tag-list").find(".STATUS_DONE").show();
							currTaskStatus = "STATUS_DONE";
						} else {
							$("#task-tag-list").find("." + currTaskStatus).hide();
							$("#task-tag-list").find(".STATUS_ACTIVE").show();
							currTaskStatus = "STATUS_ACTIVE";
						}
						$("#task-progress-div-${task.id}").css("width", parseInt(percentage.toFixed(0), 10) + "%");
						$("#task-progress-text-${task.id}").html(parseInt(percentage.toFixed(0), 10) + "%");
					}
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
	    			} else {
						var parsedData = jQuery.parseJSON(data);
						var url = CONTEXT_PATH + "/project/viewProject/${task.project.id}/tasks/${task.id}";
	    				$("#subTaskContainer-" + parsedData.id).load(url + " #subTaskContent-" + parsedData.id,
	    														function () {
	    															refreshSubTask(parsedData.id);
	    				});
					}
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
	    			} else {
						$("#subTaskContent-" + id).remove();
						if (!$("#subTaskList-BoxContainer").find(".tristate"))
							updateTaskProgress();
					}
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

	function refreshSubTask(id) {
		$('#tristate-' + id).tristate({
	        checked: "validated",
	        unchecked: "empty",
	        indeterminate: "taken"
	    });
		setTristateClickEventHandler(id);
    	updateTaskProgress();
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
		$("#boxEditingMode-" + id).addClass("display-none");
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
			$("#boxEditingMode-" + id).removeClass("display-none");
		} else {
			$(itemName).attr("disabled", "disabled");
			$("#boxEditingMode-" + id).addClass("display-none");
		}
	}
	</script>
</head>
<body>
	<div class="container display-table full-width">
		
		<div id="task-tag-list" class="display-table-cell vertical-align padding-right">
			<div class="display-none STATUS_DONE" title="T�che termin�e"><div class="display-table" style="width:30px;height:30px;"><div class="display-table-cell vertical-align full-width full-height util2-primary-bg inverted-text text-center circle text-h4"><span class="icon-checkmark"></span></div></div></div>
			<div class="display-none STATUS_ACTIVE" title="T�che en cours"><div class="display-table" style="width:30px;height:30px;"><div class="display-table-cell vertical-align full-width full-height util3-primary-bg inverted-text text-center circle text-h4"><span class="icon-loop"></span></div></div></div>
			<div class="display-none STATUS_SUSPENDED" title="T�che suspendue"><div class="display-table" style="width:30px;height:30px;"><div class="display-table-cell vertical-align full-width full-height util5-primary-bg inverted-text text-center circle text-h4"><span class="icon-history"></span></div></div></div>
			<div class="display-none STATUS_FAILED" title="T�che abandonn�e"><div class="display-table" style="width:30px;height:30px;"><div class="display-table-cell vertical-align full-width full-height util6-primary-bg inverted-text text-center circle text-h4"><span class="icon-cross"></span></div></div></div>
			<div class="display-none STATUS_UNDEFINED" title="T�che ind�termin�e"><div class="display-table" style="width:30px;height:30px;"><div class="display-table-cell vertical-align full-width full-height util1-primary-bg inverted-text text-center circle text-h4">?</div></div></div>
			<script>
				$("#task-tag-list").find("." + '${task.status}').show();
			</script>
		</div>
		
		<h1 class="text-h1 theme3-darken1-text display-table-cell vertical-align padding-right full-width">${e:forHtml(task.name)}</h1>

		<div class="display-table-cell vertical-align small-padding-right">
			<spring:message code="projecthandler.taskBoxView.priority"/>
		</div>

		<div class="taskDetails display-table-cell vertical-align padding-right">
			<div class="priority">
				<select id="prioritySelect">
					<c:forEach var="priority" items="${priorities}">
						<c:choose>
						<c:when test="${task.priority.name != null}">
							<c:choose>
								<c:when test="${task.priority.name eq priority.name}">
									<option selected="selected" id="${task.id}/${priority.id}" value="${task.id}/${priority.id}">
										${e:forHtml(priority.name)}
									</option>
								</c:when>
								<c:otherwise>
									<option id="${task.id}/${priority.id}" value="${task.id}/${priority.id}">
										${e:forHtml(priority.name)}
									</option>
								</c:otherwise>
							</c:choose>
						</c:when>
						<c:otherwise>
							<option id="${task.id}/${priority.id}" value="${task.id}/${priority.id}">
								${e:forHtml(priority.name)}
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
				<div class="display-table-cell vertical-align theme3-darken1-text small"><div style="width:84px;" class="text-left">Completed</div></div>	
				<div class="display-table-cell vertical-align full-width hard-surrounded theme3-lighten1-bdr rounded theme3-lighten1-bg" role="progressbar" aria-valuemin="0" aria-valuemax="100" aria-valuenow="0">
					<div id="task-progress-div-${task.id}" class="surrounded rounded theme3-darken1-bdr theme3-darken1-bg" style="width: ${task.progress}%;" ></div>
				</div>
				<div class="display-table-cell vertical-align theme3-darken1-text small"><div id="task-progress-text-${task.id}" class="text-right" style="width:45px;">${e:forHtml(task.progress)}%</div></div>
			</div>
		</div>	
		
		<div class="container radius theme3-lighten1-bg">
			${e:forHtml(task.description)}
		</div>

		<div class="small-margin-top display-table full-width">
			<div class="text-right">
				<div id="projectInfoBox" class="display-inline-block">
					<div id="usersAccessBox" class="clearfix">
						<c:forEach var='userInList' items='${task.users}'>
							<div class="float-left small-margin-right position-relative">
								<div class="circle img-as-background" style="width:32px;height:32px;background-image:url(${pageContext.request.contextPath}/resources/img/no-img.png);" title="${e:forHtml(userInList.firstName)} ${e:forHtml(userInList.lastName)}">
									<div class="full-width full-height circle img-as-background" style="background-image:url(<%=request.getContextPath() %>/downloadAvatar/${userInList.id});"></div>
								</div>
							</div>
						</c:forEach>
					</div>
				</div>										
			</div>
		</div>	
		
	</div>
	
	<div class="padding-left padding-right">
		<hr class="theme3-lighten1-bg">
	</div>	
	
	<div class="addSubTask-Box container margin-left small-margin-right small-margin-bottom small-margin-top">

		<div class="display-table-cell vertical-align small-padding-right text-h1 theme3-darken1-text">
			<span class="icon-clipboard"></span>
		</div>	

		<div class="display-table-cell vertical-align padding-right">
			<h2 class="text-h1 theme3-darken1-text fixedwidth-320"><spring:message code="projecthandler.taskBoxView.subTaskList"/></h2>
		</div>

		<div class="display-table-cell vertical-align full-width text-right">
			<button class="default-btn-shape theme3-darken1-text theme1-lighten2-btn-style6 radius" id="addSubTask" onClick="switchTextareaForSubTaskDescription();">
				<span class="icon-plus small-margin-right"></span><spring:message code="projecthandler.taskBoxView.addSubTask"/>
			</button>
		</div>

	</div>
	
	<div id="addSubTask-div" class="theme3-lighten1-bg container display-none" style="margin-bottom:40px;">
		<div style="margin-left:70px;">
			<div class="display-table-cell vertical-align padding-right">
				<textarea id="addSubTaskBox-description" maxlength="200" rows="2" class="textfield surrounded theme3-darken3-bdr theme3-primary-bg radius"></textarea>
			</div>
			<div class="display-table-cell vertical-align">
				<button class="default-btn-shape util3-lighten1-btn-style6" onClick="validateAddSubTask();">
					<span class="icon-checkmark small-margin-right"></span><spring:message code="projecthandler.taskBoxMessages.validateComment"/>
				</button>
				/
				<button class="default-btn-shape util5-lighten1-btn-style6" onClick="switchTextareaForSubTaskDescription();">
					<span class="icon-cross small-margin-right"></span><spring:message code="projecthandler.taskBoxMessages.cancelComment"/>
				</button>
			</div>
		</div>
	</div>
	
	<div id="subTaskList-BoxContainer">
		<div class="subTaskList-Box container margin-left no-padding-top" id="subTaskList-Box">
			<c:forEach var='subTask' items='${subTasks}'>
				<div id="subTaskContainer-${subTask.id}">
					<div id="subTaskContent-${subTask.id}" class="subTaskContent margin-left margin-bottom">
					
						<div class="display-table-cell vertical-align small-padding-right">
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
						
						<div class="display-table-cell vertical-align padding-right">
							<textarea class="textfield surrounded radius theme3-primary-bdr" id="subTaskDescription-${subTask.id}" disabled="disabled" maxlength="200">${e:forHtml(subTask.description)}</textarea>
						</div>
						
						<div class="display-table-cell vertical-align position-relative">
							<c:if test="${subTask.validated == true || subTask.taken == true}">
							<div class="display-inline-block vertical-align margin-right" style="width:30px;height:30px;">
								<div class="full-width full-height circle img-as-background" style="background-image:url(${pageContext.request.contextPath}/resources/img/no-img.png);" title="${subTask.lastUserActivity.firstName} ${subTask.lastUserActivity.lastName}">	
									<div class="full-width full-height circle img-as-background" style="background-image:url(<%=request.getContextPath() %>/downloadAvatar/${subTask.lastUserActivity.id});" title="${subTask.lastUserActivity.firstName} ${subTask.lastUserActivity.lastName}"></div>
								</div>
							</div>
							</c:if>
							<button id="editSubTaskButton-${subTask.id}" class="text-h3 reduced-btn-shape theme3-lighten1-text util2-primary-btn-style6 small-margin-right" onClick="startEditingSubTask(${subTask.id});" title="<spring:message code="projecthandler.taskBoxView.editSubTask"/>">
								<span class="icon-pencil2"></span>
							</button>
							<button class="text-h3 reduced-btn-shape theme3-lighten1-text util6-primary-btn-style6" onClick="deleteSubTask(${subTask.id});" title="<spring:message code="projecthandler.taskBoxView.deleteSubTask"/>">
								<span class="icon-cross"></span>
							</button>
							
							<div  id="boxEditingMode-${subTask.id}" class="display-none position-absolute position-top position-left fixedwidth-320 full-height inverted-bg zindex-10">
								<div class="display-table full-width full-height">
									<div class="display-table-cell full-width full-height vertical-align">
										<button id="doneEditingButton-${subTask.id}" class="default-btn-shape util3-lighten1-btn-style6" onClick="doneEditingSubTask(${subTask.id});">
											<span class="icon-checkmark small-margin-right"></span><spring:message code="projecthandler.taskBoxView.doneEditingSubTask"/>
										</button>
										/
										<button id="cancelEditingButton-${subTask.id}" class="default-btn-shape util6-lighten1-btn-style6" onmousedown="cancelEditingSubTask(${subTask.id});">
											<span class="icon-cross small-margin-right"></span><spring:message code="projecthandler.taskBoxView.cancelEditSubTask"/>
										</button>
									</div>
								</div>
							</div>					
							
						</div>
		
					</div>
				</div>
			
			</c:forEach>
		</div>
	</div>	
		
	<div class="padding-left padding-right">
		<hr class="theme3-lighten1-bg">
	</div>	
	
	<jsp:include page="./taskBoxMessages.jsp" />
	<jsp:include page="./taskBoxActivity.jsp" />

	<div class="padding-left padding-right">
		<hr class="theme3-lighten1-bg">
	</div>	

	<jsp:include page="./taskDocumentView.jsp" />
</body>
</html>