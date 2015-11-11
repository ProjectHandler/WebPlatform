<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page session="true"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<spring:url value="/resources/css/redcss.css" var="redcss"/>
<link href="${redcss}" rel="stylesheet"/>
<spring:url value="/resources/img/icon.png" var="windowicon"/>
<link href="${windowicon}" rel="icon" type="image/png"/>
<spring:url value="/resources/css/selectivity-full.min.css" var="selectivity"/>
<link href="${selectivity}" rel="stylesheet"/>
<spring:url value="/resources/css/jquery-ui.min.css" var="jqueryUiCss"/>
<link href="${jqueryUiCss}" rel="stylesheet"/>
<spring:url value="/resources/css/jquery.ui.timepicker.css" var="jqueryTimePikerCss"/>
<link href="${jqueryTimePikerCss}" rel="stylesheet"/>

<spring:url value="/resources/js/jquery-2.1.3.min.js" var="jquery"/>
<script type="text/javascript" src="${jquery}"></script>

<spring:url value="/resources/js/redcss.js" var="redcss"/>
<script type="text/javascript" src="${redcss}"></script>

<spring:url value="/resources/js/jquery.tablesorter.min.js" var="tableSorter"/>
<script type="text/javascript" src="${tableSorter}"></script>

<spring:url value="/resources/js/jquery.inputmask.js" var="jqueryMask"/>
<script type="text/javascript" src="${jqueryMask}"></script>

<spring:url value="/resources/js/chosen.jquery.js" var="jqueryChosen"/>
<script type="text/javascript" src="${jqueryChosen}"></script>

<spring:url value="/resources/js/jquery.autosize.js" var="jqueryAutosize"/>
<script type="text/javascript" src="${jqueryAutosize}"></script>

<spring:url value="/resources/js/jquery-ui.min.js" var="jqueryUI"/>
<script type="text/javascript" src="${jqueryUI}"></script>

<spring:url value="/resources/js/jquery.ui.timepicker.js" var="jqueryTimePiker"/>
<script type="text/javascript" src="${jqueryTimePiker}"></script> 

<spring:url value="/resources/js/selectivity-full.min.js" var="selectivity"/>
<script type="text/javascript" src="${selectivity}"></script>

<spring:url value="/resources/js/utilities/common.js.function.js" var="commonJsFunction"/>
<script type="text/javascript" src="${commonJsFunction}"></script>

<spring:url value="/resources/js/js.cookie-2.0.4.min.js" var="jsCookie"/>
<script type="text/javascript" src="${jsCookie}"></script>

<script type="text/javascript" src="${pageContext.request.contextPath}/resources/ckeditor/ckeditor.js"></script>