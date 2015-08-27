<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<html xmlns:th="http://www.thymeleaf.org">
	<head>
		<jsp:include page="../template/head.jsp" />
		<title><spring:message code="projechandler.projectView.title"/></title>
		<script type="text/javascript">
		$(document).ready(function(){
			$('#taskSelection').selectivity({
			    multiple: false,
			    placeholder: 'Type to search a task'
			});

			$('#taskSelection').on("selectivity-selected", openTaskDetail);
		});
		
		function openTaskDetail() {
			// TODO : open modal with task detail
		}
		</script>
	</head>
	<body>
		<div id="header">
			<jsp:include page="../template/header.jsp" />
		</div>
		<div id="toolBar" class="small-container">
			<spring:message code="projecthandler.projectTasksView.researchTask"/>: 
			<select class="display-inline-block" id="taskSelection">
				<c:forEach var='taskSelectable' items='${tasks}'>
					<c:if test="${taskSelectable.level == 2}">
						<option id="${taskSelectable.id}" value="${taskSelectable.id}">
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
						<c:if test="${task.level == 2 && task.status == 'STATUS_DONE'}">
							<div>
							</div>
							${task.name}
						</c:if>
					</div>
				</c:forEach>
			</div>
			<div id="taskDoingBox" class="display-inline-block" style="width:33%">
				<spring:message code="projecthandler.projectTasksView.tasksDoing"/>
				<c:forEach var='task' items='${tasks}'>
					<div class="taskBox">
						<c:if test="${task.level == 2 && task.status == 'STATUS_ACTIVE'}">
							${task.name}
						</c:if>
					</div>
				</c:forEach>
			</div>
			<div id="taskTodoBox" class="display-inline-block" style="width:33%">
				<spring:message code="projecthandler.projectTasksView.tasksToDo"/>
				<c:forEach var='task' items='${tasks}'>
					<div class="taskBox">
						<c:if test="${task.level == 2 && (task.status == 'STATUS_UNDEFINED' || task.status == 'STATUS_SUSPENDED')}">
							${task.name}
						</c:if>
					</div>
				</c:forEach>
			</div>
		</div>
	<jsp:include page="../template/footer.jsp" />
	</body>
</html>