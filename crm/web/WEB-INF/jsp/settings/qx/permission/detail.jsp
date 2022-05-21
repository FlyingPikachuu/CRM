<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String basePath=request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+request.getContextPath()+"/";
%>
<html>
<base href="<%=basePath%>">
<head>
    <meta charset="UTF-8">

    <%--jquery框架--%>
    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
    <%--	bootstrap框架--%>
    <link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" /><script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
    <script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
    <script type="text/javascript">
        $(function (){
           $("#createPermissionBtn").click(function (){
               $("#createPermissionModal").modal("show");
           });
           $("#savePermissionBtn").click(function (){
               let name = $.trim($("#create-name").val());
               let moduleUrl = $.trim($("#create-moduleUrl").val());
               let doUrl = $.trim($("#create-doUrl").val());
               let pId = $.trim($("#create-pId").val());
               let isParent = $.trim($("#create-isParent").val());
               $.ajax({
                   url:'settings/qx/permission/addPm.do',
                   data:{
                       name:name,
                       moduleUrl:moduleUrl,
                       doUrl:doUrl,
                       pId:pId,
                       isParent:isParent
                   },
                   type:'post',
                   datatype:'json',
                   success:function (data){
                       if(data.code=="1"){
                           $("#createPermissionModal").modal("hide");
                           parent.location.href="settings/qx/permission/index.do";
                       }else{
                           alert(data.message);
                           $("#createPermissionModal").modal("show");
                       }
                   }
               })
           })

            $("#editPermissionBtn").click(function (){
                $("#editPermissionModal").modal("show");
            })
            $("#updatePermissionBtn").click(function (){
                let id = $("#edit-id").val();
                let name = $.trim($("#edit-name").val());
                let moduleUrl = $.trim($("#edit-moduleUrl").val());
                let doUrl = $.trim($("#edit-doUrl").val());
                let pId = $.trim($("#edit-pId").val());
                let isParent = $.trim($("#edit-isParent").val());
                $.ajax({
                    url:'settings/qx/permission/editPm.do',
                    data:{
                        id : id,
                        name:name,
                        moduleUrl:moduleUrl,
                        doUrl:doUrl,
                        pId:pId,
                        isParent:isParent
                    },
                    type:'post',
                    datatype:'json',
                    success:function (data){
                        if(data.code=="1"){
                            $("#editPermissionModal").modal("hide");
                            parent.location.href="settings/qx/permission/index.do";
                            window.open("settings/qx/permission/queryPermissionById.do/"+id,"workAreaFrame2");
                        }else{
                            alert(data.message);
                            $("#editPermissionModal").modal("show");
                        }
                    }
                })
            });
           $("#deletePermissionBtn").click(function (){
               $("#removePermissionModal").modal("show");
           })
            $("#removePermissionBtn").click(function (){
                let id = this.value;
                alert(id);
                $.ajax({
                    url:'settings/qx/permission/deletePm.do',
                    data:{id:id},
                    type:'post',
                    datatype:'json',
                    success:function (data){
                        if(data.code=="1"){
                            $("#removePermissionModal").modal("hide");
                            parent.location.href="settings/qx/permission/index.do"                        }else{
                            alert(data.message);
                            $("#removePermissionModal").modal("show");
                        }
                    }
                })
            })
        });
    </script>

</head>
<body>
<!-- 新增许可模态窗口 -->
<div class="modal fade" id="createPermissionModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 80%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel1">新增许可</h4>
            </div>
            <div class="modal-body">

                <form class="form-horizontal" role="form" id="createPermissionForm">

                    <div class="form-group">
                        <label for="create-name" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-name" style="width: 200%;">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-moduleUrl" class="col-sm-2 control-label">模块URL</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-moduleUrl" style="width: 200%;">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-doUrl" class="col-sm-2 control-label">操作URL</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-doUrl" style="width: 200%;" placeholder="多个用逗号（英）隔开">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="create-pId" class="col-sm-2 control-label">父节点Id</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-pId" style="width: 200%;" placeholder="参照左侧zTree填写，从1开始，自顶向下依次+1" value="">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="create-isParent" class="col-sm-2 control-label">是否父节点</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-isParent" style="width: 200%;" placeholder="是填'1',否填'0'" value="">
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="savePermissionBtn">保存</button>
            </div>
        </div>
    </div>
</div>

<!-- 修改许可 -->
<div class="modal fade" id="editPermissionModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 80%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel2">修改许可</h4>
            </div>
            <div class="modal-body">

                <form class="form-horizontal" role="form">
                    <input id="edit-id" type="hidden" value="${pm.id}">
                    <div class="form-group">
                        <label for="edit-name" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-name" style="width: 200%;" value="${pm.name}">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-moduleUrl" class="col-sm-2 control-label">模块URL</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-moduleUrl" style="width: 200%;" value="${pm.moduleUrl}">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-doUrl" class="col-sm-2 control-label">操作URL</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-doUrl" style="width: 200%;" placeholder="多个用逗号（英）隔开" value="${pm.doUrl}">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="edit-pId" class="col-sm-2 control-label">父节点Id</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-pId" style="width: 200%;" placeholder="参照左侧zTree填写，从1开始，自顶向下依次+1" value="${pm.pId}">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="edit-isParent" class="col-sm-2 control-label">是否父节点</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-isParent" style="width: 200%;" placeholder="是填'1',否填'0'" value="${pm.isParent}">
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="updatePermissionBtn">更新</button>
            </div>
        </div>
    </div>
</div>
<!-- 删除许可的模态窗口 -->
<div class="modal fade" id="removePermissionModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 30%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel3">删除许可</h4>
            </div>
            <div class="modal-body">
                <p>您确定要删除该许可吗？</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
                <button type="button" class="btn btn-danger" id="removePermissionBtn" value="${pm.id}"}>删除</button>
            </div>
        </div>
    </div>
</div>

    <!-- 大标题 -->
    <div style="position: relative; left: 30px; top: -10px;">
        <div class="page-header">
            <h3 id="detail-name1">${pm.name} <small>许可明细</small></h3>
        </div>
        <div style="position: relative; height: 50px; width: 250px;  top: -72px; left: 60%;">
            <button type="button" class="btn btn-primary" id="createPermissionBtn"><span class="glyphicon glyphicon-plus"></span> 新增</button>
            <button type="button" class="btn btn-default" id="editPermissionBtn"><span class="glyphicon glyphicon-edit"></span> 编辑</button>
            <button type="button" class="btn btn-danger" id="deletePermissionBtn"><span class="glyphicon glyphicon-edit"></span> 删除</button>
        </div>
    </div>
    <!-- 详细信息 -->
    <div style="position: relative; top: -70px;">
        <div style="position: relative; left: 40px; height: 30px; top: 20px;">
            <div style="width: 300px; color: gray;">名称</div>
            <div style="width: 500px;position: relative; left: 200px; top: -20px;"><b id="detail-name2">${pm.name}</b></div>
            <div style="height: 1px; width: 600px; background: #D5D5D5; position: relative; top: -20px;"></div>
        </div>
        <div style="position: relative; left: 40px; height: 30px; top: 40px;">
            <div style="width: 300px; color: gray;">模块URL</div>
            <div style="width: 500px;position: relative; left: 200px; top: -20px;"><b id="detail-moduleUrl">${pm.moduleUrl}</b></div>
            <div style="height: 1px; width: 600px; background: #D5D5D5; position: relative; top: -20px;"></div>
        </div>
        <div style="position: relative; left: 40px; height: 30px; top: 60px;">
            <div style="width: 300px; color: gray;">操作URL</div>
            <div style="width: 500px;position: relative; left: 200px; top: -20px;"><b id="detail-doUrl">${pm.doUrl}</b></div>
            <div style="height: 1px; width: 600px; background: #D5D5D5; position: relative; top: -20px;"></div>
        </div>
        <div style="position: relative; left: 40px; height: 30px; top: 80px;">
            <div style="width: 300px; color: gray;">排序号</div>
            <div style="width: 500px;position: relative; left: 200px; top: -20px;"><b id="detail-orderNo">${pm.orderNo}</b></div>
            <div style="height: 1px; width: 600px; background: #D5D5D5; position: relative; top: -20px;"></div>
        </div>
    </div>
<div style="height: 200px;"></div>
</body>
</html>