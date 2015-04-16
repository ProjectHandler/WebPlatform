<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page session="true"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<spring:url value="/resources/css/redcss.css" var="redcss"/>
<link href="${redcss}" rel="stylesheet"/>
<spring:url value="/resources/img/icon.png" var="windowicon"/>
<link href="${windowicon}" rel="icon" type="image/png"/>

<script src="${pageContext.request.contextPath}/resources/js/jquery-1.11.1.min.js"></script>
<script src="${pageContext.request.contextPath}/resources/js/redcss.js"></script>

<script type="text/javascript" src="/resources/js/jquery.tablesorter.min.js"></script>

<spring:url value="/resources/js/jquery-1.11.1.js" var="jquery"/>
<script type="text/javascript" src="${jquery}"></script>

<spring:url value="/resources/js/jquery.inputmask.js" var="jqueryMask"/>
<script type="text/javascript" src="${jqueryMask}"></script>

<spring:url value="/resources/js/chosen.jquery.js" var="jqueryChosen"/>
<script type="text/javascript" src="${jqueryChosen}"></script>

<spring:url value="/resources/js/jquery.autosize.js" var="jqueryAutosize"/>
<script type="text/javascript" src="${jqueryAutosize}"></script>

