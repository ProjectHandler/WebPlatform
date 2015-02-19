<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<html xmlns:th="http://www.thymeleaf.org">
	<head>
		<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/jquery-1.11.1.min.js"></script>
		<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/jquery.tablesorter.2.0.5.min.js"></script>
		<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/ticket/tablesorter.css">
		<title>Mes projets</title>
				<script type="text/javascript">
		$(document).ready(function()
			    {
			        $("#projectTable").tablesorter();
			    }
		);
		</script>
	</head>
<body>
	<jsp:include page="../template/header.jsp" />
	<jsp:include page="../template/menu.jsp" />
	<h1>Mes Projets</h1>
	<div align="left" style="width:40%; min-width:400px">
        <table id="projectTable" class="tablesorter" border="1">
            <thead>
	            <tr>
	                <th>Nom</th>
	                <th>Date de début</th>
	                <th>Date de fin</th>
	                <th></th>
	            </tr>
            </thead>
            <tbody>
	            <c:forEach var="project" items="${projectList}">
	                <tr>
	                    <td><c:out value="${project.name}" /></td>
	                    <td><c:out value="${project.dateBegin}" /></td>
	                    <td><c:out value="${project.dateEnd}" /></td>
						<td><a href="${pageContext.request.contextPath}/ticket/list/project/${project.id}">List des tickets du projet</a></td>
	                </tr>
	            </c:forEach>
            </tbody>
        </table>
    </div>
 	<jsp:include page="../template/footer.jsp" />
</body>
</html>