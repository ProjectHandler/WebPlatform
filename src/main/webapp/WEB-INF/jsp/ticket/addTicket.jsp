<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@taglib prefix="e" uri="https://www.owasp.org/index.php/OWASP_Java_Encoder_Project" %>

<%-- Boolean to check if we are on the edit or new ticket page --%>
<c:set var="isNewTicketPage" value="${ticket.id == null}" />

<html xmlns:th="http://www.thymeleaf.org">
	<head>
		<jsp:include page="../template/head.jsp" />

		<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/jquery.tokeninput.min.js"></script>

		<spring:url value="/resources/libs/jquery-validation/jquery.validate.min.js" var="jqueryValidate"/>
		<script type="text/javascript" src="${jqueryValidate}"></script>

		<spring:url value="/resources/js/custom-selectivity.js" var="selectivityJs"/>
		<script type="text/javascript" src="${selectivityJs}"></script>

		<%-- If we don't load any localization file, language is English --%>
		<c:if test="${pageContext.response.locale.language != 'en'}">
			<c:choose>
				<c:when  test="${pageContext.response.locale.language == 'es'}">
					<spring:url value="/resources/libs/jquery-validation/localization/messages_es.js" var="jqueryValidateLang"/>
					<script type="text/javascript" src="${jqueryValidateLang}"></script>
				</c:when>
				<c:otherwise>
					<spring:url
						value="/resources/libs/jquery-validation/localization/messages_fr.js"
						var="jqueryValidateLang" />
				<script type="text/javascript" src="${jqueryValidateLang}"></script>
				</c:otherwise>
			</c:choose>
		</c:if>

		<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/tokeninput/token-input-facebook.css">
		<c:if test="${isNewTicketPage}">
			<title>Nouveau ticket</title>
		</c:if>
		<c:if test="${not isNewTicketPage}">
			<title>Edition ticket</title>
		</c:if>
		
		<script type="text/javascript">
		$(document).ready(function () {
			var textEditor = CKEDITOR.replace( 'text-ckeditor' );

			$.fn.selectivityUser({
				userElement: '#userSelection'
			});

		    var validator = $("#ticket-form").validate({
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
			$("form").submit(function(event) {
		    	var textEditorData = textEditor.getData();
		    	var stripped = $("<div/>").html(textEditorData).text();
		        if (!stripped.length) {
		        	validator.showErrors({
		        		  "text": $.validator.messages.required
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
				</div>
			</div>
			<div class="display-table-cell full-width full-height">
				
				<div class="full-width full-height position-relative">
					
					<div class="position-absolute position-top position-left full-width full-height overflow-auto">
						<div class="container">
							<div class="margin-bottom clearfix">
								<h1 class="text-h2 util1-primary-text float-left">
									<c:if test="${isNewTicketPage}">Nouveau ticket</c:if>
									<c:if test="${not isNewTicketPage}">Editer le ticket</c:if>
								</h1>
								<div class="text-h2 text-h1 float-right"><span class="icon-bubble"></span></div>
							</div>
							<div>

								<form:form method="POST" id="ticket-form"
									action="${pageContext.request.contextPath}/ticket/save"
									modelAttribute="ticket">
									
									<form:errors path="*" cssClass="error" />
									<form:input type="hidden" path="id" />
							
									<div class="display-table margin-bottom">
										<div class="display-table-cell vertical-align fixedwidth-128"><form:label path="title">Titre</form:label></div>
										<div class="display-table-cell vertical-align padding-right"><form:input maxlength="${ticket.titleMaxSize}" path="title" class="textfield surrounded theme3-primary-bdr fixedwidth-320"></form:input></div>
										<div class="display-table-cell vertical-align util6-primary-text"><form:errors path="title" cssClass="error" /></div>
									</div>
							
									<form:hidden path="project.id" />
									<div class="display-table margin-bottom">
										<div class="display-table-cell vertical-align fixedwidth-128"><form:label path="ticketTracker">Tracker</form:label></div>
										<div class="display-table-cell vertical-align padding-right">
											<form:select path="ticketTracker.id">
												<form:options items="${ticketTrackerList}" itemValue="id"
													itemLabel="name" />
											</form:select>
										</div>
									</div>
							
									<div class="display-table margin-bottom">
										<div class="display-table-cell vertical-align fixedwidth-128"><form:label path="ticketPriority">Priority</form:label></div>
										<div class="display-table-cell vertical-align padding-right">
											<form:select path="ticketPriority.id">
												<form:options items="${ticketPriorityList}" itemValue="id"
													itemLabel="name" />
											</form:select>
										</div>
									</div>
							
									<c:if test="${not isNewTicketPage}">
										<div class="display-table margin-bottom">
											<div class="display-table-cell vertical-align fixedwidth-128"><form:label path="ticketStatus">Ticket status</form:label></div>
											<div class="display-table-cell vertical-align padding-right">
											<form:select path="ticketStatus">
												<form:options items="${ticketStatusList}"
													itemLabel="value" />
											</form:select>
											</div>
										</div>
									</c:if>
							
									<div class="display-table margin-bottom">
										<div class="display-table-cell vertical-align fixedwidth-128">
											<label><spring:message
													code="projecthandler.project.edit.userSelection" /></label>
										</div>
										<div class="display-table-cell vertical-align">
											<form:select path="users" class="userSelection" id="userSelection">
												<c:forEach var='userInList' items='${usersInProject}'>
													<c:set var="found" value="false" />
													<c:if test="${ticket.users != null}">
														<c:forEach var="userInTicket" items="${ticket.users}">
															<c:if test="${userInTicket.id == userInList.id}">
																<c:set var="found" value="true" />
															</c:if>
														</c:forEach>
													</c:if>
													<c:choose>
														<c:when test="${found eq true}">
															<form:option selected="selected" value="${userInList.id}">
																${e:forHtml(userInList.firstName)} ${e:forHtml(userInList.lastName)}
															</form:option>
														</c:when>
														<c:otherwise>
															<form:option value="${userInList.id}">
																${e:forHtml(userInList.firstName)} ${e:forHtml(userInList.lastName)}
															</form:option>
														</c:otherwise>
													</c:choose>
												</c:forEach>
											</form:select>
										</div>
									</div>
							
									<div class="margin-bottom">
										<div class="margin-bottom"><form:label path="text">Message</form:label></div>
										<form:textarea maxlength="${ticket.titleMaxSize}" path="text"
											id="text-ckeditor"></form:textarea>
										<form:errors path="text" cssClass="error" />
									</div>
									<input value="Submit" type="submit" class="default-btn-shape theme1-primary-btn-style1">
							
								</form:form>

							</div>
						</div>	
					</div>	
			
				</div>
			</div>
		</div>


</body>
</html>