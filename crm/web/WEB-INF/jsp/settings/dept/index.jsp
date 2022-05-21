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

    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
    <script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
    <script type="text/javascript">
        $(function (){
           $("#createDeptBtn").click(function (){
               $("#createDeptForm")[0].reset();
               $("#createDeptModal").modal("show");
           }) ;
           $("#saveDeptBtn").click(function (){
               let code = $.trim($("#create-code").val());
               let name = $.trim($("#create-name").val());
               let description = $.trim($("#create-description").val());

               if(code==""){
                   alert("代码不为空");
                   return;
               }
               if(name==""){
                   alert("名称不为空");
                   return;
               }

               $.ajax({
                   url:'settings/dept/addDept.do',
                   data:{
                       code:code,
                       name:name,
                       description:description
                   },
                   type:'post',
                   datatype:"json",
                   success:function (data){
                       if(data.code=="1"){
                           window.location.reload();
                       }else{
                           alert(data.message);
                           $("#createDeptModal").modal("show");
                       }
                   }
               })
           })
            //给'全选'复选框添加单击事件
            $("#checkAllDept").click(function (){
                $("#deptTbody input[type='checkbox']").prop("checked",this.checked);
            });
            //给列表的复选框添加单击事件 方式二 针对动态生成元素
            $("#deptTbody").on("click","input[type='checkbox']",function (){
                if($("#deptTbody input[type='checkbox']").size()==$("#deptTbody input[type='checkbox']:checked").size()){
                    $("#checkAllDept").prop("checked",true);
                }
                else{
                    $("#checkAllDept").prop("checked",false);
                }
            })

            //给修改按钮添加单击事件
            $("#editDeptBtn").click(function (){
                let checkedIds=$("#deptTbody input[type='checkbox']:checked");
                if(checkedIds.size()==0){
                    alert("请选择要修改的部门");
                    return;
                }
                if(checkedIds.size()>1){
                    alert("每次只能修改一条部门");
                    return;
                }
                // 取dom对象属性值三种方法
                // let id=checkedIds.val();
                // let id=checkedIds.get(0).value;
                let id=checkedIds[0].value;
                alert(id);
                $.ajax({
                    url:"settings/dept/queryDeptByCode.do",
                    data:{
                        code:id
                    },
                    type:"post",
                    datatype:'json',
                    success:function (data){
                        $("#edit-oldCode").val(data.code);
                        $("#edit-code").val(data.code);
                        $("#edit-name").val(data.name);
                        $("#edit-description").val(data.description);

                        $("#editDeptModal").modal("show");
                    }
                })
            });
            //给更新按钮添加单击事件
            $("#updateDeptBtn").click(function (){
                let oldCode =  $("#edit-oldCode").val();
                let code = $.trim($("#edit-code").val());
                let name = $.trim($("#edit-name").val());
                let description = $.trim($("#edit-description").val());

                if(code==""){
                    alert("代码不为空");
                    return;
                }
                if(name==""){
                    alert("名称不为空");
                    return;
                }
                $.ajax({
                    url:'settings/dept/editDept.do',
                    data:{
                        oldCode:oldCode,
                        code:code,
                        name:name,
                        description:description
                    },
                    type:'post',
                    datatype:'json',
                    success:function (data){
                        if(data.code=="1"){
                            window.location.reload();
                        }else{
                            alert(data.message);
                            $("#editDeptModal").modal("show");
                        }
                    }
                })
            })
            //给”删除“按钮添加点击事件
            $("#deleteDeptBtn").click(function (){
                //收集参数
                let checkedIds = $("#deptTbody input[type='checkbox']:checked");
                if(checkedIds.size()==0){
                    alert("请选择要删除的部门");
                    return;
                }
                //弹对话框
                if(window.confirm("确定删除吗？")){
                    //获取所有 选择的checkbox上value属性值上绑定的id
                    // 遍历checkedIds变量 选择jq函数
                    let ids="";
                    $.each(checkedIds,function (){
                        //this 和 obj一样 从变量中取出元素放这俩里面
                        //一般只有一个属性值时，用this 简单
                        //!!!!!注意 这里拼接的ids要与controller方法中参数名相同
                        ids+="code="+this.value+"&";
                    });
                    //去除最后的&
                    ids=ids.substr(0,ids.length-1);
                    //发送请求
                    alert(ids);
                    $.ajax({
                        url:'settings/dept/deleteDept.do',
                        data:ids,
                        type:'post',
                        datatype: 'json',
                        success:function (data){
                            if(data.code=="1"){
                                window.location.reload();
                            }else{
                                alert(data.message);
                            }
                        }
                    });
                }
            });
        });
    </script>
</head>
<body>

<!-- 创建部门的模态窗口 -->
<div class="modal fade" id="createDeptModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 80%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel">新增部门</h4>
            </div>
            <div class="modal-body">

                <form id="createDeptForm" class="form-horizontal" role="form">

                    <div class="form-group">
                        <label for="create-code" class="col-sm-2 control-label">代码<span style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-code" style="width: 200%;">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-name" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-name" style="width: 200%;">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-description" class="col-sm-2 control-label">描述</label>
                        <div class="col-sm-10" style="width: 65%;">
                            <textarea class="form-control" rows="3" id="create-description"></textarea>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="saveDeptBtn">保存</button>
            </div>
        </div>
    </div>
</div>
<div class="modal fade" id="editDeptModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 80%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel1">修改部门</h4>
            </div>
            <div class="modal-body">

                <form id="editDeptForm" class="form-horizontal" role="form">
                    <input type="hidden" id="edit-oldCode">
                    <div class="form-group">
                        <label for="edit-code" class="col-sm-2 control-label">代码<span style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-code" style="width: 200%;">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-name" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-name" style="width: 200%;">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-description" class="col-sm-2 control-label">描述</label>
                        <div class="col-sm-10" style="width: 65%;">
                            <textarea class="form-control" rows="3" id="edit-description"></textarea>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="updateDeptBtn">更新</button>
            </div>
        </div>
    </div>
</div>


<div>
    <div style="position: relative; left: 30px; top: -10px;">
        <div class="page-header">
            <h3>部门列表</h3>
        </div>
    </div>
</div>
<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;left: 30px;">
    <div class="btn-group" style="position: relative; top: 18%;">
        <button type="button" class="btn btn-primary" id="createDeptBtn"><span class="glyphicon glyphicon-plus"></span> 创建</button>
        <button type="button" class="btn btn-default" id="editDeptBtn"><span class="glyphicon glyphicon-edit"></span> 编辑</button>
        <button type="button" class="btn btn-danger" id="deleteDeptBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
    </div>
</div>
<div style="position: relative; left: 30px; top: 20px;">
    <table class="table table-hover">
        <thead>
        <tr style="color: #B3B3B3;">
            <td><input  id="checkAllDept" type="checkbox" /></td>
            <td>序号</td>
            <td>代码</td>
            <td>名称</td>
            <td>描述</td>
        </tr>
        </thead>
        <tbody id="deptTbody">
        <c:forEach items="${deptList}" var="dl" varStatus="s">
            <tr class="active">
                <td><input id="checkDept" value="${dl.code}" type="checkbox" /></td>
                <td>${s.count}</td>
                <td>${dl.code}</td>
                <td>${dl.name}</td>
                <td>${dl.description}</td>
            </tr>
        </c:forEach>
<%--        <tr class="active">--%>
<%--            <td><input type="checkbox" /></td>--%>
<%--            <td>1</td>--%>
<%--            <td><a href="detail.html" style="text-decoration: none;">001</a></td>--%>
<%--            <td>市场部</td>--%>
<%--            <td>111111111111111</td>--%>
<%--        </tr>--%>
<%--        <tr>--%>
<%--            <td><input type="checkbox" /></td>--%>
<%--            <td>2</td>--%>
<%--            <td><a href="detail.html" style="text-decoration: none;">002</a></td>--%>
<%--            <td>销售总监</td>--%>
<%--            <td>销售总监销售总监销售总监销售总监销售总监</td>--%>
<%--        </tr>--%>
<%--        <tr class="active">--%>
<%--            <td><input type="checkbox" /></td>--%>
<%--            <td>3</td>--%>
<%--            <td><a href="settings/qx/role/toDetail.do" style="text-decoration: none;">003</a></td>--%>
<%--            <td>市场总监</td>--%>
<%--            <td>市场总监市场总监市场总监市场总监</td>--%>
<%--        </tr>--%>
        </tbody>
    </table>
</div>

<%--<div style="height: 50px; position: relative;top: 30px; left: 30px;">--%>
<%--    <div>--%>
<%--        <button type="button" class="btn btn-default" style="cursor: default;">共<b>50</b>条记录</button>--%>
<%--    </div>--%>
<%--    <div class="btn-group" style="position: relative;top: -34px; left: 110px;">--%>
<%--        <button type="button" class="btn btn-default" style="cursor: default;">显示</button>--%>
<%--        <div class="btn-group">--%>
<%--            <button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown">--%>
<%--                10--%>
<%--                <span class="caret"></span>--%>
<%--            </button>--%>
<%--            <ul class="dropdown-menu" role="menu">--%>
<%--                <li><a href="#">20</a></li>--%>
<%--                <li><a href="#">30</a></li>--%>
<%--            </ul>--%>
<%--        </div>--%>
<%--        <button type="button" class="btn btn-default" style="cursor: default;">条/页</button>--%>
<%--    </div>--%>
<%--    <div style="position: relative;top: -88px; left: 285px;">--%>
<%--        <nav>--%>
<%--            <ul class="pagination">--%>
<%--                <li class="disabled"><a href="#">首页</a></li>--%>
<%--                <li class="disabled"><a href="#">上一页</a></li>--%>
<%--                <li class="active"><a href="#">1</a></li>--%>
<%--                <li><a href="#">2</a></li>--%>
<%--                <li><a href="#">3</a></li>--%>
<%--                <li><a href="#">4</a></li>--%>
<%--                <li><a href="#">5</a></li>--%>
<%--                <li><a href="#">下一页</a></li>--%>
<%--                <li class="disabled"><a href="#">末页</a></li>--%>
<%--            </ul>--%>
<%--        </nav>--%>
<%--    </div>--%>
<%--</div>--%>

</body>
</html>