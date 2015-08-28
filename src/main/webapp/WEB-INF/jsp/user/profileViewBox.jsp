<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<html xmlns:th="http://www.thymeleaf.org">
	<head>
		<jsp:include page="../template/head.jsp" />
		<title><spring:message code="projechandler.profileViewBox.title"/></title>
	</head>
	<body>
		<div>
			<spring:message code="projecthandler.user.firstName"/>: ${userToFind.civility.name}  ${userToFind.firstName} 
			<spring:message code="projecthandler.user.lastName"/>: ${userToFind.lastName}
		</div>
		<div>
			<spring:message code="projecthandler.user.role"/>: ${userToFind.userRole}
			<spring:message code="projecthandler.user.status"/>: ${userToFind.accountStatus}
		</div>
		<div>
			<spring:message code="projecthandler.user.email"/>: 
			<a href="mailto:${userToFind.email}">${userToFind.email}</a>
		</div>
		<div>
			<spring:message code="projechandler.projectView.title"/>:
			<c:forEach var="project" items="${userToFind.projects}">
				<div>
					${project.name}
				</div>
			</c:forEach>
		</div>
	</body>
</html>