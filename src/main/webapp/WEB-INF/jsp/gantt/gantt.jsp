<%@ page session="true"%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
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
	
	
	<script type="text/javascript">
		var ge;  //this is the hugly but very friendly global var for the gantt editor
		$(function() {
		
		  //load templates
		  $("#ganttemplates").loadTemplates();
		
		  // here starts gantt initialization
		  ge = new GanttMaster();
		  var workSpace = $("#workSpace");
		  workSpace.css({width:$(window).width() - 20,height:$(window).height() - 100});
		  ge.init(workSpace);
		
		  //inject some buttons (for this demo only)
		  $(".ganttButtonBar div").append("<button onclick='clearGantt();' class='button'>clear</button>")
		          .append("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;")
		          .append("<button onclick='getFile();' class='button'>export</button>");
		  $(".ganttButtonBar div").addClass('buttons');
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
		
		  $(window).resize(function(){
		    workSpace.css({width:$(window).width() - 1,height:$(window).height() - workSpace.position().top});
		    workSpace.trigger("resize.gantt");
		  }).oneTime(150,"resize",function(){$(this).trigger("resize")});
		
		});
		
		
		function loadGanttFromServer(taskId, callback) {
		
		  //this is a simulation: load data from the local storage if you have already played with the demo or a textarea with starting demo data
		  loadFromLocalStorage();
		
		  //this is the real implementation
		  /*
		  //var taskId = $("#taskSelector").val();
		  var prof = new Profiler("loadServerSide");
		  prof.reset();
		
		  $.getJSON("ganttAjaxController.jsp", {CM:"LOADPROJECT",taskId:taskId}, function(response) {
		    //console.debug(response);
		    if (response.ok) {
		      prof.stop();
		
		      ge.loadProject(response.project);
		      ge.checkpoint(); //empty the undo stack
		
		      if (typeof(callback)=="function") {
		        callback(response);
		      }
		    } else {
		      jsonErrorHandling(response);
		    }
		  });
		  */
		}
		
		
		function saveGanttOnServer() {
		  if(!ge.canWrite)
		    return;
		
		
		  //this is a simulation: save data to the local storage or to the textarea
		  saveInLocalStorage();
		
		
		  /*
		  var prj = ge.saveProject();
		
		  delete prj.resources;
		  delete prj.roles;
		
		  var prof = new Profiler("saveServerSide");
		  prof.reset();
		
		  if (ge.deletedTaskIds.length>0) {
		    if (!confirm("TASK_THAT_WILL_BE_REMOVED\n"+ge.deletedTaskIds.length)) {
		      return;
		    }
		  }
		
		  $.ajax("ganttAjaxController.jsp", {
		    dataType:"json",
		    data: {CM:"SVPROJECT",prj:JSON.stringify(prj)},
		    type:"POST",
		
		    success: function(response) {
		      if (response.ok) {
		        prof.stop();
		        if (response.project) {
		          ge.loadProject(response.project); //must reload as "tmp_" ids are now the good ones
		        } else {
		          ge.reset();
		        }
		      } else {
		        var errMsg="Errors saving project\n";
		        if (response.message) {
		          errMsg=errMsg+response.message+"\n";
		        }
		
		        if (response.errorMessages.length) {
		          errMsg += response.errorMessages.join("\n");
		        }
		
		        alert(errMsg);
		      }
		    }
		
		  });
		  */
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
		
		
		function editResources(){
		
		}
		
		function clearGantt() {
		  ge.reset();
		}
		
		function loadI18n() {
		  GanttMaster.messages = {
		    "CANNOT_WRITE":                  "CANNOT_WRITE",
		    "CHANGE_OUT_OF_SCOPE":"NO_RIGHTS_FOR_UPDATE_PARENTS_OUT_OF_EDITOR_SCOPE",
		    "START_IS_MILESTONE":"START_IS_MILESTONE",
		    "END_IS_MILESTONE":"END_IS_MILESTONE",
		    "TASK_HAS_CONSTRAINTS":"TASK_HAS_CONSTRAINTS",
		    "GANTT_ERROR_DEPENDS_ON_OPEN_TASK":"GANTT_ERROR_DEPENDS_ON_OPEN_TASK",
		    "GANTT_ERROR_DESCENDANT_OF_CLOSED_TASK":"GANTT_ERROR_DESCENDANT_OF_CLOSED_TASK",
		    "TASK_HAS_EXTERNAL_DEPS":"TASK_HAS_EXTERNAL_DEPS",
		    "GANTT_ERROR_LOADING_DATA_TASK_REMOVED":"GANTT_ERROR_LOADING_DATA_TASK_REMOVED",
		    "ERROR_SETTING_DATES":"ERROR_SETTING_DATES",
		    "CIRCULAR_REFERENCE":"CIRCULAR_REFERENCE",
		    "CANNOT_DEPENDS_ON_ANCESTORS":"CANNOT_DEPENDS_ON_ANCESTORS",
		    "CANNOT_DEPENDS_ON_DESCENDANTS":"CANNOT_DEPENDS_ON_DESCENDANTS",
		    "INVALID_DATE_FORMAT":"INVALID_DATE_FORMAT",
		    "TASK_MOVE_INCONSISTENT_LEVEL":"TASK_MOVE_INCONSISTENT_LEVEL",
		
		    "GANTT_QUARTER_SHORT":"trim.",
		    "GANTT_SEMESTER_SHORT":"sem."
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
		
		
		//-------------------------------------------  LOCAL STORAGE MANAGEMENT (for this demo only) ------------------------------------------------------
		Storage.prototype.setObject = function(key, value) {
		  this.setItem(key, JSON.stringify(value));
		};
		
		
		Storage.prototype.getObject = function(key) {
		  return this.getItem(key) && JSON.parse(this.getItem(key));
		};
		
		
		function loadFromLocalStorage() {
		  var ret;
		  if (localStorage) {
		    if (localStorage.getObject("teamworkGantDemo")) {
		      ret = localStorage.getObject("teamworkGantDemo");
		    }
		  } else {
		    $("#taZone").show();
		  }
		  if (!ret || !ret.tasks || ret.tasks.length == 0){
		    ret = JSON.parse($("#ta").val());
		
		
		    //actualiza data
		    var offset=new Date().getTime()-ret.tasks[0].start;
		    for (var i=0;i<ret.tasks.length;i++)
		      ret.tasks[i].start=ret.tasks[i].start+offset;
		
		
		  }
		  ge.loadProject(ret);
		  ge.checkpoint(); //empty the undo stack
		}
		
		
		function saveInLocalStorage() {
		  var prj = ge.saveProject();
		  if (localStorage) {
		    localStorage.setObject("teamworkGantDemo", prj);
		  } else {
		    $("#ta").val(JSON.stringify(prj));
		  }
		}
		
		
		//-------------------------------------------  Open a black popup for managing resources. This is only an axample of implementation (usually resources come from server) ------------------------------------------------------
		
		function editResources(){
		
		  //make resource editor
		  var resourceEditor = $.JST.createFromTemplate({}, "RESOURCE_EDITOR");
		  var resTbl=resourceEditor.find("#resourcesTable");
		
		  for (var i=0;i<ge.resources.length;i++){
		    var res=ge.resources[i];
		    resTbl.append($.JST.createFromTemplate(res, "RESOURCE_ROW"))
		  }
		
		
		  //bind add resource
		  resourceEditor.find("#addResource").click(function(){
		    resTbl.append($.JST.createFromTemplate({id:"new",name:"resource"}, "RESOURCE_ROW"))
		  });
		
		  //bind save event
		  resourceEditor.find("#resSaveButton").click(function(){
		    var newRes=[];
		    //find for deleted res
		    for (var i=0;i<ge.resources.length;i++){
		      var res=ge.resources[i];
		      var row = resourceEditor.find("[resId="+res.id+"]");
		      if (row.size()>0){
		        //if still there save it
		        var name = row.find("input[name]").val();
		        if (name && name!="")
		          res.name=name;
		        newRes.push(res);
		      } else {
		        //remove assignments
		        for (var j=0;j<ge.tasks.length;j++){
		          var task=ge.tasks[j];
		          var newAss=[];
		          for (var k=0;k<task.assigs.length;k++){
		            var ass=task.assigs[k];
		            if (ass.resourceId!=res.id)
		              newAss.push(ass);
		          }
		          task.assigs=newAss;
		        }
		      }
		    }
		
		    //loop on new rows
		    resourceEditor.find("[resId=new]").each(function(){
		      var row = $(this);
		      var name = row.find("input[name]").val();
		      if (name && name!="")
		        newRes.push (new Resource("tmp_"+new Date().getTime(),name));
		    });
		
		    ge.resources=newRes;
		
		    closeBlackPopup();
		    ge.redraw();
		  });
		
		
		  var ndo = createBlackPage(400, 500).append(resourceEditor);
		}
	
	  $.JST.loadDecorator("ASSIGNMENT_ROW", function(assigTr, taskAssig) {
	
	    var resEl = assigTr.find("[name=resourceId]");
	    for (var i in taskAssig.task.master.resources) {
	      var res = taskAssig.task.master.resources[i];
	      var opt = $("<option>");
	      opt.val(res.id).html(res.name);
	      if (taskAssig.assig.resourceId == res.id)
	        opt.attr("selected", "true");
	      resEl.append(opt);
	    }
	
	
	    var roleEl = assigTr.find("[name=roleId]");
	    for (var i in taskAssig.task.master.roles) {
	      var role = taskAssig.task.master.roles[i];
	      var optr = $("<option>");
	      optr.val(role.id).html(role.name);
	      if (taskAssig.assig.roleId == role.id)
	        optr.attr("selected", "true");
	      roleEl.append(optr);
	    }
	
	    if(taskAssig.task.master.canWrite && taskAssig.task.canWrite){
	      assigTr.find(".delAssig").click(function() {
	        var tr = $(this).closest("[assigId]").fadeOut(200, function() {
	          $(this).remove();
	        });
	      });
	    }
	
	
	  });
	</script>
</head>
<body style="background-color: #fff; overflow: hidden">
	<jsp:include page="../template/header.jsp" />
	<jsp:include page="../template/menu.jsp" />

	<div id="workSpace" style="padding:0px; overflow-y:auto; overflow-x:hidden;border:1px solid #e5e5e5;position:relative;margin:0 5px"></div>
	
	<div id="taZone" style="display:none;" class="noprint">
	   <textarea rows="8" cols="150" id="ta">
	     {"tasks":[
	     {"id":-1,"name":"Gantt editor","code":"","level":0,"status":"STATUS_ACTIVE","canWrite":true,"start":1396994400000,"duration":21,"end":1399672799999,"startIsMilestone":true,"endIsMilestone":false,"collapsed":false,"assigs":[],"hasChild":true}
	     ],"selectedRow":0,"canWrite":true,"canWriteOnParent":true}
	   </textarea>
	
	  <button onclick="loadGanttFromServer();">load</button>
	</div>

	<form id="gimmeBack" style="display:none;" action="../gimmeBack.jsp" method="post" target="_blank"><input type="hidden" name="prj" id="gimBaPrj"></form>

	<div id="gantEditorTemplates" style="display:none;">
	  <div class="__template__" type="GANTBUTTONS"><!--
	  <div class="ganttButtonBar noprint">
	    <div class="buttons">
	    <button onclick="$('#workSpace').trigger('undo.gantt');" class="button textual" title="undo"><span class="teamworkIcon">&#39;</span></button>
	    <button onclick="$('#workSpace').trigger('redo.gantt');" class="button textual" title="redo"><span class="teamworkIcon">&middot;</span></button>
	    <span class="ganttButtonSeparator"></span>
	    <button onclick="$('#workSpace').trigger('addAboveCurrentTask.gantt');" class="button textual" title="insert above"><span class="teamworkIcon">l</span></button>
	    <button onclick="$('#workSpace').trigger('addBelowCurrentTask.gantt');" class="button textual" title="insert below"><span class="teamworkIcon">X</span></button>
	    <span class="ganttButtonSeparator"></span>
	    <button onclick="$('#workSpace').trigger('indentCurrentTask.gantt');" class="button textual" title="indent task"><span class="teamworkIcon">.</span></button>
	    <button onclick="$('#workSpace').trigger('outdentCurrentTask.gantt');" class="button textual" title="unindent task"><span class="teamworkIcon">:</span></button>
	    <span class="ganttButtonSeparator"></span>
	    <button onclick="$('#workSpace').trigger('moveUpCurrentTask.gantt');" class="button textual" title="move up"><span class="teamworkIcon">k</span></button>
	    <button onclick="$('#workSpace').trigger('moveDownCurrentTask.gantt');" class="button textual" title="move down"><span class="teamworkIcon">j</span></button>
	    <span class="ganttButtonSeparator"></span>
	    <button onclick="$('#workSpace').trigger('zoomMinus.gantt');" class="button textual" title="zoom out"><span class="teamworkIcon">)</span></button>
	    <button onclick="$('#workSpace').trigger('zoomPlus.gantt');" class="button textual" title="zoom in"><span class="teamworkIcon">(</span></button>
	    <span class="ganttButtonSeparator"></span>
	    <button onclick="$('#workSpace').trigger('deleteCurrentTask.gantt');" class="button textual" title="delete"><span class="teamworkIcon">&cent;</span></button>
	    <span class="ganttButtonSeparator"></span>
	    <button onclick="print();" class="button textual" title="print"><span class="teamworkIcon">p</span></button>
	    <span class="ganttButtonSeparator"></span>
	    <button onclick="ge.gantt.showCriticalPath=!ge.gantt.showCriticalPath; ge.redraw();" class="button textual" title="Critical Path"><span class="teamworkIcon">&pound;</span></button>
	    <span class="ganttButtonSeparator"></span>
	    <button onclick="editResources();" class="button textual" title="edit resources"><span class="teamworkIcon">M</span></button>
	      &nbsp; &nbsp; &nbsp; &nbsp;
	    </div></div>
	  --></div>
	
	  <div class="__template__" type="TASKSEDITHEAD"><!--
	  <table class="gdfTable" cellspacing="0" cellpadding="0">
	    <thead>
	    <tr style="height:40px">
	      <th class="gdfColHeader" style="width:35px;"></th>
	      <th class="gdfColHeader" style="width:25px;"></th>
	      <th class="gdfColHeader gdfResizable" style="width:30px;">code/short name</th>
	
	      <th class="gdfColHeader gdfResizable" style="width:300px;">name</th>
	      <th class="gdfColHeader gdfResizable" style="width:80px;">start</th>
	      <th class="gdfColHeader gdfResizable" style="width:80px;">end</th>
	      <th class="gdfColHeader gdfResizable" style="width:50px;">dur.</th>
	      <th class="gdfColHeader gdfResizable" style="width:50px;">dep.</th>
	      <th class="gdfColHeader gdfResizable" style="width:200px;">assignees</th>
	    </tr>
	    </thead>
	  </table>
	  --></div>
	
	  <div class="__template__" type="TASKROW"><!--
	  <tr taskId="(#=obj.id#)" class="taskEditRow" level="(#=level#)">
	    <th class="gdfCell edit" align="right" style="cursor:pointer;"><span class="taskRowIndex">(#=obj.getRow()+1#)</span> <span class="teamworkIcon" style="font-size:12px;" >e</span></th>
	    <td class="gdfCell noClip" align="center"><div class="taskStatus cvcColorSquare" status="(#=obj.status#)"></div></td>
	    <td class="gdfCell"><input type="text" name="code" value="(#=obj.code?obj.code:''#)"></td>
	    <td class="gdfCell indentCell" style="padding-left:(#=obj.level*10#)px;">
	      <div class="(#=obj.isParent()?'exp-controller expcoll exp':'exp-controller'#)" align="center"></div>
	      <input type="text" name="name" value="(#=obj.name#)">
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
	      <div class="taskStatus cvcColorSquare" status="STATUS_ACTIVE" title="active"></div>
	      <div class="taskStatus cvcColorSquare" status="STATUS_DONE" title="completed"></div>
	      <div class="taskStatus cvcColorSquare" status="STATUS_FAILED" title="failed"></div>
	      <div class="taskStatus cvcColorSquare" status="STATUS_SUSPENDED" title="suspended"></div>
	      <div class="taskStatus cvcColorSquare" status="STATUS_UNDEFINED" title="undefined"></div>
	    </div>
	  --></div>
	
	
	  <div class="__template__" type="TASK_EDITOR"><!--
	  <div class="ganttTaskEditor">
	  <table width="100%">
	    <tr>
	      <td>
	        <table cellpadding="5">
	          <tr>
	            <td><label for="code">code/short name</label><br><input type="text" name="code" id="code" value="" class="formElements"></td>
	           </tr><tr>
	            <td><label for="name">name</label><br><input type="text" name="name" id="name" value=""  size="35" class="formElements"></td>
	          </tr>
	          <tr></tr>
	            <td>
	              <label for="description">description</label><br>
	              <textarea rows="5" cols="30" id="description" name="description" class="formElements"></textarea>
	            </td>
	          </tr>
	        </table>
	      </td>
	      <td valign="top">
	        <table cellpadding="5">
	          <tr>
	          <td colspan="2"><label for="status">status</label><br><div id="status" class="taskStatus" status=""></div></td>
	          <tr>
	          <td colspan="2"><label for="progress">progress</label><br><input type="text" name="progress" id="progress" value="" size="3" class="formElements"></td>
	          </tr>
	          <tr>
	          <td><label for="start">start</label><br><input type="text" name="start" id="start"  value="" class="date" size="10" class="formElements"><input type="checkbox" id="startIsMilestone"> </td>
	          <td rowspan="2" class="graph" style="padding-left:50px"><label for="duration">dur.</label><br><input type="text" name="duration" id="duration" value=""  size="5" class="formElements"></td>
	        </tr><tr>
	          <td><label for="end">end</label><br><input type="text" name="end" id="end" value="" class="date"  size="10" class="formElements"><input type="checkbox" id="endIsMilestone"></td>
	        </table>
	      </td>
	    </tr>
	    </table>
	
	  <h2>assignments</h2>
	  <table  cellspacing="1" cellpadding="0" width="100%" id="assigsTable">
	    <tr>
	      <th style="width:100px;">name</th>
	      <th style="width:70px;">role</th>
	      <th style="width:30px;">est.wklg.</th>
	      <th style="width:30px;" id="addAssig"><span class="teamworkIcon" style="cursor: pointer">+</span></th>
	    </tr>
	  </table>
	
	  <div style="text-align: right; padding-top: 20px"><button id="saveButton" class="button big">save1</button></div>
	  </div>
	  --></div>
	
	
	  <div class="__template__" type="ASSIGNMENT_ROW"><!--
	  <tr taskId="(#=obj.task.id#)" assigId="(#=obj.assig.id#)" class="assigEditRow" >
	    <td ><select name="resourceId"  class="formElements" (#=obj.assig.id.indexOf("tmp_")==0?"":"disabled"#) ></select></td>
	    <td ><select type="select" name="roleId"  class="formElements"></select></td>
	    <td ><input type="text" name="effort" value="(#=getMillisInHoursMinutes(obj.assig.effort)#)" size="5" class="formElements"></td>
	    <td align="center"><span class="teamworkIcon delAssig" style="cursor: pointer">d</span></td>
	  </tr>
	  --></div>
	
	
	  <div class="__template__" type="RESOURCE_EDITOR"><!--
	  <div class="resourceEditor" style="padding: 5px;">
	
	    <h2>Project team</h2>
	    <table  cellspacing="1" cellpadding="0" width="100%" id="resourcesTable">
	      <tr>
	        <th style="width:100px;">name</th>
	        <th style="width:30px;" id="addResource"><span class="teamworkIcon" style="cursor: pointer">+</span></th>
	      </tr>
	    </table>
	
	    <div style="text-align: right; padding-top: 20px"><button id="resSaveButton" class="button big">save2</button></div>
	  </div>
	  --></div>
	
	
	  <div class="__template__" type="RESOURCE_ROW"><!--
	  <tr resId="(#=obj.id#)" class="resRow" >
	    <td ><input type="text" name="name" value="(#=obj.name#)" style="width:100%;" class="formElements"></td>
	    <td align="center"><span class="teamworkIcon delRes" style="cursor: pointer">d</span></td>
	  </tr>
	  --></div>
	
	
	</div>
</body>
</html>