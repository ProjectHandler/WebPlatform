<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page session="true"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<html>
	<head>
		<meta charset="utf-8">
		<meta name="viewport" content="width=device-width, initial-scale=1">
		<spring:url value="/resources/css/redcss.css" var="redcss"/>
		<link href="${redcss}" rel="stylesheet"/>
		<spring:url value="/resources/img/icon.png" var="windowicon"/>
		<link href="${windowicon}" rel="icon" type="image/png"/>
		<title>Project Handler</title>		
	</head>
	<body>
		<jsp:include page="template/header.jsp" />
		<jsp:include page="template/menu.jsp" />
		
		<h1>welcome ${user.civility} ${user.firstName} ${user.lastName}</h1> 
		<br/>
		${user.userRole}

		<jsp:include page="template/footer.jsp" />
		
		<script src="${pageContext.request.contextPath}/resources/js/jquery-1.11.1.min.js"></script>
		<script src="${pageContext.request.contextPath}/resources/js/redcss.js"></script>
	</body>
</html>
