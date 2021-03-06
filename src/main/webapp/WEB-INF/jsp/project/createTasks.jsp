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
	<title><spring:message code="projecthandler.createTasks.title"/></title>
	<script>
	var CONTEXT_PATH = "<%=request.getContextPath() %>";
	var taskType = '${e:forJavaScript(taskType)}';
	var milestoneType = '${e:forJavaScript(milestoneType)}';
	var currentTaskType = taskType;

	$(document).ready(function() {
		$(document).tooltip();
		
		setCreationTaskType();
		
		$("#name").focusout(function() {
			validateName();
		});
		
		var dateBegin = new Date();
		$('#alt-dateBegin').prop('value', dateBegin.getFullYear() + "-" + (dateBegin.getMonth() + 1) + "-" + dateBegin.getDate());
		$('#alt-dateEnd').prop('value', dateBegin.getFullYear() + "-" + (dateBegin.getMonth() + 1) + "-" + dateBegin.getDate());
		
		$(function() {
		    $("#dateBegin").datepicker({
		    	dateFormat: 'dd/mm/yy',
		    	altField  : '#alt-dateBegin',
		        altFormat : 'yy-mm-dd',
		        onSelect : function() {
		        	validateDateBegin();
		        }
		    });
		});
		
		$(function() {
		    $("#dateEnd").datepicker({
		    	dateFormat: 'dd/mm/yy',
		    	altField  : '#alt-dateEnd',
		        altFormat : 'yy-mm-dd',
		        onSelect : function() {
		        	validateDateEnd();
		        }
		    });
		});
		
		$('#prioritySelect').selectivity({
		    multiple: false,
		    placeholder: 'Change task priority'
		});
		
		// TODO : type to search a group / user => language files
		$('#userSelection').selectivity({
		    multiple: true,
		    placeholder: 'Type to search a user'
		});
		
		$('#groupSelection').selectivity({
		    multiple: true,
		    placeholder: 'Type to search a group'
		});
		
		$('#groupSelection').on("change", groupChanged);
	});
	
	function validateForm() {
		$('#task-taskLevel').prop('value', currentTaskType);
		return validateName() && validateDateBegin() && validateDateEnd();
	}
	
	function validateName() {
		var name = $("#name").val();
		$("#nameError").html("");
		if((name == null || name.length == 0)) {
			$("#nameError").html('<spring:message javaScriptEscape="true" code="projecthandler.project.edit.error.name"/>');
			return false;
		}
		return true;
	}

	// TO understand => it is supposed to be > 0 but does not work like this
	function validateDateBegin() {
		var dateBegin = new Date($("#alt-dateBegin").val());
		var dateEnd = new Date($("#alt-dateEnd").val());
		var res = dateEnd.getTime() - dateBegin.getTime();
		var dateBeginProject = new Date('${e:forJavaScript(project.dateBegin)}');
		$("#dateBeginError").html("");
		$("#dateEndError").html("");
		if((dateBegin == null || (res < 0))) {
			$("#dateBeginError").html('<spring:message javaScriptEscape="true" code="projecthandler.createTasks.error.dateBegin"/>');
			return false;
		}
		else if (res == 0) {
			$("#dateBeginError").html('<spring:message javaScriptEscape="true" code="projecthandler.createTask.error.minimumDuration"/>');
			return false;
		}
		else if (dateBeginProject > dateBegin) {
			$("#dateBeginError").html('<spring:message javaScriptEscape="true" code="projecthandler.createTask.error.minProjectBegin"/>');
			return false;
		}
		return true;
	}
	
	// TO understand => it is supposed to be > 0 but does not work like this
	function validateDateEnd() {
		var dateBegin = new Date($("#alt-dateBegin").val());
		var dateEnd = new Date($("#alt-dateEnd").val());
		var res = dateEnd.getTime() - dateBegin.getTime();
		var dateEndProject = new Date('${e:forJavaScript(project.dateEnd)}');

		$("#dateBeginError").html("");
		$("#dateEndError").html("");
		if((dateEnd == null || (res < 0))) {
			$("#dateEndError").html('<spring:message javaScriptEscape="true" code="projecthandler.createTasks.error.dateEnd"/>');
			return false;
		}
		else if (res == 0) {
			$("#dateEndError").html('<spring:message javaScriptEscape="true" code="projecthandler.createTask.error.minimumDuration"/>');
			return false;
		}
		else if (dateEndProject < dateEnd) {
			$("#dateEndError").html('<spring:message javaScriptEscape="true" code="projecthandler.createTask.error.maxProjectEnd"/>');
			return false;
		}
		return true;
	}
	
	function checkGroupUsers(user) {
		var found = false;
		var idToAdd = null;
		var txtToAdd = null;
		var data = $('#userSelection').selectivity('data');
		
		if (data != null && data !== undefined)
			$.each(data, function f(i, val) {
				if (user.id == val.id)
					found = true;
			});
		
		if (!found) {
			idToAdd = user.id;
			txtToAdd = user.firstName + ' ' + user.lastName;
			$('#userSelection').selectivity('add', {id: idToAdd, text: txtToAdd});
		}
	}
	
	function groupChanged(item) {
		var url = CONTEXT_PATH + "/project/task/fetchGroupUsers";
		var groupId;
		var usersInGroup;

		if (item.added) {
			groupId = item.added.id;
			$.ajax({
					type: "GET",
					url: url,
					data: {groupId: groupId,
						   projectId: '${project.id}'
					}, 
		    		success: function(data) {
		    				if (data == "KO")
			    				alert("error: " + data);
		    				else {
			    				usersInGroup = jQuery.parseJSON(data);
			    				$.each(usersInGroup, function f2(i, val) {
			    					checkGroupUsers(val);
			    				});
		    				}
		    		}
		    });
			$('#groupSelection').selectivity('remove', item.added);
		}
	}
	
	function switchTaskType() {
		// If the user is creating a milestone he can't add users/groups
		if (currentTaskType == milestoneType) {
			setCreationTaskType();
		}
		else { // the users creates a task and can add users/groups
			setCreationMileStoneType();
		}
	}
	
	function setCreationMileStoneType() {
		$('#task-userAndGroupSelect').hide();
		$('#userSelection').selectivity('data', null);
		$('#task-currentTaskType').html("<spring:message code='projecthandler.createTasks.milestoneMode'/>");
		$('#task-switchTypeButton').text("<spring:message code='projecthandler.createTasks.taskMode'/>");
		currentTaskType = milestoneType;
	}
	
	function setCreationTaskType() {
		$('#task-userAndGroupSelect').show();
		$('#task-currentTaskType').html("<spring:message code='projecthandler.createTasks.taskMode'/>");
		$('#task-switchTypeButton').text("<spring:message code='projecthandler.createTasks.milestoneMode'/>");
		currentTaskType = taskType;
	}
	</script>
</head>
<body>
	<div class="container">
	
		<div class="display-table full-width margin-bottom">
			
			<h1 id="task-currentTaskType" class="text-h1 theme3-darken1-text display-table-cell vertical-align padding-right full-width">
			</h1>
			
			<div class="display-table-cell vertical-align">
				<div style="width:200px;" class="text-right">
					<button id="task-switchTypeButton" class="default-btn-shape theme1-primary-btn-style1" onclick="switchTaskType();">
					</button>
				</div>
			</div>
			
		</div>	
	
		<hr class="theme3-lighten1-bg margin-bottom">
		
		<form:form method="POST" modelAttribute="task" id="addTask" action="${pageContext.request.contextPath}/project/task/save" onsubmit="return validateForm();">
	
			<!-- PROJECT -->
			<form:input type="hidden" path="id" name="taskId" id="taskId" value="${task.id}"/>
			<form:input id="task-projectId" path="project.id" type="hidden" value="${project.id}"/>
			<form:input id="task-taskLevel" path="level" type="hidden"/>
			
			<div class="display-table full-width small-padding-top">
			
				<div class="display-table-cell" style="width:50%;">
			
					<!-- TASK PRIORITY -->
					<div class="priority small-margin-bottom">
						<div class="display-table-cell vertical-align">
							<div class=" fixedwidth-128"><spring:message code="projecthandler.taskBoxView.priority"/></div>
						</div>
						<div class="display-table-cell vertical-align">
							<form:select id="prioritySelect" path="priority">
								<c:forEach var="priority" items="${priorities}">
									<c:choose>
									<c:when test="${task.priority.name != null}">
										<form:option selected="selected" value="${task.id}/${priority.id}">
											${e:forHtml(priority.name)}
										</form:option>
									</c:when>
									<c:otherwise>
										<form:option id="${task.id}/${priority.id}" value="${task.id}/${priority.id}">
											${e:forHtml(priority.name)}
										</form:option>
									</c:otherwise>
									</c:choose>
								</c:forEach>
							</form:select>
						</div>
					</div>
			
					<!-- TASK NAME -->
					<div class="small-margin-bottom">
						<div class="display-table-cell vertical-align">
							<div class=" fixedwidth-128"><label><spring:message code="projecthandler.project.edit.name" />
							<spring:message code="projecthandler.field.required"/></label></div>
						</div>
						<div class="display-table-cell vertical-align fixedmaxwidth-256">
							<form:input path="name" type="text" maxlength="30" id="name" class="fixedmaxwidth-256 textfield surrounded theme3-primary-bdr" value="${task.name}"></form:input>
							<span class="error" id="nameError"></span>
						</div>
					</div>
			
					<!-- TASK DESCRIPTION -->
					<div class="small-margin-bottom">
						<div class="display-table-cell vertical-align fixedwidth-128">
							<div class=" fixedwidth-128"><label><spring:message code="projecthandler.project.edit.description" /></label></div>
						</div>
						<div class="display-table-cell vertical-align fixedmaxwidth-256">
							<form:textarea path="description" id="description" maxlength="500" rows="10" class="fixedmaxwidth-256 textfield surrounded theme3-primary-bdr" content="${task.description}"></form:textarea>
						</div>
					</div>
			
					<!-- TASK STARTING DATE -->
					<div class="small-margin-bottom">
						<div class="display-table-cell vertical-align">
							<div class=" fixedwidth-128">
								<label>
									<spring:message code="projecthandler.project.edit.beginDate"/>
									<spring:message code="projecthandler.field.required"/>
								</label>
								<fmt:formatDate value="${task.startingDate}" var="dateBeginString" pattern="dd/MM/yyyy" />
							</div>
						</div>
						<div class="display-table-cell vertical-align fixedmaxwidth-256">
							<form:input id="alt-dateBegin" path="startingDate" type="hidden" value="${task.startingDate}"/>
							<input  id="dateBegin" value="${dateBeginString}" class="textfield surrounded fixedmaxwidth-256 theme3-primary-bdr" >
							<span class="error" id="dateBeginError"></span>
						</div>
					</div>
			
					<!-- TASK ENDING DATE -->
					<div class="small-margin-bottom">
						<div class="display-table-cell vertical-align">
							<div class=" fixedwidth-128">
								<label>
									<spring:message code="projecthandler.project.edit.endDate" />
									<spring:message code="projecthandler.field.required"/>
								</label>
							<fmt:formatDate value="${task.endingDate}" var="dateEndString" pattern="dd/MM/yyyy" />
							</div>
						</div>
						<div class="display-table-cell vertical-align fixedmaxwidth-256">
							<form:input id="alt-dateEnd" path="endingDate" type="hidden" value="${task.endingDate}"/>
							<input  id="dateEnd" value="${dateEndString}" class="textfield surrounded fixedmaxwidth-256 theme3-primary-bdr" >
							<span class="error" id="dateEndError"></span>
						</div>
					</div>
			
					<!-- TASK USERS -->
					<div id="task-userAndGroupSelect">
					<div class="small-margin-bottom">
						<div class="display-table-cell vertical-align fixedwidth-128">
							<label><spring:message code="projecthandler.project.edit.userSelection"/></label>
						</div>
						<div class="display-table-cell vertical-align">
							<form:select path="users" class="userSelection" id="userSelection">
								<c:forEach var='userInList' items='${users}'>
									<c:set var="found" value= "false"/>
									<c:if test="${task.users != null}">
										<c:forEach var="userInProj" items="${project.users}">
											<c:if test="${userInProj.id == userInList.id}">
												<c:set var="found" value= "true"/>
											</c:if>
										</c:forEach>
									</c:if>
									<c:choose>
									<c:when test="${found eq true}">
										<form:option selected="selected" value="${userInList.id}">
											${e:forHtml(userInList.firstName)} ${e:forHtml(userInList.lastName)}
										</form:option>
									</c:when>
									<c:otherwise>
										<form:option value="${userInList.id}">
											${e:forHtml(userInList.firstName)} ${e:forHtml(userInList.lastName)}
										</form:option>
									</c:otherwise>
									</c:choose>
								</c:forEach>
							</form:select>
						</div>
					</div>
					<div>
						<div class="display-table-cell vertical-align fixedwidth-128">
							<label><spring:message code="projecthandler.project.edit.groupSelection" /></label>
						</div>
						<div class="display-table-cell vertical-align">
							<select class="groupSelection"  multiple="multiple" id="groupSelection">
							<c:forEach var='group' items='${groups}'>
								<option value="${group.id}">
									${e:forHtml(group.name)}
								</option>
							</c:forEach>
							</select>
						</div>
					</div>
					</div>
				
				</div>
					
				<div class="display-table-cell text-center position-relative" style="width:50%;">
				    <c:if test="${hasBeenSaved}">
				    	<div class="position-absolute position-top position-left text-center full-width padding-left" style="margin-top:60px;">
							<div class="default-btn-shape util5-primary-bg inverted-text margin-auto">
								La tâche <u><em>${previousTaskName}</em></u><br/> a bien été sauvegardée
							</div>
						</div>						
				    </c:if> 
					<div class="display-inline-block margin-auto padding-left" style="padding-top:170px;"> 
						<div>
							<button class="default-btn-shape theme2-primary-btn-style1" type="submit" id="submit" style="width:200px;">
								<span class="icon-checkmark small-margin-right">
								</span><spring:message code="projecthandler.project.edit.save"/>
							</button>
						</div>
						<div class="small-container theme3-darken2-text">
							ou fermez cette fenêtre
						</div> 
					</div>
				</div>
			
			</div>
		
		</form:form>
	</div>
</body>
</html>