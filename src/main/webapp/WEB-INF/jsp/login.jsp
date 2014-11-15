<!DOCTYPE html>
<%@ page session="true"%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html xmlns="http://www.w3.org/1999/xhtml" lang="fr">
	<head>
		
	</head>
	<body onload='document.f.j_username.focus();'>
		<jsp:include page="template/header.jsp" />
		<article class="login">
			<h1>Login</h1>
			<form name='f' action="j_spring_security_check" method="post">
				<fieldset>
					<table>
						<tr>
							<td>Email:</td>
							<td><input type='text' name='j_username' value=''/></td>
							<td>(bruce.wayne@batman.com)</td>
						</tr>
						<tr>
							<td>Password:</td>
							<td><input type='password' name='j_password' /></td>
							<td>(1234)</td>
						</tr>
						<tr>
							<td colspan='2'><button name="submit" type="submit">Connect</button></td>
						</tr>
						<tr>
							<c:if test="${Message != null}">
								<td></td>
								<td></td>
								<td>${Message}</td>
							</c:if>
						</tr>
					</table>
				</fieldset>
			</form>
		</article>
		<jsp:include page="template/footer.jsp" />
	</body>
</html>
