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

	$(function(){
		showBtn();
		$("#createTranBtn").click(function (){
			window.location.href='workbench/transaction/toSave.do';
		});
		//当交易主页面加载完成之后,显示所有数据的第一页，默认pageSize=10
		queryTransactionByConditionForPage(1,10);

		//给"查询"按钮添加单击事件
		$("#queryTransactionBtn").click(function () {
			//查询所有符合条件数据的第一页以及所有符合条件数据的总条数;
			// 实现翻页查询每页显示条数不变
			//pagination插件 getOption 函数 获取当前客户端分页工具中用户选择的参数值
			queryTransactionByConditionForPage(1,$("#Tran_pag").bs_pagination("getOption","rowsPerPage"));
		});
		//给'全选'复选框添加单击事件
		$("#checkAllTran").click(function (){
			$("#TranTbody input[type='checkbox']").prop("checked",this.checked);
		});
		//给列表的复选框添加单击事件 方式二 针对动态生成元素
		$("#TranTbody").on("click","input[type='checkbox']",function (){
			if($("#TranTbody input[type='checkbox']").size()==$("#TranTbody input[type='checkbox']:checked").size()){
				$("#checkAllTran").prop("checked",true);
			}
			else{
				$("#checkAllTran").prop("checked",false);
			}
		})

		//给修改按钮添加单击事件
		$("#editTranBtn").click(function (){
			let checkedIds=$("#TranTbody input[type='checkbox']:checked");
			if(checkedIds.size()==0){
				alert("请选择要修改的交易");
				return;
			}
			if(checkedIds.size()>1){
				alert("每次只能修改一条交易");
				return;
			}
			// 取dom对象属性值三种方法
			// let id=checkedIds.val();
			// let id=checkedIds.get(0).value;
			let id=checkedIds[0].value;
			alert(id);
			window.location.href='workbench/transaction/toEdit.do/'+id;
		});
		//给”删除“按钮添加点击事件
		$("#tranBtnBox").on('click','#deleteTranBtn',function (){
			//收集参数
			let checkedIds = $("#TranTbody input[type='checkbox']:checked");
			if(checkedIds.size()==0){
				alert("请选择要删除的交易");
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
					ids+="ids="+this.value+"&";
				});
				//去除最后的&
				ids=ids.substr(0,ids.length-1);
				//发送请求
				alert(ids);
				$.ajax({
					url:'workbench/transaction/deleteTranByIds.do',
					data:ids,
					type:'post',
					datatype: 'json',
					success:function (data){
						if(data.code=="1"){
							queryTransactionByConditionForPage($("#Tran_pag").bs_pagination("getOption","currentPage"),$("#Tran_pag").bs_pagination("getOption","rowsPerPage"));
						}else{
							alert(data.message);
						}
					}
				});
			}
		});
	});

	function queryTransactionByConditionForPage(pageNo,pageSize){
		//获取参数
		let owner = $("#query-owner").val();
		let name = $("#query-name").val();
		let customer = $("#query-customer").val();
		let stage = $("#query-stage").val();
		let type = $("#query-type").val();
		let source = $("#query-source").val();
		let contact = $("#query-contact").val();

		$.ajax({
			url:'workbench/transaction/queryTransactionByConditionForPage.do',
			data:{
				owner:owner,
				name:name,
				customer:customer,
				stage:stage,
				type:type,
				source:source,
				contact:contact,
				pageNo:pageNo,
				pageSize:pageSize
			},
			type:"post",
			datatype:"json",
			success:function (data){
				let htmlStr="";
				$.each(data.tList,function (index,tran){
					htmlStr+="<tr>";
					htmlStr+="<td><input type=\"checkbox\" value=\""+tran.id+"\"/></td>";
					htmlStr+="<td><a style=\"text-decoration: none; cursor: pointer;\" onclick=\"window.location.href='workbench/transaction/queryTransactionForDetailById.do/"+tran.id+"';\">"+tran.name+"</a></td>";
					htmlStr+="<td>"+tran.customerId+"</td>";
					htmlStr+="<td>"+tran.stage+"</td>";
					htmlStr+="<td>"+tran.type+"</td>";
					htmlStr+="<td>"+tran.owner+"</td>";
					htmlStr+="<td>"+tran.source+"</td>";
					htmlStr+="<td>"+tran.contactId+"</td>";
					htmlStr+="</tr>";
				});
				$("#TranTbody").html(htmlStr);

				//ajax 异步刷新只刷了表单没有刷表头
				//取消全选按钮
				$("#checkAllTran").prop("checked",false);

				//计算totalPages
				let totalPages=1;
				if(data.totalRows%pageSize==0){
					totalPages=data.totalRows/pageSize;
				}else{
					totalPages=parseInt(data.totalRows/pageSize)+1;
				}


				//函数位置选择，执行函数需要保证已查到totalRows
				//对容器调用bs_pagination分页工具函数，显示翻页信息
				$("#Tran_pag").bs_pagination({
					currentPage:pageNo,//当前页号,默认1相当于pageNo

					rowsPerPage:pageSize,//每页显示条数,默认10,相当于pageSize m
					totalRows:data.totalRows,//总条数 默认1000
					totalPages: totalPages,  //总页数,必填参数.

					visiblePageLinks:5,//最多可以显示的翻页卡片数

					showGoToPage:true,//是否显示"跳转到"功能,默认true--显示
					showRowsPerPage:true,//是否显示"每页显示条数"功能。默认true--显示
					showRowsInfo:true,//是否显示记录的信息，默认true--显示

					//用户每次切换页号，都自动触发本函数;
					//功能：返回每次切换页号之后的pageNo和pageSize
					onChangePage:function (event,pageObj){
						//pageObj就代表{}函数可以调用属性
						//js代码
						// alert(pageObj.currentPage);
						// alert(pageObj.rowsPerPage);
						queryTransactionByConditionForPage(pageObj.currentPage,pageObj.rowsPerPage);
					}
				});
			}
		});

	}
	function showBtn(){
		$.ajax({
			url:'workbench/showMenu.do',
			type:'post',
			datatype:'json',
			success:function (data){
				if(data.includes("删除交易")){
					let htmlStr ="";
					htmlStr="<button type=\"button\" class=\"btn btn-danger\" id=\"deleteTranBtn\"><span class=\"glyphicon glyphicon-minus\"></span> 删除</button>"
					$("#tranBtnBox").append(htmlStr);
				}
			}
		})
	}
</script>
</head>
<body>

	
	
	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>交易列表</h3>
			</div>
		</div>
	</div>
	
	<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
	
		<div style="width: 100%; position: absolute;top: 5px; left: 10px;">
		
			<div class="btn-toolbar" role="toolbar" style="height: 80px;">
				<form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">所有者</div>
				      <input id="query-owner" class="form-control" type="text">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">名称</div>
				      <input id="query-name" class="form-control" type="text">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">客户名称</div>
				      <input id="query-customer" class="form-control" type="text">
				    </div>
				  </div>
				  
				  <br>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">阶段</div>
					  <select id="query-stage" class="form-control">
					  	<option></option>
					  	<c:forEach items="${stageList}" var="stl">
							<option value="${stl.id}">${stl.value}</option>
						</c:forEach>
					  </select>
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">类型</div>
					  <select id="query-type" class="form-control">
					  	<option></option>
					  	<c:forEach items="${typeList}" var="tl">
							<option value="${tl.id}">${tl.value}</option>
						</c:forEach>
					  </select>
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">来源</div>
				      <select id="query-source" class="form-control" id="create-clueSource">
						  <option></option>
						  <c:forEach items="${sourceList}" var="sol">
							  <option value="${sol.id}">${sol.value}</option>
						  </c:forEach>
						</select>
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">联系人名称</div>
				      <input id="query-contact" class="form-control" type="text">
				    </div>
				  </div>
				  
				  <button id="queryTransactionBtn" type="button" class="btn btn-default">查询</button>
				  
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 10px;">
				<div class="btn-group" style="position: relative; top: 18%;" id="tranBtnBox">
				  <button type="button" class="btn btn-primary" id="createTranBtn"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button type="button" class="btn btn-default" id="editTranBtn" ><span class="glyphicon glyphicon-pencil"></span> 修改</button>
<%--				  <button type="button" class="btn btn-danger" id="deleteTranBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>--%>
				</div>
				
				
			</div>
			<div style="position: relative;top: 10px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input id="checkAllTran" type="checkbox" /></td>
							<td>名称</td>
							<td>客户名称</td>
							<td>阶段</td>
							<td>类型</td>
							<td>所有者</td>
							<td>来源</td>
							<td>联系人名称</td>
						</tr>
					</thead>
					<tbody id="TranTbody" >
<%--						<tr>--%>
<%--							<td><input type="checkbox" /></td>--%>
<%--							<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.html';">动力节点-交易01</a></td>--%>
<%--							<td>动力节点</td>--%>
<%--							<td>谈判/复审</td>--%>
<%--							<td>新业务</td>--%>
<%--							<td>zhangsan</td>--%>
<%--							<td>广告</td>--%>
<%--							<td>李四</td>--%>
<%--						</tr>--%>
<%--                        <tr class="active">--%>
<%--                            <td><input type="checkbox" /></td>--%>
<%--                            <td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.html';">动力节点-交易01</a></td>--%>
<%--                            <td>动力节点</td>--%>
<%--                            <td>谈判/复审</td>--%>
<%--                            <td>新业务</td>--%>
<%--                            <td>zhangsan</td>--%>
<%--                            <td>广告</td>--%>
<%--                            <td>李四</td>--%>
<%--                        </tr>--%>
					</tbody>
				</table>
				<div id="Tran_pag"></div>
			</div>
			
<%--			<div style="height: 50px; position: relative;top: 20px;">--%>
<%--&lt;%&ndash;				<div>&ndash;%&gt;--%>
<%--&lt;%&ndash;					<button type="button" class="btn btn-default" style="cursor: default;">共<b>50</b>条记录</button>&ndash;%&gt;--%>
<%--&lt;%&ndash;				</div>&ndash;%&gt;--%>
<%--&lt;%&ndash;				<div class="btn-group" style="position: relative;top: -34px; left: 110px;">&ndash;%&gt;--%>
<%--&lt;%&ndash;					<button type="button" class="btn btn-default" style="cursor: default;">显示</button>&ndash;%&gt;--%>
<%--&lt;%&ndash;					<div class="btn-group">&ndash;%&gt;--%>
<%--&lt;%&ndash;						<button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown">&ndash;%&gt;--%>
<%--&lt;%&ndash;							10&ndash;%&gt;--%>
<%--&lt;%&ndash;							<span class="caret"></span>&ndash;%&gt;--%>
<%--&lt;%&ndash;						</button>&ndash;%&gt;--%>
<%--&lt;%&ndash;						<ul class="dropdown-menu" role="menu">&ndash;%&gt;--%>
<%--&lt;%&ndash;							<li><a href="#">20</a></li>&ndash;%&gt;--%>
<%--&lt;%&ndash;							<li><a href="#">30</a></li>&ndash;%&gt;--%>
<%--&lt;%&ndash;						</ul>&ndash;%&gt;--%>
<%--&lt;%&ndash;					</div>&ndash;%&gt;--%>
<%--&lt;%&ndash;					<button type="button" class="btn btn-default" style="cursor: default;">条/页</button>&ndash;%&gt;--%>
<%--&lt;%&ndash;				</div>&ndash;%&gt;--%>
<%--&lt;%&ndash;				<div style="position: relative;top: -88px; left: 285px;">&ndash;%&gt;--%>
<%--&lt;%&ndash;					<nav>&ndash;%&gt;--%>
<%--&lt;%&ndash;						<ul class="pagination">&ndash;%&gt;--%>
<%--&lt;%&ndash;							<li class="disabled"><a href="#">首页</a></li>&ndash;%&gt;--%>
<%--&lt;%&ndash;							<li class="disabled"><a href="#">上一页</a></li>&ndash;%&gt;--%>
<%--&lt;%&ndash;							<li class="active"><a href="#">1</a></li>&ndash;%&gt;--%>
<%--&lt;%&ndash;							<li><a href="#">2</a></li>&ndash;%&gt;--%>
<%--&lt;%&ndash;							<li><a href="#">3</a></li>&ndash;%&gt;--%>
<%--&lt;%&ndash;							<li><a href="#">4</a></li>&ndash;%&gt;--%>
<%--&lt;%&ndash;							<li><a href="#">5</a></li>&ndash;%&gt;--%>
<%--&lt;%&ndash;							<li><a href="#">下一页</a></li>&ndash;%&gt;--%>
<%--&lt;%&ndash;							<li class="disabled"><a href="#">末页</a></li>&ndash;%&gt;--%>
<%--&lt;%&ndash;						</ul>&ndash;%&gt;--%>
<%--&lt;%&ndash;					</nav>&ndash;%&gt;--%>
<%--&lt;%&ndash;				</div>&ndash;%&gt;--%>
<%--			</div>--%>
<%--			--%>
		</div>
		
	</div>
</body>
</html>