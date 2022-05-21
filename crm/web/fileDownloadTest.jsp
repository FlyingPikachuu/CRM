<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String basePath=request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+request.getContextPath()+"/";
%>
<html>
<head>
    <base href="<%=basePath%>">
    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
    <title>演示文件下载</title>
    <script type="text/javascript">
        $(function (){
            $("#fileDownloadButton").click(function (){
                //发送文件下载请求
                window.location.href="workbench/activity/fileDownload.do";
            });
        });
    </script>
</head>
<body>
<input type="button" value="下载" id="fileDownloadButton">
</body>
</html>
