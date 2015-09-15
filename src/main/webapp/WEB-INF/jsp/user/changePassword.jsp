<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>

<html lang="fr">
	<head>
		<jsp:include page="../template/head.jsp" />
		<title>Changement de mot de passe</title>
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
	<div class="display-table full-width full-height">
			<div class="display-table-row">
				<jsp:include page="../template/header.jsp" />
			</div>
			<div class="display-table full-width full-height">
				<div class="display-table-cell full-height theme1-primary-bg">
					<div class="fixedwidth-320">
						<h1 class="text-h2 container inverted-text"><span class="icon-user margin-right"></span>Mon profil</h1>
						<hr class="inverted-bg">
						<a class="container display-block full-width inverted-text default-btn-style5" href="<c:url value="/signup"/>"><span class="icon-profile margin-right"></span>Mes informations personnelles</a>
						<hr class="inverted-bg">
						<a class="container display-block full-width inverted-text default-btn-style5" href="<c:url value="/changePassword"/>"><span class="icon-key margin-right"></span>Mon mot de passe</a>
						<hr class="inverted-bg">	
					</div>
				</div>
				<div class="display-table-cell full-width full-height">
					
					<div class="full-width full-height position-relative">
						
						<div class="position-absolute position-top position-left full-width full-height overflow-auto">
							<div class="container">
								<div class="margin-bottom clearfix">
									<h1 class="text-h2 util1-primary-text float-left">Mon mot de passe</h1>
									<div class="text-h2 text-h1 float-right"><span class="icon-key"></span></div>
								</div>
								<div>
	
									<c:if test="${isPasswordChanged == true}">
										<p>Votre mot de passe a bien été enregistré.<p>
									</c:if>
									<form id="passwordForm" name="passwordForm" method="post">
										<input type="hidden" name="userId" id="userId" value="${user.id}"/>
										<ul class="form">
											<li class="small-margin-bottom">
												<div class="display-table-cell fixedwidth-192 vertical-align">
													<label><spring:message code="projecthandler.changePassword.newPassword"/><spring:message code="projecthandler.field.required"/></label>
												</div>
												<div class="display-table-cell vertical-align">
													<input type="password" name="password" class="textfield surrounded fixedwidth-192 theme3-primary-bdr" id="password" autocomplete="off" maxlength="70"/>
												</div>
												<span class="error" id="passwordError"></span>
												<p id="mdpInfo"><spring:message code="projecthandler.password.syntax"/></p>
											</li>
											<li class="small-margin-bottom">
												<div class="display-table-cell fixedwidth-192 vertical-align">
													<label><spring:message code="projecthandler.signup.passwordConfirm"/><spring:message code="projecthandler.field.required"/></label>
												</div>
												<div class="display-table-cell vertical-align">
													<input type="password" name="passwordConfirm" class="textfield surrounded fixedwidth-192 theme3-primary-bdr" id="passwordConfirm" autocomplete="off" maxlength="70"/>
												</div>
												<span class="error" id="passwordConfirmError"></span>
											</li>
										</ul>
									</form>
									<button id="btnSave" class="default-btn-shape theme2-primary-btn-style1"><span class="icon-checkmark small-margin-right"></span><spring:message code="projecthandler.signup.create" /></button>
								</div>
							</div>	
						</div>	
					
					</div>
				</div>
			</div>		
		</div>	
	</body>
</html>
