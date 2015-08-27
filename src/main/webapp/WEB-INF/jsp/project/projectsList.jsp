<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<html xmlns:th="http://www.thymeleaf.org">
	<head>
		<jsp:include page="../template/head.jsp" />
		<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/jquery.tablesorter.2.0.5.min.js"></script>
		<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/ticket/tablesorter.css">
		<title><spring:message code="projecthandler.projectsList.title"/></title>
		<script type="text/javascript">
		$(document).ready(function(){

			$("#projectTable").tablesorter();
			
		});
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
							<h1 class="text-h2 util1-primary-text float-left">Liste des projets</h1>
							<div class="text-h2 text-h1 float-right"><span class="icon-folder-open"></span></div>
						</div>
						<div>
	
							<div align="left">
						        <table id="projectTable" class="tablesorter" border="1">
						            <thead>
							            <tr>
							                <th><spring:message code="projecthandler.projectsList.name"/></th>
							                <th><spring:message code="projecthandler.projectsList.description"/></th>
							                <th><spring:message code="projecthandler.projectsList.progress"/></th>
							                <th><spring:message code="projecthandler.projectsList.options"/></th>
							            </tr>
						            </thead>
						            <tbody>
							            <c:forEach var="project" items="${projectList}" varStatus="status">
							                <tr>
							                    <td style="width:10%">
							                    	<c:out value="${project.name}" />
							                    </td>
							                    <td style="width:40%">
							                    	<c:out value="${project.description}" />
							                    </td>
												<td style="width:40%">
												<table>
													<tr>
														<td style="width:10%">
															<label><spring:message code="projecthandler.projectsList.dateProgress"/>:</label>
														</td>
														<td style="width:10%">
															<fmt:formatDate value="${project.dateBegin}" var="dateBeginString" pattern="dd-MM-yyyy" />
															<label>${dateBeginString}</label>
														</td>
														<td style="width:70%">
															<div id="progressDate${project.id}" class="ui-progressbar ui-widget ui-widget-content ui-corner-all" role="progressbar" aria-valuemin="0" aria-valuemax="100" aria-valuenow="0">
																<div class="ui-progressbar-value ui-widget-header ui-corner-left" style="width: ${projectProgressList[status.index].dateProgress}%; background: rgb(0, 128, 255);" >
																	<span style="color:black">${projectProgressList[status.index].dateProgress}%</span>
																</div>
															</div>
														</td>
														<td style="width:10%">
															<fmt:formatDate value="${project.dateEnd}" var="dateEndString" pattern="dd-MM-yyyy" />
															<label>${dateEndString}</label>
														</td>
													</tr>
													<tr>
														<td style="width:10%">
															<label><spring:message code="projecthandler.projectsList.taskProgress"/>:</label>
														</td>
														<td style="width:10%">
															<label></label>
														</td>
														<td style="width:70%">
															<div id="progressTask${project.id}" class="ui-progressbar ui-widget ui-widget-content ui-corner-all" role="progressbar" aria-valuemin="0" aria-valuemax="100" aria-valuenow="0">
																<div class="ui-progressbar-value ui-widget-header ui-corner-left" style="width: ${projectProgressList[status.index].tasksProgress}%; background: rgb(0, 128, 255);" >
																	<span style="color:black">${projectProgressList[status.index].tasksProgress}%</span>
																</div>
															</div>
														</td>
														<td style="width:10%">
															<label></label>
														</td>
													</tr>
												</table>
												</td>
												<td style="width:10%">
													<a class="default-btn-shape theme1-primary-btn-style1" href="${pageContext.request.contextPath}/project/edit/${project.id}">
														<spring:message code="projecthandler.projectsList.edit"/>
													</a>
													<a class="default-btn-shape theme1-primary-btn-style1" href="${pageContext.request.contextPath}/ticket/list/project/${project.id}">
														<spring:message code="projecthandler.projectsList.goToTickets"/>
													</a>
													<a class="default-btn-shape theme1-primary-btn-style1" href="${pageContext.request.contextPath}/project/viewProject/${project.id}">
														<spring:message code="projecthandler.projectsList.goToProjectView"/>
													</a>
													<a class="default-btn-shape theme1-primary-btn-style1" href="${pageContext.request.contextPath}/project/viewProject/${project.id}/tasks">
														<spring:message code="projecthandler.projectView.goToProjectTasksView"/>
													</a>
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
	</div>
	<jsp:include page="../template/footer.jsp" />
</body>
</html>