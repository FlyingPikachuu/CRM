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
	<!--  PAGINATION plugin -->
	<link rel="stylesheet" type="text/css" href="jquery/bs_pagination-master/css/jquery.bs_pagination.min.css">
	<script type="text/javascript" src="jquery/bs_pagination-master/js/jquery.bs_pagination.min.js"></script>
	<script type="text/javascript" src="jquery/bs_pagination-master/localization/en.js"></script>
	<script type="text/javascript">
		$(function (){
			queryDicValueForPageByCondition(1,10);

			$("#queryDicValueBtn").click(function (){
				queryDicValueForPageByCondition(1,$("#dicValue_pag").bs_pagination("getOption","rowsPerPage"));
			})
			$("#createValueBtn").click(function (){
				window.location.href='settings/dictionary/value/toSave.do';
			});
			//给'全选'复选框添加单击事件
			$("#checkAllDicValue").click(function (){
				$("#dicValueTbody input[type='checkbox']").prop("checked",this.checked);
			});
			//给列表的复选框添加单击事件 方式二 针对动态生成元素
			$("#dicValueTbody").on("click","input[type='checkbox']",function (){
				if($("#dicValueTbody input[type='checkbox']").size()==$("#dicValueTbody input[type='checkbox']:checked").size()){
					$("#checkAllDicValue").prop("checked",true);
				}
				else{
					$("#checkAllDicValue").prop("checked",false);
				}
			})

			//给修改按钮添加单击事件
			$("#editValueBtn").click(function (){
				let checkedIds=$("#dicValueTbody input[type='checkbox']:checked");
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
				window.location.href='settings/dictionary/value/toEdit.do/'+id;
			});
			//给”删除“按钮添加点击事件
			$("#deleteValueBtn").click(function (){
				//收集参数
				let checkedIds = $("#dicValueTbody input[type='checkbox']:checked");
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
						ids+="id="+this.value+"&";
					});
					//去除最后的&
					ids=ids.substr(0,ids.length-1);
					//发送请求
					alert(ids);
					$.ajax({
						url:'settings/dictionary/value/deleteValue.do',
						data:ids,
						type:'post',
						datatype: 'json',
						success:function (data){
							if(data.code=="1"){
								queryDicValueForPageByCondition($("#dicValue_pag").bs_pagination("getOption","currentPage"),$("#dicValue_pag").bs_pagination("getOption","rowsPerPage"));
							}else{
								alert(data.message);
							}
						}
					});
				}
			});
		});
		function queryDicValueForPageByCondition(pageNo,pageSize){
			let value = $.trim($("#query-value").val());
			let typeCode = $.trim($("#query-typeCode").val());

			$.ajax({
				url:'settings/dictionary/value/queryDicValueForPageByCondition.do',
				data:{
					value:value,
					typeCode:typeCode,
					pageNo:pageNo,
					pageSize:pageSize
				},
				type:'post',
				datatype:"json",
				success:function (data){
					let htmlStr="";
					$.each(data.dicValueList,function (index,value){
						htmlStr+="<tr class=\"active\">"
						htmlStr+="<td><input id=\"checkAllDicValue\" type=\"checkbox\" value='"+value.id+"' /></td>"
						htmlStr+="<td>"+(index+1)+"</td>"
						htmlStr+="<td>"+value.value+"</td>"
						htmlStr+="<td>"+value.text+"</td>"
						htmlStr+="<td>"+value.orderNo+"</td>"
						htmlStr+="<td>"+value.typeCode+"</td>"
						htmlStr+="</tr>"
					});
					$("#dicValueTbody").html(htmlStr);

					//ajax 异步刷新只刷了表单没有刷表头
					//取消全选按钮
					$("#checkAllDicValue").prop("checked",false);

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
					$("#dicValue_pag").bs_pagination({
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
							queryDicValueForPageByCondition(pageObj.currentPage,pageObj.rowsPerPage);
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
				<h3>字典值列表</h3>
			</div>
		</div>
	</div>

	<div class="btn-toolbar" role="toolbar" style="position: relative; left:30px;height: 80px;">
		<form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">

			<div class="form-group">
				<div class="input-group">
					<div class="input-group-addon">字典值</div>
					<input id="query-value" class="form-control" type="text">
				</div>
			</div>
			<div class="form-group">
				<div class="input-group">
					<div class="input-group-addon">类型编码</div>
					<select class="form-control" id="query-typeCode">
						<option></option>
						<c:forEach items="${dicTypeList}" var="dtl">
							<option value="${dtl.code}">${dtl.code}</option>
						</c:forEach>
					</select>
				</div>
			</div>
			<button type="button" class="btn btn-default" id="queryDicValueBtn">查询</button>

		</form>
	</div>
	<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;left: 30px;">
		<div class="btn-group" style="position: relative; top: 18%;">
		  <button type="button" class="btn btn-primary" id="createValueBtn"><span class="glyphicon glyphicon-plus"></span> 创建</button>
		  <button type="button" class="btn btn-default" id="editValueBtn"><span class="glyphicon glyphicon-edit"></span> 编辑</button>
		  <button type="button" class="btn btn-danger" id="deleteValueBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
		</div>
	</div>
	<div style="position: relative; left: 30px; top: 20px;">
		<table class="table table-hover">
			<thead>
				<tr style="color: #B3B3B3;">
					<td><input id="checkAllDicValue" type="checkbox" /></td>
					<td>序号</td>
					<td>字典值</td>
					<td>文本</td>
					<td>排序号</td>
					<td>字典类型编码</td>
				</tr>
			</thead>
			<tbody id="dicValueTbody">
<%--				<tr class="active">--%>
<%--					<td><input type="checkbox" /></td>--%>
<%--					<td>1</td>--%>
<%--					<td>m</td>--%>
<%--					<td>男</td>--%>
<%--					<td>1</td>--%>
<%--					<td>sex</td>--%>
<%--				</tr>--%>
<%--				<tr>--%>
<%--					<td><input type="checkbox" /></td>--%>
<%--					<td>2</td>--%>
<%--					<td>f</td>--%>
<%--					<td>女</td>--%>
<%--					<td>2</td>--%>
<%--					<td>sex</td>--%>
<%--				</tr>--%>
<%--				<tr class="active">--%>
<%--					<td><input type="checkbox" /></td>--%>
<%--					<td>3</td>--%>
<%--					<td>1</td>--%>
<%--					<td>一级部门</td>--%>
<%--					<td>1</td>--%>
<%--					<td>orgType</td>--%>
<%--				</tr>--%>
<%--				<tr>--%>
<%--					<td><input type="checkbox" /></td>--%>
<%--					<td>4</td>--%>
<%--					<td>2</td>--%>
<%--					<td>二级部门</td>--%>
<%--					<td>2</td>--%>
<%--					<td>orgType</td>--%>
<%--				</tr>--%>
<%--				<tr class="active">--%>
<%--					<td><input type="checkbox" /></td>--%>
<%--					<td>5</td>--%>
<%--					<td>3</td>--%>
<%--					<td>三级部门</td>--%>
<%--					<td>3</td>--%>
<%--					<td>orgType</td>--%>
<%--				</tr>--%>
			</tbody>
		</table>
		<div id="dicValue_pag"></div>
	</div>
	
</body>
</html>