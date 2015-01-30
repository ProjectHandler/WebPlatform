<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>

<html lang="fr">
	<head>
		<title><spring:message code="projecthandler.menu.calendar"/></title>
		<spring:url value="/resources/js/jquery-1.11.1.js" var="jquery"/>
		<script type="text/javascript" src="${jquery}"></script>
		<spring:url value="/resources/js/jquery.inputmask.js" var="jqueryMask"/>
		<script type="text/javascript" src="${jqueryMask}"></script>
		<spring:url value="/resources/js/chosen.jquery.js" var="jqueryChosen"/>
		<script type="text/javascript" src="${jqueryChosen}"></script>
		
		
		<spring:url value="/resources/libs/fullcalendar/moment.min.js" var="moment"/>
		<script type="text/javascript" src="${moment}"></script>
		<spring:url value="/resources/js/fullcalendar/fullcalendar.min.js" var="fullcalendar"/>
		<script type="text/javascript" src="${fullcalendar}"></script>
		
		
		<spring:url value="/resources/css/fullcalendar/fullcalendar.css" var="fullcalendarCss"/>
		<link href="${fullcalendarCss}" rel="stylesheet"/>
		<spring:url value="/resources/css/fullcalendar/fullcalendar.print.css" var="fullcalendarPrintCss"/>
		<link href="${fullcalendarPrintCss}" rel='stylesheet' media='print'/>

		<script type="text/javascript">
		
		
		var CONTEXT_PATH = "<%=request.getContextPath() %>";
		
		$(document).ready(function() {
			
			
			$('#calendar').fullCalendar({
				header: {
					left: 'prev,next today',
					center: 'title',
					right: 'month,agendaWeek,agendaDay'
				},
				defaultDate: '2014-11-12',
				selectable: true,
				selectHelper: true,
				select: function(start, end) {
					var title = prompt('Event Title:');
					var eventData;
					if (title) {
						eventData = {
							title: title,
							start: start,
							end: end
						};
						$('#calendar').fullCalendar('renderEvent', eventData, true); // stick? = true
					}
					$('#calendar').fullCalendar('unselect');
				},
				editable: true,
				eventLimit: true, // allow "more" link when too many events
				events: [
					{
						title: 'All Day Event',
						start: '2014-11-01'
					},
					{
						title: 'Long Event',
						start: '2014-11-07',
						end: '2014-11-10'
					},
					{
						id: 999,
						title: 'Repeating Event',
						start: '2014-11-09T16:00:00'
					},
					{
						id: 999,
						title: 'Repeating Event',
						start: '2014-11-16T16:00:00'
					},
					{
						title: 'Conference',
						start: '2014-11-11',
						end: '2014-11-13'
					},
					{
						title: 'Meeting',
						start: '2014-11-12T10:30:00',
						end: '2014-11-12T12:30:00'
					},
					{
						title: 'Lunch',
						start: '2014-11-12T12:00:00'
					},
					{
						title: 'Meeting',
						start: '2014-11-12T14:30:00'
					},
					{
						title: 'Happy Hour',
						start: '2014-11-12T17:30:00'
					},
					{
						title: 'Dinner',
						start: '2014-11-12T20:00:00'
					},
					{
						title: 'Birthday Party',
						start: '2014-11-13T07:00:00'
					},
					{
						title: 'Click for Google',
						url: 'http://google.com/',
						start: '2014-11-28'
					}
				]
			});
			
		});
		</script>
		<style>

	body {
		margin: 40px 10px;
		padding: 0;
		font-family: "Lucida Grande",Helvetica,Arial,Verdana,sans-serif;
		font-size: 14px;
	}

	#calendar {
		max-width: 900px;
		margin: 0 auto;
	}

</style>
	</head>
	<body>
		<jsp:include page="../template/header.jsp" />
		<jsp:include page="../template/menu.jsp" />

		<div id='calendar'></div>
		
		<jsp:include page="../template/footer.jsp" />
	</body>
</html>
