<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page session="false"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="e" uri="https://www.owasp.org/index.php/OWASP_Java_Encoder_Project" %>

<html>
	<head>
		<jsp:include page="template/head.jsp" />
		<title><spring:message code="projecthandler.general.error"/></title>
		<script type="text/javascript">
			$(document).ready(function() {
				// need to add a button for hide or show the stacktrace
				$("#stackTraceContainer").hide();
			});
		</script>
	</head>

	<body>
		<jsp:include page="template/header.jsp" />
		
		<div class="">
			<h1><spring:message code="projecthandler.exception.title"/></h1>
			<br>
			<span><spring:message code="projecthandler.exception.requestURI"/>:</span>
			${e:forHtml(requestURI)}
			<br>
			<span><spring:message code="projecthandler.exception.message"/>:</span>
			${e:forHtml(exception.message)}
			<br>
			<div id="stackTraceContainer">
				<span><spring:message code="projecthandler.exception.stackTrace"/>:</span>
				<c:forEach items="${exception.stackTrace}" var="stackTrace">
					${e:forHtml(stackTrace)}
				</c:forEach>
			</div>
		</div>
		<jsp:include page="template/footer.jsp" />
	</body>
</html>
