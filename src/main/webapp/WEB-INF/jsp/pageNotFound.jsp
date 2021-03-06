<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page session="false"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<html>
	<head>
		<jsp:include page="template/head.jsp" />
		<title><spring:message code="projecthandler.general.pageNotFound"/></title>
	</head>
	<body>
		<jsp:include page="template/header.jsp" />
		
		<h1><spring:message code="projecthandler.general.pageNotFound"/></h1>

		<jsp:include page="template/footer.jsp" />
	</body>
</html>
