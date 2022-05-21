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
		//阻止BootStrap框架默认回车键刷新表单，导致模态窗口关闭，页面内容消失的问题
		$(document).keydown(function(event){
			if (event.keyCode == 13) {
				$('.modal-content').each(function() {
					event.preventDefault();
				});
			}
		});
		//阶段选择后自动填写可能性
		$("#create-stage").change(function (){
			let stageValue = $("#create-stage option:selected").text();
			if(stageValue==''){
				$("#create-possibility").val("");
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
					$("#create-possibility").val(data+'%');
				}
			})
		})

		$("#create-customerName").change(function (){
			let customerName = $("#create-customerName").val();

			$("#create-name").val(customerName+"-");
		});

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

			$("#create-activityId").val(activityId);
			$("#create-activityName").val(activityName);
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

			$("#create-contactId").val(contactId);
			$("#create-contactsName").val(fullname);
			$("#findContacts").modal("hide");
		});

		//自动补充客户名称
		//当容器加载完成之后，对容器调用工具函数
		$("#create-customerName").typeahead({
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
			clearBtn:true// 设置是否显示"清空"按钮 默认false
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

		//给“保存交易”按钮添加单击事件
		$("#saveTranBtn").click(function (){
			//获取参数
			let owner = $("#create-owner").val();
			let money = $.trim($("#create-money").val());
			let expectedDate = $("#create-expectedDate").val();
			let customerName = $("#create-customerName").val();
			let name = $("#create-name").val();
			let stage = $("#create-stage").val();
			let type = $("#create-type").val();
			let source = $("#create-source").val();
			let activityId = $("#create-activityId").val();
			let contactId = $("#create-contactId").val();
			let description = $.trim($("#create-description").val());
			let contactSummary = $.trim($("#create-contactSummary").val());
			let nextContactTime = $("#create-nextContactTime").val();

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
				url:'workbench/transaction/saveTransaction.do',
				data:{
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
						self.location=document.referrer;
					}else {
						alert(data.message);
					}
				}
			})
		});

		//给“取消”按钮添加单击事件
		$("#cancelBtn").click(function (){
			window.history.back();
		});
	});
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
		<h3>创建交易</h3>
	  	<div style="position: relative; top: -40px; left: 70%;">
			<button type="button" class="btn btn-primary" id="saveTranBtn">保存</button>
			<button type="button" class="btn btn-default" id="cancelBtn">取消</button>
		</div>
		<hr style="position: relative; top: -40px;">
	</div>
	<form class="form-horizontal" role="form" style="position: relative; top: -30px;">
		<div class="form-group">
			<label for="create-owner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="create-owner">
					<option value="none" selected disabled hidden>请选择选项</option>
				 <c:forEach items="${userList}" var="ul">
					 <option value="${ul.id}">${ul.name}</option>
				 </c:forEach>
				</select>
			</div>
			<label for="create-money" class="col-sm-2 control-label">金额</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-money">
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-customerName" class="col-sm-2 control-label">客户名称<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="hidden" id="create-customerId">
				<input type="text" class="form-control" id="create-customerName" placeholder="支持自动补全，输入客户不存在则新建">
			</div>
			<label for="create-expectedDate" class="col-sm-2 control-label">预计成交日期<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control myDate" id="create-expectedDate" readonly>
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-name" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-name">
			</div>
			<label for="create-stage" class="col-sm-2 control-label">阶段<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
			  <select class="form-control" id="create-stage">
				  <option value="none" selected disabled hidden>请选择选项</option>
			  	<c:forEach items="${stageList}" var="stl">
					<option value="${stl.id}">${stl.value}</option>
				</c:forEach>
			  </select>
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-type" class="col-sm-2 control-label">类型</label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="create-type">
				  <option></option>
				  <c:forEach items="${typeList}" var="tl">
					  <option value="${tl.id}">${tl.value}</option>
				  </c:forEach>
				</select>
			</div>
			<label for="create-possibility" class="col-sm-2 control-label">可能性</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-possibility" readonly>
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-source" class="col-sm-2 control-label">来源</label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="create-source">
				  <option></option>
				 <c:forEach items="${sourceList}" var="sl">
					 <option value="${sl.id}">${sl.value}</option>
				 </c:forEach>
				</select>
			</div>
			<label for="create-activityName" class="col-sm-2 control-label">市场活动源&nbsp;&nbsp;<a href="javascript:void(0);" id="searchActivityBtn"><span class="glyphicon glyphicon-search"></span></a></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="hidden" id="create-activityId">
				<input  type="text" class="form-control" id="create-activityName" readonly>
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-contactsName" class="col-sm-2 control-label">联系人名称&nbsp;&nbsp;<a href="javascript:void(0);" id="searchContactBtn"><span class="glyphicon glyphicon-search"></span></a></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="hidden" id="create-contactId">
				<input type="text" class="form-control" id="create-contactsName" readonly>
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-description" class="col-sm-2 control-label">描述</label>
			<div class="col-sm-10" style="width: 70%;">
				<textarea class="form-control" rows="3" id="create-description"></textarea>
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-contactSummary" class="col-sm-2 control-label">联系纪要</label>
			<div class="col-sm-10" style="width: 70%;">
				<textarea class="form-control" rows="3" id="create-contactSummary"></textarea>
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control nextDate" id="create-nextContactTime" readonly>
			</div>
		</div>
		
	</form>
</body>
</html>