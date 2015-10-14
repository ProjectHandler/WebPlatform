<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<html xmlns:th="http://www.thymeleaf.org">
	<head>
		<jsp:include page="../template/head.jsp" />
		<title><spring:message code="projechandler.profileViewBox.title"/></title>
	</head>
	<body>
		<div class="full-width full-height overflow-hidden">
		
			<div class="clearfix">
				<div class="fixedwidth-384 fixedheight-384 img-as-background rounded float-left" style="background-image:url(${pageContext.request.contextPath}/resources/img/no-img.png);margin-top:-60px;margin-left:-60px;">	
					<div class="full-width full-height img-as-background rounded" style="background-image:url(<%=request.getContextPath() %>/downloadAvatar/${userToFind.id});"></div>
				</div>		
			
				<div class="float-left">
					<div style="padding: 0 0 0 0; margin: 90px 0 0 90px;">
						<div class="text-h1">Utilisateur n° ${userToFind.id}</div>
						<div class="text-h2 theme3-primary-text">${userToFind.firstName} ${userToFind.lastName}</div>
						<div class="text-h4 theme1-primary-text">${userToFind.email}</div>
						<c:if test="${userToFind.userRole == 'ROLE_ADMIN'}">
							<div class="display-inline-block small-container margin-top util6-primary-bg inverted-text">Administrateur</div>										
						</c:if>
						<c:if test="${userToFind.userRole != 'ROLE_ADMIN'}">
							<div class="display-inline-block small-container margin-top util2-primary-bg inverted-text">Utilisateur</div>										
						</c:if>	
					</div>
				</div>
			</div>
			
			<div style="padding:40px 0 0 50px;">
				<div class="text-h1 margin-bottom padding-bottom">Projets en cours</div>
				<div class="overflow-auto theme3-lighten1-bg padding-top padding-bottom" style="width:660px;height:130px;">
				<c:forEach var="project" items="${userToFind.projects}">
					<div class="margin-left margin-bottom">
						<div class="text-h1 display-table-cell vertical-align theme3-darken2-text padding-right">
							<span class="icon-folder"></span>
						</div>
						<div class="display-table-cell vertical-align">
							<div class="text-h3">${project.name}</div>
							<div class="small theme3-darken2-text">${project.status}</div>
						</div>
					</div>
				</c:forEach>
				</div>
			</div>
		
		</div>
		
	</body>
</html>