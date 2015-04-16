<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<html xmlns:th="http://www.thymeleaf.org">
	<head>
		<jsp:include page="../template/head.jsp" />
		<title>Ticket</title>
		<style>
			.ticket-message-fisrt {
			border: solid 5px #262529;
			-moz-border-radius: 7px;
			-webkit-border-radius: 7px;
			border-radius: 7px;
			background-color: #EFEFEF;
			margin-top: 8px;
			margin-bottom: 8px;
			font-family: verdana, sans-serif;
			max-width: 80%;
			padding:10px;
			font-size:110%;
		}
		.ticket-message {
			border: solid 2px #262529;
			-moz-border-radius: 7px;
			-webkit-border-radius: 7px;
			border-radius: 7px;
			background-color: #F8F8E8;
			margin-bottom: 8px;
			font-family: verdana, sans-serif;
			max-width: 80%;
			padding:10px;
		}
		.ticket-messages {
			margin-left: 40px;
		}
		.ticket-new-message {
			border: solid 2px #262529;
			-moz-border-radius: 7px;
			-webkit-border-radius: 7px;
			border-radius: 7px;
			background-color: white;
			margin-top: 8px;
			font-family: verdana, sans-serif;
			min-width: 40%;
			padding: 10px;
			display: block;
			margin-bottom:20px;
		}
		.ticket-new-message:focus {
			outline:0px none transparent;
		}
		.ticket-message-info {
			margin-top:4px;
			text-align:right;
			display:block;
			font-size:80%;
		}
		.new-message-submit {
			margin-bottom: 20px;
		}
		</style>
	</head>
<body>
	<jsp:include page="../template/header.jsp" />
	<jsp:include page="../template/menu.jsp" />
	<span><a href="${pageContext.request.contextPath}/ticket/list/project/${ticket.project.id}">Retour vers la liste des tickets du projet</a></span>
	<h1>Ticket</h1>
	<h2>Titre: ${ticket.title}</h2>
	<p class="ticket-message-fisrt">
		${ticket.text}
		<span class="ticket-message-info">
			Auteur: ${ticket.user.firstName} ${ticket.user.lastName} Date:
			<fmt:formatDate value="${ticket.createdAt}" type="both" pattern="dd-MM-yyyy HH:mm" />
		</span>
	</p>
	<div class="ticket-messages">
		<c:forEach items="${ticketMessages}" var="message">
			<div class="ticket-message">
				${message.text}
				<span class="ticket-message-info">
					Auteur: ${message.user.firstName}  ${message.user.lastName}
					Date: <fmt:formatDate value="${message.createdAt}" type="both" pattern="dd-MM-yyyy HH:mm" />
				</span>
			</div>
		</c:forEach>
		 	<form:form class="message-form" method="POST" action="${pageContext.request.contextPath}/ticket/${ticket.id}/message/save" modelAttribute="ticketMessage">
			<form:label path="text">Nouveau message</form:label>
			<form:textarea class="ticket-new-message" path="text"></form:textarea>
			<input class="new-message-submit" value="Submit" type="submit">
		</form:form>
	</div>
   	<jsp:include page="../template/footer.jsp" />
</body>
</html>