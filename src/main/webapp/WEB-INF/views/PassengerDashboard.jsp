<%@page import="com.entity.UsersEntity"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<% UsersEntity user = (UsersEntity) session.getAttribute("user"); %>

<h1>Hello ${user.fullName }</h1>
	<h1>Passenger Dashboard</h1>
	
</body>
</html>