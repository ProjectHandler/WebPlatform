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
			//get businessHours from user
			var userDailyHour = '${user.dailyHour}'.split("-");
			var start = convertTo24h(userDailyHour[0]);
			var end = convertTo24h(userDailyHour[1]);
			
			//get businessDays from user, sunday = 0;
			var userWorkDay = '${user.workDay}';
			var workDay = [];
			for (var i=0, n=userWorkDay.length;i<n;i++)
				  if (userWorkDay[i] == 't') 
					  workDay.push(i == 7 ? 0 : i + 1);
			
			if ('${user.userRole}' == "ROLE_ADMIN") {
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
            	businessHours: {
            	        start: start,
            	        end: end,
            	        dow: workDay
            	    },
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
                            element.find('.fc-title').append("<br/>" + event.description != undefined ? event.description : ""); 
                        } 
                    });
            });
		
		function convertTo24h(time_str) {
		    // Convert a string like 10:05 PM to 24h format, returns like 22:5
		    var time = time_str.match(/(\d+):(\d+) (\w)/);
		    var hours = Number(time[1]);
		    var minutes = Number(time[2]);
		    var meridian = time[3].toLowerCase();

		    if (meridian == 'p' && hours < 12)
		      hours = hours + 12;
		    else if (meridian == 'a' && hours == 12)
		      hours = hours - 12;
		    return hours + ":" + minutes; 
		  }
		</script>
		
		<jsp:include page="../template/footer.jsp" />
	</body>
</html>
