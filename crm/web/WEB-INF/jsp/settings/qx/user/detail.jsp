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

	<%--	bootstrap日历插件--%>
	<link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />
	<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
	<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
	<!--TYPEAHEAD-->
	<script type="text/javascript" src="jquery/bs_typeahead/bootstrap3-typeahead.min.js"></script>
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
		$("#edit-deptName").typeahead({
			source:function (jquery,process) {//每次键盘弹起，都自动触发本函数；我们可以向后台送请求，查询客户表中所有的名称，把客户名称以[]字符串形式返回前台，赋值给source
				//process：是个函数，能够将['xxx','xxxxx','xxxxxx',.....]字符串赋值给source，从而完成自动补全
				//jquery：在容器中输入的关键字
				//var customerName=$("#customerName").val();
				//发送查询请求
				$.ajax({
					url:'settings/qx/user/queryDeptNameByName.do',
					data:{
						name:jquery
					},
					type:'post',
					dataType:'json',
					success:function (data) {//['xxx','xxxxx','xxxxxx',.....]
						process(data);
					}
				});
			}
		});
		//给保存按钮添加单击事件
		$("#updateUserBtn").click(function (){
			//收集参数
			let id = $("#edit-id").val();
			let loginAct=$.trim($("#edit-loginAct").val());
			let loginPwd=$.trim($("#edit-loginPwd").val());
			let name=$.trim($("#edit-name").val());
			let confirmPwd=$.trim($("#edit-confirmPwd").val());
			let email=$.trim($("#edit-email").val());
			let expireTime=$.trim($("#edit-expireTime").val());
			let lockState=$.trim($("#edit-lockState").val());
			let allowIps=$.trim($("#edit-allowIps").val());
			let deptName=$.trim($("#edit-deptName").val());
			//表单验证
			if(loginAct==""){
				alert("账号不能为空！");
				return;
			}
			if(loginPwd==""){
				alert("密码不能为空！");
				return;
			}
			if(confirmPwd==""){
				alert("未确认密码");
				return;
			}
			if(confirmPwd!=""){
				if(confirmPwd!=loginPwd){
					alert("两次输入密码不一致！");
					return;
				}
			}
			if(deptName==""){
				alert("部门不为空！");
				return;
			}

			$.ajax({
				url:"settings/qx/user/detail.do/editUserById.do",
				data:{
					id : id,
					loginAct:loginAct,
					loginPwd:loginPwd,
					email:email,
					name:name,
					expireTime:expireTime,
					lockState:lockState,
					deptName:deptName,
					allowIps:allowIps
				},
				type:"post",
				dataType:"json",
				success:function (data){
					if(data.code=="1"){
						window.location.reload();
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
		$("#assignBtn").click(function (){
			// $("uLi").className="";
			// $("pLi").className="active";
			// $("#permission-info").className="tab-pane fade in active";
			// $("#permission-info").tab("show");
			roleno = '${user.roleno}'
			queryNotAssignedRole(roleno);
			queryAssignedRole(roleno);
			$("#assignRoleForUserModal").modal("show");
		})
		$("#closeAssignBtn").click(function (){
			window.location.reload();
		})
		$("#assignRoleBtn").click(function (){
			let id = $("#edit-id").val();
			let roleno= $("#roleList1 option:selected");
			console.log(roleno);
			let rolenos='';
			for (let i = 0; i < roleno.length; i++) {
				if(i<roleno.length-1){
					rolenos+=roleno[i].value+',';
				}else{
					rolenos+=roleno[i].value;
				}
			}
			let old = $("#newRoleno").val();
			alert(old);
			alert(old.length)
			console.log(old);
			if(old.length!=0){
				rolenos=old+","+rolenos;
			}else{
				rolenos=rolenos;
			}
			alert(rolenos);
			if(rolenos==""||rolenos==null||rolenos=="null"){
				alert("请选择要分配的角色");
				return;
			}
			$.ajax({
				url:'settings/qx/user/assignRoleToUser.do',
				data:{
					id: id,
					rolenos:rolenos
				},
				type:'post',
				datatype:'json',
				success:function (data){
					if(data.code=="1"){
						queryAssignedRole(rolenos);
						queryNotAssignedRole(rolenos);
						queryPermissionByRoleIdForTree(rolenos);
					}else{
						alert(data.message);
						$("#assignRoleForUserModal").modal("show");
					}
				}
			})
		})
		$("#revokeRoleBtn").click(function (){
			let id = $("#edit-id").val();
			let roleno= $("#roleList2 option:not(:selected)");
			let rolenoSelected= $("#roleList2 option:selected");
			console.log(roleno);
			let rolenos='';
			for (let i = 0; i < roleno.length; i++) {
				if(i<roleno.length-1){
					rolenos+=roleno[i].value+',';
				}else{
					rolenos+=roleno[i].value;
				}
			}

			alert(rolenos);
			if(rolenoSelected.length==0){
				alert("请选择要撤销的角色");
				return;
			}
			$.ajax({
				url:'settings/qx/user/assignRoleToUser.do',
				data:{
					id: id,
					rolenos:rolenos
				},
				type:'post',
				datatype:'json',
				success:function (data){
					if(data.code=="1"){
						queryAssignedRole(rolenos);
						queryNotAssignedRole(rolenos);
						queryPermissionByRoleIdForTree(rolenos);
						queryUserById();
					}else{
						alert(data.message);
						$("#assignRoleForUserModal").modal("show");
					}
				}
			})
		});
		$(".myDate").datetimepicker({
			//类中 添加类myDate
			language:"zh-CN",
			format:"yyyy-mm-dd hh:ii",
			minView:"hour",
			initialDate:new Date(),
			autoclose:true,
			todayBtn:true,
			clearBtn:true
		})
	});
	function  queryNotAssignedRole(roleno){
		$.ajax({
			url:'settings/qx/user/queryNotAssignedRole.do',
			data:{
				roleno:roleno
			},
			type:'post',
			datatype:'json',
			success:function (data){
				let htmlStr1='';
				$.each(data,function (index,obj){
					htmlStr1+="<option value='"+obj.code+"'>";
					htmlStr1+=""+obj.name+"</option>";
				})
				$("#roleList1").html(htmlStr1);
			}
		})
	}
	function  queryAssignedRole(roleno){
		$.ajax({
			url:'settings/qx/user/queryAssignedRole.do',
			data:{
				roleno:roleno
			},
			type:'post',
			datatype:'json',
			success:function (data){
				let htmlStr2='';
				$.each(data,function (index,obj){
					htmlStr2+="<option value='"+obj.code+"'>";
					htmlStr2+=""+obj.name+"</option>";
				})
				$("#roleList2").html(htmlStr2);
			}
		})
	}
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
	function queryUserById(){
		let id = $("#edit-id").val();
		$.ajax({
			url:'settings/qx/user/queryUserById.do/'+id,
			type:'post',
			datatype:'json',
			success:function (data){
				$("#newRoleno").val(data.roleno);
			}
		})
	}

</SCRIPT>

</head>
<body>

	<!-- 分配许可的模态窗口 -->
	<div class="modal fade" id="assignRoleForUserModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 80%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel1">为<b>${user.name}</b>分配角色</h4>
				</div>
				<div class="modal-body">
					<table width="90%" border="0" cellspacing="0" cellpadding="0" align="center">
						<tr>
							<td width="42%">
								<div class="list_tit" style="border: solid 1px #D5D5D5; background-color: #F4F4B5;">
									${user.name}，未分配角色列表
								</div>
							</td>
							<td width="15%">
								&nbsp;
							</td>
							<td width="43%">
								<div class="list_tit" style="border: solid 1px #D5D5D5; background-color: #F4F4B5;">
									${user.name}，已分配角色列表
								</div>
							</td>
						</tr>
						<tr>
							<td>
								<select size="15" name="srcList" id="roleList1"
									style="width: 100%" multiple="multiple">
<%--									<c:if test="${not empty roleList}">--%>
<%--										<c:forEach items="${roleList}" var="rl">--%>
<%--											<option value="${rl.code}">${rl.name}</option>--%>
<%--										</c:forEach>--%>
<%--									</c:if>--%>
								</select>
							</td>
							<td>
								<p align="center">
									<a href="javascript:void(0);" title="分配角色" id="assignRoleBtn"><span class="glyphicon glyphicon-chevron-right" style="font-size: 20px;"></span></a>
								</p>
								<br><br>
								<p align="center">
									<a href="javascript:void(0);" title="撤销角色" id="revokeRoleBtn"><span class="glyphicon glyphicon-chevron-left" style="font-size: 20px;"></span></a>
								</p>
							</td>
							<td>
								<select name="destList" size="15" multiple="multiple"
									id="roleList2" style="width: 100%">
<%--									<c:if test="${not empty roleList2}">--%>
<%--										<c:forEach items="${roleList2}" var="rl2">--%>
<%--											<option value="${rl2.code}">${rl2.name}</option>--%>
<%--										</c:forEach>--%>
<%--									</c:if>--%>

								</select>
							</td>
						</tr>
					</table>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" id="closeAssignBtn">关闭</button>
				</div>
			</div>
		</div>
	</div>

	<!-- 编辑用户的模态窗口 -->
	<div class="modal fade" id="editUserModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 90%;">
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
						<input id="newRoleno" type="hidden">
						<div class="form-group">
							<label for="edit-loginAct" class="col-sm-2 control-label">登录帐号<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-loginAct" value="${user.loginAct}">
							</div>
							<label for="edit-name" class="col-sm-2 control-label">用户姓名</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-name" value="${user.name}">
							</div>
						</div>
						<div class="form-group">
							<label for="edit-loginPwd" class="col-sm-2 control-label">登录密码<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="password" class="form-control" id="edit-loginPwd" value="">
							</div>
							<label for="edit-confirmPwd" class="col-sm-2 control-label">确认密码<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="password" class="form-control" id="edit-confirmPwd" value="">
							</div>
						</div>
						<div class="form-group">
							<label for="edit-email" class="col-sm-2 control-label">邮箱</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-email" value="${user.email}">
							</div>
							<label for="edit-expireTime" class="col-sm-2 control-label">失效时间</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control myDate" id="edit-expireTime" value="${user.expireTime}" readonly>
							</div>
						</div>
						<div class="form-group">
							<label for="edit-lockState" class="col-sm-2 control-label">锁定状态</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-lockState">
									<c:if test="${user.lockState=='1'}" >
										<option value="1" selected>启用</option>
									</c:if>
									<c:if test="${user.lockState=='0'}">
										<option value="0" selected>锁定</option>
									</c:if>
								</select>
							</div>
							<label for="edit-deptName" class="col-sm-2 control-label">部门名称<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-deptName" placeholder="输入部门名称，自动补全" value="${user.deptName}">
							</div>
						</div>
						<div class="form-group">
							<label for="edit-allowIps" class="col-sm-2 control-label">允许访问的IP</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-allowIps" style="width: 280%" placeholder="多个用逗号(英)隔开" value="${user.allowIps}">
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
				<h3>用户明细 <small>${user.name}</small></h3>
			</div>
			<div style="position: relative; height: 50px; width: 250px;  top: -72px; left: 80%;">
				<button type="button" class="btn btn-default" onclick="window.history.back();"><span class="glyphicon glyphicon-arrow-left"></span> 返回</button>
			</div>
		</div>
	</div>
	
	<div style="position: relative; left: 60px; top: -50px;">
		<ul id="myTab" class="nav nav-pills">
			<li id="uLi" class="active"><a href="#role-info" data-toggle="tab">用户信息</a></li>
			<li id="pLi"><a href="#permission-info" data-toggle="tab">许可信息</a></li>
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
						<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${user.name}</b></div>
						<div style="height: 1px; width: 600px; background: #D5D5D5; position: relative; top: -20px;"></div>
					</div>
					<div style="position: relative; left: 40px; height: 30px; top: 60px;">
						<div style="width: 300px; color: gray;">邮箱</div>
						<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${user.email}</b></div>
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
						<div style="width: 300px; color: gray;">锁定状态</div>
						<c:if test="${user.lockState=='0'}">
							<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>锁定</b></div>
						</c:if>
						<c:if test="${user.lockState!='0'}">
							<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>启用</b></div>
						</c:if>
						<div style="height: 1px; width: 600px; background: #D5D5D5; position: relative; top: -20px;"></div>
					</div>
					<div style="position: relative; left: 40px; height: 30px; top: 140px;">
						<div style="width: 300px; color: gray;">部门名称</div>
						<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${user.deptName}</b></div>
						<div style="height: 1px; width: 600px; background: #D5D5D5; position: relative; top: -20px;"></div>
						<button style="position: relative; left: 76%; top: -40px;" type="button" class="btn btn-default" id="editUserBtn"><span class="glyphicon glyphicon-edit"></span> 编辑</button>
					</div>
				</div>
			</div>
			<div class="tab-pane fade" id="permission-info">
				<div style="position: relative; top: 20px; left: 0px;">
					<ul id="treeDemo" class="ztree" style="position: relative; top: 15px; left: 15px;"></ul>
					<div style="position: relative;top: 30px; left: 76%;">
						<button type="button" class="btn btn-default" id="assignBtn"><span class="glyphicon glyphicon-edit"></span> 分配角色</button>
					</div>
				</div>
			</div>
		</div>
	</div>	
	
</body>
</html>