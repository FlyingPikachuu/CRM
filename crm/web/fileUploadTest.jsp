<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    //需要向后台发请求，发请求需要url，所有url从base标签找，所以要base标签
    String basePath=request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+request.getContextPath()+"/";
%>
<html>
<head>
    <base href="<%=basePath%>">
    <title>演示文件上传</title>
</head>
<body>
<%--文件上传的表单有三个条件
     1、表单组件标签必须用：<input type="file">
     <input type="text|password|radio|checkbox|hidden|button|submit|reset|file">
     <select><textarea>等
     2、请求方式只能用：post
        向后台提交的方式不同
        get:参数通过请求头提交到后台，数据/参数放在url后面；
        ，只能向后台提交文本数据（字符串）；
        ，进而对参数长度有限制；
        数据不安全；
        效率相对较高，将静态资源保存在缓存区，下次登录速度快
        post: 参数通过请求体提交到后台；
        ，既能提交文本（字符串）数据，又能提交二进制数据；
        ，理论上对参数长度没限制；
        相对安全；
        效率相对较低，数据放在请求体里，需要按照请求体格式
        但对开发人员来说，可维护性低，每次修改静态资源需要刷新缓存
        因此开发动态网页一般选用post
      3、表单的编码格式只能用：multipart/form-data
      根据HTTP协议的规定，浏览器每次向后台提交参数，都会对参数进行统一编码；
      默认采用的编码格式是urlencoded，这种编码格式只能对文本数据进行编码；
      浏览器每次向后台提交参数，都会首先把所有的参数转换成字符串，然后对这些数据统一进行urlencoded编码；
      文件上传的表单编码格式只能用multipart/form-data：enctype="multipart/form-data"
        --%>
<form action="workbench/activity/fileUpload.do" method="post" enctype="multipart/form-data">
    <input type="file" name="myFile"><br>
    <input type="text" name="username"><br>
    <input type="submit" value="提交">
</form>
</body>
</html>
