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
		<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/jquery.tablesorter.2.0.5.min.js"></script>
		<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/ticket/tablesorter.css">
		<title>Liste des tickets</title>
		<script type="text/javascript">
			var deleteTicketMessage = '<spring:message javaScriptEscape="true" code="projecthandler.ticket.deleteConfirm"/>';
	
			$(document).ready(function() {
				$(".comfirm-delete").submit(function () {
					return confirm(deleteTicketMessage);
				});
		    });
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
					<h1 class="text-h2 container inverted-text"><span class="icon-bubbles margin-right"></span>Tickets</h1>
					<hr class="inverted-bg">
					<a class="container display-block full-width inverted-text default-btn-style5" href="${pageContext.request.contextPath}/ticket/new/${projectId}"><span class="icon-bubble margin-right"></span>Creer un nouveau ticket</a>
					<hr class="inverted-bg">
					<a class="container display-block full-width inverted-text default-btn-style5" href="${pageContext.request.contextPath}/project/viewProject/${projectId}"><span class="icon-folder margin-right"></span>Retour au projet</a>
					<hr class="inverted-bg">	
				</div>
			</div>
			<div class="display-table-cell full-width full-height">
				
				<div class="full-width full-height position-relative">
					
					<div class="position-absolute position-top position-left full-width full-height overflow-auto">
						<div class="container">
							<div class="margin-bottom clearfix">
								<h1 class="text-h2 util1-primary-text float-left">Liste des tickets</h1>
								<div class="text-h2 text-h1 float-right"><span class="icon-bubbles"></span></div>
							</div>
							<div>
							
								<c:forEach items="${ticketList}" var="ticket">
								
									<div class="display-table position-relative full-width small-margin-bottom theme3-primary-boxshadow-raising-out">
										<a href="${pageContext.request.contextPath}/ticket/${ticket.id}/messages" class="cover-btn-shape default-btn-style5 zindex-10"></a>
										<div class="display-table-cell"><div class="fixedwidth-64 fixedheight-64"></div></div>
										<div class="position-absolute position-top position-left fixedwidth-64 fixedheight-64 img-as-background" style="background-image:url(${pageContext.request.contextPath}/resources/img/no-img.png);">	
											<div class="full-width full-height img-as-background" style="background-image:url(<%=request.getContextPath() %>/downloadAvatar/${ticket.user.id});"></div>
										</div>
										<div class="display-table-cell full-width vertical-align small-container padding-left padding-right">
											<div class="">
												<div class="text-capitalize text-h4">${e:forHtml(ticket.title)}</div>
												<div class="util1-lighten2-text"><small>${e:forHtml(ticket.user.firstName)} ${e:forHtml(ticket.user.lastName)} - <fmt:formatDate value="${ticket.createdAt}" type="both" pattern="MM-dd-yyyy HH:mm" /></small></div>
											</div>
										</div>

										<c:if test="${ticket.ticketStatus.value != 'open'}">
											<div class="display-table-cell vertical-align small-container padding-left padding-right">
												<span class="util6-primary-bg inverted-text" style="padding:0px 5px 3px 5px;"><small>Fermé</small></span>
											</div>											
										</c:if>										

										<div class="display-table-cell vertical-align small-container padding-left padding-right util1-lighten3-text text-h1">
											<span class="icon-bubble"></span>
										</div>
									</div>
				
									<div class="display-none">
										<c:if test="${user.id == ticket.user.id || pageContext.request.isUserInRole('ROLE_ADMIN')}">
											<a href="${pageContext.request.contextPath}/ticket/edit/${ticket.id}">Editer</a>
										</c:if>
										
										<c:if test="${user.id == ticket.user.id || pageContext.request.isUserInRole('ROLE_ADMIN')}">
											<form method="POST" class="comfirm-delete" action="${pageContext.request.contextPath}/ticket/delete">
													<input type="hidden" name="ticketId" id="ticketId" value="${ticket.id}"/>
													<input value="Delete" type="submit">
											</form>
										</c:if>
									</div>
								</c:forEach>

							</div>
						</div>	
					</div>	
			
				</div>
			</div>
		</div>
</body>
</html>