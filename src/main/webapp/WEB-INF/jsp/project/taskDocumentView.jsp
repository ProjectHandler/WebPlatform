<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="e" uri="https://www.owasp.org/index.php/OWASP_Java_Encoder_Project" %>
<script>
	var CONTEXT_PATH = "<%=request.getContextPath() %>";
	$(document).ready(function() {
		$("#documentToUpload").change(function() {
			$("#document_error").html("");
			if($("#documentToUpload").val() == ""){
				document.getElementById('documentUploadButton').disabled = true;
			}else{
				document.getElementById('documentUploadButton').disabled = false;
			}
		});
		
		$(".sizeString").each(function( index ) {
			$(this).text(getDocumentSizeString($(this).text()));
		});
	});

	function uploadDocument() {
		$("#document_error").html("");
		if($("#documentToUpload")[0] == undefined	|| navigator.userAgent.indexOf('MSIE') !== -1 || $("#documentToUpload")[0].files[0] == undefined || $("#documentToUpload")[0].files[0].size < 1048576){
			document.documentToUploadForm.action = CONTEXT_PATH + "/task/${task.project.id}/${task.id}/uploadDocument";
			document.documentToUploadForm.submit();
		}else{
			$("#document_error").html("<spring:message code='projecthandler.taskDocumentView.error.documentTooBig' arguments='${maxDocumentSize}' argumentSeparator=';'/>");
		}
	}
	
	function deleteDocument(docId) {
		$.ajax({type: "POST",
				url: CONTEXT_PATH + "/task/deleteDocument",
				data: {
					projectId: "${task.project.id}",
					taskId: "${task.id}",
					documentId: docId
				},
				success: function(data) {
					if (data.indexOf("KO:") != -1) {
	    				var msg = data.replace("KO:", "");
	    				alert(msg);
	    			}
					else
						$("#documentBox-" + docId).html("");
	    		},
	    		error: function(data) {
	    			alert("Error while deleting file: " + data);
	    		}
		});
	}
	
	// document size is given in bytes
	function getDocumentSizeString(docSize) {
		var num = 0.0;
		var unit = "";
		if (docSize < 1000000) {
			num = (docSize / 1000);
			unit = " Ko";
		}
		else if (docSize < 1000000000) {
			num = (docSize / 1000000);
			unit = " Mo";
		}
		else {
			num = (docSize / 1000000000);
			unit = " Go";
		}
		return num.toFixed(1) + unit;
	}
</script>

<div class="container margin-left small-margin-right small-margin-top small-padding-bottom">

	<div class="display-table-cell vertical-align small-padding-right text-h1 theme3-darken1-text">
		<span class="icon-files-empty"></span>
	</div>	

	<div class="display-table-cell vertical-align padding-right">
		<h2 class="text-h1 theme3-darken1-text fixedwidth-320">Documents</h2>
	</div>

</div>

<div class="container margin-left">
	<c:forEach items="${taskDocuments}" var="document">
		<div id="documentBox-${document.id}" class="display-table margin-bottom">
			<div class="display-table-cell vertical-align text-h1 theme3-primary-text padding-right">
				<div class="container theme3-lighten1-bdr surrounded radius">
					<span class="icon-file-empty"></span>
				</div>
			</div>
			<div class="display-table-cell vertical-align">
				<div>
					<a class="default-btn-shape theme1-primary-btn-style1"href="${pageContext.request.contextPath}/task/${document.projectId}/${document.taskId}/downloadDocument/${document.id}" target="_blank">
						Downlad ${document.name}
					</a>
					<button class="default-btn-shape theme3-primary-text util6-primary-btn-style6" onClick="deleteDocument(${document.id});" title="<spring:message code="projecthandler.general.delete" />">
						<span class="icon-cross"></span> Supprimer
					</button>
				</div>
				<div class="small small-margin-top">
					<!--<spring:message code="projecthandler.taskDocumentView.uploadDate" /> : -->${document.uploadDate} /
					<!--<spring:message code="projecthandler.taskDocumentView.documentFormat" /> : ${document.documentExtension} ,-->
					<!--<spring:message code="projecthandler.taskDocumentView.documentSize" /> : --><div class="display-inline-block sizeString">${document.documentSize}</div>
				</div>
			</div>
		</div>
	</c:forEach>
</div>

<div class="container margin-left no-padding-top">
	<form id="documentToUploadForm" name="documentToUploadForm" method="post" enctype="multipart/form-data">
		<div id="documentUpload-box">
			<!-- <div class="margin-bottom text-h3 theme3-darken3-text"><spring:message code="projecthandler.taskDocumentView.uploadDocument"/></div> -->
			<input type="file" name="documentToUpload" id="documentToUpload" class="filestyle" data-buttonName="btn btn-primary btn-xs" data-buttonText="&nbsp;<spring:message code="projecthandler.signup.button.chooseFile"/>"/>
			<span id="document_error" style="color: red; display:block;"></span>
			<div class="divButton small-margin-top small-margin-left">
				<button id="documentUploadButton" class="reduced-btn-shape theme1-lighten2-btn-style6" onClick="uploadDocument();return false;" disabled="disabled">
					<span class="icon-box-remove small-margin-right"></span>Uploader le fichier
				</button>
			</div>
		</div>
	</form>
</div>