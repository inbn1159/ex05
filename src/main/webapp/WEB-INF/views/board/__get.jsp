<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<%@include file="../layouts/header.jsp"%>

<script src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.29.4/moment.min.js">
</script>
<script src="/resources/js/rest.js"></script>
<script src="/resources/js/comment.js"></script>

<script>
	const COMMENT_URL = '/api/board/${param.bno}/comment/';

	$('.remove').click(function(){
		if(!confirm('정말 삭제할까요?')) return;		
		document.forms.removeForm.submit();
	});	
	

	let bno = ${param.bno};		// 글번호
	let writer = '${username}';	// 작성자(로그인 유저)


	loadComments(bno, writer);	// 댓글 목록 불러오기
	
	
	// 댓글 추가 버튼 처리
	$('.comment-add-btn').click(function(e) {
		createComment(bno, writer);		
	});


	// 댓글 수정, 삭제 버튼 처리 - 이벤트 버블링(이벤트 처리 위임)

	// 댓글 수정 보기 버튼 클릭
	$('.comment-list').on('click', '.comment-update-show-btn', 
								showUpdateComment);

	// 수정 확인 버튼 클릭
	$('.comment-list').on('click', '.comment-update-btn', function (e){
		const el = $(this).closest('.comment');
		updateComment(el, writer);
	});

	// 수정 취소 버튼 클릭
	$('.comment-list').on('click', '.comment-update-cancel-btn', 
								cancelCommentUpdate);
	
	// 수정 취소 버튼 클릭
	$('.comment-list').on('click', '.comment-update-cancel-btn', 
								cancelCommentUpdate);
	

}); 

</script>

<h1 class="page-header"><i class="far fa-file-alt"></i> ${board.title}</h1>
	
<div class="d-flex justify-content-between">
	<div><i class="fas fa-user"></i> ${board.writer}</div>
	<div>
		<i class="fas fa-clock"></i> 
		<fmt:formatDate pattern="yyyy-MM-dd" value="${board.regDate}"/>
	</div>
</div>
	
<hr>
	
<div>
	${board.content}
</div>

<c:if test="${ board.writer != username}"> 

	<div class="bg-light p-2 rounded">
		<div>${username == null ? '댓글을 작성하려면 먼저 로그인하세요' : '댓글 작성' }</div>
		<div>
			<textarea class="form-control new-comment-content" rows="3"
				${username == null ? 'disabled' : '' }></textarea>
			<div class="text-end">			
				<button class="btn btn-primary btn-sm my-2 comment-add-btn" ${username == null ? 'disabled' : '' } >
					<i class="fa-regular fa-comment"></i> 확인
				</button>
			</div>
		</div>
	</div>
</c:if>

<div class="my-3">
	댓글 목록
	<hr>
	<div class="comment-list"></div>
</div>



<div class="mt-4">
	<a href="${cri.getLink('list')}" class="btn btn-primary list">
		<i class="fas fa-list"></i> 목록</a>
	
	<c:if test="${username == board.writer }">
		<a href="${cri.getLinkWithBno('modify', board.bno) }" class="btn btn-primary modify">
			<i class="far fa-edit"></i> 수정</a>
		<a href="#" class="btn btn-danger remove">
			<i class="fas fa-trash-alt"></i> 삭제</a>
	</c:if>
</div>

<form action="remove" method="post" name="removeForm">
	<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
	<input type="hidden" name="bno" value="${board.bno}"/>
	<input type="hidden" name="pageNum" value="${cri.pageNum}"/>
	<input type="hidden" name="amount" value="${cri.amount}"/>
	<input type="hidden" name="type" value="${cri.type}"/>
	<input type="hidden" name="keyword" value="${cri.keyword}"/>
</form>

<%@include file="../layouts/footer.jsp"%>
