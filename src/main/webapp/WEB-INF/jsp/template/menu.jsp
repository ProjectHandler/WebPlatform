<%@page session="false" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>


<style type="text/css" media="screen">

#horizontalmenu ul {
	list-style:none;
}

#horizontalmenu li {
	float:right; 
	position:relative; 
	padding-right:0; 
	display:block;
}
#horizontalmenu li ul {
    display:none;
	position:absolute;
	right: 0px;"
}

#horizontalmenu li:hover ul{
    display:block;
	height:auto; 
	width:10em; 
}

#horizontalmenu li ul li{
    clear:both;
	border-style:none;}
</style>

<div style="position:absolute; top:0; right: 10px;">
	<div style="position:relative; top: 20px; right: 0px">
		<sec:authorize access="isAuthenticated()">
			<sec:authentication property="principal.fullname" />
			<a href="<c:url value="/j_spring_security_logout" />"><spring:message code="projecthandler.menu.logout"/></a>
		</sec:authorize>
	</div>
	
	<div id="horizontalmenu" style="position:relative; top: 10px; right: 0px">
       	<ul>
        	<li><a href="#"><spring:message code="projecthandler.menu"/></a>
                <ul> 
	                <li><a href="<c:url value="/"/>"><spring:message code="projecthandler.home"/></a></li> 
	                <sec:authorize access="hasRole('ROLE_ADMIN')">
	                	<li><a href="<c:url value="/admin/users_management"/>"><spring:message code="projecthandler.admin.userManagementTitle"/></a></li>
	                	<li><a href="<c:url value="/admin/groups_management"/>"><spring:message code="projecthandler.admin.groupManagementTitle"/></a></li>
	                	<li><a href="<c:url value="/signupSendMailService"/>"><spring:message code="projecthandler.admin.sendMailService"/></a></li>
	                </sec:authorize>
                </ul>
            </li>
        </ul>
	</div>
	
</div>