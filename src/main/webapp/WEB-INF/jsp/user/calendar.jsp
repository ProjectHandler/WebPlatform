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

            var calendar = $('#calendar').fullCalendar({
                header: {
                    left: 'prev,next today',
                    center: 'title',
                    right: 'month,agendaWeek,agendaDay'
                        },
                    selectable: true,
                    selectHelper: true,

                select: function(start, end, allDay) {
                        var title = prompt('Event Title:');
                        if (title) {
                            calendar.fullCalendar('renderEvent',
                            {
                                title: title,
                                start: start,
                                end: end,
                                allDay: allDay
                            },
                            true // make the event "stick"
                            );
                            }
                            calendar.fullCalendar('unselect');
                        },
                                editable: true,
                                eventSources: [
                                    {
                                            url: CONTEXT_PATH+'/calendarDetails',
                                            type: 'GET',
                                            data: {
                                                start: 'start',
                                                end: 'end',
                                                id: 'id',
                                                title: 'title',
                                                description: 'description'
                                             //   allDay: 'allDay'
                                            },
                                            error: function () {
                                                alert('there was an error while fetching events!');
                                            }
                                    }
                            ],
                        eventRender: function(event, element) { 
                            element.find('.fc-title').append("<br/>" + event.description); 
                        } 
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
