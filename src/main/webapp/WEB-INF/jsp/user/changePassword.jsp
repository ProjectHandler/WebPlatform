<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>

<html lang="fr">
	<head>
		<title>Changement de mot de passe</title>
		<spring:url value="/resources/js/jquery-1.11.1.js" var="jquery"/>
		<script type="text/javascript" src="${jquery}"></script>
		<spring:url value="/resources/js/jquery.inputmask.js" var="jqueryMask"/>
		<script type="text/javascript" src="${jqueryMask}"></script>
		<spring:url value="/resources/js/chosen.jquery.js" var="jqueryChosen"/>
		<script type="text/javascript" src="${jqueryChosen}"></script>
		<script type="text/javascript">
		var CONTEXT_PATH = "<%=request.getContextPath() %>";
		
		$(document).ready(function() {
		
			$("#btnSave").click(function(e) {
				$("#emailError").html("");
				if(checkDataBeforeSaveUser() && confirm("Etes-vous sûr de vouloir modifier votre mot de passe ?")) {
 					$("#passwordForm").attr("action", CONTEXT_PATH+"/changePassword");
 					$("#passwordForm").submit();
				}
			});


			$("#password").focusout(function() {
				validatePassword();
			});
			$("#passwordConfirm").focusout(function() {
				validatePasswordConfirm();
			});
		});
		
		
		function validatePassword(){
			var password = $("#password").val();
			$("#passwordError").html("");
			if(password == null || password.length == 0 || (password.length > 0 && !isValidPassword(password))){
				$("#passwordError").html("");
				$("#passwordError").html('<spring:message javaScriptEscape="true" code="projecthandler.signup.error.password"/>');
				return false;
			}
			return true;
		}

		function validatePasswordConfirm(){
			var password = $("#password").val();
			var passwordConfirm = $("#passwordConfirm").val();
			$("#passwordConfirmError").html("");
			if(passwordConfirm == null || passwordConfirm.length == 0 || passwordConfirm != password){
				$("#passwordConfirmError").html('<spring:message javaScriptEscape="true" code="projecthandler.signup.error.passwordConfirm"/>');
				return false;
			}
			return true;
		}
		
		

		function isValidPassword(password) {
			var pattern = new RegExp(/^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])[0-9a-zA-Z!£\$\%\^&\*()_/\-\+\{\}~#\]\[\:\;@<>?,\|\\`€=§.?µ¨²]{8,}$/);
			return pattern.test(password);
		}
		
		function checkDataBeforeSaveUser() {
			var valid = true;
			if (!validatePassword())
			valid = false;
			if (!validatePasswordConfirm())
				valid = false;
			return valid;
		}
		
		</script>
	</head>
	<body>
		<jsp:include page="../template/header.jsp" />
		<jsp:include page="../template/menu.jsp" />
		<h1>Changement de mot de passe</h1>
		<br/>
		<c:if test="${isPasswordChanged == true}">
			<p>Votre mot de passe a bien été enregistré.<p>
		</c:if>
		<form id="passwordForm" name="passwordForm" method="post">
			<input type="hidden" name="userId" id="userId" value="${user.id}"/>
			<ul class="form">
				<li>
					<label><spring:message code="projecthandler.changePassword.newPassword"/><spring:message code="projecthandler.field.required"/></label>
					<input type="password" name="password" id="password" autocomplete="off" maxlength="70"/>
					<span class="error" id="passwordError"></span>
					<p id="mdpInfo"><spring:message code="projecthandler.password.syntax"/></p>
				</li>
				<li>
					<label><spring:message code="projecthandler.signup.passwordConfirm"/><spring:message code="projecthandler.field.required"/></label>
					<input type="password" name="passwordConfirm" id="passwordConfirm" autocomplete="off" maxlength="70"/>
					<span class="error" id="passwordConfirmError"></span>
				</li>
			</ul>
		</form>
		<br/>
		<button id="btnSave"><spring:message code="projecthandler.signup.create" /></button>
		<br/>
		<a href="/projecthandler/"><spring:message code="projecthandler.signup.home"/></a>
		
		<jsp:include page="../template/footer.jsp" />
	</body>
</html>
