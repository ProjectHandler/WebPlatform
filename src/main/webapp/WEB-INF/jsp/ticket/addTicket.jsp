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
	<jsp:include page="../template/header.jsp" />
	<jsp:include page="../template/menu.jsp" />
	<c:if test="${isNewTicketPage}">
		<h1 class="text-h2 util1-primary-text float-left">Nouveau ticket</h1>
	</c:if>
	<c:if test="${not isNewTicketPage}">
		<h1 class="text-h2 util1-primary-text float-left">Editer le ticket</h1>
	</c:if>
	<form:form method="POST" id="ticket-form"
		action="${pageContext.request.contextPath}/ticket/save"
		modelAttribute="ticket">
		
		<form:errors path="*" cssClass="error" />
		<form:input type="hidden" path="id" />

		<div>
			<form:label path="title">Titre</form:label>
			<form:input maxlength="${ticket.titleMaxSize}" path="title"></form:input>
			<form:errors path="title" cssClass="error" />
		</div>

		<form:hidden path="project.id" />
		<div>
			<form:label path="ticketTracker">Tracker</form:label>
			<form:select path="ticketTracker.id">
				<form:options items="${ticketTrackerList}" itemValue="id"
					itemLabel="name" />
			</form:select>
		</div>

		<div>
			<form:label path="ticketPriority">Priority</form:label>

			<form:select path="ticketPriority.id">
				<form:options items="${ticketPriorityList}" itemValue="id"
					itemLabel="name" />
			</form:select>
		</div>

		<c:if test="${not isNewTicketPage}">
			<div>
				<form:label path="ticketStatus">Ticket status</form:label>
	
				<form:select path="ticketStatus">
					<form:options items="${ticketStatusList}"
						itemLabel="value" />
				</form:select>
			</div>
		</c:if>

		<div class="small-margin-bottom">
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

		<div>
			<form:label path="text">Message</form:label>
			<form:textarea maxlength="${ticket.titleMaxSize}" path="text"
				id="text-ckeditor"></form:textarea>
			<form:errors path="text" cssClass="error" />
		</div>
		<input value="Submit" type="submit">

	</form:form>
	<jsp:include page="../template/footer.jsp" />
</body>
</html>