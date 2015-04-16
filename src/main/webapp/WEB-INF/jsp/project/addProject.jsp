<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<html xmlns:th="http://www.thymeleaf.org">
	<head>
		<jsp:include page="../template/head.jsp" />
		<title>Nouveau projet</title>
	</head>
<body>
	<jsp:include page="../template/header.jsp" />
	<jsp:include page="../template/menu.jsp" />
	<h1>Nouveau project</h1>
	<form:form method="POST" action="${pageContext.request.contextPath}/project/save" modelAttribute="project">
		<table>
			<tbody>
				<tr>
					<td><form:label path="name">Nom</form:label></td>
					<td><form:input path="name"></form:input></td>
				</tr>
				<tr>
					<td><form:label path="description">Description</form:label></td>
					<td><form:textarea path="description"></form:textarea></td>
				</tr>
				<tr>
					<td><form:label path="dateBegin">Date de début:</form:label></td>
					<fmt:formatDate value="${project.dateBegin}" var="dateBeginString" pattern="yyyy-MM-dd" />
					<td><form:input path="dateBegin" type="date" value="${dateBeginString}"/></td>
				</tr>
				<tr>
					<td><form:label path="dateEnd">Date de fin:</form:label></td>
					<fmt:formatDate value="${project.dateBegin}" var="dateEndString" pattern="yyyy-MM-dd" />
					<td><form:input path="dateEnd" type="date" value="${dateEndString}"/></td>
				</tr>
				<tr>
					<td colspan="2"><input value="Submit" type="submit">
					</td>
				</tr>
			</tbody>
		</table>
	</form:form>
 	<jsp:include page="../template/footer.jsp" />
</body>
</html>