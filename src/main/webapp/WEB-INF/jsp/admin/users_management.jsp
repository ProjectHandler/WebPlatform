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
				
				
				$(".dropdown dt a").on('click', function () {
			          $(".dropdown dd ul").slideToggle('fast');
			    });
				$(".dropdown dd ul li a").on('click', function () {
				    $(".dropdown dd ul").hide();
				});
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
			
			function changeGroup(checkbox , userId) {
				var groupId = $(checkbox).val();
				var url = CONTEXT_PATH + "/admin/users_management/changeGroup";
				var action;
				if (checkbox.checked)
					action = "add";
				else
					action = "remove";
				
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
							<INPUT TYPE="BUTTON" VALUE='<spring:message code="projecthandler.admin.action.delete"/>' 	ONCLICK="deleteUser('${user.id}')"/>
							<c:if test="${user.accountStatus == 'INACTIVE'}">
								<INPUT TYPE="BUTTON" VALUE='<spring:message code="projecthandler.admin.action.reSendMail"/>' 	ONCLICK="sendEmailUser('${user.id}')"/>
							</c:if>
						</td>
						<td>
							<dl class="dropdown"> 
								<dt>
									<a href="#" style="background-color:#ececec; display:block; overflow: hidden; border:0; width:200px;">
										<p class="multiSel"></p>
									</a>
								</dt>
								<dd Style="position:relative;">
									<div class="mutliSelect">
										<ul style="background-color:#ececec; display:none; position:absolute; width:200px; list-style:none; overflow: auto;">
											<c:forEach var='group' items='${groups}' >
												<c:set var="found" value="false"/>
												<c:if test="${user.groups != null}">
													<c:forEach var="userGroup" items="${user.groups}">
														<c:if test="${userGroup.id == group.id}">
															<c:set var="found" value="true"/>
															<li><input type="checkbox" value="${group.id}" onchange="changeGroup(this,${user.id})" checked/><c:out value='${group.name}'/></li>
														</c:if>	
													</c:forEach>
												</c:if>
												<c:if test="${user.groups == null || found eq false}">
													<li><input type="checkbox" value="${group.id}" onchange="changeGroup(this,${user.id})" /><c:out value='${group.name}'/></li>
												</c:if>			
											</c:forEach>
										</ul>
									</div>
								</dd>
							</dl>
						</td>
					</tr>
				 </c:forEach>
			</tbody>
		</table>
		<br/>
		<a href="<c:url value="/"/>">home</a>
		<jsp:include page="../template/footer.jsp" />
	</body>
</html>
