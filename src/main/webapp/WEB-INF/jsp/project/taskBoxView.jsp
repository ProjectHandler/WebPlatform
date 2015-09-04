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
	        indeterminate: "taken"
	    });
		
		$('#addSubTaskBox-description').hide();
		
		$('#addSubTaskBox-description').focusout(function() {
			var desc = $('#addSubTaskBox-description').val();
			$.ajax({type: "GET",
	  			url: CONTEXT_PATH + "/subTask/save",
	  			data: { description: desc, userId: "${user.id}", taskId: "${task.id}"}, 
	    		success: function(data) {
	    			if (data.indexOf("KO:") != -1) {
	    				var msg = data.replace("KO:", "");
	    				alert(msg);
	    			}
	    			switchTextareaForSubTaskDescription();
	    			location.reload();
	    		},
	    		error: function(data) {
	    			alert("error: " + data);
	    		}
	    	});
		});
	});

	function changePriority(item) {
		var res = item.value.split("/");
	  	$.ajax({type: "GET",
	  			url: CONTEXT_PATH + "/task/changePriority",
	  			data: { taskId: res[0], priorityId: res[1] }, 
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
		console.log("ID=" + id);
		console.log("VALUE=" + $("#tristate-" + id).val())
    	$.ajax({type: "GET",
  			url: CONTEXT_PATH + "/subTask/update/state",
  			data: {userId: "${user.id}",
  				   subTaskId: id,
  				   state: $("#tristate-" + id).val()
  			},
    		success: function(data) {
    			if (data.indexOf("KO:") != -1) {
    				var msg = data.replace("KO:", "");
    				alert(msg);
    			}
    			location.reload();
    		},
    		error: function(data) {
    			alert("error: " + data);
    		}
    	});
    }
	
	function switchTextareaForSubTaskDescription() {
		if (newSubTaskDescriptionShown)
			$("#addSubTaskBox-description").hide();
		else
			$("#addSubTaskBox-description").show();
		newSubTaskDescriptionShown = !newSubTaskDescriptionShown;
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
	<div class="addSubTask-Box">
		<div>
			<button class="default-btn-shape theme2-primary-btn-style1" id="addSubTask" onClick="switchTextareaForSubTaskDescription();">
				<spring:message code="projecthandler.taskBoxView.addSubTask"/>
			</button>
		</div>
		<textarea id="addSubTaskBox-description" maxlength="200" rows="10" class="fixedmaxwidth-256 textfield surrounded theme3-primary-bdr"></textarea>
	</div>
	<div class="subTaskList-Box">
		<div>
			<spring:message code="projecthandler.taskBoxView.subTaskList"/>
		</div>
		<c:forEach var='subTask' items='${subTasks}'>
		<div id="subTaskContent-${subTask.id}">
			<div class="display-inline-block">
				<c:if test="${subTask.validated == true}">
					<input class="tristate" id="tristate-${subTask.id}" type="checkbox" value="validated" checked="checked" onclick="changeSubTaskState(${subTask.id})">
				</c:if>
				<c:if test="${subTask.taken == true}">
					<input class="tristate" id="tristate-${subTask.id}" type="checkbox" value="taken" indeterminate="intermediate" onclick="changeSubTaskState(${subTask.id})">
				</c:if>
				<c:if test="${subTask.validated == false && subTask.taken == false}">
					<input class="tristate" id="tristate-${subTask.id}" type="checkbox" value="empty" onclick="changeSubTaskState(${subTask.id})">
				</c:if>
			</div>
			<div class="display-inline-block">
				${subTask.description}
			</div>
			<div class="display-inline-block vertical-align small-padding-right">
					<div class="fixedwidth-64 fixedheight-64 circle img-as-background" style="background-image:url(${pageContext.request.contextPath}/resources/img/no-img.png);" title="${subTask.lastUserActivity.firstName} ${subTask.lastUserActivity.lastName}">	
							<div class="full-width full-height circle img-as-background" style="background-image:url(<%=request.getContextPath() %>/downloadAvatar/${subTask.lastUserActivity.id});" title="${subTask.lastUserActivity.firstName} ${subTask.lastUserActivity.lastName}"></div>
					</div>
			</div>
		</div>
		</c:forEach>
	</div>
	<div class="actions">
		<div class="openNewTicket">
			<!-- TODO : open a new ticket with task information pre registred -->
		</div>
	</div>
</body>
</html>