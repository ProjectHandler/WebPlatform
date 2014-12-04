<!DOCTYPE html>
<%@ page session="true"%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html xmlns="http://www.w3.org/1999/xhtml" lang="fr">
	<head>
		<meta charset="utf-8">
		<meta name="viewport" content="width=device-width, initial-scale=1">
		<title>Project Handler</title>
		<spring:url value="/resources/css/main.css" var="maincss"/>
		<link href="${maincss}" rel="stylesheet"/>
	</head>
	<body onload='document.f.j_username.focus();'>
		<div class="fullscreen_wrapper">		
		<div class="fullscreen_wrapper_inner">
			<jsp:include page="template/header.jsp" />
			<section class="login">
				<div class="login_wrapper">
					<form name='f' action="j_spring_security_check" method="post">
						<div class="row"><input type='email' name='j_username' value="" placeholder="Email" title=""/></div>
						<div class="row"><input type='password' name='j_password' value="" placeholder="Password" title=""/></div>
						<div class="row">
							<div class="subrow"><a href="#">Forgot your password ?</a></div>
							<div class="subrow"><button name="submit" type="submit">Login</button></div>
						</div>
						<div class="row">
						<c:if test="${Message != null}">
							<p>${Message}</p>
						</c:if>
						</div>
					</form>
				</div>
			</section>
			<!-- 		<jsp:include page="template/footer.jsp" /> -->
		</div>
		</div>
	</body>
</html>