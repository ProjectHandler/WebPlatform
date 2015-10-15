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
		$(document).ready(function() {
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

		function loadModalContainer(page) {
			$("#dynamicContainerForModal").html('<iframe style="border: 0px; " src="' + page + '" width="100%" height="620px"></iframe>');
		}
		
		function openProfileViewBox(id) {
			loadModalContainer(CONTEXT_PATH + '/profile/viewProfileBox/' + id);
		}
		
		function openCreateTasksBox(projectId) {
			loadModalContainer(CONTEXT_PATH + '/project/createTask/' + projectId);
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
				<div class="display-table-cell full-width full-height">
					<div class="full-width full-height position-relative">
					
						<div id="main-modal-box" class="pop-event full-width full-height position-absolute position-top position-left default-transpbg zindex-10">
							<div class="full-width full-height display-table position-relative">
								<div class="position-absolute position-top position-right">
									<a href="#" class="default-btn-shape text-h2 inverted-text util6-lighten2-btn-style6 animating-event" data-action="close-event" data-animation="pop-event" data-target="main-modal-box"><span class="icon-cross"></span></a>
								</div>
								<div class="full-width full-height display-table-cell vertical-align">
	
									<div class="inverted-bg fixedwidth-768 margin-auto overflow-hidden position-relative">
										<div id="dynamicContainerForModal">
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
	
									<div id="toolBar" class="small-container inverted-bg theme3-primary-boxshadow-raising-out display-table full-width small-margin-bottom">
										<div class="display-table-cell vertical-align">
											<div class="" style="width:170px;">
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
											<a class="default-btn-shape theme1-primary-btn-style1 animating-event" href="#" onclick="openCreateTasksBox(${project.id})" data-action="toggle-event" data-animation="pop-event" data-target="main-modal-box">
												<spring:message code="projecthandler.projectView.goToCreateTasks"/>
											</a>
											<a class="default-btn-shape theme1-primary-btn-style1" href="<c:url value="/project/projectsList"/>">
												<span class="icon-folder-open small-margin-right"></span><spring:message code="projecthandler.projectView.goToProjectsList"/>
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
	
									<div class="small-container margin-bottom">									
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
									
									<div class="small-margin-bottom">
										<div class="container theme3-lighten1-bg radius">
											<div id="descriptionBox" class="text-justify">
												${project.description}
											</div>
										</div>
										<div class="small-margin-top display-table full-width">
											<div class="text-right">
												<div id="projectInfoBox" class="display-inline-block">
													<div id="usersAccessBox" class="clearfix">
														<c:forEach var='userInList' items='${project.users}'>
															<div class="float-left small-margin-right position-relative">
																<div class="circle img-as-background" style="width:32px;height:32px;background-image:url(${pageContext.request.contextPath}/resources/img/no-img.png);">	
					 												<div class="full-width full-height circle img-as-background" style="background-image:url(<%=request.getContextPath() %>/downloadAvatar/${userInList.id});"></div>
																</div>
																<a title="${userInList.firstName} ${userInList.lastName}" href="#" class="cover-btn-shape default-btn-style5 circle animating-event" data-action="toggle-event" data-animation="pop-event" data-target="main-modal-box" onClick="openProfileViewBox(${userInList.id})"></a> 
															</div>
														</c:forEach>
													</div>
												</div>										
											</div>
										</div>
									</div>
									
									<div>
										<jsp:include page="projectTasksView.jsp" />
									</div>
									
									<div class="padding-top padding-bottom margin-top"><hr class="theme3-primary-bg"></div>
	
									<div class="">
									
										<div id="ticketAccessBox" class="clearfix">
											<c:forEach var="ticket" items="${tickets}">
												<c:if test="${ticket.ticketStatus == 'OPEN'}">
													<div class="position-relative small-container theme3-primary-boxshadow-raising-out surrounded theme3-primary-bdr float-left margin-right margin-top">
														<div class="">
															<div>Ticket ouvert n° ${ticket.id}</div>
															<div class="small-padding-left leftlined theme3-primary-bdr">
																<div class="small theme3-primary-text">${ticket.createdAt}</div>
																<div class="small theme1-primary-text">${ticket.title}</div>
															</div>
														</div>
														<a href="${pageContext.request.contextPath}/ticket/${ticket.id}/messages" class="cover-btn-shape default-btn-style5"></a> 
													</div>
												</c:if>
											</c:forEach>
										</div>
										
										<div>
											<a class="default-btn-shape theme3-primary-text theme1-lighten2-btn-style6 small-margin-top" href="${pageContext.request.contextPath}/ticket/list/project/${project.id}">
												<span class="icon-envelop small-margin-right"></span>Voir tous les tickets
											</a>
										</div>
										
									</div>
									
								</div>
							</div>
						</div>	
					
					</div>
				</div>	
			</div>
		</div>	
	</body>
</html>