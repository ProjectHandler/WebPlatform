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
			  var $dialog = $('#' + id)
			  .html('<iframe style="border: 0px; " src="' + page + '" width="100%" height="100%"></iframe>')
			  .dialog({
			    title: '<spring:message code="projechandler.profileViewBox.title"/>',
			    autoOpen: false,
			    dialogClass: 'dialog_fixed,ui-widget-header',
			    modal: true,
			    height: 700,
			    minWidth: 1000,
			    minHeight: 700,
			    draggable:false,
			    buttons: { "Ok": function () {$(this).dialog("close"); }
			  }
			  }); 
			  $dialog.dialog('open');
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
				<div class="display-table-cell full-width full-height">
					
					<div class="full-width full-height overflow-auto">
						<div class="container">
							<div class="margin-bottom clearfix">
								<h1 class="text-h2 util1-primary-text float-left">Consultation du projet</h1>
								<div class="text-h2 text-h1 float-right"><span class="icon-folder"></span></div>
							</div>
							<div>

								<div id="toolBar" class="small-container">
									<spring:message code="projecthandler.projectView.researchProject"/>: 
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
									<c:if test="${user.userRole == 'ROLE_ADMIN'}">
									<a class="default-btn-shape theme1-primary-btn-style1" href="${pageContext.request.contextPath}/project/edit/${project.id}">
										<spring:message code="projecthandler.projectView.editCurrentProject"/>
									</a>
									</c:if>
									<a class="default-btn-shape theme1-primary-btn-style1" href="${pageContext.request.contextPath}/project/viewProject/${project.id}/tasks">
										<spring:message code="projecthandler.projectView.goToProjectTasksView"/>
									</a>
									<a class="default-btn-shape theme1-primary-btn-style1" href="<c:url value="/project/projectsList"/>">
										<spring:message code="projecthandler.projectView.goToProjectsList"/>
									</a>
								</div>
								<div id="dateProgressBox" class="small-container">
									<div class="display-inline-block">
										<fmt:formatDate value="${project.dateBegin}" var="dateBeginString" pattern="dd-MM-yyyy" />
										<spring:message code="projecthandler.projectView.dateBegin"/>: ${dateBeginString} 
									</div>
									<div class="display-inline-block" style="width:40%">
										<div id="progressDate${project.id}" class="ui-progressbar ui-widget ui-widget-content ui-corner-all" role="progressbar" aria-valuemin="0" aria-valuemax="100" aria-valuenow="0">
											<div class="ui-progressbar-value ui-widget-header ui-corner-left" style="width: ${projectProgress.dateProgress}%; background: rgb(0, 128, 255);" >
												<span style="color:black">
													<spring:message code="projecthandler.projectView.daysLeft"/>: ${projectProgress.daysLeft}
												</span>
											</div>
										</div>
									</div>
									<div class="display-inline-block">
										<fmt:formatDate value="${project.dateEnd}" var="dateEndString" pattern="dd-MM-yyyy" />
										<spring:message code="projecthandler.projectView.dateEnd"/>: ${dateEndString}
									</div>
								</div>
								<div id="taskProgressBox" class="small-container">
									<div class="display-inline-block">
										<spring:message code="projecthandler.projectView.taskProgress"/>:
									</div>
									<div class="display-inline-block" style="width:40%">
										<div id="progressTask${project.id}" class="ui-progressbar ui-widget ui-widget-content ui-corner-all" role="progressbar" aria-valuemin="0" aria-valuemax="100" aria-valuenow="0">
											<div class="ui-progressbar-value ui-widget-header ui-corner-left" style="width: ${projectProgress.tasksProgress}%; background: rgb(0, 128, 255);" >
												<span style="color:black">${projectProgress.tasksProgress}%</span>
											</div>
										</div>
									</div>
								</div>
								<div id="descriptionBox" class="small-container">
									${project.description}
								</div>
								<div id="projectInfoBox" class="clearfix">
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
									<div id="usersAccessBox" class="float-right gridwidth-5">
										<div>
											<spring:message code="projecthandler.projectView.userList"/>
										</div>
										<c:forEach var='userInList' items='${project.users}'>
											<div class="userView" id="${userInList.id}">
											</div>
											<button class="display-block" onClick="openProfileViewBox(${userInList.id})">
												${userInList.firstName} ${userInList.lastName}
											</button>
										</c:forEach>
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