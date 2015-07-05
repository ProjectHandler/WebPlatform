<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<html xmlns:th="http://www.thymeleaf.org">
	<head>
		<jsp:include page="../template/head.jsp" />
		<title>Edit project</title>
		<script type="text/javascript">
		var CONTEXT_PATH = "<%=request.getContextPath() %>";
		
		$(document).ready(function() {
			// TODO : type to search a group / user => fichier de langue
			$('.userSelection').selectivity({
			    multiple: true,
			    placeholder: 'Type to search a user'
			});
			
			$('.groupSelection').selectivity({
			    multiple: true,
			    placeholder: 'Type to search a group'
			});
			
			$('.groupSelection').on("change", groupChanged);
			
			$("#name").focusout(function() {
				validateName();
			});
			
			$("#dateBegin").focusout(function() {
				validateDateBegin();
			});
			
			$("#dateEnd").focusout(function() {
				validateDateEnd();
			});
			
		});
		
		function validateForm() {
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
			var dateBegin = new Date($("#dateBegin").val());
			var dateEnd = new Date($("#dateEnd").val());
			var res = dateEnd.getTime() - dateBegin.getTime();
			$("#dateBeginError").html("");
			$("#dateEndError").html("");
			if((dateBegin == null || (res < 0))) {
				$("#dateBeginError").html('<spring:message javaScriptEscape="true" code="projecthandler.project.edit.error.dateBegin"/>');
				return false;
			}
			else if (res == 0) {
				$("#dateEndError").html('<spring:message javaScriptEscape="true" code="projecthandler.project.edit.error.minimumDuration"/>');
				return false;
			}
			return true;
		}
		
		// TO understand => it is supposed to be > 0 but does not work like this
		function validateDateEnd() {
			var dateBegin = new Date($("#dateBegin").val());
			var dateEnd = new Date($("#dateEnd").val());
			var res = dateEnd.getTime() - dateBegin.getTime();
			$("#dateBeginError").html("");
			$("#dateEndError").html("");
			if((dateEnd == null || (res < 0))) {
				$("#dateEndError").html('<spring:message javaScriptEscape="true" code="projecthandler.project.edit.error.dateEnd"/>');
				return false;
			}
			else if (res == 0) {
				$("#dateEndError").html('<spring:message javaScriptEscape="true" code="projecthandler.project.edit.error.minimumDuration"/>');
				return false;
			}
			return true;
		}
		
		function checkGroupUsers(user) {
			var found = false;
			var idToAdd = null;
			var txtToAdd = null;
			var data = $('.userSelection').selectivity('data');
			
			if (data != null && data !== undefined)
				$.each(data, function f(i, val) {
					if (user.id == val.id)
						found = true;
				});
			
			if (!found) {
				idToAdd = user.id;
				txtToAdd = user.firstName + ' ' + user.lastName;
				$('.userSelection').selectivity('add', {id: idToAdd, text: txtToAdd});
			}
		}
		
		function groupChanged(item) {
			var url = CONTEXT_PATH + "/project/fetchGroupUsers";
			var groupId;
			var usersInGroup;
			
			if (item.added) {
				groupId = item.added.id;
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
				    					checkGroupUsers(val);
				    				});
			    				}
			    		},
			    		error: function(data) {
			    			alert("error: " + data);
			    		}
			    });
				$('.groupSelection').selectivity('remove', item.added);
			}
			
		}
		</script>
	</head>
<body>
	<jsp:include page="../template/header.jsp" />
	<jsp:include page="../template/menu.jsp" />
	<h1><spring:message code="projecthandler.project.edit.title"/></h1>
	<form:form method="POST" modelAttribute="project" id="addProject" action="${pageContext.request.contextPath}/project/save" onsubmit="return validateForm();">
		<form:input type="hidden" path="id" name="projectId" id="projectId" value="${project.id}"/>
		<table>
			<tbody>
				<tr>
					<td>
						<label><spring:message code="projecthandler.project.edit.name" />
						<spring:message code="projecthandler.field.required"/>:</label>
					</td>
					<td>
						<form:input path="name" type="text" maxlength="30" id="name" value="${project.name}"></form:input>
						<span class="error" id="nameError"></span>
					</td>
				</tr>
				<tr>
					<td><label><spring:message code="projecthandler.project.edit.description" />:</label></td>
					<td><form:textarea path="description" id="description" maxlength="500" content="${project.description}"></form:textarea></td>
				</tr>
				<tr>
					<td><label><spring:message code="projecthandler.project.edit.beginDate" />:</label></td>
						<fmt:formatDate value="${project.dateBegin}" var="dateBeginString" pattern="yyyy-MM-dd" />
					<td>
						<form:input path="dateBegin" type="date" value="${dateBeginString}" id="dateBegin"/>
						<span class="error" id="dateBeginError"></span>
					</td>
				</tr>
				<tr>
					<td><label><spring:message code="projecthandler.project.edit.endDate" />:</label></td>
						<fmt:formatDate value="${project.dateEnd}" var="dateEndString" pattern="yyyy-MM-dd" />
					<td>
						<form:input path="dateEnd" type="date" value="${dateEndString}" id="dateEnd"/>
						<span class="error" id="dateEndError"></span>
					</td>
				</tr>
				<tr>
					<td><label ><spring:message code="projecthandler.project.edit.userSelection"/>:</label></td>
					<td>
					<form:select path="users" class="userSelection" id="userSelection">
						<c:forEach var='userInList' items='${users}'>
							<c:set var="found" value= "false"/>
							<c:if test="${project.users != null}">
								<c:forEach var="userInProj" items="${project.users}">
									<c:if test="${userInProj.id == userInList.id}">
										<c:set var="found" value= "true"/>
									</c:if>
								</c:forEach>
							</c:if>
							<c:choose>
							<c:when test="${found eq true}">
								<form:option selected="selected" value="${userInList.id}">
									${userInList.firstName} ${userInList.lastName}
								</form:option>
							</c:when>
							<c:otherwise>
								<form:option value="${userInList.id}">
									${userInList.firstName} ${userInList.lastName}
								</form:option>
							</c:otherwise>
							</c:choose>
						</c:forEach>
					</form:select>
					</td>
				</tr>
				<tr>
					<td><label ><spring:message code="projecthandler.project.edit.groupSelection" />:</label></td>
					<td>
					<select class="groupSelection"  multiple="multiple" id="groupSelection">
					<c:forEach var='group' items='${groups}'>
						<option value="${group.id}">
							${group.name}
						</option>
					</c:forEach>
					</select>
					</td>
				</tr>
				<tr>
				<td><input value="<spring:message code="projecthandler.project.edit.save"/>" type="submit" id="submit"></td>
				</tr>
				
			</tbody>
		</table>
	</form:form>
 	<jsp:include page="../template/footer.jsp" />
</body>
</html>