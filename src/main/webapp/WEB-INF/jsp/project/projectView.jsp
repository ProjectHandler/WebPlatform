<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<html xmlns:th="http://www.thymeleaf.org">
	<head>
		<jsp:include page="../template/head.jsp" />
		<title><spring:message code="projechandler.projectView.title"/></title>
		<script type="text/javascript">
		$(document).ready(function(){
			$('.projectSelection').selectivity({
			    multiple: false,
			    placeholder: 'Type to search a project'
			});

			$('.projectSelection').on("selectivity-selected", changeProject);
		});

		function changeProject(event) {
			var url = CONTEXT_PATH + "/project/viewProject/" + event.id;
			window.location.replace(url);
			return false;
		}

		function opendialog(page, id) {
			  var $dialog = $("#modalForUserView").html('<iframe style="border: 0px; " src="' + page + '" width="100%" height="100%"></iframe>');
			}
		
		function openProfileViewBox(id) {
			opendialog(CONTEXT_PATH + '/profile/viewProfileBox/' + id, id);
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
						<h1 class="text-h2 container inverted-text"><span class="icon-folder margin-right"></span>Projets</h1>
						<hr class="inverted-bg">
						<a class="container display-block full-width inverted-text default-btn-style5" href="<c:url value="/project/edit"/>"><span class="icon-folder-plus margin-right"></span>Creer un nouveau projet</a>
						<hr class="inverted-bg">
						<a class="container display-block full-width inverted-text default-btn-style5" href="<c:url value="/project/projectsList"/>"><span class="icon-folder-open margin-right"></span>Liste des projets</a>
						<hr class="inverted-bg">	
					</div>
				</div>
				<div class="display-table-cell full-width full-height position-relative">
					
					<div id="userprofile-modal-box" class="pop-event full-width full-height position-absolute position-top position-left default-transpbg zindex-10">
						<div class="full-width full-height display-table">
							<div class="full-width full-height display-table-cell vertical-align">

								<div class="inverted-bg fixedwidth-320 margin-auto overflow-hidden position-relative">
									<div id="modalForUserView">
									</div>
									<div class="text-center">
										<a href="#" class="reduced-btn-shape theme3-lighten1-btn-style1 animating-event" data-action="toggle-event" data-animation="pop-event" data-target="userprofile-modal-box">Fermer</a>
									</div>
								</div>

							</div>
						</div>
					</div>
					
					<div class="position-absolute position-top position-left full-width full-height overflow-auto">
						<div class="container">
							<div class="margin-bottom clearfix">
								<h1 class="text-h2 util1-primary-text float-left">Consultation du projet</h1>
								<div class="text-h2 text-h1 float-right"><span class="icon-folder"></span></div>
							</div>
							<div>

								<div id="toolBar" class="small-container display-table full-width theme3-primary-boxshadow-raising-out small-margin-bottom">
									<div class="display-table-cell vertical-align">
										<div style="width:170px;">
											<spring:message code="projecthandler.projectView.researchProject"/> :
										</div>
									</div>
									<div class="display-table-cell vertical-align">
										<select class="projectSelection display-inline-block" id="projectSelection">
											<c:forEach var='projectSelectable' items='${projects}'>
												<c:choose>
												<c:when test="${projectSelectable.id == project.id}">
													<option id="${projectSelectable.id}" selected="selected" value="${projectSelectable.id}">
														${projectSelectable.name}
													</option>
												</c:when>
												<c:otherwise>
													<option id="${projectSelectable.id}" value="${projectSelectable.id}">
														${projectSelectable.name}
													</option>
												</c:otherwise>
												</c:choose>
											</c:forEach>
										</select>
									</div>
									<div class="display-table-cell vertical-align full-width text-right">
										<a class="default-btn-shape theme1-primary-btn-style1" href="<c:url value="/project/projectsList"/>">
											<span class="icon-folder-open"></span> <spring:message code="projecthandler.projectView.goToProjectsList"/>
										</a>
									</div>
								</div>
								
				                    
			                    <div class="display-table padding-top padding-bottom">
			                    	<div class="text-center display-table-cell vertical-align small-padding-left">
				                    	<div class="display-inline-block">
				                    		<div class="fixedwidth-64 fixedheight-64 theme3-lighten1-bg theme3-darken1-text circle margin-auto text-h1">
				                    			<div class="display-table full-width full-height">
				                    				<div class="display-table-cell vertical-align full-width full-height">
														<span class="icon-folder"></span>
													</div>
												</div>
											</div>
										</div>
									</div>
									<div class=" display-table-cell vertical-align small-padding-left full-width">
				                    	<h3 class="text-capitalize">${project.name}</h3>
										<div class="theme3-primary-text">${project.status}</div>
										<div class="small">${projectProgress.daysLeft} <spring:message code="projecthandler.projectView.daysLeft"/></div>
									</div>
									<div class="display-table-cell vertical-align text-right padding-left">
										<div class="fixedwidth-192">
											<div class="display-table-cell vertical-align text-h1">
												<span class="icon-stopwatch"></span>
											</div>
											<div class="display-table-cell vertical-align small padding-left">
						                    	<div>
						                    		Débute le 
													<fmt:formatDate value="${project.dateBegin}" var="dateBeginString" pattern="dd-MM-yyyy" />
													<span class="theme1-primary-text">${dateBeginString}</span>
												</div>					
												<div>
													Finit le
													<fmt:formatDate value="${project.dateEnd}" var="dateEndString" pattern="dd-MM-yyyy" />
													<span class="theme1-primary-text">${dateEndString}</span>
												</div>
											</div>
										</div>
									</div>
			                    </div>
								
								<div class="padding-bottom">
									<a class="display-block full-width text-center small small-margin-bottom default-btn-shape theme1-lighten2-btn-style1" href="${pageContext.request.contextPath}/ticket/list/project/${project.id}">
										<spring:message code="projecthandler.projectsList.goToTickets"/>
									</a>
									<a class="display-block full-width text-center small small-margin-bottom default-btn-shape theme1-primary-btn-style1" href="${pageContext.request.contextPath}/project/viewProject/${project.id}/tasks">
										<spring:message code="projecthandler.projectView.goToProjectTasksView"/>
									</a>
								</div>
								
								<div class="container theme3-lighten1-bg radius margin-bottom">
									<div id="descriptionBox" class="text-justify">
										${project.description}
									</div>
								</div>
								
								<div class="small-container">									
									<div class="small-margin-bottom">
										<div class="display-table-cell vertical-align theme3-darken1-text small"><div class="fixedwidth-64 text-left">Deadline</div></div>	
										<div id="progressDate${project.id}" class="display-table-cell vertical-align full-width hard-surrounded theme3-lighten1-bdr rounded theme3-lighten1-bg" role="progressbar" aria-valuemin="0" aria-valuemax="100" aria-valuenow="0">
											<div class="surrounded rounded theme3-darken1-bdr theme3-darken1-bg" style="width: ${projectProgress.dateProgress}%;" ></div>
										</div>
										<div class="display-table-cell vertical-align theme3-darken1-text small"><div class="text-right" style="width:45px;">${projectProgress.dateProgress}%</div></div>	
									</div>
									<div>
										<div class="display-table-cell vertical-align theme3-darken1-text small"><div class="fixedwidth-64 text-left">Avancée</div></div>	
										<div id="progressTask${project.id}" class="display-table-cell vertical-align full-width hard-surrounded theme3-lighten1-bdr rounded theme3-lighten1-bg" role="progressbar" aria-valuemin="0" aria-valuemax="100" aria-valuenow="0">
											<div class="surrounded rounded theme3-darken1-bdr theme3-darken1-bg" style="width: ${projectProgress.tasksProgress}%;" ></div>
										</div>
										<div class="display-table-cell vertical-align theme3-darken1-text small"><div class="text-right" style="width:45px;">${projectProgress.tasksProgress}%</div></div>	
									</div>
								</div>
								
								<hr class="margin-top margin-bottom theme3-lighten1-bg">
								
								<div id="projectInfoBox" class="small-padding-top">
									<div id="usersAccessBox" class="clearfix">
										<c:forEach var='userInList' items='${project.users}'>
											<div class="small-container theme3-primary-boxshadow-raising-out float-left margin-right small-margin-bottom">
											
												<div class="display-table-cell vertical-align small-padding-right">
													<div class="fixedwidth-64 fixedheight-64 circle img-as-background" style="background-image:url(${pageContext.request.contextPath}/resources/img/no-img.png);">	
		 												<div class="full-width full-height circle img-as-background" style="background-image:url(<%=request.getContextPath() %>/downloadAvatar/${userInList.id});"></div>
													</div>
												</div>
												<div class="display-table-cell vertical-align">
													<h4 class="theme3-darken2-text">${userInList.firstName} ${userInList.lastName}</h4>
													<button class="reduced-btn-shape theme2-primary-btn-style1 small rounded animating-event"data-action="toggle-event" data-animation="pop-event" data-target="userprofile-modal-box" onClick="openProfileViewBox(${userInList.id})">
														<span class="icon-search"></span> Consulter le profil
													</button>
												</div>
											</div>
										</c:forEach>
									</div>
								</div>
								
								<a class="default-btn-shape theme1-primary-btn-style1 margin-top" href="<c:url value="/project/projectsList"/>">
									<span class="icon-folder-open"></span> <spring:message code="projecthandler.projectView.goToProjectsList"/>
								</a>
								
								<!--
								<div id="ticketAccessBox" class="float-left gridwidth-5">
									<div>
										<spring:message code="projecthandler.projectView.ticketList"/>
									</div>
									<c:forEach var="ticket" items="${tickets}">
										<div>
											<spring:message code="projecthandler.projectView.ticketTitle"/>: 
											<a href="${pageContext.request.contextPath}/ticket/${ticket.id}/messages">
												${ticket.title}. 
											</a>
											<spring:message code="projecthandler.projectView.status"/>: ${ticket.ticketStatus} 
											<spring:message code="projecthandler.projectView.priority"/>: ${ticket.ticketPriority.name}
										</div>
									</c:forEach>
								</div>
								 -->
								
							</div>
						</div>
					</div>	
				</div>	
			</div>
		</div>	
	</body>
</html>