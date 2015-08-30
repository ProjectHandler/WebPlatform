<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
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
			openProfileViewBox(event.id);
			return false;
		}

		function opendialog(page, id) {
			var $dialog = $('#' + id)
			  .html('<iframe style="border: 0px; " src="' + page + '" width="100%" height="100%"></iframe>')
			  .dialog({
			    title: '<spring:message code="projechandler.profileViewBox.title"/>',
			    autoOpen: false,
			    dialogClass: 'dialog_fixed,ui-widget-header',
			    modal: true,
			    height: 700,
			    minWidth: 1000,
			    minHeight: 700,
			    draggable:false,
			    buttons: { "Ok": function () {$(this).dialog("close"); }
			  }
			  }); 
			  $dialog.dialog('open');
		}
		
		function openProfileViewBox(id) {
			opendialog(CONTEXT_PATH + '/profile/viewProfileBox/' + id, id);
		}
		</script>
	</head>
	<body>
	<div>
		<jsp:include page="../template/header.jsp" />		
	</div>
	<div>
		<spring:message code="projecthandler.projectProfileView.research"/>: 
		<select class="userSelection display-inline-block" id="userSelection">
			<c:forEach var='userSelectable' items='${usersList}'>
				<option id="${userSelectable.id}" value="${userSelectable.id}">
					${userSelectable.firstName} ${userSelectable.lastName}
				</option>
			</c:forEach>
		</select>
	</div>
	<div>
		<c:forEach var='userInList' items='${usersList}'>
			<div>
			<div class="userView" id="${userInList.id}"></div>
			<!-- TODO just show photo + firstname + lastName -->
			<button class="display-block" onClick="openProfileViewBox(${userInList.id})">
				${userInList.firstName} ${userInList.lastName}
			</button>
			</div>
		</c:forEach>
	</div>
</body>
</html>