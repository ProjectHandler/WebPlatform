<%@page session="false" %>


<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>


<div class="">
	<div class="small-padding-top theme1-primary-bg"></div>
	<div class="container inverted-bg underlined theme3-lighten1-bdr clearfix">
		<div class="float-left padding-right">
			<img src="${pageContext.request.contextPath}/resources/img/logo&name.png" class="default-img-p">
		</div>
		<div class="float-left fixedmaxwidth-320">
			<div class="display-table-cell vertical-top full-width">
				<input type="text" class="default-box-p surrounded small-container theme3-lighten1-bdr full-width" placeholder="Your research here ..."/>
			</div>
			<a class="display-table-cell vertical-align small-padding-left small-padding-right theme1-primary-btn-style6 theme3-lighten1-bg default-text text-h2 text-center" href="#" title="search">
				<span class="icon-search"></span>
			</a>
		</div>
		<div class="float-right">
			<ul class="unstyled-list display-table no-margin-top no-margin-bottom">
				<!-- link -->
				
				<li class="position-relative vertical-top display-table-cell padding-right">
				
					<a class="default-box-p display-table-cell vertical-align default-btn-style5 util3-primary-text text-h1 text-center animating-event" data-action="toggle-event" data-animation="pop-event" data-target="debuggingmenu" title="debugging menu" href="#" title="home">
						<span class="icon-equalizer"></span>
					</a>
					
					<div id="debuggingmenu" class="pop-event focus-sensitive fixedwidth-384 position-absolute position-left margin-top container theme3-darken2-boxshadow-raising-out inverted-bg zindex-50">
					
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
				
				
				</li>
				
				<li class="position-relative vertical-top display-table-cell padding-right">
					<a class="default-box-p display-table-cell vertical-align default-btn-style5 theme1-primary-text text-h1 text-center" href="<c:url value="/"/>" title="home">
						<span class="icon-home"></span>
					</a>
				</li>
				<li class="position-relative vertical-top display-table-cell padding-right">
					<a class="default-box-p display-table-cell vertical-align default-btn-style5 theme1-primary-text text-h1 text-center" href="#" title="projects">
						<span class="icon-folder"></span>
					</a>
				</li>
				<li class="position-relative vertical-top display-table-cell padding-right">
					<a class="default-box-p display-table-cell vertical-align default-btn-style5 theme1-primary-text text-h1 text-center" href="<c:url value="/calendar"/>" title="calendar">
						<span class="icon-calendar"></span>
					</a>
				</li>
				<li class="position-relative vertical-top display-table-cell padding-right">
					<a class="default-box-p display-table-cell vertical-align default-btn-style5 theme1-primary-text text-h1 text-center" href="#" title="notifications">
						<span class="icon-bell"></span>
					</a>
				</li>
				<li class="position-relative vertical-top display-table-cell padding-right">
					<a class="default-btn-shape util6-primary-btn-style1" href="<c:url value="/admin/users_management"/>" title="administration">
						<span class="icon-database small-margin-right"></span>Administration
					</a>
				</li>
				<li class="position-relative display-table-cell">
					<a class="display-table theme1-primary-btn-style1 animating-event" data-action="toggle-event" data-animation="pop-event" data-target="mainmenu-profilebox" href="#" title="profile">
						<div class="display-table-cell">
							<div class="display-table-cell vertical-align">
								<div class="default-box-p util1-primary-bg">
									<div class="full-width full-height img-as-background" style="background-image:url(${pageContext.request.contextPath}/resources/img/no-img.png);"></div>
								</div>
							</div>
							<div class="display-table-cell vertical-align small-padding-left small-padding-right">
								<sec:authorize access="isAuthenticated()">
									<sec:authentication property="principal.firstName" /> 
									<sec:authentication property="principal.lastName" />
								</sec:authorize>
							</div>
						</div>
					</a>
					<div id="mainmenu-profilebox" class="pop-event focus-sensitive position-absolute position-right fixedwidth-384 inverted-bg margin-top theme3-darken2-boxshadow-raising-out zindex-50">
						<div class="position-relative">
							<div class="container underlined theme3-lighten1-bdr">
								<div class="display-table-cell">
									<div class="fixedwidth-128 fixedheight-128 util1-primary-bg">
										<div class="full-width full-height img-as-background" style="background-image:url(${pageContext.request.contextPath}/resources/img/no-img.png);"></div>
									</div>
								</div>
								<div class="display-table-cell vertical-top padding-left full-width">
									<sec:authorize access="isAuthenticated()">
										<h1 class="no-margin-top no-margin-bottom text-h4"><sec:authentication property="principal.firstName" /> <sec:authentication property="principal.lastName" /></h1>
										<p class="no-margin-top margin-bottom small"><sec:authentication property="principal.username" /></p>
									</sec:authorize>
									<a class="default-btn-shape theme1-primary-btn-style1" href="#">
										<span class="icon-user small-margin-right"></span>My profile
									</a>
								</div>
							</div>
							<div class="container inverted-bg clearfix">
								<div class="float-right">
									<a class="default-btn-shape default-btn-style5 theme3-darken2-boxshadow-raising-out small-margin-right" href="#">
										<span class="icon-cog small-margin-right"></span>Settings
									</a>
									<a class="default-btn-shape theme1-primary-btn-style1 theme3-darken2-boxshadow-raising-out animating-event" data-action="open-event" data-animation="pop-event" data-target="mainmenu-leavevalidation" href="#">
										<span class="icon-switch small-margin-right"></span>Sign out
									</a>
								</div>
							</div>
							<div id="mainmenu-leavevalidation" class="pop-event focus-sensitive position-absolute position-top position-left inverted-bg full-width full-height">
								<div class="display-table full-width full-height">
									<div class="display-table-cell full-width full-height vertical-align">
										<div class="text-center">
											<p class="margin-bottom"><b>Do you really want to leave ?</b></p>
											<a class="default-btn-shape util4-primary-btn-style1 small-margin-right" href="<c:url value="/j_spring_security_logout" />">
												<span class="icon-checkmark small-margin-right"></span>Yes
											</a>
											<a class="default-btn-shape util2-primary-btn-style1 animating-event" data-action="close-event" data-animation="pop-event" data-target="mainmenu-leavevalidation" href="#">
												<span class="icon-cross small-margin-right"></span>No
											</a>														
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
				</li>
			</ul>
		</div>
	</div>
</div>

<script type="text/javascript">
	var CONTEXT_PATH = "<%=request.getContextPath() %>";
</script>