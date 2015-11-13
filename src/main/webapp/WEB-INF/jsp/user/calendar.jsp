<!DOCTYPE html>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@taglib prefix="e" uri="https://www.owasp.org/index.php/OWASP_Java_Encoder_Project" %>


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

		
	
	#external-subtask {
		float: left;
		width: 150px;
		padding: 0 10px;
		border: 1px solid #ccc;
		background: #eee;
		text-align: left;
	}
		
	#external-subtask h4 {
		font-size: 16px;
		margin-top: 0;
		padding-top: 1em;
	}
		
	#external-subtask .fc-event {
		margin: 10px 0;
		cursor: pointer;
	}
		
	#external-subtask p {
		margin: 1.5em 0;
		font-size: 11px;
		color: #666;
	}
		
	#external-subtask p input {
		margin: 0;
		vertical-align: middle;
	}

	#calendar {
		max-width: 40%;
		margin: 0 auto;
	}

</style>
	</head>
	<body>
		<jsp:include page="../template/header.jsp" />
		
		<div id="calendarBasket" class="bootstrap">
			<div id='external-subtask'>
				<h4><spring:message code="projecthandler.calendar.basket" /></h4>
			</div>
			<div id='calendar'></div>
		</div>
			
			<div id="eventModal" style="display:none;">
			<form id="appointmentForm" class="form-horizontal" method="POST">
			<input type="hidden" id="eventId" name="eventId" value="" />
			<input type="hidden" id="usersConcern" name="usersConcern" value="" />
			    <div class="modal-header">
			        <label for=title><spring:message code="projecthandler.calendar.title" /></label>
			        <input type="text" name="title" id="title">
			    </div>
			    <div class="modal-body">
			    	<label for="daterange"><spring:message code="projecthandler.calendar.duration" /></label>
				    <input type="text" id="daterange" name="daterange"/><br>
				    <label id="descriptionLabel" for="description"><spring:message code="projecthandler.calendar.descritption" /></label>
			        <input type="text" id="description" name="description"/><br>
			        
					<div id="selectivityUserAndGroup" class="small-margin-bottom">
					<div class="display-table-cell vertical-align fixedwidth-128">
						<div class="small-margin-bottom">
							<div class="display-table-cell vertical-align fixedwidth-128">
								<label><spring:message code="projecthandler.project.edit.userSelection"/></label>
							</div>
							<div class="display-table-cell vertical-align">
								<select class="userSelection" id="userSelection" name="userSelection">
									<c:forEach var='userInList' items='${users}'>
										<option value="${userInList.id}">
											${e:forHtml(userInList.firstName)} ${e:forHtml(userInList.lastName)}
										</option>
									</c:forEach>
								</select>
							</div>
						</div>	
						<div class="margin-bottom">
							<div class="display-table-cell vertical-align fixedwidth-128">
								<label><spring:message code="projecthandler.project.edit.groupSelection" /></label>
							</div>
							<div class="display-table-cell vertical-align">
								<select class="groupSelection"  multiple="multiple" id="groupSelection">
								<c:forEach var='group' items='${groups}'>
									<option value="${group.id}">
										${group.name}
									</option>
								</c:forEach>
								</select>
							</div>
						</div>					
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
			
		<script type="text/javascript">
				
		var CONTEXT_PATH = "<%=request.getContextPath() %>";
		
		$(document).ready(function() {
			
			// TODO : type to search a group / user => language files
			$('.userSelection').selectivity({
			    multiple: true,
			    placeholder: 'Type to search a user'
			});
			
			$('.groupSelection').selectivity({
			    multiple: true,
			    placeholder: 'Type to search a group'
			});
			
			$('.groupSelection').on("change", groupChanged);

			

			
			/* initialize the external events (panier)
			-----------------------------------------------------------------*/
			var url = CONTEXT_PATH+"/calendar/calendarDetailsSubtaskUnplanned";
			$.ajax({
				  dataType: "json",
				  url: url,
				  async: false,
				  success: function (subTasks) {
					  $.each(subTasks, function (key, value) {
						  $('#external-subtask').append('<div data-subtask-id="' + value.id + '" data-type="subtask" class="fc-event">' + value.title + '</div>');
				      });
				  }
				});

			$('#external-subtask .fc-event').each(function() {
				// create an Event Object (http://arshaw.com/fullcalendar/docs/event_data/Event_Object/)
				// it doesn't need to have a start or end
				var eventObject = {
					id: $(this).id,
					title: $(this).text(),
					stick: true
				};
				// store the Event Object in the DOM element so we can get to it later
				$(this).data('eventObject', eventObject);
				// make the event draggable using jQuery UI
				$(this).draggable({
					zIndex: 999,
					scroll: false,		// prevent overflow issue
					revert: true,      	// will cause the event to go back to its
					revertDuration: 0  	//  original position after the drag
				});
			});
			/* initialize the external events (panier)						end
			-----------------------------------------------------------------*/
			
			
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
                theme: false,
                selectable: true,
                selectHelper: true,
                editable: true,
       			droppable: true,
       			dragRevertDuration: 0,
                select: function(event, start, end, allDay) {buildModal(true, start, end, "", "", "new", null);},
    			drop: function(date) { // this function is called when something is dropped
    				// retrieve the dropped element's stored Event Object
    				var originalEventObject = $(this).data('eventObject');
    				// we need to copy it, so that multiple events don't have a reference to the same object
    				var copiedEventObject = $.extend({}, originalEventObject);
    				// assign it the date that was reported
    				var tempDate = new Date(date);
    				copiedEventObject.start = date;
    				copiedEventObject.end = new Date(tempDate.setHours(tempDate.getHours()));// + 2 hour from start
    				copiedEventObject.allDay = false; 
    				
    				copiedEventObject.id = $(this).data("subtask-id");
    				copiedEventObject.type = $(this).data("type");
    				
    				// last `true` argument determines the event "sticks" 
    				//(specifying stick as true will cause the event to be permanently fixed to the calendar)
    				$('#calendar').fullCalendar('renderEvent', copiedEventObject, true);
   					$(this).remove();
   					
   					updateEventWithoutModal(copiedEventObject);
                    //fix temp, 
                    //bug clone subtask on calendar
 /*
 * TODO
 */
 					location.reload();
    				//$("#calendarBasket").load(CONTEXT_PATH + "/calendar #calendarBasket");
    			},
                eventDragStop: function(event, jsEvent, ui, view) {
                    if(event.type == 'subtask' && isEventOverDiv(jsEvent.clientX, jsEvent.clientY)) {
                    	// remove subtask from calendar
                        $('#calendar').fullCalendar('removeEvents', event._id);
                        var el = $("<div data-subtask-id='" + event._id + "' data-type='subtask' class='fc-event'>").appendTo('#external-subtask').text(event.title);
                        el.draggable({
                          zIndex: 999,
                          revert: true, 
                          revertDuration: 0 
                        });
                        el.data('event', {title: event.title, id :event.id, stick: true});
                        unplannedSubtask(event.id);
                        
                        //fix temp, 
                        //bug clone subtask on calendar
/*
 * TODO
 */
                        location.reload();
                        //$("#calendarBasket").load(CONTEXT_PATH + "/calendar #calendarBasket");
                    }
                },
                eventSources: [{
	                url: CONTEXT_PATH+'/calendar/calendarDetails',
	                type: 'GET',
	                data: {
	                    start: 'start',
	                    end: 'end',
	                    id: 'id',
	                    title: 'title',
	                    description: 'description',
	                    editable: 'editable',
	                    type: 'type' //solve the diff beetween subtask and event
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
	               			buildModal(false, moment(event.start), moment(event.end), event.title, event.description, event.id, event);
                   	});
                    element.find('.fc-title').append("<br>" + ((event.description != undefined) ? event.description : ""));
                  },
                  eventResize: 	function(event) {updateEventWithoutModal(event);},
                  eventDrop: 	function(event) {updateEventWithoutModal(event);}
                        
            }); // END calendar
            
          //Unplanned subtask (return to basket)
            var isEventOverDiv = function(x, y) {
                var external_events = $('#external-subtask');
                var offset = external_events.offset();
                offset.right = external_events.width() + offset.left;
                offset.bottom = external_events.height() + offset.top;

                // Compare
                if (x >= offset.left
                    && y >= offset.top
                    && x <= offset.right
                    && y <= offset .bottom) { return true; }
                return false;
            }

        });
		
		function unplannedSubtask(subtaskId) {
			var url = CONTEXT_PATH + "/calendar/unplannedSubtask";
			$.ajax({
				type: "POST",
				url: url,
				data: {subtaskId: subtaskId}
	   		});
		}

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
            if (event.type == "event")
            	updateEvent();
            else if (event.type == "subtask")
            	updateSubtask();
		}
		
		function buildModal(isNewEvent, start, end, title, description, id, event) {
			$('#selectivityUserAndGroup').hide();
			$('#descriptionLabel').hide();
			$('#description').hide();
			
			
			if (!event || event.type == "event") {
				$('#selectivityUserAndGroup').show();
				$('#descriptionLabel').show();
				$('#description').show();
			}
            	
			
			$('.userSelection').selectivity('clear');
			if (id != "new") {
				var url = CONTEXT_PATH+"/calendar/loadUserFromEvent";
				$.ajax({
					  dataType: "json",
					  type: "POST",
					  url: url,
					  data: "eventId=" + id,
					  async: false,
					  success: function (user) {
						  var found = false;
						  $.each(user, function (key, value) {
							  if ('${user.id}' == value.id)
								  found = true;
							  $('.userSelection').selectivity("add", {id: value.id, text: value.firstName + " " +  value.lastName});
					      });
						  if (!found)
							  $('.userSelection').selectivity("add", {id: '${user.id}', text: '${user.firstName}' + " " +  '${user.lastName}'});
					  }
				});
			} else {
				$('.userSelection').selectivity('clear');
				$('.userSelection').selectivity("add", {id: '${user.id}', text: '${user.firstName}' + " " +  '${user.lastName}'});
			}
			
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
            	$("#submitEventButton").unbind();
         		$("#submitEventButton").click(function() {creatNewEvent();});
            } else {
            	var titleModal = '<spring:message code="projecthandler.calendar.event" />';
            	var saveButton = '<spring:message code="projecthandler.signup.create" />';
            	$("#deleteEventButton").show();
            	$("#submitEventButton").unbind();
            	$("#submitEventButton").click(function() {updateEvent();});
            }
            
            $('.daterangepicker').hide();
          
            $("#submitEventButton").html(saveButton);
            $("#eventModal").dialog({ modal: true, title: titleModal, width:500});
		}
		
		function updateSubtask(){
			var url = CONTEXT_PATH+"/calendar/updateSubtask";
			var values = $('#appointmentForm').serialize();
			$.ajax({
				type: "POST",
				url: url,
				data: values
		    });
		}
		
		function creatNewEvent() {
			var userData = "";
			$.each($("#userSelection").selectivity("data"), function f(i, val) {
				userData += val.id + ",";
			});
			$("#usersConcern").val(userData);
			
			var url = CONTEXT_PATH+"/calendar/createEvent";
			var values = $('#appointmentForm').serialize();
			$.ajax({
				type: "POST",
				url: url,
				data: values
		    });
		}
		
		function updateEvent() {
			var userData = "";
			$.each($("#userSelection").selectivity("data"), function f(i, val) {
				userData += val.id + ",";
			});
			$("#usersConcern").val(userData);

			var url = CONTEXT_PATH+"/calendar/updateEvent";
			var values = $('#appointmentForm').serialize();
			$.ajax({
				type: "POST",
				url: url,
				data: values
		    });
		}
		
		function deleteEvent() {
			var url = CONTEXT_PATH + "/calendar/deleteEvent";
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
		
		/************************* selectivity user and group************************/
		function checkGroupUsers(user) {
			var found = false;
			var idToAdd = null;
			var txtToAdd = null;
			var data = $('.userSelection').selectivity('data');
			
			if (data != null && data !== undefined)
				$.each(data, function f(i, val) {
					if (user.id == val.id)
						found = true;
				});
			
			if (!found) {
				idToAdd = user.id;
				txtToAdd = user.firstName + ' ' + user.lastName;
				$('.userSelection').selectivity('add', {id: idToAdd, text: txtToAdd});
			}
		}

		function groupChanged(item) {
			var url = CONTEXT_PATH + "/project/fetchGroupUsers";
			var groupId;
			var usersInGroup;

			if (item.added) {
				groupId = item.added.id;
				$.ajax({
						type: "GET",
						url: url,
						data: {groupId: groupId}, 
			    		success: function(data) {
			    				if (data == "KO")
				    				alert("error: " + data);
			    				else {
				    				usersInGroup = jQuery.parseJSON(data);
				    				$.each(usersInGroup, function f2(i, val) {
				    					checkGroupUsers(val);
				    				});
			    				}
			    		},
			    		error: function(data) {
			    			alert("error: " + data);
			    		}
			    });
				$('.groupSelection').selectivity('remove', item.added);
			}
			
		}
		</script>
		
	</body>
</html>
