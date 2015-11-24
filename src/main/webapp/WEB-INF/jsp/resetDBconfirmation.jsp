<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page session="false"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<html>
	<head>
		<jsp:include page="template/head.jsp" />
		<title>Reset DB</title>
	</head>
	<style>
	#confirm-button {
		color: #FFF;
		background-color: #D9534F;
		border-color: #D43F3A;
		display: inline-block;
		padding: 6px 12px;
		margin-bottom: 0px;
		font-size: 14px;
		font-weight: 400;
		line-height: 1.42857;
		text-align: center;
		white-space: nowrap;
		vertical-align: middle;
		cursor: pointer;
		-moz-user-select: none;
		background-image: none;
		border: 1px solid transparent;
		border-radius: 4px;
	}
	</style>
	<body>
		<jsp:include page="template/header.jsp" />
		<h1>Reset Database</h1>
		<form  method="POST" action="${pageContext.request.contextPath}/debug/reset-db/execute">
			<p>Are you sure you want to permanently delete and repopulate the database ?</p>
			<input id="confirm-button" class="confirm" value="Yes" type="submit">
		</form>

		<jsp:include page="template/footer.jsp" />
	</body>
</html>
