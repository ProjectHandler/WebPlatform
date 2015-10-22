<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<html xmlns:th="http://www.thymeleaf.org">
	<head>
		<jsp:include page="../template/head.jsp" />

		<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/jquery.tokeninput.min.js"></script>
		<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/tokeninput/token-input-facebook.css">
		<title>Nouveau ticket</title>
		<script type="text/javascript">
		$(document).ready(function () {
		    $("#users").tokenInput("${pageContext.request.contextPath}/ajax/search/${ticket.project.id}/user", {
                theme: "facebook",
                excludeCurrent: true,
                enableHTML:true
            });
		});
		</script>
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
<%-- 				<tr>
					<td><form:label path="project">Projet</form:label></td>
					<td>
						<form:select path="project">
							<form:options items="${projectList}" itemValue="id" itemLabel="name" />
						</form:select>
						<span class="help-inline"><form:errors path="project" /></span>
					</td>
				</tr>
 --%>
				<form:hidden path="project" />
 				<tr>
					<td><form:label path="ticketTracker">Tracker</form:label></td>
					<td>
						<form:select path="ticketTracker">
						    <form:options items="${ticketTrackerList}" itemValue="id" itemLabel="name" />
						</form:select>
					</td>
				</tr>
				<tr>
					<td><form:label path="ticketPriority">Priority</form:label></td>
					<td>
						<form:select path="ticketPriority">
						    <form:options items="${ticketPriorityList}" itemValue="id" itemLabel="name" />
						</form:select>
					</td>
				</tr>
				<tr>
					<td><form:label path="users">Users</form:label></td>
					<td><form:input path="users"></form:input></td>
				</tr>
				<tr>
					<td><form:label path="text">Message</form:label></td>
					<td><form:textarea path="text" id="text-ckeditor"></form:textarea></td>
				</tr>
				<script>
                CKEDITOR.replace( 'text-ckeditor' );
	            </script>
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