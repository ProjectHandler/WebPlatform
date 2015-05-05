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
		<div class="display-table full-width full-height">
			<div class="display-table-row">
				<jsp:include page="../template/header.jsp" />		
			</div>
			<div class="display-table full-width full-height">
				<div class="display-table-cell full-height theme1-primary-bg">
					<div class="fixedwidth-320">
						<h1 class="padding-top padding-bottom text-center inverted-text"><span class="icon-database margin-right"></span>Administration</h1>
						<hr class="inverted-bg">
						<a class="container display-block full-width inverted-text default-btn-style5" href=""><span class="icon-tree small-margin-left margin-right"></span>Administration des groupes</a>
						<hr class="inverted-bg">
						<a class="container display-block full-width inverted-text default-btn-style5" href=""><span class="icon-users small-margin-left margin-right"></span>Administration des utilisateurs</a>
						<hr class="inverted-bg">
						<a class="container display-block full-width inverted-text default-btn-style5" href=""><span class="icon-user-plus small-margin-left margin-right"></span>Inscrire un utilisateur</a>
						<hr class="inverted-bg">
					</div>
				</div>
				<div class="display-table-cell full-width full-height">
					
					<div class="full-width full-height overflow-auto">
						<div class="container">
							<div class="margin-bottom clearfix">
								<h1 class="util1-primary-text float-left"><spring:message code="projecthandler.admin.groupManagementTitle"/></h1>
								<div class="text-h1 float-right"><span class="icon-tree"></span></div>
							</div>
							<div class="margin-bottom">
								<h2 class="small-margin-bottom"><spring:message code="projecthandler.group.create"/></h2>
								<input type="text" name="groupName" id="groupName"  maxlength="50" class="textfield fixedmaxwidth-384 surrounded theme3-primary-bdr" placeholder="Your group name here ..."/>
								<button id="btnCreate" class="default-btn-shape theme2-primary-btn-style1"><span class="icon-checkmark small-margin-right"></span><spring:message code="projecthandler.signup.create" /></button>
							</div>
							<div>
								<h2 class="small-margin-bottom">Liste des groupes</h2>
								<table id="usersTable" class="full-width surrounded theme3-primary-bdr">
									<thead>
										<tr>
											<th class="small-container padding-right padding-left soft-surrounded theme3-primary-bdr theme3-lighten1-bg theme3-darken2-text full-width"><spring:message code="projecthandler.group.name"/></th>
											<th class="small-container padding-right padding-left soft-surrounded theme3-primary-bdr theme3-lighten1-bg theme3-darken2-text text-center">Action</th>
										</tr>
									</thead>
									<tbody>
										<c:forEach var="group" items="${groups}">
											<tr>
												<td class="container soft-surrounded theme3-primary-bdr full-width">
													<c:out value="${group.name}"/>
												</td>
												<td class="container soft-surrounded theme3-primary-bdr">
													<button class="default-btn-shape util6-primary-btn-style1" ONCLICK="deleteGroup('${group.id}')"/>
														<span class="icon-cross small-margin-right"></span>supprimer
													</button>
												</td>
											</tr>
										 </c:forEach>
									</tbody>
								</table>
							</div>
						</div>	
					</div>
					
				</div>
			</div>		
		</div>

	</body>
</html>
