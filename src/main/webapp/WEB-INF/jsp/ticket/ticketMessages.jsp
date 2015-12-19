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
		<title>Ticket</title>
		<spring:url value="/resources/libs/jquery-validation/jquery.validate.min.js" var="jqueryValidate"/>
		<script type="text/javascript" src="${jqueryValidate}"></script>
		<script>
		$(document).ready(function() {
			var textEditor = CKEDITOR.replace( 'ticket-new-message' );

			var validator = $("#ticketMessage").validate({
		    	rules: {
		    		title: {
		    			required: true,
			    		minlength: <c:out value="${ticket.titleMinSize}"/>,
			    		maxlength: <c:out value="${ticket.titleMaxSize}"/>
		    		},
			   		text: {
			   			required: true,
			   		}
		    	}
	    	});
			
			<%-- If ticket text is empty, submit is canceled --%>
			$("#ticketMessage").submit(function(event) {
		    	var textEditorData = textEditor.getData();
		    	var stripped = $("<div/>").html(textEditorData).text();
		        if (!stripped.length) {
		        	validator.showErrors({
		        		  "text": "Ce champ est obligatoire."
		        	});
		            event.preventDefault();
		        }
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
					<a class="container display-block full-width inverted-text default-btn-style5" href="${pageContext.request.contextPath}/ticket/list/project/${ticket.project.id}"><span class="icon-bubbles margin-right"></span>Retour à la liste des tickets</a>
					<hr class="inverted-bg">
					<a class="container display-block full-width inverted-text default-btn-style5" href="${pageContext.request.contextPath}/project/viewProject/${ticket.project.id}"><span class="icon-folder margin-right"></span>Retour au projet</a>
					<hr class="inverted-bg">
					<c:if test="${user.id == ticket.user.id || pageContext.request.isUserInRole('ROLE_ADMIN')}">
						<a class="container display-block full-width inverted-text default-btn-style5" href="${pageContext.request.contextPath}/ticket/edit/${ticket.id}"><span class="icon-ticket margin-right"></span>Editer le tiket</a>
						<hr class="inverted-bg">
					</c:if>
				</div>
			</div>
			<div class="display-table-cell full-width full-height">
				
				<div class="full-width full-height position-relative">
					
					<div class="position-absolute position-top position-left full-width full-height overflow-auto">
						<div class="container">
							<div class="margin-bottom clearfix">
								<h1 class="text-h2 util1-primary-text float-left">
									Ticket n° ${ticket.id} - <span class="theme1-primary-text">${e:forHtml(ticket.title)}</span>
								</h1>
								<div class="text-h2 text-h1 float-right"><span class="icon-bubble"></span></div>
							</div>
							<div>
							
								<div class="ticket-message-fisrt theme1-lighten3-bg radius full-width container margin-bottom position-relative">
									
									<div class="display-table full-width">						
										<div class="display-table-cell vertical-align padding-right">
											<div class="img-as-background radius fixedwidth-128 fixedheight-128" style="background-image:url(${pageContext.request.contextPath}/resources/img/no-img.png);">	
												<div class="full-width full-height img-as-background radius" style="background-image:url(<%=request.getContextPath() %>/downloadAvatar/${ticket.user.id});"></div>
											</div>
											<p class="text-center inverted-text small-margin-top">${e:forHtml(ticket.user.firstName)}<br/>${e:forHtml(ticket.user.lastName)}</p>
										</div>
										
										<div class="display-table-cell container inverted-bg radius">
											<div>${ticket.text}</div>
										</div>
									</div>
									
									<div class="">
										<div class="ticket-message-info small small-padding-top text-right inverted-text"><fmt:formatDate value="${ticket.createdAt}" type="both" pattern="dd-MM-yyyy HH:mm" /></div>
									</div>
									
								</div>
							
								<div class="ticket-message">
									<c:forEach items="${ticketMessages}" var="message">
									
										<div class="radius full-width container margin-bottom position-relative">
											
											<div class="display-table full-width">						
												<div class="display-table-cell vertical-align padding-right">
													<div class="img-as-background radius" style="width:80px;height:80px;background-image:url(${pageContext.request.contextPath}/resources/img/no-img.png);">	
														<div class="full-width full-height img-as-background radius" style="background-image:url(<%=request.getContextPath() %>/downloadAvatar/${message.user.id});"></div>
													</div>
													<p class="text-center small-margin-top">${e:forHtml(message.user.firstName)}<br/>${e:forHtml(message.user.lastName)}</p>
												</div>
												
												<div class="display-table-cell container theme3-lighten1-bg radius full-width">
													<div>${e:forHtml(message.text)}</div>
												</div>
											</div>
											
											<div class="">
												<div class="ticket-message-info small small-padding-top text-right"><fmt:formatDate value="${message.createdAt}" type="both" pattern="dd-MM-yyyy HH:mm" /></div>
											</div>
											
										</div>
									</c:forEach>
									
									<div class="theme1-lighten3-bg container radius">
									<%-- Test if ticket is open --%>
									<c:choose>
										<c:when test="${ticket.ticketStatus == 'OPEN'}">
										 	<form:form id="ticketMessage" class="message-form" method="POST" action="${pageContext.request.contextPath}/ticket/${ticket.id}/message/save" modelAttribute="ticketMessage">
												<p class="theme1-primary-text text-h4 margin-bottom"><form:label path="text">Nouveau message</form:label></p>
												<div class="margin-bottom"><form:textarea id="ticket-new-message" maxlength="${ticket.textMaxSize}" path="text"></form:textarea></div>
												<input class="new-message-submit  default-btn-shape theme1-primary-btn-style1" value="Submit" type="submit">
											</form:form>
										</c:when>
										<c:otherwise>
											<p class="inverted-text">Ticket fermé</p>
										</c:otherwise>
									</c:choose>
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