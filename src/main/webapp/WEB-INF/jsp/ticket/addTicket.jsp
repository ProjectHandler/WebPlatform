<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<html xmlns:th="http://www.thymeleaf.org">
	<head>
		<title>Nouveau ticket</title>
	</head>
<body>
	<jsp:include page="../template/header.jsp" />
	<jsp:include page="../template/menu.jsp" />
	<h1>Nouveau ticket</h1>
	<form:form method="POST" action="${pageContext.request.contextPath}/ticket/save" modelAttribute="ticket">
		<table>
			<tbody>
				<tr>
					<td><form:label path="title">Titre</form:label></td>
					<td><form:input path="title"></form:input></td>
				</tr>
				<tr>
					<td><form:label path="project">Projet</form:label></td>
					<td>
						<form:select path="project">
							<c:forEach items="${projectList}" var="proj">
								<form:option value="${proj.id}">${proj.name}</form:option>
							</c:forEach>
						</form:select>
					</td>
				</tr>
				<tr>
					<td><form:label path="text">Message</form:label></td>
					<td><form:textarea path="text"></form:textarea></td>
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