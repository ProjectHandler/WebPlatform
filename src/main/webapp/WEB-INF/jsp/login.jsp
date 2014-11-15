<!DOCTYPE html>
<%@ page session="true"%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html xmlns="http://www.w3.org/1999/xhtml" lang="fr">
	<head>
		<meta charset="utf-8">
		<meta http-equiv="X-UA-Compatible" content="IE=edge">
		<meta name="viewport" content="width=device-width, initial-scale=1">
		<title>Project Handler</title>
		<meta name="description" content="">
		<meta name="author" content="">
		<link rel="icon" href="">
		<spring:url value="/resources/css/home.css" var="homecss"/>
		<link href="${homecss}" rel="stylesheet"/>
	</head>
	<body onload='document.f.j_username.focus();'>
		<!-- <jsp:include page="template/header.jsp" /> -->
		<div class="home_wrapper">		
		<div class="home_wrapper_inner">
			<article class="login">
				<div class="login_wrapper">
					<form name='f' action="j_spring_security_check" method="post">
						<div class="row"><input type='email' name='j_username' value="" placeholder="Email" title="(bruce.wayne@batman.com)"/></div>
						<div class="row"><input type='password' name='j_password' value="" placeholder="Password" title="(1234)"/></div>
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
			</article>
		</div>
		</div>
<!-- 		<jsp:include page="template/footer.jsp" /> -->
	</body>
</html>