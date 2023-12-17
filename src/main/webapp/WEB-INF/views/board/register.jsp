<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>

<%@include file="../layouts/header.jsp"%>

<link rel="stylesheet"
	href="/resources/css/summernote/summernote-lite.min.css">
<script src="/resources/js/summernote/summernote-lite.min.js"></script>
<script src="/resources/js/summernote/lang/summernote-ko-KR.min.js"></script>

<script>
	$(document).ready(function() {
		$('#content').summernote({
			height : 300, // 에디터 높이
			lang : "ko-KR", // 한글 설정
		});
		
		const attaches = $('[name="files"]');
		const attachList = $('#attach-list');

		attaches.change(function (e) {
		    let fileList = '';
		    for (let file of this.files) {
		        let fileStr = `
		            <div>
		                <i class="fa-solid fa-file"></i>
		                \${file.name}(\${file.size.formatBytes()})
		            </div>`;
		        fileList += fileStr;
		    }
		    attachList.html(fileList);
		});

	
});
	
	
</script>


<h1 class="page-header">
	<i class="far fa-edit"></i> 글쓰기
</h1>

<div class="panel panel-default">


	<div class="panel-body">
		<form:form modelAttribute="board" role="form"
			action="?_csrf=${_csrf.token }" enctype="multipart/form-data">
			<form:hidden path="writer" value="${username}" />
			<div class="form-group">
				<form:label path="title">제목</form:label>
				<form:input path="title" cssClass="form-control" />
				<form:errors path="title" cssClass="error" />
			</div>

			<div class="form-group">
				<label for="attaches">첨부파일</label>
				<div id="attach-list" class="my-1"></div>
				<input type="file" class="form-control" multiple name="files" />
			</div>

			<div class="form-group">
				<form:label path="content">내용</form:label>
				<form:textarea path="content" class="form-control"></form:textarea>
				<form:errors path="content" cssClass="error" />
			</div>



			<button type="submit" class="btn btn-primary list">
				<i class="fas fa-check"></i> 확인
			</button>
			<button type="reset" class="btn btn-primary">
				<i class="fas fa-undo"></i> 취소
			</button>
			<a href="javascript:history.back()" class="btn btn-primary"> <i
				class="fas fa-list"></i> 목록
			</a>
		</form:form>
	</div>
</div>


<%@include file="../layouts/footer.jsp"%>
