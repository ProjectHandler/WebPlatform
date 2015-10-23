<%@ page session="true"%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<jsp:include page="../template/head.jsp" />
	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
	<meta http-equiv="X-UA-Compatible" content="IE=9; IE=8; IE=7; IE=EDGE"/>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
	<title>Gantt</title>

	<spring:url value="/resources" var="rsc"/>
	
	<link rel=stylesheet href="${rsc}/css/gantt/platform.css" type="text/css"/>
	<link rel=stylesheet href="${rsc}/libs/gantt/dateField/jquery.dateField.css" type="text/css">

	<link rel=stylesheet href="${rsc}/css/gantt/gantt.css" type="text/css">
	<link rel=stylesheet href="${rsc}/css/gantt/ganttPrint.css" type="text/css" media="print">
	
	<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.8/jquery.min.js"></script>
	<script src="http://ajax.googleapis.com/ajax/libs/jqueryui/1.8/jquery-ui.min.js"></script>
	
	<script src="${rsc}/libs/gantt/jquery.livequery.min.js"></script>
	<script src="${rsc}/libs/gantt/jquery.timers.js"></script>
	<script src="${rsc}/libs/gantt/platform.js"></script>
	<script src="${rsc}/libs/gantt/date.js"></script>
	<script src="${rsc}/libs/gantt/i18nJs.js"></script>
	<script src="${rsc}/libs/gantt/dateField/jquery.dateField.js"></script>
	<script src="${rsc}/libs/gantt/JST/jquery.JST.js"></script>
	
	<link rel="stylesheet" type="text/css" href="${rsc}/libs/gantt/jquery.svg.css">
	<script type="text/javascript" src="${rsc}/libs/gantt/jquery.svg.min.js"></script>

	<!--In case of jquery 1.8-->
	<script type="text/javascript" src="${rsc}/libs/gantt/jquery.svgdom.1.8.js"></script>
	
	<script src="${rsc}/js/gantt/ganttUtilities.js"></script>
	<script src="${rsc}/js/gantt/ganttTask.js"></script>
	<script src="${rsc}/js/gantt/ganttDrawerSVG.js"></script>
	<!--<script src="ganttDrawer.js"></script>-->
	<script src="${rsc}/js/gantt/ganttGridEditor.js"></script>
	<script src="${rsc}/js/gantt/ganttMaster.js"></script>  
	
	<spring:url value="/resources/js/selectivity-full.min.js" var="selectivity"/>
	<script type="text/javascript" src="${selectivity}"></script>

	<script type="text/javascript">
		var messageSelectSearch = "<spring:message code='projecthandler.select.search'/>";
		var ge; //this is the hugly but very friendly global var for the gantt editor
		$(function() {
		
			//load templates
			$("#ganttemplates").loadTemplates();
		
			// here starts gantt initialization
			ge = new GanttMaster();
			var workSpace = $("#workSpace");
			workSpace.css({
				width : $(window).width() - 20,
				height : $(window).height() - 100
			});
			ge.init(workSpace);
		
			//overwrite with localized ones
			loadI18n();
		
			//simulate a data load from a server.
			loadGanttFromServer();
		
			//fill default Teamwork roles if any
			if (!ge.roles || ge.roles.length == 0) {
				setRoles();
			}
		
			//fill default Resources roles if any
			if (!ge.resources || ge.resources.length == 0) {
				setResource();
			}
		
			/*/debug time scale
			$(".splitBox2").mousemove(function(e){
			  var x=e.clientX-$(this).offset().left;
			  var mill=Math.round(x/(ge.gantt.fx) + ge.gantt.startMillis)
			  $("#ndo").html(x+" "+new Date(mill))
			});*/
		
			$(window).resize(function() {
				workSpace.css({
					width : $(window).width() - 1,
					height : $(window).height() - workSpace.position().top
				});
				workSpace.trigger("resize.gantt");
			}).oneTime(150, "resize", function() {
				$(this).trigger("resize")
			});

		});
		
		function popupAlert(title, message, error) {
			var popup = $.JST.createFromTemplate({}, "RESOURCE_POPUP_ALERT");
			popup.find("h2").text(title);
			popup.find("#msgPopup").text(message);
			popup.find("#okBtn").click(function() {
				closeBlackPopup();
			});
			if (error)
				popup.find("#okBtn").addClass('red');
			
			var ndo = createBlackPage(400, 160, loadGanttFromServer()).append(popup);
		}
		
		function loadGanttFromServer(taskId, callback) {
			//var taskId = $("#taskSelector").val();
			var prof = new Profiler("loadServerSide");
			prof.reset();
		
			var url = CONTEXT_PATH + "/gantt/load?" + "projectId="
					+ $("#selectProject option:selected").val();
		
			$.ajax({
				type : "POST",
				url : url,
				contentType: "application/json",
				dataType: "json",
				success : function(data) {
					prof.stop();
		
					//loadFromLocalStorage();
					ge.loadProject(data);
					ge.checkpoint(); //empty the undo stack
		
					if (typeof (callback) == "function") {
						callback(data);
					}
		
				}
			});
		}
		
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////		
		function saveGanttOnServer() {
			if (!ge.canWrite)
				return;
		
			//this is a simulation: save data to the local storage or to the textarea
			//saveInLocalStorage();
		
			var prj = ge.saveProject();
		
			//delete prj.resources;
			delete prj.roles;
		
			var prof = new Profiler("saveServerSide");
			prof.reset();
		
			if (ge.deletedTaskIds.length > 0) {
				if (!confirm("TASK_THAT_WILL_BE_REMOVED\n"
						+ ge.deletedTaskIds.length)) {
					return;
				}
			}

			var url = CONTEXT_PATH + "/gantt/save";
			$.ajax({
				type : "POST",
				url : url,
				data : {
					CM : "SVPROJECT",
					prj : JSON.stringify(prj),
					projectId : $("#selectProject option:selected").val()
				},
				success: function(data) {
					if (data == "success") {
						savePopup("<spring:message code='projecthandler.gantt.saveSuccess'/>");
						//loadGanttFromServer();
					} else {
						savePopup("<spring:message code='projecthandler.gantt.saveFailed'/>");
					}
				},
				error : function(error) {
					popupAlert("<spring:message code='projecthandler.general.error' />", "status: " + error.statusCode, true);
				}
			});
		}
		
		function savePopup(message) {
			var popup = $.JST.createFromTemplate({}, "RESOURCE_SAVE");
			popup.find("#msgPopup").text(message);
			popup.find("#okBtn").click(function() {
				closeBlackPopup();
			});
			
			var ndo = createBlackPage(400, 160, loadGanttFromServer()).append(popup);
		}
		
		//-------------------------------------------  Create some demo data ------------------------------------------------------
		function setRoles() {
			/*ge.roles = [
			  {
			    id:"tmp_1",
			    name:"Project Manager"
			  },
			  {
			    id:"tmp_2",
			    name:"Worker"
			  },
			  {
			    id:"tmp_3",
			    name:"Stakeholder/Customer"
			  }
			];*/
		}
		
		function setResource() {
			/*var res = [];
			for (var i = 1; i <= 10; i++) {
			  res.push({id:"tmp_" + i,name:"Resource " + i});
			}
			ge.resources = res;*/
		}
		
		function editResources() {
		
		}
		
		function clearGantt() {
			ge.reset();
		}
		

		function loadI18n() {
			GanttMaster.messages = {
				"CANNOT_WRITE" : "<spring:message code='CANNOT_WRITE'/>",
				"CHANGE_OUT_OF_SCOPE" : "<spring:message code='CHANGE_OUT_OF_SCOPE'/>",
				"START_IS_MILESTONE" : "<spring:message code='START_IS_MILESTONE'/>",
				"END_IS_MILESTONE" : "<spring:message code='END_IS_MILESTONE'/>",
				"TASK_HAS_CONSTRAINTS" : "<spring:message code='TASK_HAS_CONSTRAINTS'/>",
				"GANTT_ERROR_DEPENDS_ON_OPEN_TASK" : "<spring:message code='GANTT_ERROR_DEPENDS_ON_OPEN_TASK'/>",
				"GANTT_ERROR_DESCENDANT_OF_CLOSED_TASK" : "<spring:message code='GANTT_ERROR_DESCENDANT_OF_CLOSED_TASK'/>",
				"TASK_HAS_EXTERNAL_DEPS" : "<spring:message code='TASK_HAS_EXTERNAL_DEPS'/>",
				"GANTT_ERROR_LOADING_DATA_TASK_REMOVED" : "<spring:message code='GANTT_ERROR_LOADING_DATA_TASK_REMOVED'/>",
				"ERROR_SETTING_DATES" : "<spring:message code='ERROR_SETTING_DATES'/>",
				"CIRCULAR_REFERENCE" : "<spring:message code='CIRCULAR_REFERENCE'/>",
				"CANNOT_DEPENDS_ON_ANCESTORS" : "<spring:message code='CANNOT_DEPENDS_ON_ANCESTORS'/>",
				"CANNOT_DEPENDS_ON_DESCENDANTS" : "<spring:message code='CANNOT_DEPENDS_ON_DESCENDANTS'/>",
				"INVALID_DATE_FORMAT" : "<spring:message code='INVALID_DATE_FORMAT'/>",
				"TASK_MOVE_INCONSISTENT_LEVEL" : "<spring:message code='TASK_MOVE_INCONSISTENT_LEVEL'/>",
				
				"GANTT_QUARTER_SHORT" : "<spring:message code='GANTT_QUARTER_SHORT'/>",
				"GANTT_SEMESTER_SHORT" : "<spring:message code='GANTT_SEMESTER_SHORT'/>"
			};
		}
	
		
		//-------------------------------------------  Get project file as JSON (used for migrate project from gantt to Teamwork) ------------------------------------------------------
		function getFile() {
			$("#gimBaPrj").val(JSON.stringify(ge.saveProject()));
			$("#gimmeBack").submit();
			$("#gimBaPrj").val("");
		
			/*  var uriContent = "data:text/html;charset=utf-8," + encodeURIComponent(JSON.stringify(prj));
			 neww=window.open(uriContent,"dl");*/
		}
		
		//-------------------------------------------  Open a black popup for managing resources. This is only an axample of implementation (usually resources come from server) ------------------------------------------------------
		
		function editResources() {
		
			//make resource editor
			var resourceEditor = $.JST.createFromTemplate({}, "RESOURCE_EDITOR");
		
			//bind save event
			resourceEditor.find("#resSaveButton").click(function() {
				var newRes = [];
				var newResArray = $('.userProjectSelection').find(":selected");
		
				$.each(newResArray, function() {
					newRes.push(new Resource($(this).val(), $(this).text()));
				});
		
				ge.resources = newRes;
				closeBlackPopup();
				ge.redraw();
			});
		
			var ndo = createBlackPage(400, 300).append(resourceEditor);
		
			$('.userProjectSelection').selectivity({
				multiple : true,
				allowClear : true,
				placeholder : "<spring:message code='projecthandler.select.search'/>"
		
			});
		
			var userProjectSelected = [];
			for (var i = 0; i < ge.resources.length; i++) {
				var res = ge.resources[i];
				userProjectSelected.push({
					id : res.id,
					text : res.name
				});
			}
			$('.userProjectSelection').selectivity('data', userProjectSelected);
		}
		
		$.JST.loadDecorator("ASSIGNMENT_ROW", function(assigTr, taskAssig) {
			//useless with selectivity
		});
	</script>
	
<style>		
	label, input, table, caption, tbody, tfoot, thead, tr, th, td, {
	    margin: 0px !important;
	    padding: 10px !important;
	    border: 0px none !important;
	    font: inherit !important;
	    vertical-align: baseline !important;
	}
</style>

</head>
<body style="background-color: #fff; overflow: hidden">
	<jsp:include page="../template/header.jsp" />

	<div id="workSpace" style="padding:0px; overflow-y:auto; overflow-x:hidden;border:1px solid #e5e5e5;position:relative;margin:0 5px"></div>	

	<div id="gantEditorTemplates" style="display:none;">
	  <div class="__template__" type="GANTBUTTONS">
	  <div class="ganttButtonBar noprint" style="margin-right: 100px">
	    <div class="buttons">
	    <select id="selectProject" onchange="loadGanttFromServer()" class="ganttSelectProject" >
			<c:forEach var="project" items="${projects}">
				 <option value="${project.id}">${project.name}</option>
			</c:forEach>
		</select>

		<span class="ganttButtonSeparator"></span>
	    <button onclick="$('#workSpace').trigger('undo.gantt');" class="button textual" title="<spring:message code="projecthandler.gantt.undo"/>"><span class="teamworkIcon">&#39;</span></button>
	    <button onclick="$('#workSpace').trigger('redo.gantt');" class="button textual" title="<spring:message code="projecthandler.gantt.redo"/>"><span class="teamworkIcon">&middot;</span></button>
	    <span class="ganttButtonSeparator"></span>
	    <button onclick="$('#workSpace').trigger('addAboveCurrentTask.gantt');" class="button textual" title="<spring:message code="projecthandler.gantt.insertAbove"/>"><span class="teamworkIcon">l</span></button>
	    <button onclick="$('#workSpace').trigger('addBelowCurrentTask.gantt');" class="button textual" title="<spring:message code="projecthandler.gantt.insertBelow"/>"><span class="teamworkIcon">X</span></button>
	    <span class="ganttButtonSeparator"></span>
	    <button onclick="$('#workSpace').trigger('indentCurrentTask.gantt');" class="button textual" title="<spring:message code="projecthandler.gantt.indentTask"/>"><span class="teamworkIcon">.</span></button>
	    <button onclick="$('#workSpace').trigger('outdentCurrentTask.gantt');" class="button textual" title="<spring:message code="projecthandler.gantt.unindentTask"/>"><span class="teamworkIcon">:</span></button>
	    <span class="ganttButtonSeparator"></span>
	    <button onclick="$('#workSpace').trigger('moveUpCurrentTask.gantt');" class="button textual" title="<spring:message code="projecthandler.gantt.moveUp"/>"><span class="teamworkIcon">k</span></button>
	    <button onclick="$('#workSpace').trigger('moveDownCurrentTask.gantt');" class="button textual" title="<spring:message code="projecthandler.gantt.moveDown"/>"><span class="teamworkIcon">j</span></button>
	    <span class="ganttButtonSeparator"></span>
	    <button onclick="$('#workSpace').trigger('zoomMinus.gantt');" class="button textual" title="<spring:message code="projecthandler.gantt.zoomOut"/>"><span class="teamworkIcon">)</span></button>
	    <button onclick="$('#workSpace').trigger('zoomPlus.gantt');" class="button textual" title="<spring:message code="projecthandler.gantt.zoomIn"/>"><span class="teamworkIcon">(</span></button>
	    <span class="ganttButtonSeparator"></span>
	    <button onclick="$('#workSpace').trigger('deleteCurrentTask.gantt');" class="button textual" title="<spring:message code="projecthandler.gantt.delete"/>"><span class="teamworkIcon">&cent;</span></button>
	    <span class="ganttButtonSeparator"></span>
	    <button onclick="print();" class="button textual" title="<spring:message code="projecthandler.gantt.print"/>"><span class="teamworkIcon">p</span></button>
	    <span class="ganttButtonSeparator"></span>
	    <button onclick="ge.gantt.showCriticalPath=!ge.gantt.showCriticalPath; ge.redraw();" class="button textual" title="<spring:message code="projecthandler.gantt.criticalPath"/>"><span class="teamworkIcon">&pound;</span></button>
	    <span class="ganttButtonSeparator"></span>
	    <button onclick="editResources();" class="button textual" title="<spring:message code="projecthandler.gantt.editResources"/>"><span class="teamworkIcon">M</span></button>
	    <span class="ganttButtonSeparator"></span>
	    <!--<button onclick='getFile();' class="button textual"><spring:message code='projecthandler.gantt.export'/></button> 
	    <span class="ganttButtonSeparator"></span>-->
		<button onclick='saveGanttOnServer();' class="button textual"><spring:message code='projecthandler.gantt.save'/></button>
		<span class="ganttButtonSeparator"></span>
	    </div></div>
	  </div>
	
	  <div class="__template__" type="TASKSEDITHEAD"><!--
	  <table class="gdfTable" cellspacing="0" cellpadding="0">
	    <thead>
	    <tr style="height:40px">
	      <th class="gdfColHeader" style="width:35px;"></th>
	      <th class="gdfColHeader" style="width:25px;"></th>	
	      <th class="gdfColHeader gdfResizable" style="width:300px;"><spring:message code="projecthandler.gantt.name"/></th>
	      <th class="gdfColHeader gdfResizable" style="width:80px;"><spring:message code="projecthandler.gantt.start"/></th>
	      <th class="gdfColHeader gdfResizable" style="width:80px;"><spring:message code="projecthandler.gantt.end"/></th>
	      <th class="gdfColHeader gdfResizable" style="width:50px;"><spring:message code="projecthandler.gantt.dur"/></th>
	      <th class="gdfColHeader gdfResizable" style="width:50px;"><spring:message code="projecthandler.gantt.dep"/></th>
	      <th class="gdfColHeader gdfResizable" style="width:200px;"><spring:message code="projecthandler.gantt.assignees"/></th>
	    </tr>
	    </thead>
	  </table>
	  --></div>
	
	  <div class="__template__" type="TASKROW"><!--
	  <tr taskId="(#=obj.id#)" class="taskEditRow" level="(#=level#)">
	    <th class="gdfCell edit" align="right" style="cursor:pointer;"><span class="taskRowIndex">(#=obj.getRow()+1#)</span> <span class="teamworkIcon" style="font-size:12px;" >e</span></th>
	    <td class="gdfCell noClip" align="center"><div class="taskStatus cvcColorSquare" status="(#=obj.status#)"></div></td>
	    <td class="gdfCell indentCell" style="padding-left:(#=obj.level*10#)px;">
	      <div class="(#=obj.isParent()?'exp-controller expcoll exp':'exp-controller'#)" align="center"></div>
	      <input type="text" name="name" value="(#=obj.name#)" max="30">
	    </td>
	
	    <td class="gdfCell"><input type="text" name="start"  value="" class="date"></td>
	    <td class="gdfCell"><input type="text" name="end" value="" class="date"></td>
	    <td class="gdfCell"><input type="text" name="duration" value="(#=obj.duration#)"></td>
	    <td class="gdfCell"><input type="text" name="depends" value="(#=obj.depends#)" (#=obj.hasExternalDep?"readonly":""#)></td>
	    <td class="gdfCell taskAssigs">(#=obj.getAssigsString()#)</td>
	  </tr>
	  --></div>
	
	  <div class="__template__" type="TASKEMPTYROW"><!--
	  <tr class="taskEditRow emptyRow" >
	    <th class="gdfCell" align="right"></th>
	    <td class="gdfCell noClip" align="center"></td>
	    <td class="gdfCell"></td>
	    <td class="gdfCell"></td>
	    <td class="gdfCell"></td>
	    <td class="gdfCell"></td>
	    <td class="gdfCell"></td>
	    <td class="gdfCell"></td>
	  </tr>
	  --></div>
	
	  <div class="__template__" type="TASKBAR"><!--
	  <div class="taskBox taskBoxDiv" taskId="(#=obj.id#)" >
	    <div class="layout (#=obj.hasExternalDep?'extDep':''#)">
	      <div class="taskStatus" status="(#=obj.status#)"></div>
	      <div class="taskProgress" style="width:(#=obj.progress>100?100:obj.progress#)%; background-color:(#=obj.progress>100?'red':'rgb(153,255,51);'#);"></div>
	      <div class="milestone (#=obj.startIsMilestone?'active':''#)" ></div>
	
	      <div class="taskLabel"></div>
	      <div class="milestone end (#=obj.endIsMilestone?'active':''#)" ></div>
	    </div>
	  </div>
	  --></div>
	
	  <div class="__template__" type="CHANGE_STATUS"><!--
	    <div class="taskStatusBox">
	      <li><div class="taskStatus cvcColorSquare" status="STATUS_ACTIVE" title="active"></div><span><spring:message code='projecthandler.gantt.active'/></span></li>
	      <li><div class="taskStatus cvcColorSquare" status="STATUS_DONE" title="completed"></div><span><spring:message code='projecthandler.gantt.completed'/></span></li>
	      <li><div class="taskStatus cvcColorSquare" status="STATUS_FAILED" title="failed"></div><span><spring:message code='projecthandler.gantt.failed'/></span></li>
	      <li><div class="taskStatus cvcColorSquare" status="STATUS_SUSPENDED" title="suspended"></div><span><spring:message code='projecthandler.gantt.suspended'/></span></li>
	      <li><div class="taskStatus cvcColorSquare" status="STATUS_UNDEFINED" title="undefined"></div><span><spring:message code='projecthandler.gantt.undefined'/></span></li>
	    </div>
	  --></div>
	  
	
	  <div class="__template__" type="TASK_EDITOR"><!--
	  <div class="ganttTaskEditor" style="padding: 5px; height: 100%">
	  <table width="100%" style="padding: 5px;">
	    <tr>
	      <td>
	        <table cellpadding="5">
	          <tr>
	            <td style="padding: 10px;"><label for="name"><spring:message code='projecthandler.gantt.name'/></label><br><input type="text" name="name" id="name" value=""  size="30" class="formElements"></td>
	          </tr>
	          <tr></tr>
	            <td style="padding: 10px;">
	              <label for="description"><spring:message code='projecthandler.gantt.description'/></label><br>
	              <textarea rows="5" cols="30" id="description" name="description" class="formElements" max="500"></textarea>
	            </td>
	          </tr>
	        </table>
	      </td>
	      <td valign="top">
	        <table cellpadding="5">
	          <tr>
	          <td colspan="2" style="padding: 10px;"><label for="status"><spring:message code='projecthandler.gantt.status'/></label><br><div id="status" class="taskStatus" status=""></div></td>
	          <tr>
	          <td colspan="2" style="padding: 10px;" hidden ><label for="progress"><spring:message code='projecthandler.gantt.progress'/></label><br><input type="text" name="progress" id="progress" value="" size="3" class="formElements"></td>
	          </tr>
	          <tr>
	          <td style="padding: 10px;"><label for="start"><spring:message code='projecthandler.gantt.start'/></label><br><input type="text" name="start" id="start"  value="" class="date" size="10" class="formElements"><input type="checkbox" id="startIsMilestone"> </td>
	          <td rowspan="2" class="graph" style="padding-left:50px; vertical-align:middle;"><label for="duration"><spring:message code='projecthandler.gantt.dur'/></label><br><input type="text" name="duration" id="duration" value=""  size="5" class="formElements"></td>
	        </tr><tr>
	          <td style="padding: 10px;"><label for="end"><spring:message code='projecthandler.gantt.end'/></label><br><input type="text" name="end" id="end" value="" class="date"  size="10" class="formElements"><input type="checkbox" id="endIsMilestone"></td>
	        </table>
	      </td>
	    </tr>
	    </table>
	
	  <div id="taskAssignation">
		  <h2 style="padding: 5px 10px;"><spring:message code='projecthandler.gantt.assignees'/></h2>
		  <select class="userTaskSelection" multiple="multiple" placeholder style="width: 100%; padding: 5px 10px;">
		  </select>
	  </div>
	 
	  <div style="padding: 20px 10px 10px; position: relative; vertical-align: bottom; text-align: right; bottom: 0px;"><button id="saveButton" class="button big"><spring:message code='projecthandler.gantt.save'/></button></div>
	  </div>
	  --></div>
	
	  <div class="__template__" type="RESOURCE_EDITOR"><!-- 
	  	<div class="resourceEditor" style="padding: 5px;">
	  		<h2><spring:message code='projecthandler.gantt.team'/></h2>
				<select class="userProjectSelection" multiple="multiple" placeholder style="width: 100%">
					<c:forEach var="user" items="${users}">
						<option value="${user.id}" >${user.firstName} ${user.lastName}</option>
					</c:forEach>
				</select>
			<div style="text-align: right; padding-top: 20px"><button id="resSaveButton" class="button big"><spring:message code='projecthandler.gantt.save'/></button></div>				       					
	  	</div>-->
	 </div>
	
	
	 <div class="__template__" type="RESOURCE_SAVE"><!-- 
	  	<div style="padding: 5px;">
	  		<h2><spring:message code='projecthandler.gantt.saveTitle'/></h2>
	  		<div class="ganttPopupCenter">
	  			<label id="msgPopup"></label>
			</div>
			<div class="ganttPopupCenter">
				<button id="okBtn" class="button big"><spring:message code='projecthandler.general.ok'/></button>
			</div>				       					
	  	</div>-->
	 </div>
	 
	  <div class="__template__" type="RESOURCE_POPUP_ALERT"><!-- 
	  	<div style="padding: 5px;">
	  		<h2></h2>
	  		<div class="ganttPopupCenter">
	  			<label id="msgPopup"></label>
			</div>
			<div class="ganttPopupCenter">
				<button id="okBtn" class="button big"><spring:message code='projecthandler.general.ok'/></button>
			</div>				       					
	  	</div>-->
	 </div>
	 
	</div>
</body>
</html>