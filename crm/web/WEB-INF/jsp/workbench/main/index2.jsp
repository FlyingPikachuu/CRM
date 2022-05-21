<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String basePath=request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+request.getContextPath()+"/";
%>
<html>
<base href="<%=basePath%>">
<head>
    <head>
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>Home</title>
        <!-- FontAwesome Styles-->
        <link rel="stylesheet" type="text/css" href="assets/fonts/font-awesome-4.7.0/css/font-awesome.min.css">
        <%--jquery框架--%>
        <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
        <%--	bootstrap框架--%>
        <link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" /><script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
        <script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
        <!-- Custom Styles-->
        <link href="assets/css/custom-styles.css" rel="stylesheet" />
        <%--	bootstrap日历插件--%>
        <link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />
        <script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
        <script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
        <!--引入echarts插件-->
        <script type="text/javascript" src="jquery/echarts/echarts.min.js"></script>
        <script type="text/javascript">
            $(function (){
                showPageHeader();
            })

            function showPageHeader(){
                let date = new Date();
                let year = date.getFullYear();
                let month = date.getMonth()+1;
                let name1 = year+'年每月交易创建和成交情况对比统计图';
                let name2 = year+'年'+month+'月职员业绩Top10';
                $("#tran-bar-head").text(name1);
                $("#money-bar-head").text(name2)
                let htmlStr="";
                let hello="";
                let name = '${sessionScope.userInfo.name}';
                console.log(date);
                if(date.getHours()>6&&date.getHours()<=12){
                    hello="上午好！"
                    htmlStr+=""+hello+" <small>"+name+"</small>"
                }
                if(date.getHours()>12&&date.getHours()<=18){
                    hello="下午好！"
                    htmlStr+=""+hello+" <small>"+name+"</small>"
                }
                if(date.getHours()>18&&date.getHours()<=24){
                    hello ="晚上好"
                    htmlStr+=""+hello+" <small>"+name+"</small>"
                }
                if(date.getHours()>0&&date.getHours()<=6){
                    hello ="时间不早了，工作完，早点休息哦"
                    htmlStr+=""+hello+" <small>"+name+"</small>"
                }

                $("#pageHeader").html(htmlStr);

            }
        </script>
    </head>

<body>
<div id="wrapper" style="background: whitesmoke;">

    <!-- /. NAV SIDE  -->
    <div id="page-inner" style="background-color: whitesmoke;margin:0px 0px 0px 0px; min-height:500px;width: 1242px"  >
        <div class="row" style="width: 1242px">
            <div class="col-md-3">
                <h1 class="page-header" id="pageHeader">
                </h1>
            </div>
        </div>


        <!-- /. ROW  -->




        <div class="row" style="height: 530px;width: 1242px">
            <img src="image/Home1.jpg" />
        </div>







        <!-- /. ROW  -->






        <!-- /. ROW  -->
    </div>
    <!-- /. PAGE INNER  -->

    <!-- /. PAGE WRAPPER  -->
</div>
<!-- /. WRAPPER  -->



</body>

</html>