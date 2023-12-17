<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>

<script src="https://cdn.jsdelivr.net/npm/@fancyapps/ui@5.0/dist/fancybox/fancybox.umd.js"></script>
<link
  rel="stylesheet"
  href="https://cdn.jsdelivr.net/npm/@fancyapps/ui@5.0/dist/fancybox/fancybox.css"
/>


<%@include file="../layouts/header.jsp"%>
<style>
.thumb-images>a {
	width:20%;
}
.thumb-images img {
  width: 100%;
  height: 150px;
  padding: 2px;
  object-fit: cover;
}

.image-panel {
	width: 300px;
	height: 270px;
}

.image-panel > img{
	width: 300px;
	height: 200px;
	object-fit: cover;	
}

.image-panel > .sm-images > img {
	width:20%;
	height:60px;
	object-fit: cover;	
	cursor: pointer ;
}
</style>


<c:if test="${not empty username}">
<style>
	.fa-heart {
		cursor: pointer;
	}
</style>

<script src="/resources/js/rest.js"></script>
<script>
$(document).ready(function() {
	let username = '${username}';
	
	const BASE_URL = '/api/travel/heart';
	
	// 좋아요 추가	
	$('span.heart').on('click', '.fa-heart.fa-regular', async function(e){
		
		let tno = parseInt($(this).data("tno"));
		let heart = { tno, username };
		console.log(heart);	
		
		await rest_create(BASE_URL + "/add", heart);
		
		let heartCount = $(this).parent().find(".heart-count");
		console.log(heartCount);
		let count = parseInt(heartCount.text());
		heartCount.text(count+1);
		
		$(this)
			.removeClass('fa-regular')
			.addClass('fa-solid');
	});
	
	// 좋아요 제거
	$('span.heart').on('click', '.fa-heart.fa-solid', async function(e){
		let tno = parseInt($(this).data("tno"));

		await rest_delete(`\${BASE_URL}/delete?tno=\${tno}&username=\${username}`);
		
		let heartCount = $(this).parent().find(".heart-count");
		console.log(heartCount);
		let count = parseInt(heartCount.text());
		heartCount.text(count-1);
		
		$(this)
			.removeClass('fa-solid')
			.addClass('fa-regular');
	});
});
	
</script>
</c:if>

<script>
$(document).ready(function() {

	$('.remove').click(function(){
		if(!confirm('정말 삭제할까요?')) return;		
		document.forms.removeForm.submit();
	});	

	Fancybox.bind('[data-fancybox="gallery"]', {
		  // Your custom options
	});
	

	$('.sm-images > img').mouseenter(function(e) {
		let src = $(this).attr('src');
		$('.image-panel > img').attr('src', src);		
	});
	
});
</script>

<h1 class="page-header mt-5">
	<i class="fa-solid fa-location-dot"></i>[${travel.region}] ${travel.title}
</h1>
	
<div class="d-flex justify-content-between">
	<div>
		
	</div>
	<div>

		<span class="heart mr-4"> 
			<i class="${ travel.myHeart ? 'fa-solid' : 'fa-regular' } fa-heart text-danger"
				data-tno="${travel.no}"></i> 
			<span class="heart-count">${travel.hearts}</span>
		</span> 
		<i class="fa-solid fa-phone"></i> 연락처: ${travel.phone}
	</div>
</div>


<hr>
	
<div class="clearfix">
	<div class="image-panel float-left mr-3">
		<img src="${travel.image}">
		<div class="sm-images mt-1 d-flex">
		  	<c:forEach var="image" items="${travel.images}">
	  			<img src="${image}">
		  	</c:forEach>
		</div>		
	</div>
	${travel.description}
</div>

<div class="thumb-images my-5 d-flex">
  	<c:forEach var="image" items="${travel.images}">
  		<a href="${image}" data-fancybox="gallery">
  			<img src="${image}">
  		</a>
  	</c:forEach>
</div>

<div class="mt-5">
	<i class="fa-solid fa-map-location-dot"></i> 주소: ${travel.address}
</div>	

<div id="map" style="width:100%; height:300px;background:gray"></div>




<div class="mt-4">
	<a href="${cri.getLink('list')}" class="btn btn-primary list">
		<i class="fas fa-list"></i> 목록</a>
	<sec:authorize access="hasAnyRole('ROLE_MANAGER')">
		<a href="${cri.getLink('modify')}&no=${travel.no}" class="btn btn-primary modify">
			<i class="far fa-edit"></i> 수정</a>
		<a href="#" class="btn btn-danger remove">
			<i class="fas fa-trash-alt"></i> 삭제</a>
	</sec:authorize>
</div>

 
<form action="remove" method="post" name="removeForm">
	<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
	<input type="hidden" name="no" value="${travel.no}"/>
	<input type="hidden" name="pageNum" value="${cri.pageNum}"/>
	<input type="hidden" name="amount" value="${cri.amount}"/>
	<input type="hidden" name="type" value="${cri.type}"/>
	<input type="hidden" name="keyword" value="${cri.keyword}"/>
</form>



<script src="//dapi.kakao.com/v2/maps/sdk.js?appkey=e764090e30af4050163f115a68c2be4a&libraries=services"></script>
<script>
	let geocoder = new kakao.maps.services.Geocoder();

	let address ='${travel.address}'; 

	geocoder.addressSearch(address, function(result, status) {
		if (status === kakao.maps.services.Status.OK) {
			// 배열의 첫번째 위치로 이동
			let coords = new kakao.maps.LatLng(result[0].y, result[0].x);
			
			let mapContainer = document.getElementById('map');
			let mapOption = { 
		        center: coords,  // 중심좌표
		        level: 5 // 지도의 확대 레벨
		    };
			
			let map = new kakao.maps.Map(mapContainer, mapOption); 			
			
			let marker = new kakao.maps.Marker({
				map: map,
				position: coords
			});

			// 지도의 중심을 결과값으로 받은 위치로 이동시킵니다
			// map.setCenter(coords);
		} else {
			alert('잘못된 주소입니다.');
		}
	});



	
</script>




<%@include file="../layouts/footer.jsp"%>



