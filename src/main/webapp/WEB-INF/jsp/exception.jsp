<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page session="false"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<html>
	<head>
		<jsp:include page="template/head.jsp" />
	</head>

	<body>
		<jsp:include page="template/header.jsp" />
		<jsp:include page="template/menu.jsp" />
		<div class="floatLeft">
			<h2>ERROR:</h2>
			
			Exception: ${exception.message}.
			<c:forEach items="${exception.stackTrace}" var="stackTrace">
				${stackTrace}
			</c:forEach>
			
		</div>
		<jsp:include page="template/footer.jsp" />
	</body>
</html>
