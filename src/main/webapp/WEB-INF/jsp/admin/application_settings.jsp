<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page session="true"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<html>
	<head>
		<jsp:include page="../template/head.jsp" />
		<title><spring:message code="projecthandler.applicationSettings.title"/></title>
		<script type="text/javascript">
			var koDocSize = [
				{ id: '102400', text: '< 100 Ko'},
				{ id: '204800', text: '< 200 Ko'},
				{ id: '307200', text: '< 300 Ko'},
				{ id: '409600', text: '< 400 Ko'},
				{ id: '512000', text: '< 500 Ko'},
				{ id: '614400', text: '< 600 Ko'},
				{ id: '716800', text: '< 700 Ko'},
				{ id: '819200', text: '< 800 Ko'},
				{ id: '921600', text: '< 900 Ko'}
			];
			
			var moDocSize = [
				{ id: '1048576',   text: '< 1 Mo'},
				{ id: '5242880',   text: '< 5 Mo'},
				{ id: '10485760',  text: '< 10 Mo'},
				{ id: '20971520',  text: '< 20 Mo'},
				{ id: '41943040',  text: '< 40 Mo'},
				{ id: '83886080',  text: '< 80 Mo'},
				{ id: '167772160', text: '< 160 Mo'},
				{ id: '335544320', text: '< 320 Mo'},
				{ id: '671088640', text: '< 640 Mo'}        
			];
			
			var goDocSize = [
				{ id: '1073741824', text: '< 1 Go'},
				{ id: '2147483648', text: '< 2 Go'},
				{ id: '3221225472', text: '< 3 Go'},
				{ id: '4294967296', text: '< 4 Go'},
				{ id: '5368709120', text: '< 5 Go'}
			];
			$(document).ready(function() {
				$('.maxSize-Select').selectivity({
				    allowClear: true,
				    items: [{
				        id: 'Ko',
				        text: 'Kilo octet',
				        submenu: {
				            items: koDocSize,
				            showSearchInput: false
				        }
				    },{
				    	id: 'Mo',
				        text: 'Mega octet',
				        submenu: {
				            items: moDocSize,
				            showSearchInput: false
				        }
				    },{
				    	id: 'Go',
				        text: 'Giga octet',
				        submenu: {
				            items: goDocSize,
				            showSearchInput: false
				        }
				    }],
				    placeholder: '<spring:message code="projecthandler.applicationSettings.selectPlaceholder"/>',
				    showSearchInputInDropdown: false
				});
				
			});
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
						<h1 class="text-h2 container inverted-text"><span class="icon-database margin-right"></span>Administration</h1>
						<hr class="inverted-bg">
						<a class="container display-block full-width inverted-text default-btn-style5" href="<c:url value="/admin/users_management"/>"><span class="icon-users margin-right"></span>Administration des utilisateurs</a>
						<hr class="inverted-bg">
						<a class="container display-block full-width inverted-text default-btn-style5" href="<c:url value="/admin/groups_management"/>"><span class="icon-tree margin-right"></span>Administration des groupes</a>
						<hr class="inverted-bg">
						<a class="container display-block full-width inverted-text default-btn-style5" href="<c:url value="/admin/application_settings"/>"><span class="icon-tree margin-right"></span><spring:message code="projecthandler.applicationSettings.title"/></a>
						<hr class="inverted-bg">	
					</div>
				</div>
				<div class="display-table-cell full-width full-height">
					<div class="full-width full-height position-relative">
						<div class="position-absolute position-top position-left full-width full-height overflow-auto">
							<div class="container">
								<div class="margin-bottom clearfix">
									<h1 class="text-h2 util1-primary-text float-left"><spring:message code="projecthandler.applicationSettings.title"/></h1>
									<div class="text-h2 text-h1 float-right"><span class="icon-tree"></span></div>
								</div>
								<div id="avatarMaxSize-box">
									<label for="avatarMaxSize-input"><spring:message code="projecthandler.applicationSettings.label.avatarMaxSize"/></label>
									<select id="avatarMaxSize-input" class="maxSize-Select">
									</select>
								</div>
								<div id="documentMaxSize-box">
									<label for="documentMaxSize-input"><spring:message code="projecthandler.applicationSettings.label.documentMaxSize"/></label>
									<select id="documentMaxSize-input" class="maxSize-Select">
									</select>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</body>
</html>
