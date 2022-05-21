<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String basePath=request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+request.getContextPath()+"/";
%>
<html>
<base href="<%=basePath%>">
<head>
    <meta charset="UTF-8">
    <link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
    <link href="jquery/zTree_v3-master/css/zTreeStyle/zTreeStyle.css" type="text/css" rel="stylesheet" />

    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
    <script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
    <script type="text/javascript" src="jquery/zTree_v3-master/js/jquery.ztree.all.min.js"></script>
    <SCRIPT type="text/javascript">
        let setting = {
            edit:{
                enable: true,
                showRemoveBtn:false,
                showRenameBtn: false
            },
            data: {
                simpleData: {
                    enable: true
                }
            }
        };
        <%--let json  = ${s1};--%>
        <%--let zNodes = eval(json);--%>
        let zNodes;
        let roleno = '${user.roleno}';
        $(document).ready(function(){
            $("#editUserBtn").click(function (){
                $("#editUserModal").modal("show");
            });

            //给保存按钮添加单击事件
            $("#updateUserBtn").click(function (){
                //收集参数
                let id = $("#edit-id").val();
                let name=$.trim($("#edit-name").val());
                let email=$.trim($("#edit-email").val());
                $.ajax({
                    url:"settings/personalInfo/editPersonalInfoById.do",
                    data:{
                        id : id,
                        email:email,
                        name:name
                    },
                    type:"post",
                    dataType:"json",
                    success:function (data){
                        if(data.code=="1"){

                            $("#pi-email").text(email);
                            $("#pi-name").text(name);
                            //关闭模态窗口
                            $("#editUserModal").modal("hide");
                        }else{
                            //提示信息
                            alert(data.message);
                            //模态窗口不关闭——关闭dismiss后可不写
                            $("#editUserModal").modal("show");
                        }
                    }
                })
            });
            if(location.hash) {
                $('a[href=' + location.hash + ']').tab('show');
            }
            $(document.body).on("click", "a[data-toggle]", function(event) {
                location.hash = this.getAttribute("href");
            });
            queryPermissionByRoleIdForTree(roleno);

        });
        function queryPermissionByRoleIdForTree(roleno){
            $.ajax({
                url:'settings/qx/user/queryPermissionByRoleIdForTree.do',
                data:{
                    roleno:roleno
                },
                type:'post',
                datatype:'json',
                success:function (data){
                    zNodes =data;
                    $.fn.zTree.init($("#treeDemo"), setting, zNodes);
                }
            })
        }

        $(window).on('popstate', function() {
            var anchor = location.hash || $("a[data-toggle=tab]").first().attr("href");
            $('a[href=' + anchor + ']').tab('show');
        });

    </SCRIPT>

</head>
<body>


<!-- 编辑用户的模态窗口 -->
<div class="modal fade" id="editUserModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 50%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel">修改用户</h4>
            </div>
            <div class="modal-body">

                <form class="form-horizontal" role="form">
                    <input id="edit-id" type="hidden" value="${user.id}">
                    <div class="form-group">
                        <label for="edit-name" class="col-sm-2 control-label">用户姓名</label>
                        <div class="col-sm-10" style="width: 250px;">
                            <input type="text" class="form-control" id="edit-name" style="width: 200%;" value="${user.name}">
                        </div>
                        <span style="position: relative; left: 270px; height: 34px; top: 8px; font-size: 14px;" id="oldPwdInfo"></span>
                    </div>

                    <div class="form-group">
                        <label for="edit-email" class="col-sm-2 control-label">邮箱</label>
                        <div class="col-sm-10" style="width: 250px;">
                            <input type="text" class="form-control" id="edit-email" style="width: 200%;" value="${user.email}">
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="updateUserBtn">更新</button>
            </div>
        </div>
    </div>
</div>

<div>
    <div style="position: relative; left: 30px; top: -10px;">
        <div class="page-header">
            <h3>个人信息 <small>${user.name}</small></h3>
        </div>
        <div style="position: relative; height: 50px; width: 250px;  top: -72px; left: 80%;">
            <button type="button" class="btn btn-default" onclick="window.history.back();"><span class="glyphicon glyphicon-arrow-left"></span> 返回</button>
        </div>
    </div>
</div>

<div style="position: relative; left: 60px; top: -50px;">
    <ul id="myTab" class="nav nav-pills">
        <li id="uLi" class="active"><a href="#role-info" data-toggle="tab">信息明细</a></li>
        <li id="pLi"><a href="#permission-info" data-toggle="tab">许可明细</a></li>
    </ul>
    <div id="myTabContent" class="tab-content">
        <div class="tab-pane fade in active" id="role-info">
            <div style="position: relative; top: 20px; left: -30px;">
                <div style="position: relative; left: 40px; height: 30px; top: 20px;">
                    <div style="width: 300px; color: gray;">登录帐号</div>
                    <div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${user.loginAct}</b></div>
                    <div style="height: 1px; width: 600px; background: #D5D5D5; position: relative; top: -20px;"></div>
                </div>
                <div style="position: relative; left: 40px; height: 30px; top: 40px;">
                    <div style="width: 300px; color: gray;">用户姓名</div>
                    <div style="width: 500px;position: relative; left: 200px; top: -20px;"><b id="pi-name">${user.name}</b></div>
                    <div style="height: 1px; width: 600px; background: #D5D5D5; position: relative; top: -20px;"></div>
                </div>
                <div style="position: relative; left: 40px; height: 30px; top: 60px;">
                    <div style="width: 300px; color: gray;">邮箱</div>
                    <div style="width: 500px;position: relative; left: 200px; top: -20px;"><b id="pi-email">${user.email}</b></div>
                    <div style="height: 1px; width: 600px; background: #D5D5D5; position: relative; top: -20px;"></div>
                </div>
                <div style="position: relative; left: 40px; height: 30px; top: 80px;">
                    <div style="width: 300px; color: gray;">失效时间</div>
                    <div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${user.expireTime}</b></div>
                    <div style="height: 1px; width: 600px; background: #D5D5D5; position: relative; top: -20px;"></div>
                </div>
                <div style="position: relative; left: 40px; height: 30px; top: 100px;">
                    <div style="width: 300px; color: gray;">允许访问IP</div>
                    <div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${user.allowIps}</b></div>
                    <div style="height: 1px; width: 600px; background: #D5D5D5; position: relative; top: -20px;"></div>
                </div>
                <div style="position: relative; left: 40px; height: 30px; top: 120px;">
                    <div style="width: 300px; color: gray;">部门名称</div>
                    <div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${user.deptName}</b></div>
                    <div style="height: 1px; width: 600px; background: #D5D5D5; position: relative; top: -20px;"></div>
                </div>
                <div style="position: relative; left: 40px; height: 30px; top: 140px;">
                    <div style="width: 300px; color: gray;">职位名称</div>
                    <div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${roleName}</b></div>
                    <div style="height: 1px; width: 600px; background: #D5D5D5; position: relative; top: -20px;"></div>
                    <button style="position: relative; left: 76%; top: -40px;" type="button" class="btn btn-default" id="editUserBtn"><span class="glyphicon glyphicon-edit"></span> 编辑</button>
                </div>
            </div>
        </div>
        <div class="tab-pane fade" id="permission-info">
            <div style="position: relative; top: 20px; left: 0px;">
                <ul id="treeDemo" class="ztree" style="position: relative; top: 15px; left: 15px;"></ul>
                <div style="position: relative;top: 30px; left: 76%;">
                </div>
            </div>
        </div>
    </div>
</div>

</body>
</html>