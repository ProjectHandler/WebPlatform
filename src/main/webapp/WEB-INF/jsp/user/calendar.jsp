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
		
		<div class="bootstrap">
				
			<div id='calendar'></div>
			
			
			
			<div id="eventModal" style="display:none;">
			<form id="appointmentForm" class="form-horizontal" method="POST">
			<input type="hidden" id="eventId" name="eventId" value="" />
			    <div class="modal-header">
			        <label for=title><spring:message code="projecthandler.calendar.title" /></label>
			        <input type="text" name="title" id="title">
			    </div>
			    <div class="modal-body">
			    	<label for="daterange"><spring:message code="projecthandler.calendar.duration" /></label>
				    <input type="text" id="daterange" name="daterange"/><br>
				    <label for="description"><spring:message code="projecthandler.calendar.descritption" /></label>
			        <input type="text" id="description" name="description"/><br>
			        
					<div class="small-margin-bottom">
					<div class="display-table-cell vertical-align fixedwidth-128">
						<label><spring:message code="projecthandler.project.edit.userSelection"/></label>
					</div>
				</div>	
			    </div>
			    <div class="modal-footer">
			        <button class="btn btn-default" data-dismiss="modal" aria-hidden="true"><spring:message code="projecthandler.gantt.undo" /></button>
			        <button class="btn btn-danger" id="deleteEventButton" onclick="deleteEvent()"><spring:message code="projecthandler.admin.action.delete" /></button>
			        <button class="btn btn-primary" id="submitEventButton"></button>
			    </div>
		    </form>
			</div>

		</div>
		
		<script type="text/javascript">
				
		var CONTEXT_PATH = "<%=request.getContextPath() %>";
		

		
		$(document).ready(function() {
			//get businessHours from user
			var userDailyHour = '${user.dailyHour}'.split("-");
			var start = convertTo24h(userDailyHour[0]);
			var end = convertTo24h(userDailyHour[1]);
			
			//get businessDays from user, strat at sunday = 0;
			var userWorkDay = '${user.workDay}';
			var workDay = [];
			for (var i=0, n=userWorkDay.length;i<n;i++)
				  if (userWorkDay[i] == 't') 
					  workDay.push(i == 6 ? 0 : i + 1);
			
			if ('${user.userRole}' == "ROLE_ADMIN") {
/*
 * TODO
 */
			}

            var calendar = $('#calendar').fullCalendar({
            	businessHours: 	{
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
                	buildModal(true, start, end, "", "", "new");
                        },
                editable: true,
                eventSources: [{
                            url: CONTEXT_PATH+'/calendarDetails',
                            type: 'GET',
                            data: {
                                start: 'start',
                                end: 'end',
                                id: 'id',
                                title: 'title',
                                description: 'description',
                                editable: 'editable',
                             //   allDay: 'allDay'
                            },
                            error: function () {
                                alert('there was an error while fetching events!');
                            }
                    }],
                        eventRender: function(event, element) {//edit event
                          	element.click(function() {
                          		$("#eventId").val(event.id);
                          		if (event.editable)
                          			buildModal(false, moment(event.start), moment(event.end), event.title, event.description, event.id);
                          	});
                            element.find('.fc-title').append("<br/>" + event.description != undefined ? event.description : "");
                        },
                        eventResize: function(event) {
                        	updateEventWithoutModal(event);
                        },
                        eventDrop: function(event) {
                        	updateEventWithoutModal(event);
                        }
                    });
            });

		function updateEventWithoutModal(event) {
			$("#eventId").val(event.id);
        	$('input[name="daterange"]').daterangepicker({
		        timePicker: true,
		        pickTime: true,
		        autoApply: false,
		        format: 'DD/MM/YYYY h:mm A',
		        timePickerIncrement: 30,
		        timePicker12Hour: false
		    });
        	$('.daterangepicker').hide();
            $("#daterange").data('daterangepicker').setStartDate(event.start);
            $("#daterange").data('daterangepicker').setEndDate(event.end);
            $("#title").val(event.title);
            $("#description").val(event.description);
            updateEvent();
		}
		
		function buildModal(isNewEvent, start, end, title, description, id) {
            $('input[name="daterange"]').daterangepicker({
		        timePicker: true,
		        pickTime: true,
		        autoApply: false,
		        format: 'DD/MM/YYYY h:mm A',
		        timePickerIncrement: 30,
		        timePicker12Hour: false
		    });
            $("#daterange").data('daterangepicker').setStartDate(start);
            $("#daterange").data('daterangepicker').setEndDate(end);
            $("#title").val(title);
            $("#description").val(description);
            if (isNewEvent) {
            	var titleModal = '<spring:message code="projecthandler.calendar.newEvent" />';
            	var saveButton = '<spring:message code="projecthandler.calendar.create" />';
            	$("#deleteEventButton").hide();
         		$("#submitEventButton").click(function() {creatNewEvent();});
            } else {
            	var titleModal = '<spring:message code="projecthandler.calendar.event" />';
            	var saveButton = '<spring:message code="projecthandler.signup.create" />';
            	$("#deleteEventButton").show();
            	$("#submitEventButton").click(function() {updateEvent();});
            }
            
            $('.daterangepicker').hide();
          
            $("#submitEventButton").html(saveButton);
            $("#eventModal").dialog({ modal: true, title: titleModal, width:500});
		}
		
		function creatNewEvent() {
			var url = CONTEXT_PATH+"/createEvent";
			var values = $('#appointmentForm').serialize();
			$.ajax({
				type: "POST",
				url: url,
				data: values
		    });
		}
		
		function updateEvent() {
			var url = CONTEXT_PATH+"/updateEvent";
			var values = $('#appointmentForm').serialize();
			$.ajax({
				type: "POST",
				url: url,
				data: values
		    });
		}
		
		function deleteEvent() {
			var url = CONTEXT_PATH + "/deleteEvent";
			$.ajax({
				type: "POST",
				url: url,
				data: {eventId: $("#eventId").val()}
	   		});
		}
		
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
		
	</body>
</html>
