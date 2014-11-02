<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>

<html lang="fr">
	<head>
		<title>Inscription</title>
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
				if(confirm("Etes-vous sûr de vouloir enregistrer vos données ?")) {
					$("#createAccount").attr("action", CONTEXT_PATH+"/saveUser");
					$("#createAccount").submit();
				}
			});
		});
		
		
		</script>
	</head>
	<body>
		
		<form id="createAccount" name="createAccount" method="post">
			<input type="hidden" name="userId" id="userId" value="${user.id}"/>
			
				<h1><spring:message code="projecthandler.signup.form"/></h1>

				<br/>
	
			<ul class="form">
				<li>
					<label><spring:message code="projecthandler.signup.civility"/><spring:message code="projecthandler.field.required"/></label>
				<c:forEach items="${civility}" var="civil">
					<c:if test="${user != null && user.civility.id eq civil.id}">
						<input type="radio" name="civility" id="civility" value="${civil.id}" class="radio" checked="checked" style="width: 15px; float:none;"/><c:out value="${civil.value}" />
					</c:if>
					<c:if test="${user eq null || user.civility.id != civil.id}">
						<input type="radio" name="civility" id="civility" value="${civil.id}" class="radio" style="width: 15px; float:none;"/><c:out value="${civil.value}" />
					</c:if>
					</c:forEach>
					<span class="error" id="civilityError"></span>
				</li>
		
				<li>
					<label><spring:message code="projecthandler.user.lastName"/><spring:message code="projecthandler.field.required"/></label>
					<input type="text" name="lastName" id="lastName"  value="${user.lastName}" maxlength="30"/>
					<span class="error" id="lastNameError"></span>
				</li>
				<li>
					<label><spring:message code="projecthandler.user.firstName"/><spring:message code="projecthandler.field.required"/></label>
					<input type="text" name="firstName" id="firstName"  value="${user.firstName}" maxlength="30"/>
					<span class="error" id="firstNameError"></span>
				</li>

				<li>
					<label><spring:message code="projecthandler.user.email"/><spring:message code="projecthandler.field.required"/></label>
					<c:if test="${user.email != null}">
						<input type="text" name="emailDummy" value="${user.email}" disabled="disabled" style="color: grey;"/>
						<input type="hidden" name="email" id="email" value="${user.email}"/>
					</c:if>
					<c:if test="${user.email == null}">
						<input type="text" name="email" id="email" value="${user.email}" maxlength="512"/>
						<span class="error" id="emailError"></span>
					</c:if>
					
				</li>
				
				<li>
					<label><spring:message code="projecthandler.signup.phone"/><spring:message code="projecthandler.field.required"/></label>
					<input type="text" name="phone" id="phone"  maxlength="10"/>
					<span class="error" id="phoneError"></span>
				</li>
				<li>
					<label><spring:message code="projecthandler.signup.mobilePhone"/></label>
					<input type="text" name="mobilePhone" id="mobilePhone" maxlength="10"/>
					<span class="error" id="mobilePhoneError"></span>
				</li>

				<li>
					<label><spring:message code="projecthandler.signup.password"/><spring:message code="projecthandler.field.required"/></label>
					<input type="password" name="password" id="password" autocomplete="off" maxlength="70"/>
					<span class="error" id="passwordError"></span>
				</li>
				<li>
					<label><spring:message code="projecthandler.signup.passwordConfirm"/><spring:message code="projecthandler.field.required"/></label>
					<input type="password" name="passwordConfirm" id="passwordConfirm" autocomplete="off" maxlength="70"/>
					<span class="error" id="passwordConfirmError"></span>
				</li>
				
				<p id="mdpInfo"><spring:message code="projecthandler.password.syntax"/></p>
  
			</ul>

		</form>
		
		<br/>
		
		<button id="btnSave"><spring:message code="projecthandler.signup.create" /></button>
		
		<br/>

		<a href="/projecthandler/"><spring:message code="projecthandler.signup.home"/></a>
		
	
	</body>
</html>
