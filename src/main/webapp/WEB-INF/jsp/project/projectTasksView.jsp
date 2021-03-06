<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@taglib prefix="e" uri="https://www.owasp.org/index.php/OWASP_Java_Encoder_Project" %>

<script type="text/javascript">
	$(document).ready(function(){
		$('#taskSelection').selectivity({
		    multiple: false,
		    placeholder: 'Type to search a task'
		});
	
		$('#taskSelection').on("selectivity-selected", function(item){
			var res = item.id.split("/");
			$("* [data-how-to-focus='task-" + res[1] + "-project-" + res[0] + "']").click();
		});
	});
	
	function openTaskViewBox(taskId, projectId) {
		loadModalContainer(CONTEXT_PATH + '/project/viewProject/' + projectId + "/tasks/" + taskId);
	}
</script>

<div>
	<div class="display-table full-width margin-bottom position-relative">
		<h3 class="theme3-primary-text display-table-cell vertical-align"><div class="fixedwidth-192">Liste des tâches</div></h3>
		<div class="display-table-cell vertical-align full-width">		
			<div id="tasksearch-toolBar" class="small-container">
				<select class="display-inline-block" id="taskSelection">
					<c:forEach var='taskSelectable' items='${tasks}'>
						<c:if test="${taskSelectable.level == 2}">
							<option id="${taskSelectable.id}" value="${project.id}/${taskSelectable.id}">
								${e:forHtml(taskSelectable.name)}
							</option>
						</c:if>
					</c:forEach>
				</select>
			</div>		
		</div>
		<div class="display-table-cell vertical-align">
			<div style="width:290px;">
				<a class="default-btn-shape theme3-primary-text theme1-lighten2-btn-style6 animating-event" href="#" onclick="openCreateTasksBox(${project.id})" data-action="toggle-event" data-animation="pop-event" data-target="main-modal-box">
					<span class="icon-plus small-margin-right"></span><spring:message code="projecthandler.projectView.goToCreateTasks"/>
				</a>
			</div>
		</div>
		<div class="display-table-cell vertical-align">
			<div class="display-table position-relative" style="width:30px;height:30px;">
				<a class="cover-btn-shape default-btn-style5 circle animating-event" data-action="open-event" data-animation="pop-event" data-target="tasklist-helpbox" href="#"></a>
				<div class="display-table-cell vertical-align full-width full-height util2-lighten2-bg inverted-text text-center circle text-h4" title="help">?</div>
			</div>
		</div>
		<div id="tasklist-helpbox" class="pop-event focus-sensitive fixedwidth-256 inverted-text theme1-primary-bg position-absolute position-top position-right zindex-5">
			<div class="display-table full-width position-relative small-container">
				<h3 class="display-table-cell full-width vertical-align">Aide</h3>
				<div class="display-table-cell vertical-align">
					<a class="inverted-text animating-event text-h4" data-action="close-event" data-animation="pop-event" data-target="tasklist-helpbox" href="#"><span class="icon-cross"></span></a>
				</div>
			</div>
			<hr class="inverted-bg">
			<div class="small-container">
				<div class="small-margin-bottom"><div class="display-table-cell vertical-align"><div class="display-table" style="width:30px;height:30px;"><div class="display-table-cell vertical-align full-width full-height util2-primary-bg inverted-text text-center circle text-h4 surrounded inverted-bdr" title="Tâche terminée"><span class="icon-checkmark"></span></div></div></div><div class="display-table-cell vertical-align small-padding-left">Tâche terminée</div></div>
				<div class="small-margin-bottom"><div class="display-table-cell vertical-align"><div class="display-table" style="width:30px;height:30px;"><div class="display-table-cell vertical-align full-width full-height util3-primary-bg inverted-text text-center circle text-h4 surrounded inverted-bdr" title="Tâche en cours"><span class="icon-loop"></span></div></div></div><div class="display-table-cell vertical-align small-padding-left">Tâche en cours</div></div>
				<div class="small-margin-bottom"><div class="display-table-cell vertical-align"><div class="display-table" style="width:30px;height:30px;"><div class="display-table-cell vertical-align full-width full-height util5-primary-bg inverted-text text-center circle text-h4 surrounded inverted-bdr" title="Tâche suspendue"><span class="icon-history"></span></div></div></div><div class="display-table-cell vertical-align small-padding-left">Tâche suspendue</div></div>
				<div class="small-margin-bottom"><div class="display-table-cell vertical-align"><div class="display-table" style="width:30px;height:30px;"><div class="display-table-cell vertical-align full-width full-height util6-primary-bg inverted-text text-center circle text-h4 surrounded inverted-bdr" title="Tâche abandonnée"><span class="icon-cross"></span></div></div></div><div class="display-table-cell vertical-align small-padding-left">Tâche abandonnée</div></div>
				<div><div class="display-table-cell vertical-align"><div class="display-table" style="width:30px;height:30px;"><div class="display-table-cell vertical-align full-width full-height util1-primary-bg inverted-text text-center circle text-h4 surrounded inverted-bdr" title="Tâche indéterminée">?</div></div>	</div><div class="display-table-cell vertical-align small-padding-left">Tâche indéterminée</div></div>
			</div>
		</div>
	</div>
</div>
	

<div id="sortedtasklist-container"></div>
		
<div class="theme3-primary-boxshadow-raising-out small-margin-bottom position-relative task-node-template display-none" data-task-state="">
	<div class="display-table full-width small-container">
		<div class="display-table-cell vertical-align small-padding-right text-h1 theme3-primary-text task-node-icon">
			<span class="icon-clipboard"></span>
		</div>
		<div class="display-table-cell vertical-align full-width">
			<div class="task-node-name text-h4">name</div>
			<div class="small theme3-primary-text">
				<span class="task-node-startingdate">startingdate</span> -
				<span class="task-node-endingdate">endingdate</span>
			</div>
		</div>
		<div class="display-table-cell vertical-align text-right small small-padding-left task-node-progress-container">
			<div class="fixedwidth-128 hard-surrounded theme3-lighten1-bdr rounded theme3-lighten1-bg" role="progressbar" aria-valuemin="0" aria-valuemax="100" aria-valuenow="0">
				<div class="surrounded rounded theme3-darken1-bdr theme3-darken1-bg task-node-progress"></div>
			</div>
		</div>
		<div class="display-table-cell vertical-align text-right small small-padding-left">
			<div class="display-none STATUS_DONE"><div class="display-table" style="width:30px;height:30px;"><div class="display-table-cell vertical-align full-width full-height util2-primary-bg inverted-text text-center circle text-h4"><span class="icon-checkmark"></span></div></div></div>
			<div class="display-none STATUS_ACTIVE"><div class="display-table" style="width:30px;height:30px;"><div class="display-table-cell vertical-align full-width full-height util3-primary-bg inverted-text text-center circle text-h4"><span class="icon-loop"></span></div></div></div>
			<div class="display-none STATUS_SUSPENDED"><div class="display-table" style="width:30px;height:30px;"><div class="display-table-cell vertical-align full-width full-height util5-primary-bg inverted-text text-center circle text-h4"><span class="icon-history"></span></div></div></div>
			<div class="display-none STATUS_FAILED"><div class="display-table" style="width:30px;height:30px;"><div class="display-table-cell vertical-align full-width full-height util6-primary-bg inverted-text text-center circle text-h4"><span class="icon-cross"></span></div></div></div>
			<div class="display-none STATUS_UNDEFINED"><div class="display-table" style="width:30px;height:30px;"><div class="display-table-cell vertical-align full-width full-height util1-primary-bg inverted-text text-center circle text-h4">?</div></div></div>
		</div>
	</div>
	<a class="cover-btn-shape default-btn-style5 animating-event task-node-link" data-action="toggle-event" data-animation="pop-event" data-target="main-modal-box" href="#"></a>
</div>

<script>

	var Task = function(id, name, startingDate, endingDate, status, progress, description, duration, level) {
		this._id = parseInt(id);
		this._name = name;
		this._startingDate = startingDate;
		this._endingDate = endingDate;
		this._status = status;
		this._progress = progress;
		this._description = description;
		this._duration = duration;
		this._level = level;
	}

	Task.prototype = {
		getId: function () { return this._id; },
		getName: function () { return this._name; },
		getStartingDate: function () { return this._startingDate; },
		getEndingDate: function () { return this._endingDate; },
		getStatus: function () { return this._status; },
		getProgress: function () { return this._progress; },
		getDescription: function () { return this._description; },
		getDuration: function () { return this._duration; },
		getLevel: function () { return this._level; }
	}
	
	var tasklist = new Array();
	var projectId = "${project.id}";
	
	<c:forEach var='task' items='${tasks}'>
		var task = "${task.id}";
		var task = new Task("${task.id}", "${e:forJavaScript(e:forHtml(task.name))}", new Date("${task.startingDate}").toLocaleDateString(), new Date("${task.endingDate}").toLocaleDateString(), "${task.status}", "${task.progress}", "${e:forJavaScript(e:forHtml(task.description))}", "${task.duration}", "${task.level}");
		tasklist[tasklist.length] = task;
	</c:forEach>
	
	for(var i = 0 ; i < tasklist.length ; i++) {
		var row = $(".task-node-template").clone();
		$(row).removeClass("task-node-template");
		$(row).addClass("task-node");
		$(row).attr("data-task-state", tasklist[i].getStatus());
		$(row).find(".task-node-name").html(tasklist[i].getName());
		$(row).find(".task-node-startingdate").html(tasklist[i].getStartingDate());
		$(row).find(".task-node-endingdate").html(tasklist[i].getEndingDate());
		if (tasklist[i].getLevel() == 1) { $(row).addClass("surrounded theme3-primary-bdr"); }
		if (tasklist[i].getLevel() == 2) { $(row).css("margin-left", "60px"); }
		if (tasklist[i].getLevel() == 1) { $(row).find(".task-node-icon").html("<span class=\"theme1-primary-text\"><span class=\"icon-bookmark\"></span></span>"); }
		$(row).find(".task-node-link").attr("onClick", "openTaskViewBox("+ tasklist[i].getId() + ", " + projectId + ")");
		$(row).find(".task-node-link").attr("data-how-to-focus", "task-" + tasklist[i].getId() + "-project-" + projectId + "");
		$(row).find(".task-node-progress").css("width", tasklist[i].getProgress() + "%");
		if (tasklist[i].getLevel() == 1) { $(row).find(".task-node-progress-container").html(""); }
		if (tasklist[i].getLevel() == 1) { $(row).find(".task-node-link").addClass("display-none"); }
		$(row).find("." + tasklist[i].getStatus()).show();
		$(row).appendTo("#sortedtasklist-container");
		$(row).show();
	}
	
</script>					
