<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<div id="taskBoxMessages">
	<script>
		var newCommentDivShown = false;
		var savedComment = null;

		$(document).ready(function() {
			$("#newComment-div").hide();
		});

		function switchDivForNewComment() {
			if (newCommentDivShown)
				$("#newComment-div").hide();
			else
				$("#newComment-div").show();
			newCommentDivShown = !newCommentDivShown;
			$("#newComment-textarea").val('');
		}

		function validateAddComment() {
			var desc = $('#newComment-textarea').val();
			if (desc != "") {
				$.ajax({type: "GET",
		  				url: CONTEXT_PATH + "/task/comment/save",
		  				data: { content: desc,
		  						userId: "${user.id}",
		  						taskId: "${task.id}"
		  				},
    					success: function(data) {
	    					if (data.indexOf("KO:") != -1) {
	    	    				var msg = data.replace("KO:", "");
	    	    				alert(msg);
	    	    			}
							else {
								var comment = jQuery.parseJSON(data);
								var url = CONTEXT_PATH + "/project/viewProject/${task.project.id}/tasks/${task.id}";
			    				$("#commentContainer").load(url + " #commentContainer");
			    				switchDivForNewComment();
							}
			    		},
		    			error: function(data) {
		    				alert("error: " + data);
		    			}
		    	});
			}
			else
				switchDivForNewComment();
		}

		function switchCommentEditing(id, itemName) {
			var disabled = $(itemName).attr("disabled");
			if (disabled == "disabled") {
				$(itemName).removeAttr("disabled");
				//$("#validateEditingCommentButton-" + id).removeClass("display-none");
				//$("#cancelEditingCommentButton-" + id).removeClass("display-none");
				$("#editingCommentButtonBox-" + id).removeClass("display-none");
			}
			else {
				$(itemName).attr("disabled", "disabled");
				//$("#validateEditingCommentButton-" + id).addClass("display-none");
				//$("#cancelEditingCommentButton-" + id).addClass("display-none");
				$("#editingCommentButtonBox-" + id).addClass("display-none");
			}
		}

		function startEditingComment(id) {
			var itemName = "#message-" + id;
			savedComment = $(itemName).val();
			switchCommentEditing(id, itemName);

			// if focus is lost => changes are saved
			// if canceled is clicked => mousedown event triggers before and focusout event won't be triggered.
			// because it has been unbinded (".off()") in cancelEditingComment
			// Note: timeout is required in order to let the browser set the next focused item.
			$("#messageBox-" + id).focusout(function(event){
				var $elem = $(this);
			    setTimeout(function () {
			        if (!$elem.find(':focus').length) {
			            doneEditingComment(id);
			        }
			    }, 0);
			});
		}

		function cancelEditingComment(id) {
			var itemName = "#message-" + id;
			$("#messageBox-" + id).off('focusout');
			$(itemName).val(savedComment);
			switchCommentEditing(id, itemName);
			savedComment = null;
		}

		function doneEditingComment(id) {
			var itemName = "#message-" + id;
			$(itemName).attr("disabled", "disabled");
			//$("#validateEditingCommentButton-" + id).addClass("display-none");
			//$("#cancelEditingCommentButton-" + id).addClass("display-none");
			$("#editingCommentButtonBox-" + id).addClass("display-none");
			if ($(itemName).val() != savedComment && $(itemName).val() != "") {
				changeCommentContent(id);
			}
			savedComment = null;
			$("#messageBox-" + id).off('focusout');
		}
		
		function changeCommentContent(id) {
			var desc = $('#message-' + id).val()
			$.ajax({type: "GET",
				url: CONTEXT_PATH + "/task/comment/update",
				data: {
					content: desc,
					commentId: id,
					userId: "${user.id}"
				},
				success: function(data) {
					if (data.indexOf("KO:") != -1) {
	    				var msg = data.replace("KO:", "");
	    				alert(msg);
	    			}
					else {
						var comment = jQuery.parseJSON(data);
						var url = CONTEXT_PATH + "/project/viewProject/${task.project.id}/tasks/${task.id}";
	    				$("#messageBox-" + comment.id).load(url + " #messageBox-" + comment.id);
					}
	    		},
    			error: function(data) {
    				alert("error: " + data);
    			}
		});
		}

		function deleteComment(id) {
			$.ajax({type: "GET",
  					url: CONTEXT_PATH + "/task/comment/delete",
  					data: {
  						commentId: id,
  						userId: "${user.id}"
  					},
   					success: function(data) {
    					if (data.indexOf("KO:") != -1) {
    	    				var msg = data.replace("KO:", "");
    	    				alert(msg);
    	    			}
						else {
							$("#messageBox-" + id).remove();
						}
		    		},
	    			error: function(data) {
	    				alert("error: " + data);
	    			}
			});
		}
	</script>
	<div class="container margin-left small-margin-right small-margin-bottom small-margin-top">

		<div class="display-table-cell vertical-align small-padding-right text-h1 theme3-darken1-text">
			<span class="icon-bubbles"></span>
		</div>	

		<div class="display-table-cell vertical-align padding-right">
			<h2 class="text-h1 theme3-darken1-text fixedwidth-320">Commentaires</h2>
		</div>

		<div class="display-table-cell vertical-align full-width text-right">
			<button class="default-btn-shape theme3-darken1-text theme1-lighten2-btn-style6 radius" onClick="switchDivForNewComment();">
				<span class="icon-plus small-margin-right"></span><spring:message code="projecthandler.taskBoxMessages.addComment"/>
			</button>
		</div>

	</div>
	
	<div id="newComment-div" class="theme3-lighten1-bg container display-none" style="margin-bottom:40px;">
		<div id="newComment-div" style="margin-left:70px;">
			<div class="display-table-cell vertical-align padding-right">
				<textarea id="newComment-textarea" maxlength="200" rows="2" class="textfield surrounded theme3-darken3-bdr theme3-primary-bg radius"></textarea>
			</div>
			<div class="display-table-cell vertical-align">
				<button class="default-btn-shape util3-lighten1-btn-style6" onClick="validateAddComment();">
					<span class="icon-checkmark small-margin-right"></span><spring:message code="projecthandler.taskBoxMessages.validateComment"/>
				</button>
				/
				<button class="default-btn-shape util5-lighten1-btn-style6" onClick="switchDivForNewComment();">
					<span class="icon-cross small-margin-right"></span><spring:message code="projecthandler.taskBoxMessages.cancelComment"/>
				</button>
			</div>
		</div>
	</div>	
	
	<div id="commentContainer" class="container margin-left no-padding-top margin-right">
		<c:forEach var='message' items='${taskMessages}'>
		
			<div id="messageBox-${message.id}">
		
				<div class="display-table">
				
					<div class="display-table-cell vertical-align padding-right">
						<div class="display-table-cell vertical-align">
							<div class="fixedwidth-64 fixedheight-64 circle img-as-background" style="background-image:url(${pageContext.request.contextPath}/resources/img/no-img.png);" title="${message.owner.firstName} ${message.owner.lastName}">	
								<div class="full-width full-height circle img-as-background" style="background-image:url(<%=request.getContextPath() %>/downloadAvatar/${message.owner.id});" title="${message.owner.firstName} ${message.owner.lastName}"></div>
							</div>
						</div>
					</div>
					<div class="display-table-cell vertical-align full-width">
						<textarea id="message-${message.id}" disabled="disabled" maxlength="200" class="textfield surrounded theme3-primary-bdr radius" style="width:100%;max-width:100%;">${message.content}</textarea>
					</div>
				</div>
			
				<div class="clearfix margin-bottom position-relative" style="margin-top:-5px;">
				
					<div id="editingCommentButtonBox-${message.id}" class="display-none text-right zindex-10 position-absolute position-top position-right inverted-bg fixedwidth-256">
						<button id="validateEditingCommentButton-${message.id}" class=" reduced-btn-shape small theme2-primary-btn-style6" onClick="doneEditingComment(${message.id});">
							<span class="icon-checkmark small-margin-right"></span><spring:message code="projecthandler.taskBoxMessages.validateComment"/>
						</button>
						/
						<button id="cancelEditingCommentButton-${message.id}" class=" reduced-btn-shape small util6-primary-btn-style6" onmousedown="cancelEditingComment(${message.id});">
							<span class="icon-cross small-margin-right"></span><spring:message code="projecthandler.taskBoxMessages.cancelComment"/>
						</button>
					</div>
				
					<div class="float-right">
						
						<c:if test="${user.id == message.owner.id}">
							<div>
								<button class="reduced-btn-shape small theme1-primary-btn-style6" onClick="startEditingComment(${message.id});">
									<spring:message code="projecthandler.taskBoxMessages.editComment"/>
								</button>
								<button class="reduced-btn-shape small util6-primary-btn-style6" onClick="deleteComment(${message.id});">
									<spring:message code="projecthandler.taskBoxMessages.deleteComment"/>
								</button>
							</div>
						</c:if>
					</div>
					
					<div class="float-left small theme3-primary-text" style="margin-left:90px;padding-top:2px;">
						${message.updateDate}
					</div>
				</div>
			
			</div>
			
		</c:forEach>
	</div>
	
</div>