<%@page session="false" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<div class="position-relative">
	<div class="container position-absolute position-top position-right">
		
		<button class="default-btn-shape theme3-primary-btn-style1 inverted-text position-absolute position-top position-right margin-top margin-right toggle-event text-h1" data-toggle="pop-event" data-target="debuggingmenu" title="debugging menu">
			<span class="icon-equalizer"></span>
		</button>
		
		<div id="debuggingmenu" class="pop-event container surrounded theme3-primary-bdr radius inverted-bg position-relative">
		
			<button class="reduced-btn-shape theme3-primary-bg inverted-text position-absolute position-top position-right toggle-event" data-toggle="pop-event" data-target="debuggingmenu">
				<span class="icon-cross"></span>
			</button>
		
			<h1 class="no-margin-top margin-bottom">Debugging menu</h1>
			
			<sec:authorize access="isAuthenticated()">
				<p class="margin-bottom">you are logged as : <span class="theme2-primary-text"><sec:authentication property="principal.fullname" /></span></p>
			</sec:authorize>
			
           	<ul class="margin-bottom">
				<li><a href="<c:url value="/"/>"><spring:message code="projecthandler.home"/></a></li> 
				<sec:authorize access="hasRole('ROLE_ADMIN')">
				<li><a href="<c:url value="/admin/users_management"/>">				<spring:message code="projecthandler.admin.userManagementTitle"/></a></li>
				<li><a href="<c:url value="/admin/groups_management"/>">			<spring:message code="projecthandler.admin.groupManagementTitle"/></a></li>
				<li><a href="<c:url value="/admin/signupSendMailService"/>">		<spring:message code="projecthandler.admin.sendMailService"/></a></li>
				</sec:authorize>
				<li><a href="<c:url value="/calendar"/>">							<spring:message code="projecthandler.menu.calendar"/></a></li>
				<li><a href="<c:url value="/changePassword"/>">						<spring:message code="projecthandler.menu.changePassword"/></a></li>
				<li><a href="<c:url value="/signup"/>">								<spring:message code="projecthandler.menu.personalInformation"/></a></li>
				<li><a href="<c:url value="/project/projectHome"/>">test projects</a></li>
				<li><a href="<c:url value="/gantt"/>">test Gantt</a></li>
			</ul>

			<div class="clearfix">
				<sec:authorize access="isAuthenticated()">
					<a class="default-btn-shape util4-primary-btn-style1 float-right" href="<c:url value="/j_spring_security_logout" />"><spring:message code="projecthandler.menu.logout"/></a>
				</sec:authorize>
			</div>
			
		</div>
		
	</div>
</div>