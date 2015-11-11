<!DOCTYPE html>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@taglib prefix="e" uri="https://www.owasp.org/index.php/OWASP_Java_Encoder_Project" %>
<html xmlns:th="http://www.thymeleaf.org">
	<head>
		<jsp:include page="./template/head.jsp" />
		<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/jquery.tablesorter.2.0.5.min.js"></script>
		<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/ticket/tablesorter.css">
		<title><spring:message code="projecthandler.home.title"/></title>
		<script type="text/javascript">
		$(document).ready(function(){
			$("#yesterdayTable").tablesorter();
			$("#todayTable").tablesorter();
			$("#tomorrowTable").tablesorter();
		});
		</script>
	</head>
<body>
	<jsp:include page="./template/header.jsp" />
	<jsp:include page="./template/menu.jsp" />
	<h1><spring:message code="projecthandler.home.tasksAndEvents"/></h1>
	<div align="left">
		<div>
			<label><spring:message code="projecthandler.home.yesterday"/></label>
			<table id="yesterdayTable" class="tablesorter" border="1">
	            <thead>
		            <tr>
		            	<th><spring:message code="projecthandler.home.type"/></th>
		                <th><spring:message code="projecthandler.home.name"/></th>
		                <th><spring:message code="projecthandler.home.description"/></th>
		                <th><spring:message code="projecthandler.home.startingDate"/></th>
		                <th><spring:message code="projecthandler.home.endingDate"/></th>
		                <th><spring:message code="projecthandler.home.status"/></th>
		                <th><spring:message code="projecthandler.home.progress"/></th>
		            </tr>
	            </thead>
	            <tbody>
	            	<c:forEach var="item" items="${tneYesterday}">
	            		<tr>
	            			<td>
	            				${e:forHtml(item.type)}
	            			</td>
	            			<td>
	            				${e:forHtml(item.name)}
	            			</td>
	            			<td>
	            				${e:forHtml(item.description)}
	            			</td>
	            			<td>
	            				${e:forHtml(item.startingDate)}
	            			</td>
	            			<td>
	            				${e:forHtml(item.endingDate)}
	            			</td>
	            			<td>
	            				${e:forHtml(item.status)}
	            			</td>
	            			<c:choose>
	            			<c:when test="${item.type == 'Task'}">
		            			<td>
									<div id="progress${item.id}" class="ui-progressbar ui-widget ui-widget-content ui-corner-all" role="progressbar" aria-valuemin="0" aria-valuemax="100" aria-valuenow="0">
										<div class="ui-progressbar-value ui-widget-header ui-corner-left" style="width: ${item.progress}%; background: rgb(0, 128, 255);" >
											<span style="color:black">${item.progress}%</span>
										</div>
									</div>
								</td>
	            			</c:when>
	            			<c:otherwise><td/></c:otherwise>
	            			</c:choose>
	            		</tr>
	            	</c:forEach>
	            </tbody>
	        </table>
		</div>
		<div>
	        <label><spring:message code="projecthandler.home.today"/></label>
			<table id="todayTable" class="tablesorter" border="1">
	            <thead>
		            <tr>
		            	<th><spring:message code="projecthandler.home.type"/></th>
		                <th><spring:message code="projecthandler.home.name"/></th>
		                <th><spring:message code="projecthandler.home.description"/></th>
		                <th><spring:message code="projecthandler.home.startingDate"/></th>
		                <th><spring:message code="projecthandler.home.endingDate"/></th>
		                <th><spring:message code="projecthandler.home.status"/></th>
		                <th><spring:message code="projecthandler.home.progress"/></th>
		            </tr>
	            </thead>
	            <tbody>
	            	<c:forEach var="item" items="${tneToday}">
	            		<tr>
	            			<td>
	            				${e:forHtml(item.type)}
	            			</td>
	            			<td>
	            				${e:forHtml(item.name)}
	            			</td>
	            			<td>
	            				${e:forHtml(item.description)}
	            			</td>
	            			<td>
	            				${e:forHtml(item.startingDate)}
	            			</td>
	            			<td>
	            				${e:forHtml(item.endingDate)}
	            			</td>
	            			<td>
	            				${e:forHtml(item.status)}
	            			</td>
	            			<c:choose>
	            			<c:when test="${item.type == 'Task'}">
		            			<td>
									<div id="progress${item.id}" class="ui-progressbar ui-widget ui-widget-content ui-corner-all" role="progressbar" aria-valuemin="0" aria-valuemax="100" aria-valuenow="0">
										<div class="ui-progressbar-value ui-widget-header ui-corner-left" style="width: ${item.progress}%; background: rgb(0, 128, 255);" >
											<span style="color:black">${e:forHtml(item.progress)}%</span>
										</div>
									</div>
								</td>
	            			</c:when>
	            			<c:otherwise><td/></c:otherwise>
	            			</c:choose>
	            		</tr>
	            	</c:forEach>
	            </tbody>
	        </table>
		</div>
		<div>
	        <label><spring:message code="projecthandler.home.tomorrow"/></label>
			<table id="tomorrowTable" class="tablesorter" border="1">
	            <thead>
		            <tr>
		            	<th><spring:message code="projecthandler.home.type"/></th>
		                <th><spring:message code="projecthandler.home.name"/></th>
		                <th><spring:message code="projecthandler.home.description"/></th>
		                <th><spring:message code="projecthandler.home.startingDate"/></th>
		                <th><spring:message code="projecthandler.home.endingDate"/></th>
		                <th><spring:message code="projecthandler.home.status"/></th>
		                <th><spring:message code="projecthandler.home.progress"/></th>
		            </tr>
	            </thead>
	            <tbody>
	            	<c:forEach var="item" items="${tneTomorrow}">
	            		<tr>
	            			<td>
	            				${e:forHtml(item.type)}
	            			</td>
	            			<td>
	            				${e:forHtml(item.name)}
	            			</td>
	            			<td>
	            				${e:forHtml(item.description)}
	            			</td>
	            			<td>
	            				${e:forHtml(item.startingDate)}
	            			</td>
	            			<td>
	            				${e:forHtml(item.endingDate)}
	            			</td>
	            			<td>
	            				${e:forHtml(item.status)}
	            			</td>
	            			<c:choose>
	            			<c:when test="${item.type == 'Task'}">
		            			<td>
									<div id="progress${item.id}" class="ui-progressbar ui-widget ui-widget-content ui-corner-all" role="progressbar" aria-valuemin="0" aria-valuemax="100" aria-valuenow="0">
										<div class="ui-progressbar-value ui-widget-header ui-corner-left" style="width: ${item.progress}%; background: rgb(0, 128, 255);" >
											<span style="color:black">${e:forHtml(item.progress)}%</span>
										</div>
									</div>
								</td>
	            			</c:when>
	            			<c:otherwise><td/></c:otherwise>
	            			</c:choose>
	            		</tr>
	            	</c:forEach>
	            </tbody>
	        </table>
	    </div>
	</div>
	<div>
		<label><spring:message code="projecthandler.home.activity"/></label>
	</div>
	<jsp:include page="template/footer.jsp" />
</body>
</html>
