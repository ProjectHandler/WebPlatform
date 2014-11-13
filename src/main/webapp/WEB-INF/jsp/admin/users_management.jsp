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
			});
			
			function changeRole(role, user_id) {
			    $.ajax({type: "GET", url: CONTEXT_PATH + "/admin/users_management/changeRole", data: { userId: user_id, role: role.value }, 
			    	success: function(data) {if (data == "KO") alert("error");}, 
			    	error: function(data) {alert("error: " + data);} 
			    });
			}
			
			function changeStatus(status, user_id) {
			    $.ajax({type: "GET", url: CONTEXT_PATH + "/admin/users_management/changeStatus", data: { userId: user_id, status: status.value }, 
			    	success: function(data) {if (data == "KO") alert("error");}, 
			    	error: function(data) {alert("error: " + data);} 
			    });
			}
			
			function deleteUser(user_id) {
			    $.ajax({type: "GET", url: CONTEXT_PATH + "/admin/users_management/delete", data: { userId: user_id}, 
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
		<h1><spring:message code="projecthandler.admin.userManagementTitle"/></h1> 
		
		<table id="usersTable">
			<thead>
				<tr>
					<th><spring:message code="projecthandler.user.lastName"/></th>
					<th><spring:message code="projecthandler.user.firstName"/></th>
					<th><spring:message code="projecthandler.user.email"/></th>
					<th><spring:message code="projecthandler.user.role"/></th>
					<th><spring:message code="projecthandler.user.status"/></th>
					<th>Action</th>
				</tr>
			</thead>
			<tbody>
				<c:forEach var="user" items="${users}">
					<tr>
						<td><c:out value="${user.lastName}"/></td>
						<td><c:out value="${user.firstName}"/></td>
						<td><c:out value="${user.email}"/></td>
						<td>
							<select id="role" value="ROLE_MANAGER" onchange="changeRole(this, '${user.id}')">
								<c:forEach var='role' items='${user_role}' >
									<c:choose>
										<c:when test="${role==user.userRole}">
											<option selected="selected"><c:out value='${role}'/></option>
										</c:when>
										<c:otherwise>
											<option><c:out value='${role}'/></option>
										</c:otherwise>
									</c:choose>
								</c:forEach>
							</select>
						</td>
						<td>
							<select id="accountStatus" onchange="changeStatus(this, '${user.id}')">
								<c:forEach var='status' items='${account_status}' >
									<c:choose>
										<c:when test="${status==user.accountStatus}">
											<option selected="selected"><c:out value='${status}'/></option>
										</c:when>
										<c:otherwise>
											<option><c:out value='${status}'/></option>
										</c:otherwise>
									</c:choose>
								</c:forEach>
							</select>
						</td>
						<td><INPUT TYPE="BUTTON" VALUE='<spring:message code="projecthandler.admin.action.delete"/>' ONCLICK="deleteUser('${user.id}')"/></td>
					</tr>
				 </c:forEach>
			</tbody>
		</table>
		<br/>
		<a href="<c:url value="/"/>">home</a>
		<jsp:include page="../template/footer.jsp" />
	</body>
</html>
