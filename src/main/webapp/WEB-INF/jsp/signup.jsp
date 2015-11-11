<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@taglib prefix="e" uri="https://www.owasp.org/index.php/OWASP_Java_Encoder_Project" %>

<html lang="fr">
	<head>
		<jsp:include page="template/head.jsp" />
		<title>Inscription</title>
		<script type="text/javascript">
		var CONTEXT_PATH = "<%=request.getContextPath() %>";
		
		$(document).ready(function() {
			$("#avatar").change(function() {
				$("#avatar_error").html("");
				if($("#avatar").val() == ""){
					document.getElementById('addAvatarButton').disabled = true;
				}else{
					document.getElementById('addAvatarButton').disabled = false;
				}
			});
			
			$("#btnSave").click(function(e) {
				$("#emailError").html("");
				if(checkDataBeforeSaveUser() && confirm("Etes-vous sûr de vouloir enregistrer vos données ?")) { // TODO traduire
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
			
			if ("${user.civility}".length <= 0)
				$("#civility_1").prop("checked", true);
			
			

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
			var userDailyHour = $("#userDailyHour").val().split(" - ");
			 $('#dailyHourStartDiv').timepicker('setTime',userDailyHour[0]);
			 $('#dailyHourEndDiv').timepicker('setTime',userDailyHour[1]);
		}
		
		function validateFirstName(){
			var fisrtName = $("#firstName").val();
			$("#firstNameError").html("");
			if((fisrtName == null || fisrtName.length == 0)){
				$("#firstNameError").html('<spring:message javaScriptEscape="true" code="projecthandler.signup.error.firstName"/>');
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
		
		function addAvatar() {
			$("#avatar_error").html("");
			if($("#avatar")[0] == undefined	|| navigator.userAgent.indexOf('MSIE') !== -1 || $("#avatar")[0].files[0] == undefined || $("#avatar")[0].files[0].size < 1048576){
				document.createAccount.action = CONTEXT_PATH + "/saveAvatar";
				document.createAccount.submit();
			}else{
				$("#avatar_error").html("<spring:message code='projecthandler.signup.error.file.toBig1mo'/>");
			}
		}
		
		function deleteAvatar() {
			$("#avatar_error").html("");
			$("#avatar").val("");
			document.createAccount.action = CONTEXT_PATH + "/saveAvatar";
			document.createAccount.submit();
		}
		
		</script>
	</head>
	<body>
	<form id="createAccount" class="full-width full-height" name="createAccount" method="post" enctype="multipart/form-data">
	
		<div class="display-table full-width full-height">
			<div class="display-table-row">
				<jsp:include page="template/header.jsp" />
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
				
						<div id="avatar-modal-box" class="pop-event full-width full-height position-absolute position-top position-left default-transpbg zindex-10">
							<div class="full-width full-height display-table">
								<div class="full-width full-height display-table-cell vertical-align">
	
									<div class="inverted-bg fixedwidth-320 margin-auto overflow-hidden position-relative">
										<c:choose>
											<c:when test="${user.avatarFileName != null}">
												<div id="divAvatarImage">
													<img id="userAvatar" alt="avatar" src="<%=request.getContextPath() %>/downloadAvatar/${user.id}"/>
												</div>
											</c:when>
											<c:otherwise>
												<img alt="avatar" src="resources/img/no-img.png" />
											</c:otherwise>
										</c:choose>	
										<div id="tdAvatarButton" class="container">
										
											<div class="small-margin-bottom"><spring:message code="projecthandler.signup.customDetails.imageType" /></div>
											<input type="file" name="avatar" id="avatar" class="filestyle" data-buttonName="btn btn-primary btn-xs" data-buttonText="&nbsp;<spring:message code="projecthandler.signup.button.chooseFile"/>"/>
											<span id="avatar_error" style="color: red; display:block;"></span>
											<div class="divButton small-margin-top display-inline-block">
												<button id="addAvatarButton" class="reduced-btn-shape radius theme1-primary-btn-style1" onClick="addAvatar();return false;" disabled="disabled">
													<spring:message code="projecthandler.admin.action.add" />
												</button>
											</div>
											<c:choose>
												<c:when test="${user.avatarFileName != null}">					
													<div class="divButton display-inline-block">
														<button id="deleteAvatarButton" class="reduced-btn-shape radius util6-primary-btn-style1" onClick='deleteAvatar();return false;'>
															<spring:message code="projecthandler.admin.action.delete" />
														</button>
													</div>
												</c:when>
											</c:choose>									
										</div>
										<div class="text-center">
											<a href="#" class="reduced-btn-shape theme3-lighten1-btn-style1 animating-event" data-action="toggle-event" data-animation="pop-event" data-target="avatar-modal-box">Annuler</a>
										</div>
									</div>
	
								</div>
							</div>
						</div>
						
						<div class="position-absolute position-top position-left full-width full-height overflow-auto">
							<div class="container">
								<div class="margin-bottom clearfix">
									<h1 class="text-h2 util1-primary-text float-left">Mes informations personnelles</h1>
									<div class="text-h2 text-h1 float-right"><span class="icon-profile"></span></div>
								</div>
								<div>		
									
										<input type="hidden" name="userId" 			id="userId" 		value="${user.id}"/>
										<input type="hidden" name="userStatus" 		id="userStatus" 	value="${e:forHtml(user.accountStatus)}"/>
										<input type="hidden" name="userWorkDay" 	id="userWorkDay"	value="${e:forHtml(user.workDay)}"/>
										<input type="hidden" name="userDailyHour" 	id="userDailyHour"	value="${e:forHtml(user.dailyHour)}"/>
										<ul class="form">
											<li class="small-margin-bottom">
												<div class="display-table-cell fixedwidth-128 vertical-align">
													<label path="civility"><spring:message code="projecthandler.signup.civility"/><spring:message code="projecthandler.field.required"/></label>
												</div>
												<div class="display-table-cell vertical-align">
													<c:forEach items="${civilityList}" var="civil">
														<c:set var="civilityValue"><spring:message code="${civil.name}" text=""/></c:set>
														<c:if test="${user != null && user.civility.id eq civil.id}">
															<input type="radio" name="civility" id="civility_${civil.id}" value="${civil.id}"  checked="checked" class="radio" style="width: 15px; float:none;"/><c:out value="${civilityValue}" />
														</c:if>
														<c:if test="${user eq null || user.civility.id != civil.id}">
															<input type="radio" name="civility" id="civility_${civil.id}" value="${civil.id}" class="radio" style="width: 15px; float:none;"/><c:out value="${civilityValue}" />
														</c:if>
													</c:forEach>
												</div>
											</li>
							
											<li class="small-margin-bottom">
												<div class="display-table-cell fixedwidth-128 vertical-align">
													<label><spring:message code="projecthandler.user.lastName"/><spring:message code="projecthandler.field.required"/></label>
												</div>
												<div class="display-table-cell vertical-align">
													<input type="text" name="lastName" id="lastName"  class="textfield fixedwidth-192 surrounded theme3-primary-bdr" value="${e:forHtml(user.lastName)}" maxlength="30"/>
													<span class="error" id="lastNameError"></span>
												</div>
											</li>
											<li class="small-margin-bottom">
												<div class="display-table-cell fixedwidth-128 vertical-align">
												<label><spring:message code="projecthandler.user.firstName"/><spring:message code="projecthandler.field.required"/></label>
												</div>
												<div class="display-table-cell vertical-align">
													<input type="text" name="firstName" id="firstName" class="textfield fixedwidth-192 surrounded theme3-primary-bdr" value="${e:forHtml(user.firstName)}" maxlength="30"/>
													<span class="error" id="firstNameError"></span>
												</div>
											</li>
											<li class="small-margin-bottom">
												<div class="display-table-cell fixedwidth-128 vertical-align">
													<label><spring:message code="projecthandler.user.email"/><spring:message code="projecthandler.field.required"/></label>
												</div>
												<div class="display-table-cell vertical-align">
													<c:if test="${user.email != null}">
														<input type="text" name="emailDummy" class="textfield surrounded fixedwidth-192 theme3-primary-bdr" value="${e:forHtml(user.email)}" disabled="disabled" style="color: grey;"/>
														<input type="hidden" name="email" id="email" value="${e:forHtml(user.email)}"/>
													</c:if>
													<c:if test="${user.email == null}">
														<input type="text" name="email" class="textfield surrounded fixedwidth-192 theme3-primary-bdr" id="email" maxlength="512"/>
														<span class="error" id="emailError"></span>
													</c:if>
												</div>
											</li>
											<li class="small-margin-bottom">
												<div class="display-table-cell fixedwidth-128 vertical-align">
													<label><spring:message code="projecthandler.signup.phone"/><spring:message code="projecthandler.field.required"/></label>
												</div>
												<div class="display-table-cell vertical-align">
													<input type="text" name="phone" id="phone"  class="textfield surrounded fixedwidth-192 theme3-primary-bdr" value="${e:forHtml(user.phone)}" maxlength="10"/>
													<span class="error" id="phoneError"></span>
												</div>
											</li>
											<li class="small-margin-bottom">
												<div class="display-table-cell fixedwidth-128 vertical-align">
													<label>Mobile</label>
												</div>
												<div class="display-table-cell vertical-align">	
													<input type="text" name="mobilePhone" class="textfield surrounded fixedwidth-192 theme3-primary-bdr" id="mobilePhone" value="${e:forHtml(user.mobilePhone)}" maxlength="10"/>
													<span class="error" id="mobilePhoneError"></span>
												</div>
											</li>
											<li class="">
												<div class="display-table-cell fixedwidth-128 vertical-align">
													<label>Avatar</label>
												</div>
												<div class="display-table-cell vertical-align">	
													<div class="fixedwidth-192 fixedheight-192 position-relative img-as-background theme3-primary-boxshadow-raising-out" style="background-image:url(${pageContext.request.contextPath}/resources/img/no-img.png);">
														<div class="full-width full-height img-as-background" style="background-image:url(<%=request.getContextPath() %>/downloadAvatar/<sec:authentication property="principal.id" />);"></div>
														<a class="default-btn-shape position-absolute position-bottom position-right default-btn-style1 animating-event" style="margin-bottom:50px;" href="#" data-action="toggle-event" data-animation="pop-event" data-target="avatar-modal-box"><span class="icon-wrench small-margin-right"></span>Editer</a>
													</div>
												</div>
											</li>
											 <c:if test="${user.accountStatus != 'ACTIVE'}">
											 	<li>
											 		<hr class="theme3-lighten1-bg margin-top margin-bottom">
												</li>
												<li class="small-margin-bottom">
													<div class="display-table-cell fixedwidth-128 vertical-align"><label><spring:message code="projecthandler.signup.password"/><spring:message code="projecthandler.field.required"/></label></div>
													<div class="display-table-cell vertical-align"><input type="password" name="password" class="textfield surrounded fixedwidth-192 theme3-primary-bdr" id="password" autocomplete="off" maxlength="70"/></div>
													<span class="error" id="passwordError"></span>
												</li>
												<li>
													<div class="display-table-cell fixedwidth-128 vertical-align"><label>Confirmation<spring:message code="projecthandler.field.required"/></label></div>
													<div class="display-table-cell vertical-align"><input type="password" name="passwordConfirm" class="textfield surrounded fixedwidth-192 theme3-primary-bdr" id="passwordConfirm" autocomplete="off" maxlength="70"/></div>
													<span class="error" id="passwordConfirmError"></span>
												</li>
												<p id="mdpInfo"><spring:message code="projecthandler.password.syntax"/></p>
											 </c:if>
											 	<li>
											 		<hr class="theme3-lighten1-bg margin-top margin-bottom">
												</li>
												 <li>
													<div class="text-h3 theme3-primary-text margin-bottom"><label><spring:message code="projecthandler.signup.workDay"/></label></div>
													<div id="workDayCheckboxes" class="padding-left display-inline-block">
														<div class="display-table-cell padding-right">
															<div class="small-margin-bottom">
																<label>
																	<div class="fixedwidth-64 display-table-cell vertical-align"><spring:message code="projecthandler.day.monday"/></div>
											   						<div class="display-table-cell padding-left vertical-align"><input name="workDayCheckboxes" type="checkbox"/></div>
											   					</label>
											   				</div>
											   				<div class="small-margin-bottom">
											   					<label>
											   						<div class="fixedwidth-64 display-table-cell vertical-align"><spring:message code="projecthandler.day.tuesday"/></div>
														    		<div class="display-table-cell padding-left vertical-align"><input name="workDayCheckboxes" type="checkbox"/></div>
														    	</label>
														    </div>
											   				<div>
														    	<label>
														    		<div class="fixedwidth-64 display-table-cell vertical-align"><spring:message code="projecthandler.day.wednesday"/></div>
														    		<div class="display-table-cell padding-left vertical-align"><input name="workDayCheckboxes" type="checkbox"/></div>
														    	</label>
														    </div>
														</div>
														<div class="display-table-cell theme3-lighten1-bg" style="width:1px;">
														</div>
														<div class="display-table-cell padding-left">
															<div class="small-margin-bottom">
														    	<label>
														    		<div class="fixedwidth-64 display-table-cell vertical-align"><spring:message code="projecthandler.day.thursday"/></div>
														    		<div class="display-table-cell padding-left vertical-align"><input name="workDayCheckboxes" type="checkbox"/></div>
														    	</label>
														    </div>
											   				<div class="small-margin-bottom">
														    	<label>
														    		<div class="fixedwidth-64 display-table-cell vertical-align"><spring:message code="projecthandler.day.friday"/></div>
														    		<div class="display-table-cell padding-left vertical-align"><input name="workDayCheckboxes" type="checkbox"/></div>
														    	</label>
														    </div>
											   				<div>
														    	<label>
														    		<div class="fixedwidth-64 display-table-cell vertical-align"><spring:message code="projecthandler.day.saturday"/></div>
														    		<div class="display-table-cell padding-left vertical-align"><input name="workDayCheckboxes" type="checkbox"/></div>
														    	</label>
														    </div>
													    </div>
													    <div class="text-center">
													    	<div class="display-inline-block small-margin-top">
													    		<label>
													    			<spring:message code="projecthandler.day.sunday"/>
													    			<input name="workDayCheckboxes" type="checkbox"/>
													    		</label>
													    	</div>
													    </div>
													</div>
												 </li>
												<li>
											 		<hr class="theme3-lighten1-bg margin-top margin-bottom">
												</li>
												 <li>
													 <div class="text-h3 theme3-primary-text margin-bottom"><label for="dailyHour"><spring:message code="projecthandler.signup.dailyHour"/></label></div>
													 <div id="dailyHour" class="padding-left">
														<div class="small-margin-bottom">
														 	<div class="display-table-cell vertical-align fixedwidth-64"><label for="dailyHourStart"><span class="text-capitalize"><spring:message code="projecthandler.gantt.start"/></span></label></div>
														 	<div class="display-table-cell vertical-align surrounded theme3-primary-bdr theme3-primary-text position-relative">
														 		<a class="cover-btn-shape zindex-10 animating-event" data-action="toggle-event" data-animation="pop-event" data-target="worktime-panel-1"  href="#" target="_blanck"></a>
														 		<input type="text" id="dailyHourStart" name="dailyHourStart" class="textfield theme3-primary-text fixedwidth-128" disabled/>
														 		<span class="icon-pencil2 small-margin-right"></span>
														 	</div>
														 	<div class="display-table-cell position-relative">
																<div id="worktime-panel-1" class="pop-event focus-sensitive position-absolute position-top position-left margin-left inverted-transpbg theme3-primary-boxshadow-raising-out" style="margin-top:-75px;">
																	<div id="dailyHourStartDiv" class="margin-left margin-right margin-bottom" style="margin-top:5px;"></div>
																</div>
															</div>
														</div>
														<div>
															 <div class="display-table-cell vertical-align fixedwidth-64"><label for="dailyHourEnd"><span class="text-capitalize"><spring:message code="projecthandler.gantt.end"/></span></label></div>
															 <div class="display-table-cell vertical-align surrounded theme3-primary-bdr theme3-primary-text position-relative">
															 	<a class="cover-btn-shape zindex-10 animating-event" data-action="toggle-event" data-animation="pop-event" data-target="worktime-panel-2" href="#"></a>
															 	<input type="text" id="dailyHourEnd" name="dailyHourEnd"  class="textfield theme3-primary-text fixedwidth-128" disabled/>
															 	<span class="icon-pencil2 small-margin-right"></span>
															 </div>
														 	<div class="display-table-cell position-relative">
																<div id="worktime-panel-2" class="pop-event focus-sensitive position-absolute position-top position-left margin-left inverted-transpbg theme3-primary-boxshadow-raising-out" style="margin-top:-125px;">
																	<div id="dailyHourEndDiv" class="margin-left margin-right margin-bottom" style="margin-top:5px;"></div>
																</div>
															</div>
														 </div>
														 <span class="error" id="dailyHourConfirmError"></span>
													</div>												
												</li>
												<li>
											 		<hr class="theme3-lighten1-bg margin-top margin-bottom">
												</li>
										</ul>
									<div class="">
										<a id="btnSave" class="default-btn-shape theme2-primary-btn-style1" href="#"><span class="icon-checkmark"></span> Valider les informations</a>
									</div>
								</div>
							</div>	
						</div>
					
					</div>
				</div>
			</div>		
		</div>
	</form>
	</body>
</html>
