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
			$("#edit-orderNo").blur(function (){
				$.ajax({
					url:"settings/dictionary/value/verifyValue.do",
					data:{
						"typeCode":$("#edit-typeCode").val(),
						"orderNo":$("#edit-orderNo").val()
					},
					type: "post",
					datatype: "json",
					success:function (data) {
						if(data.message=="√"){
							$("#orderNoInfo").css("color","green");
						}
						else{
							$("#orderNoInfo").css("color","red");
						}
						$("#orderNoInfo").html(data.message);
						$("#orderNoInfo").val(data.message);
					}
				});
			})
			$("#updateValueBtn").click(function (){
				let id = $("#edit-id").val();
				alert(id);
				let typeCode = $.trim($("#edit-typeCode").val());
				let value= $.trim($("#edit-value").val());
				let text = $.trim($("#edit-text").val());
				let orderNo = $.trim($("#edit-orderNo").val());
				let verify = $("#orderNoInfo").val();
				alert(verify);
				if(verify!=""&&verify!="√"){
					alert(verify);
					return;
				}
				if(typeCode==""){
					alert("字典类型不为空");
					return;
				}
				if(value==""){
					alert("字典值不为空！");
					return;
				}
				$.ajax({
					url:'settings/dictionary/value/editValue.do',
					data:{
						id : id,
						typeCode :typeCode,
						value:value,
						text:text,
						orderNo:orderNo
					},
					type:"post",
					datatype:"json",
					success:function (data){
						if(data.code=="1"){
							window.history.back();
							// self.location = document.referrer;
						}else{
							alert(data.message);
						}
					}
				});

			});
		});
	</script>
</head>
<body>

	<div style="position:  relative; left: 30px;">
		<h3>修改字典值</h3>
	  	<div style="position: relative; top: -40px; left: 70%;">
			<button type="button" class="btn btn-primary" id="updateValueBtn">更新</button>
			<button type="button" class="btn btn-default" onclick="window.history.back();">取消</button>
		</div>
		<hr style="position: relative; top: -40px;">
	</div>
	<form class="form-horizontal" role="form">
		<input type="hidden" id="edit-id" value="${dv.id}">
		<div class="form-group">
			<label for="edit-typeCode" class="col-sm-2 control-label">字典类型编码</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="edit-typeCode" style="width: 200%;" value="${dv.typeCode}" readonly>
			</div>
		</div>
		
		<div class="form-group">
			<label for="edit-value" class="col-sm-2 control-label">字典值<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="edit-value" style="width: 200%;" value="${dv.value}">
			</div>
		</div>
		
		<div class="form-group">
			<label for="edit-text" class="col-sm-2 control-label">文本</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="edit-text" style="width: 200%;" value="${dv.text}">
			</div>
		</div>
		
		<div class="form-group">
			<label for="edit-orderNo" class="col-sm-2 control-label">排序号</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="edit-orderNo" style="width: 200%;" value="${dv.orderNo}">
			</div>
			<span style="position: relative; left: 270px; height: 34px; top: 8px; font-size: 14px;" id="orderNoInfo"></span>
		</div>
	</form>
	
	<div style="height: 200px;"></div>
</body>
</html>