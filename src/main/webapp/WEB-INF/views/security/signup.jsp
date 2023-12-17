<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>

<%@ include file="../layouts/header.jsp" %>

<div style="width: 500px" class="mx-auto">
	<h1 class="my-5"><i class="fa-solid fa-user-plus"></i> 회원 가입</h1>
	<div>
		<form:form modelAttribute="member"
			action="/security/signup?_csrf=${_csrf.token}" 
			enctype="multipart/form-data">
			
			<div class="form-group">
				<form:label path="username"><i class="fa-solid fa-user"></i> 사용자 ID:</form:label>
				<form:input path="username" cssClass="form-control"/>
				<form:errors path="username" cssClass="error"/>
	 		</div>
			<div class="form-group">
				<form:label path="password"><i class="fa-solid fa-lock"></i> 비밀번호:</form:label>
				<form:password path="password" class="form-control" />
				<form:errors path="password" cssClass="error"/>				
			</div>
			<div class="form-group">
				<form:label path="password2"><i class="fa-solid fa-lock"></i> 비밀번호 확인:</form:label>
				<form:password path="password2" class="form-control" />
				<form:errors path="password2" cssClass="error"/>				
			</div>
			<div class="form-group">
				<form:label path="email"><i class="fa-regular fa-envelope"></i> email:</form:label>
				<form:input path="email" class="form-control" />
				<form:errors path="email" cssClass="error"/>				
			</div>
			
			<input type="file" name="avatar" />
			
			<div class="text-center">
				<button type="submit" class="btn btn-primary"><i class="fa-solid fa-user-plus"></i> 회원가입</button>
			</div>
		</form:form>
	</div>
</div>	
<%@ include file="../layouts/footer.jsp" %>
