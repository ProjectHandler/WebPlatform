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
			    	success: function(data) {
			    		if (data.indexOf("KO:") != -1) {
			    			var msg = data.replace("KO:", "");
			    			alert(msg);
			    		} else 
			    			location.reload();}, 
			    	error: function(data) {alert("error: " + data);} 
			    });
			}
			
			function changeStatus(item) {
				var res = item.value.split("/");
			    $.ajax({type: "GET", url: CONTEXT_PATH + "/admin/users_management/changeStatus", data: { userId: res[0], status: res[1] }, 
			    	success: function(data) {
			    		if (data.indexOf("KO:") != -1) {
			    			var msg = data.replace("KO:", "");
			    			alert(msg);
			    		} else 
			    			location.reload();}, 
			    	error: function(data) {alert("error: " + data);} 
			    });
			}
			
			function deleteUser(user_id) {
			    $.ajax({type: "GET", url: CONTEXT_PATH + "/admin/users_management/delete", data: { userId: user_id}, 
			    	success: function(data) {
			    		if (data.indexOf("KO:") != -1) {
			    			var msg = data.replace("KO:", "");
			    			alert(msg);
			    		} else 
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
						<h1 class="text-h2 container text-left inverted-text"><span class="icon-database margin-right"></span>Administration</h1>
						<hr class="inverted-bg">
						<a class="container display-block full-width inverted-text default-btn-style5" href="<c:url value="/admin/users_management"/>"><span class="icon-users margin-right"></span>Administration des utilisateurs</a>
						<hr class="inverted-bg">
						<a class="container display-block full-width inverted-text default-btn-style5" href="<c:url value="/admin/groups_management"/>"><span class="icon-tree margin-right"></span>Administration des groupes</a>
						<hr class="inverted-bg">
						<a class="container display-block full-width inverted-text default-btn-style5" href="<c:url value="/admin/signupSendMailService"/>"><span class="icon-user-plus margin-right"></span>Inscrire un utilisateur</a>
						<hr class="inverted-bg">
					</sec:authorize>
					</div>
				</div>
				<div class="position-relative display-table-cell full-width full-height">
					<div id="modalBox" class="display-none position-absolute position-top position-left zindex-25 default-transpbg full-width full-height overflow-auto">
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
								<h1 class="text-h2 util1-primary-text float-left"><spring:message code="projecthandler.admin.userManagementTitle"/></h1>
								<div class="text-h2 float-right"><span class="icon-users"></span></div>
							</div>
							<div>
								<h2 class="text-h3 small-margin-bottom">Liste des utilisateurs</h2>
								
								<div>
									<c:forEach var="user" items="${users}">
										<div class="display-table position-relative full-width small-margin-bottom util1-lighten3-boxshadow-raising-out">
											<a href="#" class="cover-btn-shape default-btn-style5 zindex-10" ONCLICK="showModal(${user.id})"></a>
											<div class="display-table-cell"><div class="fixedwidth-64 fixedheight-64"></div></div>
											<div class="position-absolute position-top position-left fixedwidth-64 fixedheight-64 default-bg">
												<c:if test="${user.avatarFileName != null}">
 													<div class="full-width full-height img-as-background" style="background-image:url(<%=request.getContextPath() %>/downloadAvatar/${user.id});"></div>
												</c:if>
												<c:if test="${user.avatarFileName == null}">
 													<div class="full-width full-height img-as-background" style="background-image:url(${pageContext.request.contextPath}/resources/img/no-img.png);"></div>
												</c:if>
											</div>
											<div class="display-table-cell full-width vertical-align small-container padding-left padding-right">
												<div class="">
													<div class="text-capitalize text-h4">${user.firstName} ${user.lastName}</div>
													<div class="util1-lighten2-text"><small>${user.email}</small></div>
												</div>
											</div>

											<c:if test="${user.userRole == 'ROLE_ADMIN'}">
												<div class="display-table-cell vertical-align small-container padding-left padding-right util6-primary-text">
													<span class="util5-primary-bg inverted-text" style="padding:0px 5px 3px 5px;"><small>administrator</small></span>
												</div>											
											</c:if>	
											
											<c:if test="${user.accountStatus == 'INACTIVE'}">
												<div class="display-table-cell vertical-align small-container padding-left padding-right">
													<span class="util6-primary-bg inverted-text" style="padding:0px 5px 3px 5px;"><small>inactive</small></span>
												</div>											
											</c:if>

											<div class="display-table-cell vertical-align small-container padding-left padding-right util1-lighten3-text">
												<span class="icon-wrench"></span>
											</div>
										</div>
										
										<div id="userDataContainer-${user.id}" class="display-none">
											<div id="userData-${user.id}" class="text-center">
												<button class="position-absolute position-top position-right default-btn-shape util1-lighten3-text default-btn-style6" ONCLICK="closeModal(${user.id})">
													<span class="icon-cross"></span>
												</button>
											 	<div class="display-inline-block container">
													<div class="display-table-cell padding-right">
														<div class="fixedwidth-128 fixedheight-128 circle">
															<c:if test="${user.avatarFileName != null}">
			 													<div class="full-width full-height img-as-background circle" style="background-image:url(<%=request.getContextPath() %>/downloadAvatar/${user.id});"></div>
															</c:if>
															<c:if test="${user.avatarFileName == null}">
			 													<div class="full-width full-height img-as-background circle" style="background-image:url(${pageContext.request.contextPath}/resources/img/no-img.png);"></div>
															</c:if>
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
													<button class="default-btn-shape util6-primary-btn-style1 animating-event" data-action="open-event" data-animation="pop-event" data-target="deleteSecurityfor-${user.id}">
														<span class="icon-cross small-margin-right"></span>Supprimer
													</button>
													<div id="deleteSecurityfor-${user.id}" class="pop-event position-absolute position-top position-left full-width full-height inverted-transpbg">
														<div class="display-table full-width full-height">
															<div class="display-table-cell full-width full-height vertical-align">
																<div>
																	<div class="container util6-lighten2-bg inverted-text">
																		<div class="margin-top text-h2">You are deleting this user !</div>
																		<div class="container text-center">
																			<button class="default-btn-shape util6-primary-btn-style1 small-margin-right radius" ONCLICK="deleteUser('${user.id}')">
																				<span class="icon-checkmark small-margin-right"></span>Supprimer
																			</button>
																			or
																			<button class="default-btn-shape inverted-btn-style1 animating-event small-margin-left radius" data-action="close-event" data-animation="pop-event" data-target="deleteSecurityfor-${user.id}">
																				<span class="icon-cross small-margin-right"></span>Annuler
																			</button>
																		</div>
																	</div>
																</div>
															</div>
														</div>
													</div>
													<c:if test="${user.accountStatus == 'INACTIVE'}">
													<button class="default-btn-shape util2-primary-btn-style1" ONCLICK="sendEmailUser('${user.id}')">
														<span class="icon-mail2 small-margin-right"></span><spring:message code="projecthandler.admin.action.reSendMail"/>
													</button>
													</c:if>
												</div>
											
											</div>
										</div>
									</c:forEach>
								</div>
								
							</div>
						</div>	
					</div>					
				</div>
			</div>		
		</div>
	</body>
</html>
