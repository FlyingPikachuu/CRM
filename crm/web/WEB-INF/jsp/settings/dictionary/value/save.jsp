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
	<script type="text/javascript">
		$(function (){
			$("#create-orderNo").blur(function (){
				$.ajax({
					url:"settings/dictionary/value/verifyValue.do",
					data:{
						"typeCode":$("#create-typeCode").val(),
						"orderNo":$("#create-orderNo").val()
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
			$("#saveValueBtn").click(function (){
				let typeCode = $.trim($("#create-typeCode").val());
				let value= $.trim($("#create-value").val());
				let text = $.trim($("#create-text").val());
				let orderNo = $.trim($("#create-orderNo").val());
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
					url:'settings/dictionary/value/addValue.do',
					data:{
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
		<h3>新增字典值</h3>
	  	<div style="position: relative; top: -40px; left: 70%;">
			<button type="button" class="btn btn-primary" id="saveValueBtn">保存</button>
			<button type="button" class="btn btn-default" onclick="window.history.back();">取消</button>
		</div>
		<hr style="position: relative; top: -40px;">
	</div>
	<form class="form-horizontal" role="form">
					
		<div class="form-group">
			<label for="create-typeCode" class="col-sm-2 control-label">字典类型编码<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="create-typeCode" style="width: 200%;">
				  <option></option>
				  <c:forEach items="${dtList}" var="dtl">
					  <option value="${dtl.code}">${dtl.code}</option>
				  </c:forEach>
				</select>
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-value" class="col-sm-2 control-label">字典值<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-value" style="width: 200%;">
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-text" class="col-sm-2 control-label">文本</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-text" style="width: 200%;">
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-orderNo" class="col-sm-2 control-label">排序号</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-orderNo" style="width: 200%;">
			</div>
			<span style="position: relative; left: 270px; height: 34px; top: 8px; font-size: 14px;" id="orderNoInfo"></span>
		</div>
	</form>
	
	<div style="height: 200px;"></div>
</body>
</html>