<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page session="false"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>

<html lang="fr">
	<head>
		<title>Home</title>
		<script type="text/javascript">
		
		
		
		</script>
	</head>
	<body>
	
		<h1>Project Handler</h1>
		

		
		
		<br>
		<label><spring:message code="projecthandler.user.firstName"/> <c:out value="${user.firstName}"/>   
		<br>
		<spring:message code="projecthandler.user.lastName"/> <c:out value="${user.lastName}"/>   
		<br>
		<spring:message code="projecthandler.user.email"/> <c:out value="${user.email}"/></label>
		<br>


		<a href="signup"><spring:message code="projecthandler.signup.link"/></a>

	
	
	</body>
</html>
