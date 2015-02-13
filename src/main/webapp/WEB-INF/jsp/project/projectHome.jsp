<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<html xmlns:th="http://www.thymeleaf.org">
	<head>
		<title>Mes projets</title>
	</head>
<body>
	<jsp:include page="../template/header.jsp" />
	<jsp:include page="../template/menu.jsp" />
	<h1>Mes Projets</h1>
	<div align="left">
        <table border="1">
            <tr>
                <th>Nom</th>
                <th>Date de début</th>
                <th>Date de fin</th>
            </tr>
            <c:forEach var="project" items="${projectList}">
                <tr>
                    <td><c:out value="${project.name}" /></td>
                    <td><c:out value="${project.dateBegin}" /></td>
                    <td><c:out value="${project.dateEnd}" /></td>
                </tr>
            </c:forEach>
        </table>
    </div>
 	<jsp:include page="../template/footer.jsp" />
</body>
</html>