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
	<jsp:include page="../template/header.jsp" />
	<jsp:include page="../template/menu.jsp" />
	<h1><spring:message code="projecthandler.projectsList.title"/></h1>
	<form action="${pageContext.request.contextPath}/project/edit">
    	<input type="submit" value="<spring:message code="projecthandler.projectsList.buttonNew"/>">
	</form>
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
							<form action="${pageContext.request.contextPath}/project/edit/${project.id}">
    							<input type="submit" value="<spring:message code="projecthandler.projectsList.edit"/>">
							</form>
							<form action="${pageContext.request.contextPath}/ticket/list/project/${project.id}">
    							<input type="submit" value="<spring:message code="projecthandler.projectsList.goToTickets"/>">
							</form>
						</td>
	                </tr>
	            </c:forEach>
            </tbody>
        </table>
    </div>
 	<jsp:include page="../template/footer.jsp" />
</body>
</html>