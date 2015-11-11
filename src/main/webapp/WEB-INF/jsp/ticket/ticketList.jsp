<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@taglib prefix="e" uri="https://www.owasp.org/index.php/OWASP_Java_Encoder_Project" %>
<html xmlns:th="http://www.thymeleaf.org">
	<head>
		<jsp:include page="../template/head.jsp" />
		<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/jquery.tablesorter.2.0.5.min.js"></script>
		<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/ticket/tablesorter.css">
		<title>Liste des tickets</title>
		<script type="text/javascript">
		$(document).ready(function()
			    {
			        $("#ticketTable").tablesorter({
/* 			        	dateFormat : "ddmmyyyy",
			            headers: {
			                2: { sorter: "shortDate" }
			              }
 */			        });
					$(".comfirm-delete").submit(function () {
						return confirm('<spring:message code="projecthandler.project.edit.deleteConfirm"/>');
					});
			    }
		);
		</script>
		<style>
		.center {
		  position: relative;
		  top: 0;
		  right: 0;
		  bottom: 0;
		  left: 0;
		  margin: auto;
		  width:80%;
		}
		</style>
	</head>
<body>
	<jsp:include page="../template/header.jsp" />
	<jsp:include page="../template/menu.jsp" />
	<a href="${pageContext.request.contextPath}/ticket/new/${projectId}">Créer un nouveau ticket</a>
	<h1>Liste des tickets du projet</h1>
	<div class="center">
		<table id="ticketTable"  class="tablesorter" style="">
			<thead>
				<tr>
					<th>Titre</th>
					<th>Auteur</th>
					<th>Date</th>
					<th>Statut</th>
				</tr>
			</thead>
			<tbody>
				<c:forEach items="${ticketList}" var="ticket">
					<tr>
						<td><a href="${pageContext.request.contextPath}/ticket/${ticket.id}/messages">${e:forHtml(ticket.title)}</a></td>
						<td>${e:forHtml(ticket.user.firstName)} ${e:forHtml(ticket.user.lastName)}</td>
						<td><fmt:formatDate value="${ticket.createdAt}" type="both" pattern="MM-dd-yyyy HH:mm" /></td>
						<td><spring:message javaScriptEscape="true" code="projecthandler.ticket.status.${ticket.ticketStatus.value}"/></td>
						<td colspan="2">
							<form method="POST" class="comfirm-delete" action="${pageContext.request.contextPath}/ticket/delete">
									<input type="hidden" name="ticketId" id="ticketId" value="${ticket.id}"/>
									<input value="Delete" type="submit">
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