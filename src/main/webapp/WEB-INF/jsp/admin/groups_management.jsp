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
					<sec:authorize access="hasRole('ROLE_ADMIN')">
						<h1 class="text-h2 container inverted-text"><span class="icon-database margin-right"></span>Administration</h1>
						<hr class="inverted-bg">
						<a class="container display-block full-width inverted-text default-btn-style5" href="<c:url value="/admin/users_management"/>"><span class="icon-users margin-right"></span>Administration des utilisateurs</a>
						<hr class="inverted-bg">
						<a class="container display-block full-width inverted-text default-btn-style5" href="<c:url value="/admin/groups_management"/>"><span class="icon-tree margin-right"></span>Administration des groupes</a>
						<hr class="inverted-bg">
					</sec:authorize>	
					</div>
				</div>
				<div class="display-table-cell full-width full-height">
					
					<div class="full-width full-height overflow-auto">
						<div class="container">
							<div class="margin-bottom clearfix">
								<h1 class="text-h2 util1-primary-text float-left"><spring:message code="projecthandler.admin.groupManagementTitle"/></h1>
								<div class="text-h2 text-h1 float-right"><span class="icon-tree"></span></div>
							</div>
							<div class="margin-bottom">
								<h2 class="text-h3 small-margin-bottom"><spring:message code="projecthandler.group.create"/></h2>
								<input type="text" name="groupName" id="groupName"  maxlength="50" class="textfield fixedmaxwidth-384 surrounded theme3-primary-bdr" placeholder="Your group name here ..."/>
								<button id="btnCreate" class="default-btn-shape util3-primary-btn-style1"><span class="icon-checkmark small-margin-right"></span><spring:message code="projecthandler.signup.create" /></button>
							</div>
							<div>
								<h2 class="text-h3 small-margin-bottom">Liste des groupes</h2>
								<div class="clearfix">
									<c:forEach var="group" items="${groups}">
										<div class="position-relative fixedheight-128 theme3-primary-boxshadow-raising-out margin-right margin-bottom float-left overflow-hidden" style="width:100px;">
											<a href="#" class="cover-btn-shape default-btn-style5 zindex-10 animating-event" data-action="open-event" data-animation="pop-event" data-target="groupdeletingvalidation-${group.id}"></a>
											<div id="groupdeletingvalidation-${group.id}" class="pop-event focus-sensitive position-absolute position-top position-left full-width full-height util6-primary-transpbg zindex-20">
												<div>
													<button class="default-btn-shape inverted-text default-btn-style6 animating-event" data-action="close-event" data-animation="pop-event" data-target="groupdeletingvalidation-${group.id}">
														<span class="icon-cross"></span>
													</button>
												</div>
												<div>
													<button class="default-btn-shape full-width text-center small-margin-top inverted-text default-btn-style6" ONCLICK="deleteGroup('${group.id}')">
														Supprimer
													</button>
												</div>
											</div>
											<div class="small-container text-center"><div class="display-inline-block"><div class="display-table-cell vertical-align fixedwidth-64 fixedheight-64 theme3-lighten1-bg theme3-darken1-text circle margin-auto text-h3">
												<span class="icon-tree"></span>
											</div></div></div>
											<div class="text-center small-container small"><c:out value="${group.name}"/></div>
										</div>
									</c:forEach>
								</div>
								
								<!-- <table id="usersTable" class="full-width surrounded theme3-primary-bdr">
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
								</table> -->
							</div>
						</div>	
					</div>	
				</div>
			</div>		
		</div>
	</body>
</html>
