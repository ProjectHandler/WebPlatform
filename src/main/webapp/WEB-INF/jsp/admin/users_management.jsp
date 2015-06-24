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
				
				$('.role').selectivity({
				    allowClear: true,
				    showSearchInputInDropdown: false,
				    placeholder: ''
				});
				
				$('.role').on("change", changeRole);
				
				$('.accountStatus').selectivity({
				    allowClear: true,
				    showSearchInputInDropdown: false,
				    placeholder: ''
				});
				
				$('.accountStatus').on("change", changeStatus);

				// TODO : placeholder="type to search a group" => fichier de langue
				$('.groupSelection').selectivity({
				    multiple: true,
				    placeholder: ''
				});
				
				$('.groupSelection').on("change", changeGroup);
			});
			
			function changeRole(item) {
				var res = item.value.split("/");
			  	$.ajax({type: "GET", url: CONTEXT_PATH + "/admin/users_management/changeRole", data: { userId: res[0], role: res[1] }, 
			    	success: function(data) {if (data == "KO") alert("error");}, 
			    	error: function(data) {alert("error: " + data);} 
			    });
			}
			
			function changeStatus(item) {
				var res = item.value.split("/");
			    $.ajax({type: "GET", url: CONTEXT_PATH + "/admin/users_management/changeStatus", data: { userId: res[0], status: res[1] }, 
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
		<div class="display-table full-width full-height">
			<div class="display-table-row">
				<jsp:include page="../template/header.jsp" />		
			</div>
			<div class="display-table full-width full-height">
				<div class="display-table-cell full-height theme1-primary-bg">
					<div class="fixedwidth-320">
					<sec:authorize access="hasRole('ROLE_ADMIN')">
						<h1 class="padding-top padding-bottom text-center inverted-text"><span class="icon-database margin-right"></span>Administration</h1>
						<hr class="inverted-bg">
						<a class="container display-block full-width inverted-text default-btn-style5" href="<c:url value="/admin/groups_management"/>"><span class="icon-tree small-margin-left margin-right"></span>Administration des groupes</a>
						<hr class="inverted-bg">
						<a class="container display-block full-width inverted-text default-btn-style5" href="<c:url value="/admin/users_management"/>"><span class="icon-users small-margin-left margin-right"></span>Administration des utilisateurs</a>
						<hr class="inverted-bg">
						<a class="container display-block full-width inverted-text default-btn-style5" href="<c:url value="/admin/signupSendMailService"/>"><span class="icon-user-plus small-margin-left margin-right"></span>Inscrire un utilisateur</a>
						<hr class="inverted-bg">
					</sec:authorize>	
					</div>
				</div>
				<div class="position-relative display-table-cell full-width full-height">
					<div id="modalBox" class="display-none position-absolute position-top position-left zindex-50 default-transpbg full-width full-height overflow-auto">
						<div class="display-table full-width full-height">
							<div class="display-table-cell full-width full-height vertical-align">
								<div class="position-relative fixedwidth-576 margin-auto inverted-bg">
									<div id="modalData"></div>
								</div>
							</div>
						</div>
					</div>			
					<script>
						function showModal(id) { 
							var data=$("#userData-" + id);
							$("#modalData").html(data);
							$("#modalBox").show();
						}
						function closeModal(id) {
							var data=$("#userData-" + id);
							$("#modalBox").hide();
							$("#userDataContainer-" + id).html(data);
						}
					</script>
					
					
					<div class="full-width full-height overflow-auto">
						<div class="container">
							<div class="margin-bottom clearfix">
								<h1 class="util1-primary-text float-left"><spring:message code="projecthandler.admin.userManagementTitle"/></h1>
								<div class="text-h1 float-right"><span class="icon-users"></span></div>
							</div>
							<div>
								<h2 class="small-margin-bottom">Liste des utilisateurs</h2>
								<table id="usersTable" class="full-width surrounded theme3-primary-bdr">
									<thead>
										<tr>
											<th class="small-container padding-right padding-left soft-surrounded theme3-primary-bdr theme3-lighten1-bg theme3-darken2-text"><div class="fixedwidth-192 overflow-hidden">User</div></th>
											<th class="small-container padding-right padding-left soft-surrounded theme3-primary-bdr theme3-lighten1-bg theme3-darken2-text full-width"><spring:message code="projecthandler.user.email"/></th>
											<th class="small-container padding-right padding-left soft-surrounded theme3-primary-bdr theme3-lighten1-bg theme3-darken2-text"><spring:message code="projecthandler.user.action"/></th>
										</tr>
									</thead>
									<tbody>
										<c:forEach var="user" items="${users}">
										<tr>
											<td class="text-capitalize container soft-surrounded theme3-primary-bdr vertical-align"><c:out value="${user.firstName}"/> <c:out value="${user.lastName}"/></td>
											<td class="container soft-surrounded theme3-primary-bdr vertical-align"><c:out value="${user.email}"/></td>
											<td class="container soft-surrounded theme3-primary-bdr vertical-align">
												<button class="default-btn-shape util2-primary-btn-style1" ONCLICK="showModal(${user.id})">
													<span class="icon-wrench small-margin-right"></span>Consulter
												</button>
												
												<div id="userDataContainer-${user.id}" class="display-none">
													<div id="userData-${user.id}" class="text-center">
														<button class="position-absolute position-top position-right default-btn-shape util1-lighten3-text default-btn-style6" ONCLICK="closeModal(${user.id})">
															<span class="icon-cross"></span>
														</button>
													 	<div class="display-inline-block container">
															<div class="display-table-cell padding-right">
																<div class="fixedwidth-128 fixedheight-128 default-bg circle">
																	<div class="full-width full-height img-as-background circle" style="background-image:url(${pageContext.request.contextPath}/resources/img/no-img.png);"></div>
																</div>
															</div>
															<div class="display-table-cell padding-left vertical-align text-left">
																<div class="text-h2 text-capitalize">${user.firstName} ${user.lastName}</div>
																<div class="text-h4 util1-lighten1-text">${user.email}</div>
															</div>
														</div>
														<div class="display-table full-width theme3-lighten1-bg container">
															<div class="display-table-cell gridwidth-5">
																<div class="text-h2 small-margin-bottom">Role</div>
																<select id="role" value="ROLE_MANAGER" class="role select-switch surrounded theme3-primary-bdr full-width">
																	<c:forEach var='role' items='${user_role}' >
																	<c:choose>
																	<c:when test="${role==user.userRole}">
																		<option selected="selected" value="${user.id}/${role}"><c:out value='${role}'/></option>
																	</c:when>
																	<c:otherwise>
																		<option value="${user.id}/${role}"><c:out value='${role}'/></option>
																	</c:otherwise>
																	</c:choose>
																	</c:forEach>
																</select>
															</div>
															<div class="display-table-cell gridwidth-5">
																<div class="text-h2 small-margin-bottom">State</div>
																<select id="accountStatus" class="accountStatus select-switch surrounded theme3-primary-bdr full-width">
																	<c:forEach var='status' items='${account_status}' >
																	<c:choose>
																	<c:when test="${status==user.accountStatus}">
																		<option selected="selected" value="${user.id}/${status}"><c:out value='${status}'/></option>
																	</c:when>
																	<c:otherwise>
																		<option value="${user.id}/${status}"><c:out value='${status}'/></option>
																	</c:otherwise>
																	</c:choose>
																	</c:forEach>
																</select>
															</div>
														</div>
														<div class="container">
															<div class="text-h2 small-margin-bottom">Groups</div>
															<select class="groupSelection"  multiple="multiple" placeholder">
																<c:forEach var='group' items='${groups}'>
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
														</div>
														<hr class="theme3-lighten1-bg">
														<div class="container">
															<button class="default-btn-shape util6-primary-btn-style1" ONCLICK="deleteUser('${user.id}')"/>
																<span class="icon-cross small-margin-right"></span>supprimer
															</button>
															<c:if test="${user.accountStatus == 'INACTIVE'}">
															<button class="default-btn-shape util2-primary-btn-style1" ONCLICK="sendEmailUser('${user.id}')"/>
																<span class="icon-mail2 small-margin-right"></span><spring:message code="projecthandler.admin.action.reSendMail"/>
															</button>
															</c:if>
														</div>
													
													</div>
												</div>
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
