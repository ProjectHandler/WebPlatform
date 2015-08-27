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
		</script>
	</head>
	<body>
		<div>
			<jsp:include page="../template/header.jsp" />
		</div>
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
				<fmt:formatDate value="${project.dateBegin}" var="dateEndString" pattern="dd-MM-yyyy" />
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
				<%-- TODO : href="${pageContext.request.contextPath}/user/profileView/${user.id}" --%>
					<div>
						<c:if test="${userInList.id != user.id}">
							<a>
								${userInList.firstName} ${userInList.lastName}
							</a>
						</c:if>
					</div>
				</c:forEach>
			</div>
		</div>
		<jsp:include page="../template/footer.jsp" />
	</body>
</html>