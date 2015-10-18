<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<html>
	<head>
		<jsp:include page="template/head.jsp" />
	</head>
	<body>
		<jsp:include page="template/header.jsp" />
		<sec:authorize access="isAuthenticated()">
			<jsp:include page="template/menu.jsp" />
		<h1> access denied </h1>
		</sec:authorize>
		<jsp:include page="template/footer.jsp" />
	</body>
</html>
