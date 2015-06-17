<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>

<html lang="fr">
	<head>
		<jsp:include page="template/head.jsp" />
		<title>Inscription</title>
		<script type="text/javascript">
		var CONTEXT_PATH = "<%=request.getContextPath() %>";
		
		$(document).ready(function() {
		
			$("#btnSave").click(function(e) {
				$("#emailError").html("");
				if(checkDataBeforeSaveUser() && confirm("Etes-vous sûr de vouloir enregistrer vos données ?")) {
					var workDayCheckboxes = document.querySelectorAll('input[name="workDayCheckboxes"]'), values = [];
					var workDay = "";
					for (var i=0, n=workDayCheckboxes.length;i<n;i++)
					  if (workDayCheckboxes[i].checked) 
						  workDay += "t";
					  else
						  workDay += "f";
					$("#userWorkDay").val(workDay);
					var dailyHour = $("#dailyHourStart").val() + " - " + $("#dailyHourEnd").val();
					$("#userDailyHour").val(dailyHour);
					$("#createAccount").attr("action", CONTEXT_PATH+"/saveUser");
					$("#createAccount").submit();
				}
			});

			$("#lastName").focusout(function() {
				validateLastName();
			});
			$("#firstName").focusout(function() {
				validateFirstName();
			});
			$("#phone").focusout(function() {
				validatePhone();
			});
			$("#mobilePhone").focusout(function() {
				validateMobilePhone();
			});
			$("#password").focusout(function() {
				validatePassword();
			});
			$("#passwordConfirm").focusout(function() {
				validatePasswordConfirm();
			});
			
			$("#dailyHourStartDiv").timepicker({
			    showPeriod: true,
			    showLeadingZero: true,
			    altField: '#dailyHourStart',
			});
			
			$("#dailyHourEndDiv").timepicker({
			    showPeriod: true,
			    showLeadingZero: true,
			    altField: '#dailyHourEnd'
			});

			setUserWorkDays();
			setUserDailyHour();
				
			
		});
		
		function setUserWorkDays() {
			var workDayCheckboxes = document.querySelectorAll('input[name="workDayCheckboxes"]'), values = [];
			var userWorkDays = $("#userWorkDay").val().split("");
			for (var i=0, n=workDayCheckboxes.length;i<n;i++)
				if (userWorkDays[i] == 't') 
					document.forms[0].workDayCheckboxes[i].checked=true;
		}
		
		function setUserDailyHour() {
			var userDailyHour = $("#userDailyHour").val().split("-");
			 $('#dailyHourStartDiv').timepicker('setTime',userDailyHour[0]);
			 $('#dailyHourEndDiv').timepicker('setTime',userDailyHour[1]);
		}
		
		function validateFirstName(){
			var fisrtName = $("#firstName").val();
			$("#firstNameError").html("");
			if((fisrtName == null || fisrtName.length == 0)){
				$("#fisrtNameError").html('<spring:message javaScriptEscape="true" code="projecthandler.signup.error.firstName"/>');
				return false;
			}
			return true;
		}
		
		function validateLastName(){
			var lastName = $("#lastName").val();
			$("#lastNameError").html("");
			if((lastName == null || lastName.length == 0)){
				$("#lastNameError").html('<spring:message javaScriptEscape="true" code="projecthandler.signup.error.lastName"/>');
				return false;
			}
			return true;
		}
		
		function validatePhone(){
			var phone = $("#phone").val();
			$("#phoneError").html("");
			if((phone == null || phone.length == 0) || (phone != null && phone.length != 0 && !isValidPhoneNumber(phone.trim()))){
				$("#phoneError").html('<spring:message javaScriptEscape="true" code="projecthandler.signup.error.phone"/>');
				return false;
			}
			return true;
		}
		
		function validateMobilePhone(){
			var mobilePhone = $("#mobilePhone").val();
			$("#mobilePhoneError").html("");
			if(mobilePhone != null && mobilePhone.length != 0 && !isValidPhoneNumber(mobilePhone.trim())){
				$("#mobilePhoneError").html('<spring:message javaScriptEscape="true" code="projecthandler.signup.error.mobilePhone"/>');
				return false;
			}
			return true;
		}
		
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
		
		function validateDailyHour(){
			var dailyHourStart = $("#dailyHourStart").val();
			var dailyHourEnd = $("#dailyHourEnd").val();
			if ((dailyHourStart == null || dailyHourStart.length == 0 || (dailyHourStart.length > 0 && !isValideHour12Format(dailyHourStart))) 
			|| (dailyHourEnd == null || dailyHourEnd.length == 0 || (dailyHourEnd.length > 0 && !isValideHour12Format(dailyHourEnd)))) {
				$("#dailyHourConfirmError").html('<spring:message javaScriptEscape="true" code="projecthandler.signup.error.dailyHour"/>');
				return false;
			}
			return true
		}
		
		function isValidPhoneNumber(phone){
			var pattern = new RegExp(/^0[1-9]([\.|\-|\s]*[0-9]{2}){4}$/);
			return pattern.test(phone);
		}

		function isValidPassword(password) {
			var pattern = new RegExp(/^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])[0-9a-zA-Z!£\$\%\^&\*()_/\-\+\{\}~#\]\[\:\;@<>?,\|\\`€=§.?µ¨²]{8,}$/);
			return pattern.test(password);
		}
		
		function isValideHour12Format(hour) {
			var pattern = new RegExp(/^([0]\d|[1][0-2]):([0-5]\d)\s?(?:AM|PM)$/i);
			return pattern.test(hour);
		}
		
		function checkDataBeforeSaveUser() {
			var valid = true;
			
			$("#civilityError").html("");
			if(!$("input:radio[name='civility']").is(":checked")){
				valid = false;
				$("#civilityError").html('<spring:message javaScriptEscape="true" code="projecthandler.signup.error.civility"/>');
			}
			
			if (!validateFirstName())
				valid = false;
			
			if (!validateLastName())
				valid = false;

			
			if ($("#userStatus").val() != 'ACTIVE') {
				if (!validatePassword())
				valid = false;
				
				if (!validatePasswordConfirm())
					valid = false;
			}
			
			if (!validatePhone())
				valid = false;
			
			if (!validateMobilePhone())
				valid = false;
			
			if (!validateDailyHour())
				valid = false;
			return valid;
		}
		
		</script>
	</head>
	<body>
		<jsp:include page="template/header.jsp" />
		<jsp:include page="template/menu.jsp" />
		<form id="createAccount" name="createAccount" method="post">
			<input type="hidden" name="userId" 			id="userId" 		value="${user.id}"/>
			<input type="hidden" name="userStatus" 		id="userStatus" 	value="${user.accountStatus}"/>
			<input type="hidden" name="userWorkDay" 	id="userWorkDay"	value="${user.workDay}"/>
			<input type="hidden" name="userDailyHour" 	id="userDailyHour"	value="${user.dailyHour}"/>
				<h1><spring:message code="projecthandler.signup.form"/></h1>
				<br/>
			<ul class="form">
				<li>
					<label path="civility"><spring:message code="projecthandler.signup.civility"/><spring:message code="projecthandler.field.required"/></label>
					<c:forEach items="${civilityList}" var="civil">
						<c:set var="civilityValue"><spring:message code="${civil.name}" text=""/></c:set>
						<c:if test="${user != null && user.civility.id eq civil.id}">
							<input type="radio" name="civility" id="civility" value="${civil.id}" class="radio" checked="checked" style="width: 15px; float:none;"/><c:out value="${civilityValue}" />
						</c:if>
						<c:if test="${user eq null || user.civility.id != civil.id}">
							<input type="radio" name="civility" id="civility" value="${civil.id}" class="radio" style="width: 15px; float:none;"/><c:out value="${civilityValue}" />
						</c:if>
					</c:forEach>
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
						<input type="text" name="email" id="email" maxlength="512"/>
						<span class="error" id="emailError"></span>
					</c:if>
				</li>
				<li>
					<label><spring:message code="projecthandler.signup.phone"/><spring:message code="projecthandler.field.required"/></label>
					<input type="text" name="phone" id="phone"  value="${user.phone}" maxlength="10"/>
					<span class="error" id="phoneError"></span>
				</li>
				<li>
					<label><spring:message code="projecthandler.signup.mobilePhone"/></label>
					<input type="text" name="mobilePhone" id="mobilePhone" value="${user.mobilePhone}" maxlength="10"/>
					<span class="error" id="mobilePhoneError"></span>
				</li>
				 <c:if test="${user.accountStatus != 'ACTIVE'}">
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
				 </c:if>
					 <li>
					 <label><spring:message code="projecthandler.signup.workDay"/></label>
						<div id="workDayCheckboxes">
							<label for="workDayCheckboxes"><spring:message code="projecthandler.day.monday"/></label>
			   				<input name="workDayCheckboxes" type="checkbox"/>
			   				<label for="workDayCheckboxes"><spring:message code="projecthandler.day.tuesday"/></label>
						    <input name="workDayCheckboxes" type="checkbox"/>
						    <label for="workDayCheckboxes"><spring:message code="projecthandler.day.wednesday"/></label>
						    <input name="workDayCheckboxes" type="checkbox"/>
						    <label for="workDayCheckboxes"><spring:message code="projecthandler.day.thursday"/></label>
						    <input name="workDayCheckboxes" type="checkbox"/>
						    <label for="workDayCheckboxes"><spring:message code="projecthandler.day.friday"/></label>
						    <input name="workDayCheckboxes" type="checkbox"/>
						    <label for="workDayCheckboxes"><spring:message code="projecthandler.day.saturday"/></label>
						    <input name="workDayCheckboxes" type="checkbox"/>
						    <label for="workDayCheckboxes"><spring:message code="projecthandler.day.sunday"/></label>
						    <input name="workDayCheckboxes" type="checkbox"/>
						</div>
					 </li>
					 <li>
						 <label for="dailyHour"><spring:message code="projecthandler.signup.dailyHour"/></label>
						 <div id="dailyHour">
							 <label for="dailyHourStart"><spring:message code="projecthandler.gantt.start"/></label>
							 <input type="text" id="dailyHourStart" name="dailyHourStart"  disabled/>
							 <div id="dailyHourStartDiv"></div>
							 <label for="dailyHourEnd"><spring:message code="projecthandler.gantt.end"/></label>
							 <input type="text" id="dailyHourEnd" name="dailyHourEnd"  disabled/>
							 <div id="dailyHourEndDiv"></div>
							 <span class="error" id="dailyHourConfirmError"></span>
						</div>
					</li>
			</ul>
		</form>
		<br/>
		<button id="btnSave"><spring:message code="projecthandler.signup.create" /></button>
		<br/>
		<a href="/projecthandler/"><spring:message code="projecthandler.signup.home"/></a>
		
		<jsp:include page="template/footer.jsp" />
	</body>
</html>
