<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>文件选择</title>
</head>
<body>
	<form class="easyui-form" style="padding: 10px" data-options="border:false,fit:true" enctype="multipart/form-data" method="post">
 		<input class="easyui-filebox" style="width:100%" name="file" data-options="width:400,buttonText:'选择文件',buttonIcon:'icon-search',required:true,accept:'image/*'"/>
	</form>
</body>
</html>