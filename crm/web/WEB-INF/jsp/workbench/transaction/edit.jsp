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
<link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />

<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
	<!--TYPEAHEAD-->
	<script type="text/javascript" src="jquery/bs_typeahead/bootstrap3-typeahead.min.js"></script>
<script type="text/javascript">
	$(function (){
		$("#edit-customerName").change(function (){
			let customerName = $("#edit-customerName").val();
			$("#edit-name").val(customerName+"-");
		});
		//阻止BootStrap框架默认回车键刷新表单，导致模态窗口关闭，页面内容消失的问题
		$(document).keydown(function(event){
			if (event.keyCode == 13) {
				$('.modal-content').each(function() {
					event.preventDefault();
				});
			}
		});
		//将要修改的交易信息放到文本框里


		//阶段选择后自动填写可能性
		$("#edit-stage").change(function (){
			let stageValue = $("#edit-stage option:selected").text();
			if(stageValue==''){
				$("#edit-possibility").val("");
				return;
			}
			$.ajax({
				url:'workbench/transaction/getPossibilityByStage.do',
				data:{
					stageValue:stageValue
				},
				type:"post",
				datatype:"json",
				success:function (data){
					$("#edit-possibility").val(data+'%');
				}
			})
		})

		//市场活动源搜索添加单击事件
		$("#searchActivityBtn").click(function (){

			//清空搜索框
			$("#searchActivityTxt").val("");

			//清空列表
			$("#activityTbody").html("");

			$("#findMarketActivity").modal("show");
		});
		//给市场活动模态窗口输入框添加键盘弹起事件
		$("#searchActivityTxt").keyup(function (){
			let name = this.value;
			$.ajax({
				url:"workbench/transaction/queryActivity.do",
				data:{
					name:name
				},
				type:'post',
				datatype:"json",
				success:function (data){
					let htmlStr='';
					$.each(data,function (index,al){
						htmlStr+="<tr>"
						htmlStr+="<td><input type=\"radio\" value='"+al.id+"' activityName=\""+al.name+"\" name=\"activity\"/></td>"
						htmlStr+="<td>"+al.name+"</td>"
						htmlStr+="<td>"+al.startDate+"</td>"
						htmlStr+="<td>"+al.endDate+"</td>"
						htmlStr+="<td>"+al.owner+"</td>"
						htmlStr+="</tr>"
					})
					$("#activityTbody").html(htmlStr);
				}
			});
		});
		//给选择市场活动单选框添加单击事件
		$("#activityTbody").on("click","input[name='activity']",function (){
			//获取参数
			let activityId = $(this).val();
			let activityName = $(this).attr("activityName");

			$("#edit-activityId").val(activityId);
			$("#edit-activityName").val(activityName);
			$("#findMarketActivity").modal("hide");

		});

		//给联系人搜索添加单击事件
		$("#searchContactBtn").click(function (){
			$("#searchContactTxt").val("");
			$("#contactTbody").html("");
			$("#findContacts").modal("show");
		});
		//给联系人模态窗口输入框添加键盘弹起事件
		$("#searchContactTxt").keyup(function (){
			let fullname = this.value;
			$.ajax({
				url:'workbench/transaction/queryContact.do',
				data:{
					fullname:fullname
				},
				type:'post',
				datatype:'json',
				success:function (data){
					let htmlStr="";
					$.each(data,function (index,cot){
						htmlStr+="<tr>"
						htmlStr+="<td><input type=\"radio\" value=\""+cot.id+"\" contactFullname=\""+cot.fullname+"\" name=\"contact\"/></td>"
						htmlStr+="<td>"+cot.fullname+"</td>"
						htmlStr+="<td>"+cot.email+"</td>"
						htmlStr+="<td>"+cot.mphone+"</td>"
						htmlStr+="</tr>"
					});
					$("#contactTbody").html(htmlStr);
				}
			});
		});
		//给选择联系人单选框添加单击事件
		$("#contactTbody").on("click","input[name='contact']",function (){
			let contactId = this.value;
			let fullname = $(this).attr("contactFullname");

			$("#edit-contactId").val(contactId);
			$("#edit-contactName").val(fullname);
			$("#findContacts").modal("hide");
		});

		//自动补充客户名称
		//当容器加载完成之后，对容器调用工具函数
		$("#edit-customerName").typeahead({
			source:function (jquery,process) {//每次键盘弹起，都自动触发本函数；我们可以向后台送请求，查询客户表中所有的名称，把客户名称以[]字符串形式返回前台，赋值给source
				//process：是个函数，能够将['xxx','xxxxx','xxxxxx',.....]字符串赋值给source，从而完成自动补全
				//jquery：在容器中输入的关键字
				//var customerName=$("#customerName").val();
				//发送查询请求
				$.ajax({
					url:'workbench/transaction/queryCustomerNameByName.do',
					data:{
						customerName:jquery
					},
					type:'post',
					dataType:'json',
					success:function (data) {//['xxx','xxxxx','xxxxxx',.....]
						process(data);
					}
				});
			}
		});

		//日历插件
		$(".myDate").datetimepicker({
			language:'zh-CN',//语言类型
			format:'yyyy-mm-dd',//日期格式
			minView:'month',//显示的最小时间
			initialDate:new Date(),//初始时间
			autoclose:true,//设置完时间后是否自动关闭
			todayBtn:true,//设置是否显示"今天"按钮，默认false
			clearBtn:true,// 设置是否显示"清空"按钮 默认false

		});
		$(".nextDate").datetimepicker({
			language:'zh-CN',//语言类型
			format:'yyyy-mm-dd',//日期格式
			minView:'month',//显示的最小时间
			initialDate:new Date(),//初始时间
			autoclose:true,//设置完时间后是否自动关闭
			todayBtn:true,//设置是否显示"今天"按钮，默认false
			clearBtn:true,// 设置是否显示"清空"按钮 默认false
			pickerPosition:'top-right'
		});

		//给“保存修改”按钮添加单击事件
		$("#saveEditBtn").click(function (){
			//获取参数
			let id = '${tran.id}';
			let owner = $("#edit-owner").val();
			let money = $.trim($("#edit-money").val());
			let expectedDate = $("#edit-expectedDate").val();
			let customerName = $("#edit-customerName").val();
			let name = $("#edit-name").val();
			let stage = $("#edit-stage").val();
			let type = $("#edit-type").val();
			let source = $("#edit-source").val();
			let activityId = $("#edit-activityId").val();
			let contactId = $("#edit-contactId").val();
			let description = $.trim($("#edit-description").val());
			let contactSummary = $.trim($("#edit-contactSummary").val());
			let nextContactTime = $("#edit-nextContactTime").val();

			let regExp= /^(([1-9]\d*)|0)$/;
			if(!regExp.test(money)&&money!=''){
				alert("金额只能是非负整数！");
				return;
			}
			if(name==''){
				alert("交易名称不能为空！")
				return;
			}
			if(customerName==''){
				alert("客户名称不为空！");
				return;
			}
			if(expectedDate==''){
				alert("预计成交日期不为空！");
				return;
			}
			if(stage==''){
				alert("阶段不为空！")
				return;
			}
			$.ajax({
				url:'workbench/transaction/editTran.do',
				data:{
					id : id,
					owner : owner,
					money : money,
					name : name,
					expectedDate : expectedDate,
					customerName : customerName,
					stage : stage,
					type :type ,
					source : source,
					activityId : activityId,
					contactId : contactId,
					description : description,
					contactSummary : contactSummary,
					nextContactTime : nextContactTime
				},
				type:"post",
				datatype:'json',
				success:function (data){
					if(data.code=="1"){
						window.location.href='workbench/transaction/index.do';
					}else {
						alert(data.message);
					}
				}
			})
		});

		//给“取消”按钮添加单击事件
		$("#cancelBtn").click(function (){
			window.location.href='workbench/transaction/index.do';
		});


	});
	function queryTranById(){
		$.ajax({
			url:'workbench/transaction/queryTranById.do',
			data:{
				id:id
			}
		});
	};
</script>
</head>
<body>

	<!-- 查找市场活动 -->	
	<div class="modal fade" id="findMarketActivity" role="dialog">
		<div class="modal-dialog" role="document" style="width: 80%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">查找市场活动</h4>
				</div>
				<div class="modal-body">
					<div class="btn-group" style="position: relative; top: 18%; left: 8px;">
						<form class="form-inline" role="form">
						  <div class="form-group has-feedback">
						    <input id="searchActivityTxt" type="text" class="form-control" style="width: 300px;" placeholder="请输入市场活动名称，支持模糊查询">
						    <span class="glyphicon glyphicon-search form-control-feedback"></span>
						  </div>
						</form>
					</div>
					<table id="activityTable3" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
						<thead>
							<tr style="color: #B3B3B3;">
								<td></td>
								<td>名称</td>
								<td>开始日期</td>
								<td>结束日期</td>
								<td>所有者</td>
							</tr>
						</thead>
						<tbody id="activityTbody">
<%--							<tr>--%>
<%--								<td><input type="radio" name="activity"/></td>--%>
<%--								<td>发传单</td>--%>
<%--								<td>2020-10-10</td>--%>
<%--								<td>2020-10-20</td>--%>
<%--								<td>zhangsan</td>--%>
<%--							</tr>--%>
<%--							<tr>--%>
<%--								<td><input type="radio" name="activity"/></td>--%>
<%--								<td>发传单</td>--%>
<%--								<td>2020-10-10</td>--%>
<%--								<td>2020-10-20</td>--%>
<%--								<td>zhangsan</td>--%>
<%--							</tr>--%>
						</tbody>
					</table>
				</div>
			</div>
		</div>
	</div>

	<!-- 查找联系人 -->	
	<div class="modal fade" id="findContacts" role="dialog">
		<div class="modal-dialog" role="document" style="width: 80%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">查找联系人</h4>
				</div>
				<div class="modal-body">
					<div class="btn-group" style="position: relative; top: 18%; left: 8px;">
						<form class="form-inline" role="form">
						  <div class="form-group has-feedback">
						    <input id="searchContactTxt" type="text" class="form-control" style="width: 300px;" placeholder="请输入联系人名称，支持模糊查询">
						    <span class="glyphicon glyphicon-search form-control-feedback"></span>
						  </div>
						</form>
					</div>
					<table id="activityTable" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
						<thead>
							<tr style="color: #B3B3B3;">
								<td></td>
								<td>名称</td>
								<td>邮箱</td>
								<td>手机</td>
							</tr>
						</thead>
						<tbody id="contactTbody">
<%--							<tr>--%>
<%--								<td><input type="radio" name="activity"/></td>--%>
<%--								<td>李四</td>--%>
<%--								<td>lisi@bjpowernode.com</td>--%>
<%--								<td>12345678901</td>--%>
<%--							</tr>--%>
<%--							<tr>--%>
<%--								<td><input type="radio" name="activity"/></td>--%>
<%--								<td>李四</td>--%>
<%--								<td>lisi@bjpowernode.com</td>--%>
<%--								<td>12345678901</td>--%>
<%--							</tr>--%>
						</tbody>
					</table>
				</div>
			</div>
		</div>
	</div>
	
	
	<div style="position:  relative; left: 30px;">
		<h3>修改交易</h3>
	  	<div style="position: relative; top: -40px; left: 70%;">
			<button type="button" class="btn btn-primary" id="saveEditBtn">保存</button>
			<button type="button" class="btn btn-default" id="cancelBtn">取消</button>
		</div>
		<hr style="position: relative; top: -40px;">
	</div>
	<form id="editForm" class="form-horizontal" role="form" style="position: relative; top: -30px;">
		<div class="form-group">
			<label for="edit-owner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="edit-owner">
					<c:forEach items="${userList}" var="ul">
						<c:if test="${tran.owner==ul.id}">
							<option value="${ul.id}" selected>${ul.name}</option>
						</c:if>
						<c:if test="${tran.owner!=ul.id}">
							<option value="${ul.id}">${ul.name}</option>
						</c:if>
					</c:forEach>
				</select>
			</div>
			<label for="edit-money" class="col-sm-2 control-label">金额</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="edit-money" value="${tran.money}">
			</div>
		</div>
		
		<div class="form-group">
			<label for="edit-customerName" class="col-sm-2 control-label">客户名称<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input value="${tran.customerId}" type="text" class="form-control" id="edit-customerName" placeholder="支持自动补全，输入客户不存在则新建">
			</div>
			<label for="edit-expectedDate" class="col-sm-2 control-label">预计成交日期<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control myDate" id="edit-expectedDate" value="${tran.expectedDate}">
			</div>
		</div>
		
		<div class="form-group">
			<label for="edit-name" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="edit-name" value="${tran.name}">
			</div>
			<label for="edit-stage" class="col-sm-2 control-label">阶段<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
			  <select class="form-control" id="edit-stage">
				  <c:forEach items="${stageList}" var="stl">
					  <c:if test="${tran.stage==stl.id}">
						  <option value="${stl.id}" selected>${stl.value}</option>
					  </c:if>
					  <c:if test="${tran.stage!=stl.id}">
						  <option value="${stl.id}">${stl.value}</option>
					  </c:if>

				  </c:forEach>
			  </select>
			</div>
		</div>
		
		<div class="form-group">
			<label for="edit-type" class="col-sm-2 control-label">类型</label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="edit-type">
				  <option></option>
					<c:forEach items="${typeList}" var="tl">
						<c:if test="${tran.type==tl.id}">
							<option value="${tl.id}" selected>${tl.value}</option>
						</c:if>
						<c:if test="${tran.type!=tl.id}">
							<option value="${tl.id}">${tl.value}</option>
						</c:if>
					</c:forEach>
				</select>
			</div>
			<label for="edit-possibility" class="col-sm-2 control-label">可能性</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="edit-possibility" value="${tran.possibility}%" readonly>
			</div>
		</div>
		
		<div class="form-group">
			<label for="edit-source" class="col-sm-2 control-label">来源</label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="edit-source">
				  <option></option>
					<c:forEach items="${sourceList}" var="sl">
						<c:if test="${tran.source==sl.id}">
							<option value="${sl.id}" selected>${sl.value}</option>
						</c:if>
						<c:if test="${tran.source!=sl.id}">
							<option value="${sl.id}">${sl.value}</option>
						</c:if>
					</c:forEach>
				</select>
			</div>
			<label for="edit-activityName" class="col-sm-2 control-label">市场活动源&nbsp;&nbsp;<a href="javascript:void(0);" id="searchActivityBtn"><span class="glyphicon glyphicon-search"></span></a></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="hidden" id="edit-activityId" value="${tran.activityId}">
				<input type="text" class="form-control" id="edit-activityName" value="${tran.activityName}" readonly>
			</div>
		</div>
		
		<div class="form-group">
			<label for="edit-contactName" class="col-sm-2 control-label">联系人名称&nbsp;&nbsp;<a href="javascript:void(0);" id="searchContactBtn"><span class="glyphicon glyphicon-search"></span></a></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="hidden" id="edit-contactId" value="${tran.contactId}" }>
				<input type="text" class="form-control" id="edit-contactName" value="${tran.contactName}" readonly>
			</div>
		</div>
		
		<div class="form-group">
			<label for="edit-description" class="col-sm-2 control-label">描述</label>
			<div class="col-sm-10" style="width: 70%;">
				<textarea class="form-control" rows="3" id="edit-description">${tran.description}</textarea>
			</div>
		</div>
		
		<div class="form-group">
			<label for="edit-contactSummary" class="col-sm-2 control-label">联系纪要</label>
			<div class="col-sm-10" style="width: 70%;">
				<textarea class="form-control" rows="3" id="edit-contactSummary">${tran.contactSummary}</textarea>
			</div>
		</div>
		
		<div class="form-group">
			<label for="edit-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control nextDate" id="edit-nextContactTime" value="${tran.nextContactTime}" readonly>
			</div>
		</div>
		
	</form>
</body>
</html>