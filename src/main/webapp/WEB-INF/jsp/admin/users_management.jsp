<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page session="true"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<html>
	<head>
		<jsp:include page="../template/head.jsp" />
		<title><spring:message code="projecthandler.admin.userManagementTitle"/></title>

		<script type="text/javascript">
			var CONTEXT_PATH = "<%=request.getContextPath() %>";
			
			$(document).ready(function() {
				$("#usersTable").tablesorter();

				// TODO : type to search a group => fichier de langue
				$('.groupSelection').selectivity({
				    multiple: true,
				    placeholder: 'Type to search a group'
				});
				
				$('.groupSelection').on("change", changeGroup);
			});
			
			function changeRole(role, user_id) {
			    $.ajax({type: "GET", url: CONTEXT_PATH + "/admin/users_management/changeRole", data: { userId: user_id, role: role.value }, 
			    	success: function(data) {if (data == "KO") alert("error");}, 
			    	error: function(data) {alert("error: " + data);} 
			    });
			}
			
			function changeStatus(status, user_id) {
			    $.ajax({type: "GET", url: CONTEXT_PATH + "/admin/users_management/changeStatus", data: { userId: user_id, status: status.value }, 
			    	success: function(data) {
			    		if (data == "KO") 
			    			alert("error");
				    	else 
			    			location.reload();}, 
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
			
			function sendEmailUser(user_id) {
				$.ajax({type: "GET", url: CONTEXT_PATH + "/admin/users_management/reSendEmail", data: { userId: user_id}, 
			    	success: function(data) {
			    		if (data == "KO") 
			    			alert("error"); 
			    		else 
			    			location.reload();}, 
			    	error: function(data) {alert("error: " + data);} 
			    });
			}

			function changeGroup(item) {
				var url = CONTEXT_PATH + "/admin/users_management/changeGroup";
				var res;
				var userId;
				var groupId;
				var action;
				
				if (item.added) {
					res = item.added.id.split("/");
					action = "add";
				}
				else {
					res = item.removed.id.split("/");
					action = "remove";
				}
				userId = res[0];
				groupId = res[1];
				
				$.ajax({type: "GET", url: url, data: { userId: userId, groupId: groupId, action: action}, 
			    	success: function(data) {
			    		if (data == "KO") 
			    			alert("error"); 
			    	}, 
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
					<th><spring:message code="projecthandler.user.action"/></th>
					
					<th>Group</th>
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
					<td>
						<INPUT TYPE="BUTTON" VALUE='<spring:message code="projecthandler.admin.action.delete"/>'
							ONCLICK="deleteUser('${user.id}')"/>
						<c:if test="${user.accountStatus == 'INACTIVE'}">
						<INPUT TYPE="BUTTON" VALUE='<spring:message code="projecthandler.admin.action.reSendMail"/>'
							ONCLICK="sendEmailUser('${user.id}')"/>
						</c:if>
					</td>
					<td>
						<select class="groupSelection"  multiple="multiple" placeholder>
       						<c:forEach var='group' items='${groups}' >
								<c:set var="found" value="false"/>
								<c:if test="${user.groups != null}">
									<c:forEach var="userGroup" items="${user.groups}">
										<c:if test="${userGroup.id == group.id}">
											<c:set var="found" value="true"/>
											<option selected value="${user.id}/${group.id}">
												${group.name}
											</option>
										</c:if>
									</c:forEach>
								</c:if>
								<c:if test="${user.groups == null || found eq false}">
									<option value="${user.id}/${group.id}">
										${group.name}
									</option>
								</c:if>	
							</c:forEach>
       					</select>
       				</td>
					</tr>
				 </c:forEach>
			</tbody>
		</table>
		<br/>
		
		<jsp:include page="../template/footer.jsp" />
	</body>
</html>
