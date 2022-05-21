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
	<!--  PAGINATION plugin -->
	<link rel="stylesheet" type="text/css" href="jquery/bs_pagination-master/css/jquery.bs_pagination.min.css">
	<script type="text/javascript" src="jquery/bs_pagination-master/js/jquery.bs_pagination.min.js"></script>
	<script type="text/javascript" src="jquery/bs_pagination-master/localization/en.js"></script>
	<script type="text/javascript">
		$(function (){
				queryDicTypeForPageByCondition(1,10);

				$("#queryDicTypeBtn").click(function (){
					queryDicTypeForPageByCondition(1,$("#dicType_pag").bs_pagination("getOption","rowsPerPage"));
				})

			$("#createTypeBtn").click(function (){
				window.location.href='settings/dictionary/type/toSave.do';
			});
			//给'全选'复选框添加单击事件
			$("#checkAllDicType").click(function (){
				$("#dicTypeTbody input[type='checkbox']").prop("checked",this.checked);
			});
			//给列表的复选框添加单击事件 方式二 针对动态生成元素
			$("#dicTypeTbody").on("click","input[type='checkbox']",function (){
				if($("#dicTypeTbody input[type='checkbox']").size()==$("#dicTypeTbody input[type='checkbox']:checked").size()){
					$("#checkAllDicType").prop("checked",true);
				}
				else{
					$("#checkAllDicType").prop("checked",false);
				}
			})

			//给修改按钮添加单击事件
			$("#editTypeBtn").click(function (){
				let checkedIds=$("#dicTypeTbody input[type='checkbox']:checked");
				if(checkedIds.size()==0){
					alert("请选择要修改的字典类型");
					return;
				}
				if(checkedIds.size()>1){
					alert("每次只能修改一条字典类型");
					return;
				}
				// 取dom对象属性值三种方法
				// let id=checkedIds.val();
				// let id=checkedIds.get(0).value;
				let id=checkedIds[0].value;
				alert(id);
				window.location.href='settings/dictionary/type/toEdit.do/'+id;
			});
			//给”删除“按钮添加点击事件
			$("#deleteTypeBtn").click(function (){
				//收集参数
				let checkedIds = $("#dicTypeTbody input[type='checkbox']:checked");
				if(checkedIds.size()==0){
					alert("请选择要删除的字典类型");
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
						url:'settings/dictionary/type/deleteType.do',
						data:ids,
						type:'post',
						datatype: 'json',
						success:function (data){
							if(data.code=="1"){
								queryDicTypeForPageByCondition($("#dicType_pag").bs_pagination("getOption","currentPage"),$("#dicType_pag").bs_pagination("getOption","rowsPerPage"));
							}else{
								alert(data.message);
							}
						}
					});
				}
			});
		});
		function queryDicTypeForPageByCondition(pageNo,pageSize){
			let code = $.trim($("#query-code").val());
			let name = $.trim($("#query-name").val());

			$.ajax({
				url:'settings/dictionary/type/queryDicTypeForPageByCondition.do',
				data:{
					code:code,
					name:name,
					pageNo:pageNo,
					pageSize:pageSize
				},
				type:'post',
				datatype:"json",
				success:function (data){
					let htmlStr="";
					$.each(data.dicTypeList,function (index,type){
						htmlStr+="<tr class=\"active\">"
						htmlStr+="<td><input id=\"checkAllDicType\" type=\"checkbox\" value='"+type.code+"'/></td>"
						htmlStr+="<td>"+(index+1)+"</td>"
						htmlStr+="<td>"+type.code+"</td>"
						htmlStr+="<td>"+type.name+"</td>"
						htmlStr+="<td>"+type.description+"</td>"
						htmlStr+="</tr>"
					});
					$("#dicTypeTbody").html(htmlStr);

					//ajax 异步刷新只刷了表单没有刷表头
					//取消全选按钮
					$("#checkAllDicType").prop("checked",false);

					//计算totalPages
					let totalPages=1;
					if(data.totalRows%pageSize==0){
						totalPages=data.totalRows/pageSize;
					}
					else{
						totalPages=parseInt(data.totalRows/pageSize)+1;
					}


					//函数位置选择，执行函数需要保证已查到totalRows
					//对容器调用bs_pagination分页工具函数，显示翻页信息
					$("#dicType_pag").bs_pagination({
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
							queryDicTypeForPageByCondition(pageObj.currentPage,pageObj.rowsPerPage);
						}
					});
				}
			});
		};
	</script>
</head>
<body>

	<div>
		<div style="position: relative; left: 30px; top: -10px;">
			<div class="page-header">
				<h3>字典类型列表</h3>
			</div>
		</div>
	</div>
	<div class="btn-toolbar" role="toolbar" style="height: 80px;">
		<form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">

			<div class="form-group">
				<div class="input-group">
					<div class="input-group-addon">编码</div>
					<input id="query-code" class="form-control" type="text">
				</div>
			</div>
			<div class="form-group">
				<div class="input-group">
					<div class="input-group-addon">名称</div>
					<input id="query-name" class="form-control" type="text">
				</div>
			</div>
			<button type="button" class="btn btn-default" id="queryDicTypeBtn">查询</button>

		</form>
	</div>
	<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;left: 30px;">
		<div class="btn-group" style="position: relative; top: 18%;">
		  <button type="button" class="btn btn-primary" id="createTypeBtn"><span class="glyphicon glyphicon-plus"></span> 创建</button>
		  <button type="button" class="btn btn-default" id="editTypeBtn"><span class="glyphicon glyphicon-edit"></span> 编辑</button>
		  <button type="button" class="btn btn-danger" id="deleteTypeBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
		</div>
	</div>
	<div style="position: relative; left: 30px; top: 20px;">
		<table class="table table-hover">
			<thead>
				<tr style="color: #B3B3B3;">
					<td><input id="checkAllDicType" type="checkbox" /></td>
					<td>序号</td>
					<td>编码</td>
					<td>名称</td>
					<td>描述</td>
				</tr>
			</thead>
			<tbody id="dicTypeTbody">
<%--				<tr class="active">--%>
<%--					<td><input type="checkbox" /></td>--%>
<%--					<td>1</td>--%>
<%--					<td>sex</td>--%>
<%--					<td>性别</td>--%>
<%--					<td>性别包括男和女</td>--%>
<%--				</tr>--%>
			</tbody>
		</table>
		<div id="dicType_pag"></div>
	</div>
	
</body>
</html>