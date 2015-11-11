<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@taglib prefix="e" uri="https://www.owasp.org/index.php/OWASP_Java_Encoder_Project" %>
<html xmlns:th="http://www.thymeleaf.org">
	<head>
		<jsp:include page="../template/head.jsp" />
		<title><spring:message code="projecthandler.projectProfileView.title"/></title>
		<script type="text/javascript">
		$(document).ready(function(){
			$('.userSelection').selectivity({
			    multiple: false,
			    placeholder: 'Type to search a user'
			});

			$('.userSelection').on("selectivity-selected", changeUser);
		});

		function changeUser(event) {
			$("#modal-btn-" + event.id).click();
			return false;
		}

		function loadModalContainer(page) {
			$("#dynamicContainerForModal").html('<iframe style="border: 0px; " src="' + page + '" width="100%" height="620px"></iframe>');
		}
		
		function openProfileViewBox(id) {
			loadModalContainer(CONTEXT_PATH + '/profile/viewProfileBox/' + id);
		}		

		</script>
	</head>
	<body>
		<div class="display-table full-width full-height">
			<div class="display-table-row">
				<jsp:include page="../template/header.jsp" />		
			</div>
			<div class="display-table full-width full-height">
				<div class="display-table-cell full-height theme1-primary-bg">
					<div class="fixedwidth-320">
						<h1 class="text-h2 container inverted-text"><span class="icon-user margin-right"></span>Utilisateurs</h1>
						<hr class="inverted-bg">
						<div class="container">
							<div class="inverted-text small-margin-bottom">
								<span class="icon-search small-margin-right"></span><spring:message code="projecthandler.projectProfileView.research"/>
							</div>
							<div>
								<select class="userSelection display-inline-block" id="userSelection">
									<c:forEach var='userSelectable' items='${usersList}'>
										<option id="${userSelectable.id}" value="${userSelectable.id}">
											${e:forHtml(userSelectable.firstName)} ${e:forHtml(userSelectable.lastName)}
										</option>
									</c:forEach>
								</select>
							</div>
						</div>	
						<hr class="inverted-bg">	
					</div>
				</div>
				<div class="display-table-cell full-width full-height">
					<div class="full-width full-height position-relative">
					
						<div id="main-modal-box" class="pop-event full-width full-height position-absolute position-top position-left default-transpbg zindex-10">
							<div class="full-width full-height display-table position-relative">
								<div class="position-absolute position-top position-right">
									<a href="#" class="default-btn-shape text-h2 inverted-text util6-lighten2-btn-style6 animating-event" data-action="close-event" data-animation="pop-event" data-target="main-modal-box"><span class="icon-cross"></span></a>
								</div>
								<div class="full-width full-height display-table-cell vertical-align">
	
									<div class="inverted-bg fixedwidth-768 margin-auto overflow-hidden position-relative">
										<div id="dynamicContainerForModal">
										</div>
									</div>
	
								</div>
							</div>
						</div>
						
						<div class="position-absolute position-top position-left full-width full-height overflow-auto">
							<div class="container">
								<div class="margin-bottom clearfix">
									<h1 class="text-h2 util1-primary-text float-left">Liste des utilisateurs</h1>
									<div class="text-h2 text-h1 float-right"><span class="icon-user"></span></div>
								</div>
								<div>	
								
									<div class="">
										<c:forEach var='userInList' items='${usersList}'>
											<div class="float-left margin-left margin-bottom position-relative rounded overflow-hidden">
											
												<div class="fixedwidth-128 fixedheight-128 img-as-background rounded" style="background-image:url(${pageContext.request.contextPath}/resources/img/no-img.png);">	
													<div class="full-width full-height img-as-background rounded" style="background-image:url(<%=request.getContextPath() %>/downloadAvatar/${userInList.id});"></div>
												</div>
											
												<div class="position-absolute position-bottom position-right small-container default-transpbg radius inverted-text" style="margin:0 0 30px 0;">
													<p class="small">${e:forHtml(userInList.firstName)}</p>
													<p class="small">${e:forHtml(userInList.lastName)}</p>
												</div>
									
												<a id="modal-btn-${userInList.id}" href="#" class="cover-btn-shape rounded default-btn-style5 animating-event" data-action="open-event" data-animation="pop-event" data-target="main-modal-box" onClick="openProfileViewBox(${userInList.id})"></a>
											</div>
										</c:forEach>
									</div>
									
								</div>
							</div>
						</div>	
					
					</div>
				</div>	
			</div>
		</div>
		
		
	</body>
</html>