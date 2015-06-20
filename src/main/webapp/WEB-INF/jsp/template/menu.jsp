<%@page session="false" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<div class="container small-padding-top small-padding-bottom theme3-lighten1-bg clearfix">
	
	<div class="float-right">

		<button class="reduced-btn-shape text-h3 surrounded theme3-darken2-text theme3-darken2-bdr theme1-primary-btn-style2 animating-event" data-action="toggle-event" data-animation="pop-event" data-target="debugging-menu" title="debugging menu">
			<span class="icon-equalizer"></span>
		</button>
		
		<div id="debugging-menu" class="pop-event position-absolute position-right focus-sensitive default-bg small-margin-top margin-right container surrounded theme3-primary-bdr inverted-bg zindex-10">
		
			<h1 class="margin-bottom">Debugging menu</h1>
			
			<sec:authorize access="isAuthenticated()">
				<p class="margin-bottom">you are logged as : <span class="theme2-primary-text"><sec:authentication property="principal.firstName" /> <sec:authentication property="principal.lastName" /></span></p>
			</sec:authorize>
			
           	<ul class="margin-bottom">
				<li><a class="display-block full-width theme1-primary-text default-btn-style5" href="<c:url value="/"/>"><spring:message code="projecthandler.home"/></a></li> 
				<sec:authorize access="hasRole('ROLE_ADMIN')">
				<li><a class="display-block full-width theme1-primary-text default-btn-style5" href="<c:url value="/admin/users_management"/>">				<spring:message code="projecthandler.admin.userManagementTitle"/></a></li>
				<li><a class="display-block full-width theme1-primary-text default-btn-style5" href="<c:url value="/admin/groups_management"/>">			<spring:message code="projecthandler.admin.groupManagementTitle"/></a></li>
				<li><a class="display-block full-width theme1-primary-text default-btn-style5" href="<c:url value="/admin/signupSendMailService"/>">		<spring:message code="projecthandler.admin.sendMailService"/></a></li>
				</sec:authorize>
				<li><a class="display-block full-width theme1-primary-text default-btn-style5" href="<c:url value="/calendar"/>">							<spring:message code="projecthandler.menu.calendar"/></a></li>
				<li><a class="display-block full-width theme1-primary-text default-btn-style5" href="<c:url value="/changePassword"/>">						<spring:message code="projecthandler.menu.changePassword"/></a></li>
				<li><a class="display-block full-width theme1-primary-text default-btn-style5" href="<c:url value="/signup"/>">								<spring:message code="projecthandler.menu.personalInformation"/></a></li>
				<li><a class="display-block full-width theme1-primary-text default-btn-style5" href="<c:url value="/project/projectHome"/>">test projects</a></li>
				<li><a class="display-block full-width theme1-primary-text default-btn-style5" href="<c:url value="/gantt"/>">test Gantt</a></li>
			</ul>

			<div class="clearfix">
				<sec:authorize access="isAuthenticated()">
					<a class="default-btn-shape util4-primary-btn-style1 float-right" href="<c:url value="/j_spring_security_logout" />"><spring:message code="projecthandler.menu.logout"/></a>
				</sec:authorize>
			</div>
			
		</div>

	</div>
</div>