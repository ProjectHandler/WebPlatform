<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page session="true"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<html>
	<head>
		<title><spring:message code="projecthandler.admin.userManagementTitle"/></title>
		<script type="text/javascript" src="../resources/js/jquery-1.11.1.js"></script>
		<script type="text/javascript" src="../resources/js/jquery.tablesorter.min.js"></script>
		<script type="text/javascript">
			var CONTEXT_PATH = "<%=request.getContextPath() %>"; 
			
			$(document).ready(function() {
				$("#usersTable").tablesorter();
				
				$("#btnCreate").click(function(e) {
					var groupName = document.getElementById('groupName').value;
					
					$.ajax({type: "GET", url: CONTEXT_PATH + "/admin/groups_management/create", data: { groupName: groupName}, 
				    	success: function(data) {
				    		if (data != "OK") 
				    			alert(data);
				    		else 
				    			location.reload();
				    	}, 
				    	error: function(data) {alert("error: " + data);} 
				    });
				});
				
			});
			
			function deleteGroup(group_id) {
			    $.ajax({type: "GET", url: CONTEXT_PATH + "/admin/groups_management/delete", data: { groupId: group_id}, 
			    	success: function(data) {
			    		if (data == "KO") 
			    			alert("error"); 
			    		else 
			    			location.reload();}, 
			    	error: function(data) {alert("error: " + data);} 
			    });
			}
			
		</script>
	</head>
	<body>
		<jsp:include page="../template/header.jsp" />
		<jsp:include page="../template/menu.jsp" />
		<h1><spring:message code="projecthandler.admin.groupManagementTitle"/></h1> 
		
		<table id="usersTable">
			<thead>
				<tr>
					<th><spring:message code="projecthandler.group.name"/></th>
					<th>Action</th>
				</tr>
			</thead>
			<tbody>
				<c:forEach var="group" items="${groups}">
					<tr>
						<td><c:out value="${group.name}"/></td>
						<td><INPUT TYPE="BUTTON" VALUE='<spring:message code="projecthandler.admin.action.delete"/>' ONCLICK="deleteGroup('${group.id}')"/></td>
					</tr>
				 </c:forEach>
			</tbody>
		</table>
		<br/>
		
		<div>
			<h3><spring:message code="projecthandler.group.create"/></h3>
			<input type="text" name="groupName" id="groupName"  maxlength="50"/>
			<button id="btnCreate"><spring:message code="projecthandler.signup.create" /></button>
		</div>
		
		<jsp:include page="../template/footer.jsp" />
	</body>
</html>
