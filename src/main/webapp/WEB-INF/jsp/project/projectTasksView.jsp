<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>

		<script type="text/javascript">
		$(document).ready(function(){
			$('#taskSelection').selectivity({
			    multiple: false,
			    placeholder: 'Type to search a task'
			});

			$('#taskSelection').on("selectivity-selected", function(item){
				var res = item.id.split("/");
				openTaskViewBox(res[1], res[0]);
			});
		});
		
		function openkikoolol(page, id) {
			var $dialog = $('#' + id)
			  .html('<iframe style="border: 0px; " src="' + page + '" width="100%" height="100%"></iframe>')
			  .dialog({
			    title: '<spring:message code="projecthandler.taskBoxView.title"/>',
			    autoOpen: false,
			    dialogClass: 'dialog_fixed,ui-widget-header',
			    modal: true,
			    height: 700,
			    minWidth: 1000,
			    minHeight: 700,
			    draggable:false,
			    buttons: { "Ok": function () {$(this).dialog("close"); }
			  }
			  }); 
			  $dialog.dialog('open');
		}
		
		function openTaskViewBox(taskId, projectId) {
			openkikoolol(CONTEXT_PATH + '/project/viewProject/' + projectId + "/tasks/" + taskId, taskId);
		}
		
		function getFocusedTask() {
			
		}
		</script>
	</head>
	<body>

		<div id="tasksearch-toolBar" class="small-container">
			<spring:message code="projecthandler.projectTasksView.researchTask"/>: 
			<select class="display-inline-block" id="taskSelection">
				<c:forEach var='taskSelectable' items='${tasks}'>
					<c:if test="${taskSelectable.level == 2}">
						<option id="${taskSelectable.id}" value="${project.id}/${taskSelectable.id}">
							${taskSelectable.name} (<spring:message code="projecthandler.projectTasksView.state"/>: ${taskSelectable.status})
						</option>
					</c:if>
				</c:forEach>
			</select>
		</div>

		<div id="doingViewBox" class="small-container">
			<div id="taskDoneBox" class="display-inline-block" style="width:33%">
				<spring:message code="projecthandler.projectTasksView.tasksDone"/>
				<c:forEach var='task' items='${tasks}'>
					<div class="taskBox">
						<c:if test="${task.level == 2 && (task.status == 'STATUS_DONE' || task.status == 'STATUS_FAILED')}">
							<div class="small-container">
								<div class="display-inline-block">
									Name: ${task.name}
								</div>
								<div class="display-inline-block">
									Priorité: 
									<c:choose>
										<c:when test="${task.priority.name != null}">
											${task.priority.name} 
										</c:when>
										<c:otherwise>
											NONE 
										</c:otherwise>
									</c:choose>
								</div>
								<div class="display-inline-block">
									Statut: ${task.status}
								</div>
								<div class="display-inline-block">
									<div class="taskView" id="${task.id}"></div>
									<button class="display-block default-btn-shape theme1-primary-btn-style1" onClick="openTaskViewBox(${task.id}, ${project.id})">
										<spring:message code="projecthandler.projectTasksView.taskOpen"/>
									</button>
								</div>
								<div id="progressTask${task.id}" class="ui-progressbar ui-widget ui-widget-content ui-corner-all" role="progressbar" aria-valuemin="0" aria-valuemax="100" aria-valuenow="0">
									<div class="ui-progressbar-value ui-widget-header ui-corner-left" style="width: ${task.progress}%; background: rgb(0, 128, 255);" >
										<span style="color:black">
											${task.progress}%
										</span>
									</div>
								</div>
								<div>
									Description:
								</div>
								<div>
									 ${task.description}
								</div>
							</div>
						</c:if>
					</div>
				</c:forEach>
			</div>
			<div id="taskDoingBox" class="display-inline-block" style="width:33%">
				<spring:message code="projecthandler.projectTasksView.tasksDoing"/>
				<c:forEach var='task' items='${tasks}'>
					<div class="taskBox">
						<c:if test="${task.level == 2 && task.status == 'STATUS_ACTIVE'}">
							<div class="small-container">
								<div class="display-inline-block">
									Name: ${task.name}
								</div>
								<div class="display-inline-block">
									Priorité: 
									<c:choose>
										<c:when test="${task.priority != null}">
											${task.priority.name} 
										</c:when>
										<c:otherwise>
											NONE 
										</c:otherwise>
									</c:choose>
								</div>
								<div class="display-inline-block">
									Statut: ${task.status}
								</div>
								<div class="display-inline-block">
									<div class="taskView" id="${task.id}"></div>
									<button class="display-block default-btn-shape theme1-primary-btn-style1" onClick="openTaskViewBox(${task.id}, ${project.id})">
										<spring:message code="projecthandler.projectTasksView.taskOpen"/>
									</button>
								</div>
								<div id="progressTask${task.id}" class="ui-progressbar ui-widget ui-widget-content ui-corner-all" role="progressbar" aria-valuemin="0" aria-valuemax="100" aria-valuenow="0">
									<div class="ui-progressbar-value ui-widget-header ui-corner-left" style="width: ${task.progress}%; background: rgb(0, 128, 255);" >
										<span style="color:black">
											${task.progress}%
										</span>
									</div>
								</div>
								<div>
									Description:
								</div>
								<div>
									 ${task.description}
								</div>
							</div>
						</c:if>
					</div>
				</c:forEach>
			</div>
			<div id="taskTodoBox" class="display-inline-block" style="width:33%">
				<spring:message code="projecthandler.projectTasksView.tasksToDo"/>
				<c:forEach var='task' items='${tasks}'>
					<div class="taskBox">
						<c:if test="${task.level == 2 && (task.status == 'STATUS_UNDEFINED' || task.status == 'STATUS_SUSPENDED')}">
							<div class="small-container">
								<div class="display-inline-block">
									Name: ${task.name}
								</div>
								<div class="display-inline-block">
									Priorité: 
									<c:choose>
										<c:when test="${task.priority.value != null}">
											${task.priority.name} 
										</c:when>
										<c:otherwise>
											NONE 
										</c:otherwise>
									</c:choose>
								</div>
								<div class="display-inline-block">
									Statut: ${task.status}
								</div>
								<div class="display-inline-block">
									<div class="taskView" id="${task.id}"></div>
									<button class="display-block default-btn-shape theme1-primary-btn-style1" onClick="openTaskViewBox(${task.id}, ${project.id})">
										<spring:message code="projecthandler.projectTasksView.taskOpen"/>
									</button>
								</div>
								<div id="progressTask${task.id}" class="ui-progressbar ui-widget ui-widget-content ui-corner-all" role="progressbar" aria-valuemin="0" aria-valuemax="100" aria-valuenow="0">
									<div class="ui-progressbar-value ui-widget-header ui-corner-left" style="width: ${task.progress}%; background: rgb(0, 128, 255);" >
										<span style="color:black">
											${task.progress}%
										</span>
									</div>
								</div>
								<div>
									Description:
								</div>
								<div>
									 ${task.description}
								</div>
							</div>
						</c:if>
					</div>
				</c:forEach>
			</div>
		</div>
