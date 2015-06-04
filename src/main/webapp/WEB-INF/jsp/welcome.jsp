<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page session="true"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<html>
	<head>
		<jsp:include page="template/head.jsp" />
		<title>Project Handler</title>		
	</head>
	<body>
		<jsp:include page="template/header.jsp" />
		<jsp:include page="template/menu.jsp" />
		
		<h1>welcome <spring:message code="${user.civility.name}" text=""/> ${user.firstName} ${user.lastName}</h1>
		<br/>
		${user.userRole}

		<jsp:include page="template/footer.jsp" />
		
		
	</body>
</html>
