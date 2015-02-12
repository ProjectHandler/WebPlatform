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
	<h1>Liste des tickets du projet</h1>
		<table style="width:100%">
						<tr>
						<th>Titre</th>
						<th>Auteur</th>
						<th>Date</th>
		</tr>
			<c:forEach items="${ticketList}" var="ticket">
				<tr>
					<td><a href="${pageContext.request.contextPath}/ticket/${ticket.id}/messages">${ticket.title}</a></td>
					<td>${ticket.user.firstName}  ${ticket.user.lastName}</td></td>
					<td><fmt:formatDate value="${ticket.createdAt}" type="both" pattern="dd-MM-yyyy HH:mm" /></td>
					</tr>
			</c:forEach>
	</table>
 	<jsp:include page="../template/footer.jsp" />
</body>
</html>