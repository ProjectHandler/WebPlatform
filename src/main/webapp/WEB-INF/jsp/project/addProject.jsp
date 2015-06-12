<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<html xmlns:th="http://www.thymeleaf.org">
	<head>
		<jsp:include page="../template/head.jsp" />
		<title>Nouveau projet</title>
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
		});
		
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
				    				alert("error");
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
	<h1>Nouveau project</h1>
	<form:form method="POST" action="${pageContext.request.contextPath}/project/save" modelAttribute="project">
		<table>
			<tbody>
				<tr>
					<td><form:label path="name">Nom:</form:label></td>
					<td><form:input path="name"></form:input></td>
				</tr>
				<tr>
					<td><form:label path="description">Description:</form:label></td>
					<td><form:textarea path="description"></form:textarea></td>
				</tr>
				<tr>
					<td><form:label path="dateBegin">Date de début:</form:label></td>
					<fmt:formatDate value="${project.dateBegin}" var="dateBeginString" pattern="yyyy-MM-dd" />
					<td><form:input path="dateBegin" type="date" value="${dateBeginString}"/></td>
				</tr>
				<tr>
					<td><form:label path="dateEnd">Date de fin:</form:label></td>
					<fmt:formatDate value="${project.dateBegin}" var="dateEndString" pattern="yyyy-MM-dd" />
					<td><form:input path="dateEnd" type="date" value="${dateEndString}"/></td>
				</tr>
				<tr>
					<td><form:label path="users">utilisateur(s):</form:label></td>
					<td>
					<form:select  path="users" class="userSelection" id="id">
						<c:forEach var='user' items='${users}'>
						<form:option value="${user.id}">
							${user.firstName} ${user.lastName}
						</form:option>
					</c:forEach>
						
					</form:select>
					</td>
				</tr>
				<tr>
					<td><label >Groupe(s):</label></td>
					<td>
					<select class="groupSelection"  multiple="multiple" placeholder>
					<c:forEach var='group' items='${groups}'>
						<option value="${group.id}">
							${group.name}
						</option>
					</c:forEach>
					</select>
					</td>
				</tr>
				<tr>
					<td colspan="2"><input value="Submit" type="submit">
					</td>
				</tr>
				
			</tbody>
		</table>
	</form:form>
 	<jsp:include page="../template/footer.jsp" />
</body>
</html>