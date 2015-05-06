<!DOCTYPE html>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>


<html lang="fr">
	<head>
		<jsp:include page="../template/head.jsp" />
		<title><spring:message code="projecthandler.menu.calendar"/></title>
		
		<spring:url value="/resources/js/fullcalendar/moment.min.js" var="moment"/>
		<script type="text/javascript" src="${moment}"></script>
		
		<spring:url value="/resources/js/daterangepicker.js" var="daterangepicker"/>
		<script type="text/javascript" src="${daterangepicker}"></script>
		
		<spring:url value="/resources/js/fullcalendar/fullcalendar.min.js" var="fullcalendar"/>
		<script type="text/javascript" src="${fullcalendar}"></script>
		
		<spring:url value="/resources/css/fullcalendar/fullcalendar.css" var="fullcalendarCss"/>
		<link href="${fullcalendarCss}" rel="stylesheet"/>
		
		<spring:url value="/resources/css/fullcalendar/fullcalendar.print.css" var="fullcalendarPrintCss"/>
		<link href="${fullcalendarPrintCss}" rel='stylesheet' media='print'/>

		<spring:url value="/resources/css/daterangepicker/daterangepicker-bs3.css" var="daterangepickerBs3"/>
		<link href="${daterangepickerBs3}" rel='stylesheet'/>
		
		<spring:url value="/resources/css/bootstrap.min.css" var="bootstrap"/>
		<link href="${bootstrap}" rel='stylesheet'/>

		<style>

	#calendar {
		max-width: 40%;
		margin: 0 auto;
	}

</style>
	</head>
	<body>
		<jsp:include page="../template/header.jsp" />
		<jsp:include page="../template/menu.jsp" />
		

	<form id="createEvent" name="createEvent" method="post">
		<div id='daterangeDiv'>
		</div>
	</form>
				
		<div id='calendar'></div>
		
		<script type="text/javascript">
				
		var CONTEXT_PATH = "<%=request.getContextPath() %>";
		
		function createEventFromDatePiker() {
		/*
		 * TODO check input
		 */
			$('#createEvent').attr("action", CONTEXT_PATH+"/createEvent");
			$('#createEvent').submit();
		}
		
		$(document).ready(function() {
			var userRole = '<sec:authentication property="principal.userRole"/>';// $("#userRole").val();
			if (userRole == "ROLE&#95;ADMIN") {
				var creatFormEvent = '<label><spring:message code="projecthandler.calendar.title" /></label>' + '<input type="text" name="title"/>' 
				+ '<label><spring:message code="projecthandler.calendar.descritption" /></label>' + '<input type="text" name="description"/>'
				+ '</br>' + '<input type="text" name="daterange"/>' 
				+ '<button type="button" id="btnSave" onclick="createEventFromDatePiker()"><spring:message code="projecthandler.signup.create" /></button>';
				
				$("#daterangeDiv").append(creatFormEvent);

				$('input[name="daterange"]').daterangepicker({
			        timePicker: true,
			        format: 'DD/MM/YYYY h:mm A',
			        timePickerIncrement: 30,
			        timePicker12Hour: false
			    });
			}

            var calendar = $('#calendar').fullCalendar({
                header: {
                    left: 'today prev,next',
                    center: 'title',
                    right: 'month,agendaWeek,agendaDay'
                        },
                    firstDay:1,
                    defaultView: 'agendaWeek',
                    theme:false,
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
		
		<jsp:include page="../template/footer.jsp" />
	</body>
</html>
