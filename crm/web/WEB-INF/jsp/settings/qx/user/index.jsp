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
	<%--	bootstrap日历插件--%>
	<link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />
	<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
	<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>

	<!--  PAGINATION plugin -->
	<link rel="stylesheet" type="text/css" href="jquery/bs_pagination-master/css/jquery.bs_pagination.min.css">
	<script type="text/javascript" src="jquery/bs_pagination-master/js/jquery.bs_pagination.min.js"></script>
	<script type="text/javascript" src="jquery/bs_pagination-master/localization/en.js"></script>

<script type="text/javascript">
	$(function (){
		//给创建按钮加单击事件
		$("#addUserBtn").click(function (){
			//初始化工作——清空上次填写的表单数据
			//方式一取表单项.val()赋值为空 数据多时繁琐
			//方式二拿到form标签的DOM对象
			//原始方法 document.getElementById("addUserForm");
			// $("#addUserForm")[0].reset();
			//重置表单
			// $("#addUserForm").get(0).reset();
			//弹出创建市场活动的模态窗口
			$("#createUserModal").modal("show");
		})

		//给保存按钮添加单击事件
		$("#saveUserBtn").click(function (){
			//收集参数
		let loginAct=$.trim($("#create-loginActNo").val());
		let loginPwd=$.trim($("#create-loginPwd").val());
		let username=$.trim($("#create-username").val());
		let confirmPwd=$.trim($("#create-confirmPwd").val());
		let email=$.trim($("#create-email").val());
		let endDateTime=$.trim($("#create-endDateTime").val());
		let lockStatus=$.trim($("#create-lockStatus").val());
		let allowIps=$.trim($("#create-allowIps").val());
		let org=$.trim($("#create-org").val());
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

		$.ajax({
			url:"settings/qx/user/addUser.do",
			data:{
				loginAct:loginAct,
				loginPwd:loginPwd,
				confirmPwd:confirmPwd,
				email:email,
				name:username,
				expireTime:endDateTime,
				lockState:lockStatus,
				deptno:org,
				allowIps:allowIps
			},
			type:"post",
			dataType:"json",
			success:function (data){
				if(data.code=="1"){
					//关闭模态窗口
					$("#createUserModal").modal("hide");
				}else{
					//提示信息
					alert(data.message);
					//模态窗口不关闭——关闭dismiss后可不写
					$("#createUserModal").modal("show");
				}
			}
		})
	})

		//容器加载完后，对容器调用工具类
		// $("input[name='myDate']").datetimepicker({})
		//容器内添加name 属性
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

		//当用户管理主页面加载完成，查询所有数据的第一页以及所有数据的总条数,默认每页显示10条
		queryUserByConditionForPage(1,10);

		//给"查询"按钮添加单击事件
		$("#queryUserBtn").click(function () {
			//查询所有符合条件数据的第一页以及所有符合条件数据的总条数;
			//实现翻页查询每页显示条数不变
			// pagination插件 getOption 函数 获取当前客户端分页工具中用户选择的参数值
			queryUserByConditionForPage(1,$("#user_pag").bs_pagination("getOption","rowsPerPage"));
		});

		//给“状态"按钮添加单击事件
		$("#tBody").on("click","#editLockState",function (){
			let lockState=$(this).attr("userLockState");
			console.log(lockState);
			let id=$(this).attr("userid");
			if(lockState==1||lockState==null){
				if(window.confirm("确定锁定该用户吗？")){
					$.ajax({
						url:'settings/qx/user/editLockState.do',
						data:{
							lockState:lockState,
							id:id
						},
						type:"post",
						datatype:'json',
						success:function (data){
							if(data.code=="1"){
								queryUserByConditionForPage(1,$("#user_pag").bs_pagination("getOption","rowsPerPage"));
							}else{
								alert(data.message);
							}
						}
					});
				}
			}
			else{
				if(window.confirm("确定启用该用户吗？")){
					$.ajax({
						url:'settings/qx/user/editLockState.do',
						data:{
							lockState:lockState,
							id:id
						},
						type:"post",
						datatype:'json',
						success:function (data){
							if(data.code=="1"){
								queryUserByConditionForPage(1,$("#user_pag").bs_pagination("getOption","rowsPerPage"));
							}else{
								alert(data.message);
							}
						}
					});
				}
			}
		});


})
	function queryUserByConditionForPage(pageNo,pageSize){
		//收集参数
		let name = $("#query-name").val();
		let deptno = $("#query-deptno").val();
		let lockState = $("#query-lockState").val();
		console.log(lockState);
		let startDateTime = $("#query-startDateTime").val();
		let endDateTime = $("#query-endDateTime").val();
		// let pageNo=1;
		// let pageSize=10;
		//发送请求
		$.ajax({
			url: 'settings/qx/user/queryUserByConditionForPage.do',
			data: {
				name: name,
				deptno: deptno,
				lockState:lockState,
				startDateTime:startDateTime,
				endDateTime:endDateTime,
				pageNo:pageNo,
				pageSize:pageSize
			},
			type: 'post',
			dataType: 'json',
			success: function (data) {
				//显示总条数
				// $("#totalRowsB").text(data.totalRows);
				//显示市场活动的列表
				//遍历activityList，拼接所有行数据
				let htmlStr = "";
				$.each(data.userList,function (index,users){
					htmlStr+="<tr class='active'>"
					htmlStr+="<td><input type='checkbox' value=\"" + users.id + "\"/></td>"
					htmlStr+="<td>" +users.id+ "</td>"
					htmlStr+="<td><a  href='settings/qx/user/detail.do'>"+users.loginAct+"</a></td>"
					htmlStr+="<td>"+users.name+"</td>"
					htmlStr+="<td>"+users.deptno+"</td>"
					htmlStr+="<td>"+users.email+"</td>"
					htmlStr+="<td>"+users.expireTime+"</td>"
					htmlStr+="<td>"+users.allowIps+"</td>"
					if(users.lockState==1||users.lockState==null){
						htmlStr+="<td><a href='javascript:void(0);' id='editLockState' userId=\""+users.id+"\" userLockState=\""+users.lockState+"\" style='text-decoration: none;'>启用</a></td>"
					}else {
						htmlStr+="<td><a href='javascript:void(0);' id='editLockState' userId=\""+users.id+"\" userLockState=\""+users.lockState+"\" style='text-decoration: none;'>锁定</a></td>"
					}
					htmlStr+="<td>"+users.createBy+"</td>"
					htmlStr+="<td>"+users.createtime+"</td>"
					htmlStr+="<td>"+users.editBy+"</td>"
					htmlStr+="<td>"+users.editTime+"</td>"
					htmlStr+="</tr>"

				})
				$("#tBody").html(htmlStr);

				//取消全选按钮
				$("#checkAllUser").prop("checked",false);

				//计算totalpages
				let totalPages=1;
				if(data.totalrows%pageSize==0){
					totalPages=data.totalRows/pageSize;
				}
				else{
					totalPages=parseInt(data.totalRows/pageSize)+1;
				}

				//执行函数时需保证已查到totalRows
				//对容器调用bs_pagination分页工具函数，显示翻页信息
				$("#user_pag").bs_pagination({
					currentPage:pageNo,
					rowsPerPage:pageSize,
					totalRows:data.totalRows,
					totalPages:totalPages,

					visiblePageLinks:5,

					showGoToPage:true,
					showRowsPerPage:true,
					showRowsInfo:true,

					//用户每次切换页号，触发本函数
					//返回每次切换也好厚的pageNo和pageSize
					onChangePage:function(event,pageObj){
						queryUserByConditionForPage(pageObj.currentPage,pageObj.rowsPerPage);
					}
				});
			}
		});
	}


</script>
</head>
<body>

	<!-- 创建用户的模态窗口 -->
	<div class="modal fade" id="createUserModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 90%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel">新增用户</h4>
				</div>
				<div class="modal-body">

					<form id="addUserForm" class="form-horizontal" role="form">

						<div class="form-group">
							<label for="create-loginActNo" class="col-sm-2 control-label">登录帐号<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-loginActNo">
							</div>
							<label for="create-username" class="col-sm-2 control-label">用户姓名</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-username">
							</div>
						</div>
						<div class="form-group">
							<label for="create-loginPwd" class="col-sm-2 control-label">登录密码<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="password" class="form-control" id="create-loginPwd">
							</div>
							<label for="create-confirmPwd" class="col-sm-2 control-label">确认密码<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="password" class="form-control" id="create-confirmPwd">
							</div>
						</div>
						<div class="form-group">
							<label for="create-email" class="col-sm-2 control-label">邮箱</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-email">
							</div>
							<label for="create-expireTime" class="col-sm-2 control-label">失效时间</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control myDate" id="create-expireTime" readonly>
							</div>
						</div>
						<div class="form-group">
							<label for="create-lockStatus" class="col-sm-2 control-label">锁定状态</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-lockStatus">
								  <option value="1"></option>
								  <option value="1">启用</option>
								  <option value="0">锁定</option>
								</select>
							</div>
							<label for="create-org" class="col-sm-2 control-label">部门<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-org" placeholder="输入部门名称，自动补全">
							</div>
						</div>
						<div class="form-group">
							<label for="create-allowIps" class="col-sm-2 control-label">允许访问的IP</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-allowIps" style="width: 280%" placeholder="多个用逗号隔开">
							</div>
						</div>
					</form>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="saveUserBtn">保存</button>
				</div>
			</div>
		</div>
	</div>


	<div>
		<div style="position: relative; left: 30px; top: -10px;">
			<div class="page-header">
				<h3>用户列表</h3>
			</div>
		</div>
	</div>

	<div class="btn-toolbar" role="toolbar" style="position: relative; height: 80px; left: 30px; top: -10px;">
		<form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">

		  <div class="form-group">
		    <div class="input-group">
		      <div class="input-group-addon">用户姓名</div>
		      <input class="form-control" type="text" id="query-name">
		    </div>
		  </div>
		  &nbsp;&nbsp;&nbsp;&nbsp;
		  <div class="form-group">
		    <div class="input-group">
		      <div class="input-group-addon">部门名称</div>
		      <input class="form-control" type="text" id="query-deptno">
		    </div>
		  </div>
		  &nbsp;&nbsp;&nbsp;&nbsp;
		  <div class="form-group">
		    <div class="input-group">
		      <div class="input-group-addon">锁定状态</div>
			  <select class="form-control" id="query-lockState">
			  	  <option value="1"></option>
			      <option value="0">锁定</option>
				  <option value="1">启用</option>
			  </select>
		    </div>
		  </div>
		  <br><br>

		  <div class="form-group">
		    <div class="input-group">
		      <div class="input-group-addon">失效时间</div>
			  <input class="form-control myDate" type="text" id="query-startDateTime" readonly/>
		    </div>
		  </div>

		  ~

		  <div class="form-group">
		    <div class="input-group">
			  <input class="form-control myDate" type="text" id="query-endDateTime" readonly/>
		    </div>
		  </div>
		  
		  <button type="button" class="btn btn-default" id="queryUserBtn">查询</button>
		  
		</form>
	</div>
	
	
	<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;left: 30px; width: 110%; top: 20px;">
		<div class="btn-group" style="position: relative; top: 18%;">
		  <button type="button" class="btn btn-primary" id="addUserBtn"></span> 创建</button>
		  <button type="button" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> 删除</button>
		</div>
		<div class="btn-group" style="position: relative; top: 18%; left: 5px;">
			<button type="button" class="btn btn-default">设置显示字段</button>
			<button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown" style="height: 34px">
				<span class="caret"></span>
				<span class="sr-only">Toggle Dropdown</span>
			</button>
			<ul id="definedColumns" class="dropdown-menu" role="menu"> 
				<li><a href="javascript:void(0);"><input type="checkbox"/> 登录帐号</a></li>
				<li><a href="javascript:void(0);"><input type="checkbox"/> 用户姓名</a></li>
				<li><a href="javascript:void(0);"><input type="checkbox"/> 部门名称</a></li>
				<li><a href="javascript:void(0);"><input type="checkbox"/> 邮箱</a></li>
				<li><a href="javascript:void(0);"><input type="checkbox"/> 失效时间</a></li>
				<li><a href="javascript:void(0);"><input type="checkbox"/> 允许访问IP</a></li>
				<li><a href="javascript:void(0);"><input type="checkbox"/> 锁定状态</a></li>
				<li><a href="javascript:void(0);"><input type="checkbox"/> 创建者</a></li>
				<li><a href="javascript:void(0);"><input type="checkbox"/> 创建时间</a></li>
				<li><a href="javascript:void(0);"><input type="checkbox"/> 修改者</a></li>
				<li><a href="javascript:void(0);"><input type="checkbox"/> 修改时间</a></li>
			</ul>
		</div>
	</div>
	
	<div style="position: relative; left: 30px; top: 40px; width: 110%">
		<table class="table table-hover">
			<thead>
				<tr style="color: #B3B3B3;">
					<td><input type="checkbox" id="checkAllUser"/></td>
					<td>序号</td>
					<td>登录帐号</td>
					<td>用户姓名</td>
					<td>部门名称</td>
					<td>邮箱</td>
					<td>失效时间</td>
					<td>允许访问IP</td>
					<td>锁定状态</td>
					<td>创建者</td>
					<td>创建时间</td>
					<td>修改者</td>
					<td>修改时间</td>
				</tr>
			</thead>
			<tbody id="tBody">
<%--			<c:forEach items="${userList}" var="users">--%>
<%--				<tr class="active">--%>
<%--					<td><input type="checkbox" /></td>--%>
<%--					<td>${users.id}</td>--%>
<%--					<td><a  href="settings/qx/user/detail.do">${users.loginAct}</a></td>--%>
<%--					<td>${users.name}</td>--%>
<%--					<td>${users.deptno}</td>--%>
<%--					<td>${users.email}</td>--%>
<%--					<td>${users.expireTime}</td>--%>
<%--					<td>${users.allowIps}</td>--%>
<%--					<td><a href="javascript:void(0);" onclick="window.confirm('您确定要锁定该用户吗？');" style="text-decoration: none;">启用</a></td>--%>
<%--					<td>${users.createBy}</td>--%>
<%--					<td>${users.createtime}</td>--%>
<%--					<td>${users.editBy}</td>--%>
<%--					<td>${users.editTime}</td>--%>
<%--				</tr>--%>
<%--			</c:forEach>--%>
			</tbody>
		</table>
		<div id="user_pag"></div>
	</div>
	
<%--	<div style="height: 50px; position: relative;top: 30px; left: 30px;">--%>
<%--		<div>--%>
<%--			<button type="button" class="btn btn-default" style="cursor: default;">共<b id="totalRowsB">50</b>条记录</button>--%>
<%--		</div>--%>
<%--		<div class="btn-group" style="position: relative;top: -34px; left: 110px;">--%>
<%--			<button type="button" class="btn btn-default" style="cursor: default;">显示</button>--%>
<%--			<div class="btn-group">--%>
<%--				<button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown">--%>
<%--					10--%>
<%--					<span class="caret"></span>--%>
<%--				</button>--%>
<%--				<ul class="dropdown-menu" role="menu">--%>
<%--					<li><a href="#">20</a></li>--%>
<%--					<li><a href="#">30</a></li>--%>
<%--				</ul>--%>
<%--			</div>--%>
<%--			<button type="button" class="btn btn-default" style="cursor: default;">条/页</button>--%>
<%--		</div>--%>
<%--		<div style="position: relative;top: -88px; left: 285px;">--%>
<%--			<nav>--%>
<%--				<ul class="pagination">--%>
<%--					<li class="disabled"><a href="#">首页</a></li>--%>
<%--					<li class="disabled"><a href="#">上一页</a></li>--%>
<%--					<li class="active"><a href="#">1</a></li>--%>
<%--					<li><a href="#">2</a></li>--%>
<%--					<li><a href="#">3</a></li>--%>
<%--					<li><a href="#">4</a></li>--%>
<%--					<li><a href="#">5</a></li>--%>
<%--					<li><a href="#">下一页</a></li>--%>
<%--					<li class="disabled"><a href="#">末页</a></li>--%>
<%--				</ul>--%>
<%--			</nav>--%>
<%--		</div>--%>
<%--	</div>--%>
			
</body>
</html>