<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String basePath=request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+request.getContextPath()+"/";
%>
<html>
<base href="<%=basePath%>">
<head>
    <meta charset="UTF-8">
    <link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
    <script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
    <script type="text/javascript">

        //页面加载完毕
        $(function(){

            //导航中所有文本颜色为黑色
            $(".liClass > a").css("color" , "black");

            //默认选中导航菜单中的第一个菜单项
            $(".liClass:first").addClass("active");

            //第一个菜单项的文字变成白色
            $(".liClass:first > a").css("color" , "white");

            //给所有的菜单项注册鼠标单击事件
            $(".liClass").click(function(){
                //移除所有菜单项的激活状态
                $(".liClass").removeClass("active");
                //导航中所有文本颜色为黑色
                $(".liClass > a").css("color" , "black");
                //当前项目被选中
                $(this).addClass("active");
                //当前项目颜色变成白色
                $(this).children("a").css("color","white");
            });
            $("#myInfoBtn").click(function (){
                $("#myInformation").modal("show");
            });
            $("#editPwdBtn").click(function (){
                $("#editPwdForm")[0].reset();
                $("#oldPwdInfo").html("");
                $("#confirmPwdInfo").html("");
                $("#editPwdModal").modal("show");
            });
            $("#edit-oldPwd").blur(function (){
                let op = '${sessionScope.userInfo.loginPwd}';
                let oldPwd = $.trim($("#edit-oldPwd").val());
                if(oldPwd!=""&&oldPwd!=op){
                    $("#oldPwdInfo").css("color","red");
                    $("#oldPwdInfo").html("密码错误");
                    $("#oldPwdInfo").val("密码错误");
                }else{
                    $("#oldPwdInfo").css("color","green");
                    $("#oldPwdInfo").html("√");
                    $("#oldPwdInfo").val("√");
                }
            })
            $("#edit-confirmPwd").blur(function (){
                let newPwd = $.trim($("#edit-newPwd").val());
                let confirmPwd = $.trim($("#edit-confirmPwd").val());
                if(newPwd!=""&&confirmPwd!=""&&newPwd!=confirmPwd){
                    $("#confirmPwdInfo").css("color","red");
                    $("#confirmPwdInfo").html("两次输入密码不一致");
                    $("#confirmPwdInfo").val("两次输入密码不一致");
                }else{
                    $("#confirmPwdInfo").css("color","green");
                    $("#confirmPwdInfo").html("√");
                    $("#confirmPwdInfo").val("√");
                }
            })
            $("#updatePwdBtn").click(function (){
                let id = '${sessionScope.userInfo.id}';
                let oldPwd = $.trim($("#edit-oldPwd").val());
                let newPwd = $.trim($("#edit-newPwd").val());
                alert(newPwd);
                let confirmPwd = $.trim($("#edit-confirmPwd").val());
                let verifyOp =$("#oldPwdInfo").val();
                let verifyCp =$("#confirmPwdInfo").val();
                if(oldPwd==""){
                    alert("原密码不为空");
                    return;
                }
                if(verifyOp!=""&&verifyOp!="√"){
                    alert(verifyOp);
                    return;
                }
                if(newPwd==""){
                    alert("未填写新密码");
                    return;
                }
                if(confirmPwd==""){
                    alert("未确认密码");
                    return;
                }
                if(verifyCp!=""&&verifyCp!="√"){
                    alert(verifyCp);
                    return;
                }
                $.ajax({
                    url:'settings/qx/user/editPwd.do',
                    data:{
                        newPwd:newPwd,
                        id:id
                    },
                    type:"post",
                    datatype:"json",
                    success:function (data){
                        if(data.code=="1"){
                            window.location.href='settings/qx/user/toLogin.do';
                        }else{
                            alert(data.message);
                            $("#editPwdModal").modal("show");
                        }
                    }
                });
            });
            $("#exitBtn").click(function (){
                $("#exitModal").modal("show");
            });
            //给退出登录的确定按钮添加单击事件
            $("#logoutBtn").click(function (){
                window.location.href="settings/qx/user/logout.do";
            });
            //展示市场活动页面
            window.open("settings/personalInfo/index.do","workareaFrame");

        });

        function menuUl(){
            let roleno = '${sessionScope.userInfo.roleno}';
            if(roleno.includes("001")){
                let htmlStr ="";
                htmlStr+="<li><a href=\"settings/index.do\"><span class=\"glyphicon glyphicon-wrench\"></span> 系统设置</a></li>";
                htmlStr+="<li><a href=\"workbench/index.do\"><span class=\"glyphicon glyphicon-home\"></span> 工作台</a></li>"
                htmlStr+="<li><a href=\"settings/index.do\"><span class=\"glyphicon glyphicon-wrench\"></span> 系统设置</a></li>"
                htmlStr+="<li><a href=\"javascript:void(0)\" id=\"myInfoBtn\"><span class=\"glyphicon glyphicon-file\"></span> 我的资料</a></li>"
                htmlStr+="<li><a href=\"javascript:void(0)\" id=\"editPwdBtn\"><span class=\"glyphicon glyphicon-edit\"></span> 修改密码</a></li>"
                htmlStr+="<li><a href=\"javascript:void(0)\" id=\"exitBtn\"><span class=\"glyphicon glyphicon-off\"></span> 退出</a></li>"
                $("#menuUl").prepend(htmlStr);
            }
        }
    </script>

</head>
<body>

<!-- 我的资料 -->
<div class="modal fade" id="myInformation" role="dialog">
    <div class="modal-dialog" role="document" style="width: 30%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title">我的资料</h4>
            </div>
            <div class="modal-body">
                <div style="position: relative; left: 40px;">
                    姓名：<b>${sessionScope.userInfo.name}</b><br><br>
                    登录帐号：<b>${sessionScope.userInfo.loginAct}</b><br><br>
                    组织机构：<b>${sessionScope.userInfo.deptno}，${sessionScope.userInfo.deptName}</b><br><br>
                    邮箱：<b>${sessionScope.userInfo.email}</b><br><br>
                    失效时间：<b>${sessionScope.userInfo.expireTime}</b><br><br>
                    允许访问IP：<b>${sessionScope.userInfo.allowIps}</b>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
            </div>
        </div>
    </div>
</div>

<!-- 修改密码的模态窗口 -->
<div class="modal fade" id="editPwdModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 70%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title">修改密码</h4>
            </div>
            <div class="modal-body">
                <form id="editPwdForm" class="form-horizontal" role="form">
                    <input type="hidden" id="edit-id2">
                    <div class="form-group">
                        <label for="edit-oldPwd" class="col-sm-2 control-label">原密码</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="password" class="form-control" id="edit-oldPwd" style="width: 200%;">
                        </div>
                        <span style="position: relative; left: 270px; height: 34px; top: 8px; font-size: 14px;" id="oldPwdInfo"></span>
                    </div>

                    <div class="form-group">
                        <label for="edit-newPwd" class="col-sm-2 control-label">新密码</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="password" class="form-control" id="edit-newPwd" style="width: 200%;">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-confirmPwd" class="col-sm-2 control-label">确认密码</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="password" da class="form-control" id="edit-confirmPwd" style="width: 200%;">
                        </div>
                        <span style="position: relative; left: 270px; height: 34px; top: 8px; font-size: 14px;" id="confirmPwdInfo"></span>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
                <button type="button" class="btn btn-primary" id="updatePwdBtn">更新</button>
            </div>
        </div>
    </div>
</div>

<!-- 退出系统的模态窗口 -->
<div class="modal fade" id="exitModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 30%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title">离开</h4>
            </div>
            <div class="modal-body">
                <p>您确定要退出系统吗？</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
                <button type="button" class="btn btn-primary" data-dismiss="modal" id="logoutBtn">确定</button>
            </div>
        </div>
    </div>
</div>

<!-- 顶部 -->
<div id="top" style="height: 50px; background-color: #3C3C3C; width: 100%;">
    <div style="position: absolute; top: 5px; left: 0px; font-size: 30px; font-weight: 400; color: white; font-family: 'times new roman'">CRM &nbsp;<span style="font-size: 12px;">&copy;2022&nbsp;Aloha</span></div>
    <div style="position: absolute; top: 15px; right: 15px;">
        <ul>
            <li class="dropdown user-dropdown">
                <a href="javascript:void(0)" style="text-decoration: none; color: white;" class="dropdown-toggle" data-toggle="dropdown">
                    <span class="glyphicon glyphicon-user"></span> ${sessionScope.userInfo.name} <span class="caret"></span>
                </a>
                <ul class="dropdown-menu" style="position:relative;left: 75px;top: 20px" id="menuUl">
                    <li><a href="workbench/index.do"><span class="glyphicon glyphicon-home"></span> 工作台</a></li>
                    <li><a href="javascript:void(0)" id="myInfoBtn"><span class="glyphicon glyphicon-file"></span> 我的资料</a></li>
                    <li><a href="javascript:void(0)" id="editPwdBtn"><span class="glyphicon glyphicon-edit"></span> 修改密码</a></li>
                    <li><a href="javascript:void(0)" id="exitBtn"><span class="glyphicon glyphicon-off"></span> 退出</a></li>
                </ul>
            </li>
        </ul>
    </div>
</div>

<!-- 中间 -->
<div id="center" style="position: absolute;top: 50px; bottom: 30px; left: 0px; right: 0px;">

    <!-- 导航 -->
    <div id="navigation" style="left: 0px; width: 18%; position: relative; height: 100%; overflow:auto;">

        <ul id="no1" class="nav nav-pills nav-stacked">
            <li class="liClass"><a href="settings/personalInfo/index.do" target="workareaFrame"><span class="glyphicon glyphicon-user"></span> 个人信息</a></li>
        </ul>

        <!-- 分割线 -->
        <div id="divider1" style="position: absolute; top : 0px; right: 0px; width: 1px; height: 100% ; background-color: #B3B3B3;"></div>
    </div>

    <!-- 工作区 -->
    <div id="workarea" style="position: absolute; top : 0px; left: 18%; width: 82%; height: 100%;">
        <iframe style="border-width: 0px; width: 100%; height: 100%;" name="workareaFrame"></iframe>
    </div>

</div>

<div id="divider2" style="height: 1px; width: 100%; position: absolute;bottom: 30px; background-color: #B3B3B3;"></div>

<!-- 底部 -->
<div id="down" style="height: 30px; width: 100%; position: absolute;bottom: 0px;"></div>

</body>
</html>