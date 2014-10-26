<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page session="false"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<html>
	<head>
		<script type="text/javascript">
		</script>
	</head>
	<body>
		<h1>welcome ${user.firstName} ${user.lastName}</h1> 
		<br/>
		${user.userRole}
		<br/>
		<br/>
		<a href="<c:url value="/signupSendMailService"/>">signupSendMailService</a>
		<br/>
		<a href="<c:url value="/j_spring_security_logout"/>">logout</a>	
	</body>
</html>
