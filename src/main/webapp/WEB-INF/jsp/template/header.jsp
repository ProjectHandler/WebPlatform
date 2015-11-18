<%@page session="false" %>

<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<script type="text/javascript">
	$(document).ready(function() {
		var savedDraftData = null;

		if (document.getElementById('text-draft-section')) {
			var draftEditor = CKEDITOR.replace('text-draft-ckeditor', {
				height: '5em',
				width: 500
			});
			$.ajax({
				type: "GET",
				url: CONTEXT_PATH + "/user/draft/get",
	    		success: function(data) {
					if (data == "KO")
	    				alert("error: " + data);
					else {
						draftEditor.setData(data, {
							callback: function() {
								savedDraftData = draftEditor.getData();
							}
						});
					}
	    		}
		    });

			draftEditor.addCommand("save", {
			    exec: function() {
			    	var draftData = draftEditor.getData();
			    	$.ajax({
						type: "POST",
						url: CONTEXT_PATH + "/user/draft/save",
						data: {
							draftMessage: draftData
						}, 
			    		success: function(data) {
			    			// TODO mettre des petits messages de fail ou success
		    				if (data == "KO")
			    				alert("error: " + data);
							else {
								savedDraftData = draftData;
								alert("Enregistrement réussi");
							}
			    		}
				    });
			    }
			});
	
			draftEditor.ui.addButton('Sauvegarder', {
			    label: '<spring:message code="projecthandler.project.edit.save"/>',
			    command: 'save',
			    toolbar: 'insert',
			    icon: '${pageContext.request.contextPath}/resources/libs/ckeditor/content-save.png'
			});
	
			draftEditor.on('key', function(obj) {
	            if (obj.data.keyCode === 8 || obj.data.keyCode === 46) {
	                return true;
	            }
	            if (draftEditor.getData().length >= 500) {
	            	// TODO show error when the user reaches 500 character +
	            	draftEditor.setData(draftEditor.getData().substring(0, draftEditor.getData().length - 1));
	                return false;
	            }
			});
	
			$("#text-draft-toggle").click(function(){
				$("#text-draft-section").toggle(400, function() {
					if ($("#text-draft-section").is(":hidden")) {
						Cookies.set("draft-toggle", "hide");
					} else {
						Cookies.set("draft-toggle", "show");
					}
				});
			});
	
			$(window).bind('beforeunload', function(event) {
				if (savedDraftData !== null && draftEditor.getData() != savedDraftData) {
					// Custom message not displayed on Firefox
					return "Vous n'avez pas sauvegardé vos notes.";
				}
			});
		}
	});
</script>

<div class="">
	<div class="small-padding-top theme1-primary-bg"></div>
	<div class="display-table full-width inverted-bg underlined theme3-lighten1-bdr">
		<div class="display-table-cell container">
			<img src="${pageContext.request.contextPath}/resources/img/logo&name.png" class="default-img-p">
		</div>
		<sec:authorize access="isAuthenticated()">
			<div class="display-table-cell container full-width clearfix">
				<ul class="unstyled-list display-table no-margin-top no-margin-bottom float-right">
					<!-- link -->
					
					<li class="position-relative vertical-top display-table-cell padding-right">
					
						<a class="display-none default-box-p display-table-cell vertical-align default-btn-style5 util3-primary-text text-h1 text-center radius animating-event" data-action="toggle-event" data-animation="pop-event" data-target="debuggingmenu" title="debugging menu" href="#" title="home">
							<span class="icon-equalizer"></span>
						</a>
						<sec:authorize access="isAuthenticated()">
							<div id="debuggingmenu" class="pop-event focus-sensitive fixedwidth-384 position-absolute position-left margin-top container theme3-darken2-boxshadow-raising-out inverted-bg zindex-50">
	
								<h1 class="margin-bottom">Debugging menu</h1>
	
								<p class="margin-bottom">you are logged as : <span class="theme2-primary-text"><sec:authentication property="principal.firstName" /> <sec:authentication property="principal.lastName" /></span></p>
								
								<ul class="margin-bottom">
									<li><a class="display-block full-width theme1-primary-text default-btn-style5" href="<c:url value="/"/>"><spring:message code="projecthandler.home"/></a></li> 
									<sec:authorize access="hasRole('ROLE_ADMIN')">
									<li><a class="display-block full-width theme1-primary-text default-btn-style5" href="<c:url value="/admin/users_management"/>">				<spring:message code="projecthandler.admin.userManagementTitle"/></a></li>
									<li><a class="display-block full-width theme1-primary-text default-btn-style5" href="<c:url value="/admin/groups_management"/>">			<spring:message code="projecthandler.admin.groupManagementTitle"/></a></li>
									</sec:authorize>
									<li><a class="display-block full-width theme1-primary-text default-btn-style5" href="<c:url value="/calendar"/>">							<spring:message code="projecthandler.menu.calendar"/></a></li>
									<li><a class="display-block full-width theme1-primary-text default-btn-style5" href="<c:url value="/changePassword"/>">						<spring:message code="projecthandler.menu.changePassword"/></a></li>
									<li><a class="display-block full-width theme1-primary-text default-btn-style5" href="<c:url value="/signup"/>">								<spring:message code="projecthandler.menu.personalInformation"/></a></li>
									<li><a class="display-block full-width theme1-primary-text default-btn-style5" href="<c:url value="/project/projectsList"/>">projects list</a></li>
									<li><a class="display-block full-width theme1-primary-text default-btn-style5" href="<c:url value="/gantt"/>">test Gantt</a></li>
								</ul>
	
								<div class="clearfix">
									<a class="default-btn-shape util4-primary-btn-style1 float-right" href="<c:url value="/j_spring_security_logout" />"><spring:message code="projecthandler.menu.logout"/></a>
								</div>
								
							</div>
						</sec:authorize>
	
					</li>
					<c:set var="draftEditorClass" value="${cookie['draft-toggle'].value == 'hide' ? 'display-none' : ''}"/>
					<li>
						<button id="text-draft-toggle">Toggle draft</button>
						<div id="text-draft-section" class="${draftEditorClass}">
							<textarea id="text-draft-ckeditor"></textarea>
						</div>
					</li>
					<li class="position-relative vertical-top display-table-cell padding-right">
						<a class="default-box-p display-table-cell vertical-align default-btn-style5 theme1-primary-text text-h1 text-center radius" href="<c:url value="/"/>" title="home">
							<span class="icon-home"></span>
						</a>
					</li>
					<li class="position-relative vertical-top display-table-cell padding-right">
						<a class="default-box-p display-table-cell vertical-align default-btn-style5 theme1-primary-text text-h1 text-center radius" href="<c:url value="/project/projectsList"/>" title="projects">
							<span class="icon-folder"></span>
						</a>
					</li>
					<li class="position-relative vertical-top display-table-cell padding-right">
						<a class="default-box-p display-table-cell vertical-align default-btn-style5 theme1-primary-text text-h1 text-center radius" href="<c:url value="/calendar"/>" title="calendar">
							<span class="icon-calendar"></span>
						</a>
					</li>
					<li class="position-relative vertical-top display-table-cell padding-right">
						<a class="default-box-p display-table-cell vertical-align default-btn-style5 theme1-primary-text text-h1 text-center radius" href="<c:url value="/gantt"/>" title="gantt">
							<span class="icon-table2"></span>
						</a>
					</li>
					<li class="position-relative vertical-top display-table-cell padding-right">
						<a class="default-box-p display-table-cell vertical-align default-btn-style5 theme1-primary-text text-h1 text-center radius" href="<c:url value="/profile/usersProfile"/>" title="users">
							<span class="icon-user"></span>
						</a>
					</li>
					<sec:authorize access="hasRole('ROLE_ADMIN')">
					<li class="position-relative vertical-top display-table-cell padding-right">
						<a class="default-btn-shape util6-primary-btn-style1" href="<c:url value="/admin/users_management"/>" title="administration">
							<span class="icon-database small-margin-right"></span>Administration
						</a>
					</li>
					</sec:authorize>
					<li class="position-relative display-table-cell">
						<div class="display-table position-relative theme3-primary-boxshadow-raising-out">
							<a class="cover-btn-shape animating-event default-btn-style5 zindex-5" data-action="toggle-event" data-animation="pop-event" data-target="mainmenu-profilebox" href="#" title="profile"></a>
							<div class="display-table-cell"><div class="default-box-p"></div></div>
							<div class="default-box-p position-absolute position-top position-left img-as-background" style="background-image:url(${pageContext.request.contextPath}/resources/img/no-img.png);">
								<div class="full-width full-height img-as-background" style="background-image:url(<%=request.getContextPath() %>/downloadAvatar/<sec:authentication property="principal.id" />);"></div>
							</div>
							<div class="display-table-cell vertical-align small-padding-left small-padding-right util1-lighten3-text">
								<sec:authorize access="isAuthenticated() && isAuthenticated()">
									<sec:authentication property="principal.firstName" />
								</sec:authorize>
							</div>
						</div>
						<div id="mainmenu-profilebox" class="pop-event focus-sensitive position-absolute position-right fixedwidth-384 inverted-bg margin-top theme3-darken2-boxshadow-raising-out zindex-50">
							<div class="position-relative">
								<div class="container underlined theme3-lighten1-bdr">
									<div class="display-table-cell">
										<div class="fixedwidth-128 fixedheight-128 img-as-background theme3-primary-boxshadow-raising-out" style="background-image:url(${pageContext.request.contextPath}/resources/img/no-img.png);">
											<div class="full-width full-height img-as-background" style="background-image:url(<%=request.getContextPath() %>/downloadAvatar/<sec:authentication property="principal.id" />);"></div>
										</div>
									</div>
									<div class="display-table-cell vertical-top padding-left full-width">
										<sec:authorize access="isAuthenticated()">
											<h1 class="no-margin-top no-margin-bottom text-h4"><sec:authentication property="principal.firstName" /> <sec:authentication property="principal.lastName" /></h1>
											<p class="no-margin-top margin-bottom small"><sec:authentication property="principal.username" /></p>
										</sec:authorize>
										<a class="default-btn-shape theme1-primary-btn-style1" href="<c:url value="/signup"/>">
											<span class="icon-user small-margin-right"></span>Mon profil
										</a>
									</div>
								</div>
								<div class="container inverted-bg clearfix">
									<div class="float-right">
										<a class="default-btn-shape default-btn-style5 theme3-primary-boxshadow-raising-out small-margin-right" href="#">
											<span class="icon-cog small-margin-right"></span>Settings
										</a>
										<a class="default-btn-shape theme1-primary-btn-style1 animating-event" data-action="open-event" data-animation="pop-event" data-target="mainmenu-leavevalidation" href="#">
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
		</sec:authorize>
	</div>
</div>

<script type="text/javascript">
	var CONTEXT_PATH = "<%=request.getContextPath() %>";
</script>