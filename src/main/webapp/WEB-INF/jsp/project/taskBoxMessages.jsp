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
				$("#validateEditingCommentButton-" + id).removeClass("display-none");
				$("#cancelEditingCommentButton-" + id).removeClass("display-none");
			}
			else {
				$(itemName).attr("disabled", "disabled");
				$("#validateEditingCommentButton-" + id).addClass("display-none");
				$("#cancelEditingCommentButton-" + id).addClass("display-none");
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
			$("#validateEditingCommentButton-" + id).addClass("display-none");
			$("#cancelEditingCommentButton-" + id).addClass("display-none");
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
	<div>
		<button class="default-btn-shape theme2-primary-btn-style1" onClick="switchDivForNewComment();">
			<spring:message code="projecthandler.taskBoxMessages.addComment"/>
		</button>
		<div id="newComment-div">
			<textarea id="newComment-textarea" maxlength="200" rows="10" class="fixedmaxwidth-256 textfield surrounded theme3-primary-bdr"></textarea>
			<button class="default-btn-shape theme2-primary-btn-style1" onClick="validateAddComment();">
				<spring:message code="projecthandler.taskBoxMessages.validateComment"/>
			</button>
			<button class="default-btn-shape theme2-primary-btn-style1" onClick="switchDivForNewComment();">
				<spring:message code="projecthandler.taskBoxMessages.cancelComment"/>
			</button>
		</div>
	</div>
	<div id="commentContainer">
		<c:forEach var='message' items='${taskMessages}'>
		<div id="messageBox-${message.id}">
			<div class="display-inline-block display-table-cell vertical-align small-padding-right">
				<div class="fixedwidth-64 fixedheight-64 circle img-as-background" style="background-image:url(${pageContext.request.contextPath}/resources/img/no-img.png);" title="${message.owner.firstName} ${message.owner.lastName}">	
					<div class="full-width full-height circle img-as-background" style="background-image:url(<%=request.getContextPath() %>/downloadAvatar/${message.owner.id});" title="${message.owner.firstName} ${message.owner.lastName}"></div>
				</div>
			</div>
			<textarea id="message-${message.id}" disabled="disabled" maxlength="200" style="width: 50%;" class="display-inline-block">${message.content}</textarea>
			<button id="validateEditingCommentButton-${message.id}" class="display-none default-btn-shape theme2-primary-btn-style1" onClick="doneEditingComment(${message.id});">
				<spring:message code="projecthandler.taskBoxMessages.validateComment"/>
			</button>
			<button id="cancelEditingCommentButton-${message.id}" class="display-none default-btn-shape theme2-primary-btn-style1" onmousedown="cancelEditingComment(${message.id});">
				<spring:message code="projecthandler.taskBoxMessages.cancelComment"/>
			</button>
			<c:if test="${user.id == message.owner.id}">
				<button class="default-btn-shape theme2-primary-btn-style1" onClick="startEditingComment(${message.id});">
					<spring:message code="projecthandler.taskBoxMessages.editComment"/>
				</button>
				<button class="default-btn-shape theme2-primary-btn-style1" onClick="deleteComment(${message.id});">
					<spring:message code="projecthandler.taskBoxMessages.deleteComment"/>
				</button>
			</c:if>
			<div>
				${message.updateDate}
			</div>
		</div>
		</c:forEach>
	</div>
</div>