<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<html xmlns:th="http://www.thymeleaf.org">
	<head>
		<jsp:include page="../template/head.jsp" />
		<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/jquery.tablesorter.2.0.5.min.js"></script>
		<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/ticket/tablesorter.css">
		<title><spring:message code="projecthandler.home.title"/></title>
		<script type="text/javascript">
		$(document).ready(function(){
			
			$("#yesterdayTable").tablesorter();
			$("#todayTable").tablesorter();
			$("#tomorrowTable").tableSorter();
			
			  
		    
		});
		</script>
	</head>
<body>
	<jsp:include page="../template/header.jsp" />
	<jsp:include page="../template/menu.jsp" />
	<div align="left" style="width:30%">
		<table id="yesterdayTable" class="tablesorter" border="1">
            <thead>
	            <tr>
	                <th><spring:message code="projecthandler.home.tasksAndEvents"/></th>
	            </tr>
            </thead>
            <tbody>
            </tbody>
        </table>
	</div>
	<div align="center" style="width:30%">
		<table id="todayTable" class="tablesorter" border="1">
            <thead>
	            <tr>
	                <th><spring:message code="projecthandler.home.tasksAndEvents"/></th>
	            </tr>
            </thead>
            <tbody>
            </tbody>
        </table>
	</div>
	<div align="right" style="width:30%">
		<table id="tomorrowTable" class="tablesorter" border="1">
            <thead>
	            <tr>
	                <th><spring:message code="projecthandler.home.tasksAndEvents"/></th>
	            </tr>
            </thead>
            <tbody>
            </tbody>
        </table>
	</div>
</body>
</html>