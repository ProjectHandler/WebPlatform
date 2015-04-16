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
								$("#emailError").html('<spring:message javaScriptEscape="true" code="projecthandler.admin.sendMailService.sending"/>');
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
		<jsp:include page="../template/header.jsp" />
		<jsp:include page="../template/menu.jsp" />
		
		<h1><spring:message code="projecthandler.admin.sendMailService.title"/></h1> 
		<br/>
		<spring:message code="projecthandler.admin.sendMailService.here"/>
		<form name="emailForm" id="emailForm" method="post" >
			<textarea style="resize: none" rows="3" cols="102" name="email" id="email" maxlength="1024" onKeyUp="checkInput()"></textarea>
			<span class="error" id="emailError"></span>
		</form>
		<button id="btnSend"><spring:message code="projecthandler.admin.sendMailService.send"/></button>
		<br/>
		<br/>
		<a href="<c:url value="/"/>"><spring:message code="projecthandler.home"/></a>
		<br/>
		<a href="<c:url value="/j_spring_security_logout"/>"><spring:message code="projecthandler.menu.logout"/></a>
		<jsp:include page="../template/footer.jsp" />
	</body>
</html>