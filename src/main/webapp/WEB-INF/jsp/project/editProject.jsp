<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<html xmlns:th="http://www.thymeleaf.org">
	<head>
		<jsp:include page="../template/head.jsp" />
		<title>Edit project</title>
		<script type="text/javascript">
		var CONTEXT_PATH = "<%=request.getContextPath() %>";
		
		$(document).ready(function() {
			// TODO : type to search a group / user => fichier de langue
			$('.userSelection').selectivity({
			    multiple: true,
			    placeholder: 'Type to search a user'
			});
			
			$('.groupSelection').selectivity({
			    multiple: true,
			    placeholder: 'Type to search a group'
			});
			
			$('.groupSelection').on("change", groupChanged);
			
			$("#name").focusout(function() {
				validateName();
			});
			
			$(function() {
			    $("#dateBegin").datepicker({
			    	dateFormat: 'dd/mm/yy',
			    	altField  : '#alt-dateBegin',
			        altFormat : 'yy-mm-dd',
			        onSelect : function() {
			        	validateDateBegin();
			        }
			    });
			});
			
			$(function() {
			    $("#dateEnd").datepicker({
			    	dateFormat: 'dd/mm/yy',
			    	altField  : '#alt-dateEnd',
			        altFormat : 'yy-mm-dd',
			        onSelect : function() {
			        	validateDateEnd();
			        }
			    });
			});
		});
		
		function validateForm() {
			return validateName() && validateDateBegin() && validateDateEnd();
		}
		
		function validateName() {
			var name = $("#name").val();
			$("#nameError").html("");
			if((name == null || name.length == 0)) {
				$("#nameError").html('<spring:message javaScriptEscape="true" code="projecthandler.project.edit.error.name"/>');
				return false;
			}
			return true;
		}

		// TO understand => it is supposed to be > 0 but does not work like this
		function validateDateBegin() {
			var dateBegin = new Date($("#alt-dateBegin").val());
			var dateEnd = new Date($("#alt-dateEnd").val());
			var res = dateEnd.getTime() - dateBegin.getTime();
			$("#dateBeginError").html("");
			$("#dateEndError").html("");
			if((dateBegin == null || (res < 0))) {
				$("#dateBeginError").html('<spring:message javaScriptEscape="true" code="projecthandler.project.edit.error.dateBegin"/>');
				return false;
			}
			else if (res == 0) {
				$("#dateEndError").html('<spring:message javaScriptEscape="true" code="projecthandler.project.edit.error.minimumDuration"/>');
				return false;
			}
			return true;
		}
		
		// TO understand => it is supposed to be > 0 but does not work like this
		function validateDateEnd() {
			var dateBegin = new Date($("#alt-dateBegin").val());
			var dateEnd = new Date($("#alt-dateEnd").val());
			var res = dateEnd.getTime() - dateBegin.getTime();
			$("#dateBeginError").html("");
			$("#dateEndError").html("");
			if((dateEnd == null || (res < 0))) {
				$("#dateEndError").html('<spring:message javaScriptEscape="true" code="projecthandler.project.edit.error.dateEnd"/>');
				return false;
			}
			else if (res == 0) {
				$("#dateEndError").html('<spring:message javaScriptEscape="true" code="projecthandler.project.edit.error.minimumDuration"/>');
				return false;
			}
			return true;
		}
		
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
		
		function confirmDelete() {
			return confirm('<spring:message code="projecthandler.project.edit.deleteConfirm"/>');
		}
		</script>
	</head>
<body>
	<div class="display-table full-width full-height">
		<div class="display-table-row">
			<jsp:include page="../template/header.jsp" />		
		</div>
		<div class="display-table full-width full-height">
			<div class="display-table-cell full-height theme1-primary-bg">
				<div class="fixedwidth-320">
					<h1 class="text-h2 container inverted-text"><span class="icon-folder margin-right"></span>Projets</h1>
					<hr class="inverted-bg">
					<a class="container display-block full-width inverted-text default-btn-style5" href="<c:url value="/project/edit"/>"><span class="icon-folder-plus margin-right"></span>Creer un nouveau projet</a>
					<hr class="inverted-bg">
					<a class="container display-block full-width inverted-text default-btn-style5" href="<c:url value="/project/projectsList"/>"><span class="icon-folder-open margin-right"></span>Liste des projets</a>
					<hr class="inverted-bg">	
				</div>
			</div>
			<div class="display-table-cell full-width full-height position-relative">
				
				<div class="position-absolute position-top position-left full-width full-height overflow-auto">
					<div class="container">
						<div class="margin-bottom clearfix">
							<c:if test="${project.id == null}">
								<h1 class="text-h2 util1-primary-text float-left">Creer un nouveau projet</h1>
							</c:if>
							<c:if test="${project.id != null}">
								<h1 class="text-h2 util1-primary-text float-left">Editer le projet</h1>
							</c:if>
							<div class="text-h2 text-h1 float-right"><span class="icon-folder-plus"></span></div>
						</div>
						<div>
						
							<form:form method="POST" modelAttribute="project" id="addProject" action="${pageContext.request.contextPath}/project/save" onsubmit="return validateForm();">
								<form:input type="hidden" path="id" name="projectId" id="projectId" value="${project.id}"/>
								
									<div class="small-margin-bottom">
										<div class="display-table-cell vertical-align">
											<div class=" fixedwidth-128"><label><spring:message code="projecthandler.project.edit.name" />
											<spring:message code="projecthandler.field.required"/></label></div>
										</div>
										<div class="display-table-cell vertical-align fixedmaxwidth-256">
											<form:input path="name" type="text" maxlength="30" id="name" class="fixedmaxwidth-256 textfield surrounded theme3-primary-bdr" value="${project.name}"></form:input>
											<span class="error" id="nameError"></span>
										</div>
									</div>
									
									<div class="small-margin-bottom">
										<div class="display-table-cell vertical-align fixedwidth-128">
											<div class=" fixedwidth-128"><label><spring:message code="projecthandler.project.edit.description" /></label></div>
										</div>
										<div class="display-table-cell vertical-align fixedmaxwidth-256">
											<form:textarea path="description" id="description" maxlength="500" rows="10" class="fixedmaxwidth-256 textfield surrounded theme3-primary-bdr" content="${project.description}"></form:textarea>
										</div>
									</div>
									
									<div class="small-margin-bottom">
										<div class="display-table-cell vertical-align">
											<div class=" fixedwidth-128"><label><spring:message code="projecthandler.project.edit.beginDate" /></label>
											<fmt:formatDate value="${project.dateBegin}" var="dateBeginString" pattern="dd/MM/yyyy" /></div>
										</div>
										<div class="display-table-cell vertical-align fixedmaxwidth-256">
											<form:input id="alt-dateBegin" path="dateBegin" type="hidden" value="${project.dateBegin}"/>
											<input  id="dateBegin" value="${dateBeginString}" class="textfield surrounded fixedmaxwidth-256 theme3-primary-bdr" >
											<span class="error" id="dateBeginError"></span>
										</div>
									</div>
									<div class="small-margin-bottom">
										<div class="display-table-cell vertical-align">
											<div class=" fixedwidth-128"><label><spring:message code="projecthandler.project.edit.endDate" /></label>
											<fmt:formatDate value="${project.dateEnd}" var="dateEndString" pattern="dd/MM/yyyy" /></div>
										</div>
										<div class="display-table-cell vertical-align fixedmaxwidth-256">
											<form:input id="alt-dateEnd" path="dateEnd" type="hidden" value="${project.dateEnd}"/>
											<input  id="dateEnd" value="${dateEndString}" class="textfield surrounded fixedmaxwidth-256 theme3-primary-bdr" >
											<span class="error" id="dateEndError"></span>
										</div>
									</div>										
										
									<div class="small-margin-bottom">
										<div class="display-table-cell vertical-align fixedwidth-128">
											<label><spring:message code="projecthandler.project.edit.userSelection"/></label>
										</div>
										<div class="display-table-cell vertical-align">
											<form:select path="users" class="userSelection" id="userSelection">
												<c:forEach var='userInList' items='${users}'>
													<c:set var="found" value= "false"/>
													<c:if test="${project.users != null}">
														<c:forEach var="userInProj" items="${project.users}">
															<c:if test="${userInProj.id == userInList.id}">
																<c:set var="found" value= "true"/>
															</c:if>
														</c:forEach>
													</c:if>
													<c:choose>
													<c:when test="${found eq true}">
														<form:option selected="selected" value="${userInList.id}">
															${userInList.firstName} ${userInList.lastName}
														</form:option>
													</c:when>
													<c:otherwise>
														<form:option value="${userInList.id}">
															${userInList.firstName} ${userInList.lastName}
														</form:option>
													</c:otherwise>
													</c:choose>
												</c:forEach>
											</form:select>
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
										
									<button class="default-btn-shape theme2-primary-btn-style1" type="submit" id="submit"><span class="icon-checkmark small-margin-right"></span><spring:message code="projecthandler.project.edit.save"/></button>

							</form:form>

							<div style="margin-top:-36px;margin-left:130px;">
							<c:if test="${project.id != null}">
							<form:form method="POST" modelAttribute="project" action="${pageContext.request.contextPath}/project/delete" onsubmit="return confirmDelete();">
								<form:input type="hidden" path="id" name="projectId" id="projectId" value="${project.id}"/>
   	 							<button class="default-btn-shape util6-primary-btn-style1" type="submit" id="submit"><span class="icon-cross small-margin-right"></span><spring:message code="projecthandler.project.edit.delete"/></button>
							</form:form>
							</c:if>
							</div>

						</div>
					</div>	
				</div>	
			</div>
		</div>		
	</div>
</body>
</html>
