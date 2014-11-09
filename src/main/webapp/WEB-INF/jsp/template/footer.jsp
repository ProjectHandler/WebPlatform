<%@page session="false" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ page contentType="text/html;charset=UTF-8" %>


<div style="position:absolute; bottom:0; width:100%;">
	<spring:eval expression="@applicationProps['site.web.url']" var="siteWebUrl"/>
	<table  align="center">
		<tr>
			<td><a href="${siteWebUrl}">home</a></td>
			<td>|</td>
			<td><a href="${siteWebUrl}/team">team</a></td>
			<td>|</td>
			<td><a href="${siteWebUrl}/solution">solution</a></td>
			<td>|</td>
			<td><a href="${siteWebUrl}/forum">forum</a></td>
			<td>|</td>
			<td><a href="https://github.com/ProjectHandler/WebPlatform">git</a></td>
			<td>|</td>
			<td><a href="${siteWebUrl}/contact">contact</a></td>
		</tr>
	</table>
</div>
