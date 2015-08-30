<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<html xmlns:th="http://www.thymeleaf.org">
<head>
	<jsp:include page="../template/head.jsp" />
	<title><spring:message code="projecthandler.taskBoxView.title"/></title>
	<script>
	var CONTEXT_PATH = "<%=request.getContextPath() %>";
	$(document).ready(function(){
		$( document ).tooltip();
		
		$('#prioritySelect').selectivity({
		    multiple: false,
		    placeholder: 'Change task priority'
		});
		$('#prioritySelect').on("change", changePriority);
	});

	function changePriority(item) {
		var res = item.value.split("/");

		console.log("CALL : " + res[0] + ", " + res[1]);
	  	$.ajax({type: "GET", url: CONTEXT_PATH + "/task/changePriority", data: { taskId: res[0], priorityId: res[1] }, 
	    	success: function(data) {
	    		if (data.indexOf("KO:") != -1) {
	    			var msg = data.replace("KO:", "");
	    			alert(msg);
	    		} else 
	    			location.reload();}, 
	    	error: function(data) {alert("error: " + data);} 
	    });
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
	<div class="taskDetails">
		<div class="members display-inline-block">
			<spring:message code="projecthandler.taskBoxView.taskMembers"/>: 
			<c:forEach var="userInList" items="${task.project.users}">
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
	<div class="subTasksList">
	</div>
	<div class="actions">
		<div class="openNewTicket">
			<!-- TODO : open a new ticket with task information pre registred -->
		</div>
	</div>
</body>
</html>