<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<html>
	<head>
		<spring:url value="/resources/js/jquery-1.11.1.js" var="jquery"/>
		<script type="text/javascript" src="${jquery}"></script>
		<spring:url value="/resources/js/jquery.inputmask.js" var="jqueryMask"/>
		<script type="text/javascript" src="${jqueryMask}"></script>
		<spring:url value="/resources/js/chosen.jquery.js" var="jqueryChosen"/>
		<script type="text/javascript" src="${jqueryChosen}"></script>

		<script type="text/javascript">
		var CONTEXT_PATH = "<%=request.getContextPath() %>";
		
		$(document).ready(function() {
			
		$("#btnSend").click(function(e) {
			$("#emailError").html("");
			$.ajax({
				type: "POST",
				url:  CONTEXT_PATH+"/checkEmailExists?"+"email="+$("#email").val(),
				success: function(data) {
					if(data == "OK"){
						$("#emailError").html('Envoie en cours...');
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
		
		function sendEmails() {
			$("#emailForm").attr("action", CONTEXT_PATH+"/admin/sendEmail");
			$("#emailForm").submit();
		}
		
		</script>
	</head>
	<body>
		<jsp:include page="template/header.jsp" />
		<jsp:include page="template/menu.jsp" />
		
		<h1>Insert email to send</h1> 
		<br/>
		here :
		<form name="emailForm" id="emailForm" method="post" >
			<input type="text" name="email" id="email" value="${u.email}" maxlength="512"/>
			<span class="error" id="emailError"></span>
		</form>
		<button id="btnSend"><spring:message code="projecthandler.admin.sendMailService.send"/></button>
		<br/>
		<br/>
		<a href="<c:url value="/"/>"><spring:message code="projecthandler.home"/></a>
		<br/>
		<a href="<c:url value="/j_spring_security_logout"/>"><spring:message code="projecthandler.menu.logout"/></a>
		<jsp:include page="template/footer.jsp" />
	</body>
</html>