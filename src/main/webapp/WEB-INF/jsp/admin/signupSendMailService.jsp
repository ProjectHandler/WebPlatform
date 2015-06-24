<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<html>
	<head>
		<jsp:include page="../template/head.jsp" />


		<script type="text/javascript">		
		$(document).ready(function() {
			$('#email').autosize();
			
			$("#btnSend").click(function(e) {
				if (checkInput())
					$.ajax({
						type: "POST",
						url:  CONTEXT_PATH+"/checkEmailExists?"+"email="+$("#email").val(),
						success: function(data) {
							if(data == "OK"){
								$("#emailOk").html('<spring:message javaScriptEscape="true" code="projecthandler.admin.sendMailService.sending"/>');
								sendEmails();
							}else{
								$("#emailError").html(data);
							}
						}, error: function (xhr, ajaxOptions, thrownError) {
							alert(xhr.responseText);
						}
					});
			});
		});
		
		
		function checkInput() {
			$("#emailError").html("");
			
			var email = $("#email").val();
			if (email == null || email.length == 0) {
				$("#emailError").html('<spring:message javaScriptEscape="true" code="projecthandler.signup.error.inputEmpty"/>');
				return false;
			}
			var pattern = new RegExp(/^[^<>%$]*$/);	
			if (!pattern.test(email)) {
				$("#emailError").html('<spring:message javaScriptEscape="true" code="projecthandler.signup.error.characterNotAllowed"/>');
				document.getElementById("btnSend").disabled = true; 
				return false;
			} else {
				document.getElementById("btnSend").disabled = false;
				return true;
			}
		}
		
		function sendEmails() {
			$("#emailForm").attr("action", CONTEXT_PATH+"/admin/sendEmail");
			$("#emailForm").submit();
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
					<sec:authorize access="hasRole('ROLE_ADMIN')">
						<h1 class="padding-top padding-bottom text-center inverted-text"><span class="icon-database margin-right"></span>Administration</h1>
						<hr class="inverted-bg">
						<a class="container display-block full-width inverted-text default-btn-style5" href="<c:url value="/admin/groups_management"/>"><span class="icon-tree small-margin-left margin-right"></span>Administration des groupes</a>
						<hr class="inverted-bg">
						<a class="container display-block full-width inverted-text default-btn-style5" href="<c:url value="/admin/users_management"/>"><span class="icon-users small-margin-left margin-right"></span>Administration des utilisateurs</a>
						<hr class="inverted-bg">
						<a class="container display-block full-width inverted-text default-btn-style5" href="<c:url value="/admin/signupSendMailService"/>"><span class="icon-user-plus small-margin-left margin-right"></span>Inscrire un utilisateur</a>
						<hr class="inverted-bg">
					</sec:authorize>	
					</div>
				</div>
				<div class="display-table-cell full-width full-height">
					
					<div class="full-width full-height overflow-auto">
						<div class="container">
							<div class="margin-bottom clearfix">
								<h1 class="util1-primary-text float-left">Inscrire un utilisateur</h1>
								<div class="text-h1 float-right"><span class="icon-user-plus"></span></div>
							</div>
							<div>
								<h2 class="small-margin-bottom"><spring:message code="projecthandler.admin.sendMailService.title"/></h2>
								<div class="fixedmaxwidth-384">
									<form name="emailForm" id="emailForm" method="post" >
										<textarea rows="3" name="email" id="email" maxlength="1024" onKeyUp="checkInput()" class="textfield fixedmaxwidth-384 surrounded theme3-primary-bdr" placeholder="Your email here ..."></textarea>
									</form>
									<div class="util6-primary-text text-right" id="emailError"></div>
									<div class="util3-primary-text text-right" id="emailOk"></div>
								</div>
								<button id="btnSend" class="margin-top default-btn-shape util3-primary-btn-style1"><span class="icon-mail2 small-margin-right"></span><spring:message code="projecthandler.admin.sendMailService.send"/></button>						
							</div>
						</div>	
					</div>					
				</div>
			</div>		
		</div>
	</body>
</html>