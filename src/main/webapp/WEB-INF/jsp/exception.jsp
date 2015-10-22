<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page session="false"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<html>
	<head>
		<jsp:include page="template/head.jsp" />
		<title><spring:message code="projecthandler.general.error"/></title>

	</head>

	<body>
		<jsp:include page="template/header.jsp" />
		
		<div class="">
			<h1><spring:message code="projecthandler.exception.title"/></h1>
			<br>
			<span><spring:message code="projecthandler.exception.requestURI"/>:</span>
			${requestURI}
			<br>
			<span><spring:message code="projecthandler.exception.message"/>:</span>
			${exception.message}
			<br>
			<span><spring:message code="projecthandler.exception.stackTrace"/>:</span>
			<c:forEach items="${exception.stackTrace}" var="stackTrace">
				${stackTrace}
				<br>
			</c:forEach>
		</div>
		<jsp:include page="template/footer.jsp" />
	</body>
</html>
