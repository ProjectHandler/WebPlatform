<%@page session="false" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ page contentType="text/html;charset=UTF-8" %>

<header>
	<div class="brandwrapper">
		<a href="${siteWebUrl}">
			<img src="${pageContext.request.contextPath}/resources/img/logo&name.png"  height="40%" width="40%"/>
		</a>
	</div>
</header>

<script type="text/javascript">
	var CONTEXT_PATH = "<%=request.getContextPath() %>";
</script>