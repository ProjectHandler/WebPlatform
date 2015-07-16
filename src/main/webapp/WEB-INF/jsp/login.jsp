<!DOCTYPE html>
<%@ page session="true"%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html xmlns="http://www.w3.org/1999/xhtml" lang="fr">
	<head>
		<meta charset="utf-8">
		<meta name="viewport" content="width=device-width, initial-scale=1">
		<title>Project Handler</title>
		<spring:url value="/resources/css/redcss.css" var="redcss"/>
		<link href="${redcss}" rel="stylesheet"/>
		<spring:url value="/resources/img/icon.png" var="windowicon"/>
		<link href="${windowicon}" rel="icon" type="image/png"/>		
	</head>
	<body onload='document.f.j_username.focus();'>

		<div class="display-table full-width full-height inverted-bg">
			<div class="display-table-cell vertical-align full-width full-height">

				<div class="fixedmaxwidth-1024 container margin-auto">
					<div class="display-table full-width">
						<div class="display-table-cell vertical-align">
							<img src="${pageContext.request.contextPath}/resources/img/download-box.png" alt="" class="fixedwidth-384 xxxs-display-none sm-display-block margin-right"/>
						</div>
						<div class="display-table-cell vertical-align full-width">
							<div class="fixedmaxwidth-384 margin-auto">
								<h1 class="margin-bottom padding-bottom util1-primary-text"><spring:message code="projecthandler.login.signIn"/></h1>

								<form name='f' action="j_spring_security_check" method="post">
								
									<label>
										<div class="padding-bottom position-relative">
											<h2 class="small-margin-bottom text-h3"><span class="icon-checkmark small-margin-right"></span><spring:message code="projecthandler.login.email"/>:</h2>
											<input type="email" name="j_username" class="default-btn-shape theme3-lighten1-bdr display-block full-width" placeholder="<spring:message code="projecthandler.login.typeEmail"/>" required/>
											<c:if test="${Message != null}">
												<p name="error-tag" class="position-absolute position-bottom position-right util5-primary-text">
												<span class="icon-cancel-circle"></span><spring:message code="projecthandler.login.invalid"/></p>
											</c:if>	
										</div>
									</label>
									<label>
										<div class="padding-bottom position-relative">
											<h2 class="small-margin-bottom text-h3"><span class="icon-checkmark small-margin-right"></span><spring:message code="projecthandler.login.password"/>:</h2>
											<input type="password" name="j_password" class="default-btn-shape theme3-lighten1-bdr display-block full-width" placeholder="<spring:message code="projecthandler.login.typePassword"/>" required/>
											<c:if test="${Message != null}">
												<p name="error-tag" class="position-absolute position-bottom position-right util5-primary-text">
												<span class="icon-cancel-circle"></span><spring:message code="projecthandler.login.invalid"/></p>
											</c:if>
										</div>
									</label>
									<button name="submit" type="submit" class="default-btn-shape theme1-primary-btn-style1 display-block text-center margin-top margin-bottom  full-width"><spring:message code="projecthandler.login.login"/></button>
									<div class="text-center"><a class="display-inline-block default-btn-shape default-btn-style5" href="#"><spring:message code="projecthandler.login.forgotPassword"/>?</a></div>
								</form>

							</div>
						</div>
					</div>	
				</div>
			
			</div>
		</div>

	</body>
</html>