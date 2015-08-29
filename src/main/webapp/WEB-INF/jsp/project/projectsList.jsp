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
			<div class="display-table-cell full-width full-height position-relative">
				
				<div class="position-absolute position-top position-left full-width full-height overflow-auto">
					<div class="container">
						<div class="margin-bottom clearfix">
							<h1 class="text-h2 util1-primary-text float-left">Liste des projets</h1>
							<div class="text-h2 text-h1 float-right"><span class="icon-folder-open"></span></div>
						</div>
						<div>
				            <c:forEach var="project" items="${projectList}" varStatus="status">
				                <div class="inverted-bg theme3-primary-boxshadow-raising-out margin-bottom margin-right float-left fixedwidth-256">
				                    
				                    <div class="small-container display-table">
				                    	<div class="text-center display-table-cell vertical-align">
					                    	<div class="display-inline-block">
					                    		<div class="fixedwidth-64 fixedheight-64 theme3-lighten1-bg theme3-darken1-text circle margin-auto text-h3">
					                    			<div class="display-table full-width full-height">
					                    				<div class="display-table-cell vertical-align full-width full-height">
															<span class="icon-folder"></span>
														</div>
													</div>
												</div>
											</div>
										</div>
										<div class=" display-table-cell vertical-align ful-width small-padding-left">
					                    	<h3 class="text-capitalize text-p">${project.name}</h3>
											<div class="small theme3-primary-text">${project.status}</div>
										</div>
				                    </div>
				                    
				                    <c:if test="${user.userRole == 'ROLE_ADMIN'}">
			                    	<a class="reduced-btn-shape rounded util5-primary-btn-style1 small float-right" style="margin-top:-8px;margin-right:10px;" href="${pageContext.request.contextPath}/project/edit/${project.id}">
										<span class="icon-pencil2"> </span><spring:message code="projecthandler.projectsList.edit"/>
									</a>
									</c:if>

									<div class="small-container theme3-lighten1-bg">
										<div class="fixedwidth-192 margin-auto">
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
									<div class="small-container padding-top">									
										<div class="small-margin-bottom">
											<div class="display-table-cell vertical-align theme3-darken1-text small"><div class="fixedwidth-64 text-left">Deadline</div></div>	
											<div id="progressDate${project.id}" class="display-table-cell vertical-align full-width hard-surrounded theme3-lighten1-bdr rounded theme3-lighten1-bg" role="progressbar" aria-valuemin="0" aria-valuemax="100" aria-valuenow="0">
												<div class="surrounded rounded theme3-darken1-bdr theme3-darken1-bg" style="width: ${projectProgressList[status.index].dateProgress}%;" ></div>
											</div>
											<div class="display-table-cell vertical-align theme3-darken1-text small"><div class="text-right" style="width:45px;">${projectProgressList[status.index].dateProgress}%</div></div>	
										</div>
										<div>
											<div class="display-table-cell vertical-align theme3-darken1-text small"><div class="fixedwidth-64 text-left">Avancée</div></div>	
											<div id="progressTask${project.id}" class="display-table-cell vertical-align full-width hard-surrounded theme3-lighten1-bdr rounded theme3-lighten1-bg" role="progressbar" aria-valuemin="0" aria-valuemax="100" aria-valuenow="0">
												<div class="surrounded rounded theme3-darken1-bdr theme3-darken1-bg" style="width: ${projectProgressList[status.index].tasksProgress}%;" ></div>
											</div>
											<div class="display-table-cell vertical-align theme3-darken1-text small"><div class="text-right" style="width:45px;">${projectProgressList[status.index].tasksProgress}%</div></div>	
										</div>
									</div>
									<div class="small-container">
										<a class="display-block full-width text-center small small-margin-bottom default-btn-shape theme3-primary-btn-style1" href="${pageContext.request.contextPath}/project/viewProject/${project.id}">
											<spring:message code="projecthandler.projectsList.goToProjectView"/>
										</a>
										<a class="display-block full-width text-center small small-margin-bottom default-btn-shape theme3-primary-btn-style1" href="${pageContext.request.contextPath}/ticket/list/project/${project.id}">
											<spring:message code="projecthandler.projectsList.goToTickets"/>
										</a>
										<a class="display-block full-width text-center small default-btn-shape theme3-primary-btn-style1" href="${pageContext.request.contextPath}//project/viewProject/${project.id}/tasks">
											<spring:message code="projecthandler.projectView.goToProjectTasksView"/>
										</a>
									</div>
									
								 </div>
				            </c:forEach>
						</div>
					</div>	
				</div>	
			</div>
		</div>		
	</body>
</html>
