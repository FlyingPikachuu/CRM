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

<script type="text/javascript">
	var setting = {
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

	//查找所有权限，然后建树
	let json2 = ${j};
	<%--let json= ${json2};--%>
	<%--let zNodes =eval(json);--%>
	let zNodes;
	let zNodes2 = eval(json2);

	let setting2 = {
		edit:{
			enable: true,
			showRemoveBtn:false,
			showRenameBtn: false
		},
			data: {
				simpleData: {
					enable: true
				}
			},
			check : {
				enable : true
			}
		};


	let code;
	;
	function queryPermissionByRoleIdForTree(){
		let roleno = $("#edit-code").val()
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

	function setCheck() {
		let zTree = $.fn.zTree.getZTreeObj("treeDemo"),
				py = $("#py").attr("checked") ? "p" : "",
				sy = $("#sy").attr("checked") ? "s" : "",
				pn = $("#pn").attr("checked") ? "p" : "",
				sn = $("#sn").attr("checked") ? "s" : "",
				type = {"Y": py + sy, "N": pn + sn};
		zTree.setting.check.chkboxType = type;
		showCode('setting.check.chkboxType = { "Y" : "' + type.Y + '", "N" : "' + type.N + '" };');
	}

	function showCode(str) {
		if (!code) code = $("#code");
		code.empty();
		code.append("<li>" + str + "</li>");
	}

	//从后台获取本角色有的权限
	function getChecked() {
		let roleId = $("#rid").val();
		$.ajax({
			type: "post",
			url: "settings/qx/role/queryRPRByRoleId.do",
			data:{
				roleId : roleId
			},
			dataType: "json",
			success: function (data) {
				for (let i = 0; i < data.length; i++) {
					let zTree = $.fn.zTree.getZTreeObj("permissionTree"); //
					zTree.checkNode(zTree.getNodeByParam("id", data[i]), true); //根据id在ztree的复选框中实现自动勾选
				}
			}
		})
	}

	
	$(document).ready(function(){
		if(location.hash) {
			$('a[href=' + location.hash + ']').tab('show');
		}
		$(document.body).on("click", "a[data-toggle]", function(event) {
			location.hash = this.getAttribute("href");
		});
		queryPermissionByRoleIdForTree();
		$(window).on('popstate', function() {
			var anchor = location.hash || $("a[data-toggle=tab]").first().attr("href");
			$('a[href=' + anchor + ']').tab('show');
		});


		//给修改按钮添加单击事件
		$("#editRoleBtn").click(function (){
		   $("#editRoleModal").modal("show");
		});
		//给更新按钮添加单击事件
		$("#updateRoleBtn").click(function (){
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
				url:'settings/qx/role/editRole.do',
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
						$("#editRoleModal").modal("show");
					}
				}
			})
		});
		//给许可分配添加单击事件
		$("#APBtn").click(function (){
			$("#assignPermissionForRoleModal").modal("show");
			$.fn.zTree.init($("#permissionTree"), setting2, zNodes2);
			getChecked();
			setCheck();
			$("#py").bind("change", setCheck);
			$("#sy").bind("change", setCheck);
			$("#pn").bind("change", setCheck);
			$("#sn").bind("change", setCheck);
		});
		//分配(修改)权限，可以实现权限的增加或者删除，勾选即添加，取消勾选即删除
		$("#ABtn").click(function (){
			let zTree = $.fn.zTree.getZTreeObj("permissionTree");
			let roleId = $("#rid").val();
			alert(roleId);
			if (zTree != null) {
				let nodes = zTree.getCheckedNodes(true);
				let tmpNode;
				let ids = '';
				//要对数据进行处理
				for(let i=0; i<nodes.length; i++) {
					tmpNode = nodes[i];
					if (i != nodes.length - 1) {
						ids += tmpNode.id + ",";
					} else {
						ids += tmpNode.id;
					}
				}
				alert(ids);
				$.ajax({
					type: "post",
					url: "settings/qx/role/assignPermission.do/"+roleId,
					data: {ids: ids},
					dataType: "json",
					success: function (data) {
						if (data.code == "1") {
							queryPermissionByRoleIdForTree();
							$("#assignPermissionForRoleModal").modal("hide");
						}else{
							alert(data.message);
							$("#assignPermissionForRoleModal").modal("show");
						}
					}
				})
			}
		});
	});

</script>

</head>
<body>

	<!-- 分配许可的模态窗口 -->
	<div class="modal fade" id="assignPermissionForRoleModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 30%;">
			<div class="modal-content">
				<div class="modal-header">
					<input type="hidden" id="rid" value="${role.code}">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel">为<b>${role.name}</b>分配许可</h4>
				</div>
				<div class="modal-body">
					<ul id="permissionTree" class="ztree"></ul>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
					<button type="button" class="btn btn-primary" id="ABtn">分配</button>
				</div>
			</div>
		</div>
	</div>

	<!-- 修改角色的模态窗口 -->
	<div class="modal fade" id="editRoleModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 80%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel1">修改角色</h4>
				</div>
				<div class="modal-body">

					<form id="editRoleForm" class="form-horizontal" role="form">
						<input type="hidden" id="edit-oldCode" value="${role.code}">
						<div class="form-group">
							<label for="edit-code" class="col-sm-2 control-label">代码<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-code" style="width: 200%;" value="${role.code}">
							</div>
						</div>

						<div class="form-group">
							<label for="edit-name" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-name" style="width: 200%;" value="${role.name}">
							</div>
						</div>

						<div class="form-group">
							<label for="edit-description" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 65%;">
								<textarea class="form-control" rows="3" id="edit-description">${role.description}</textarea>
							</div>
						</div>
					</form>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="updateRoleBtn">更新</button>
				</div>
			</div>
		</div>
	</div>

	<div>
		<div style="position: relative; left: 30px; top: -10px;">
			<div class="page-header">
				<h3>角色明细 <small>${role.name}</small></h3>
			</div>
			<div style="position: relative; height: 50px; width: 250px;  top: -72px; left: 80%;">
				<button type="button" class="btn btn-default" onclick="window.history.back();"><span class="glyphicon glyphicon-arrow-left"></span> 返回</button>
			</div>
		</div>
	</div>
	
	<div style="position: relative; left: 60px; top: -50px;">
		<ul id="myTab" class="nav nav-pills">
			<li class="active"><a href="#role-info" data-toggle="tab">角色信息</a></li>
			<li><a href="#permission-info" data-toggle="tab">许可信息</a></li>
		</ul>
		<div id="myTabContent" class="tab-content">
			<div class="tab-pane fade in active" id="role-info">
				<div style="position: relative; top: 20px; left: -30px;">
					<div style="position: relative; left: 40px; height: 30px; top: 20px;">
						<div style="width: 300px; color: gray;">代码</div>
						<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${role.code}</b></div>
						<div style="height: 1px; width: 600px; background: #D5D5D5; position: relative; top: -20px;"></div>
					</div>
					<div style="position: relative; left: 40px; height: 30px; top: 40px;">
						<div style="width: 300px; color: gray;">名称</div>
						<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${role.name}</b></div>
						<div style="height: 1px; width: 600px; background: #D5D5D5; position: relative; top: -20px;"></div>
					</div>
					<div style="position: relative; left: 40px; height: 30px; top: 60px;">
						<div style="width: 300px; color: gray;">描述</div>
						<div style="width: 200px;position: relative; left: 200px; top: -20px;"><b>${role.description}</b></div>
						<div style="height: 1px; width: 600px; background: #D5D5D5; position: relative; top: -20px;"></div>
						<button style="position: relative; left: 76%;" type="button" class="btn btn-default" id="editRoleBtn"><span class="glyphicon glyphicon-edit"></span> 编辑</button>
					</div>
				</div>
			</div>
			<div class="tab-pane fade" id="permission-info">
				<div style="position: relative; top: 20px; left: 0px;">
					<ul id="treeDemo" class="ztree" style="position: relative; top: 15px; left: 15px;"></ul>
					<div style="position: relative;top: 30px; left: 76%;">
						<button type="button" class="btn btn-default" id="APBtn"><span class="glyphicon glyphicon-edit"></span> 分配许可</button>
					</div>
				</div>
			</div>
		</div>
	</div>	
	
</body>
</html>