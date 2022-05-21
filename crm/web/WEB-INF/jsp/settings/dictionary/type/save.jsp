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
			$("#create-code").blur(function (){
				$.ajax({
					url:"settings/dictionary/type/verify.do",
					data:{"code":$("#create-code").val()
					},
					type: "post",
					datatype: "json",
					success:function (data) {
						if(data.message=="√"){
							$("#codeInfo").css("color","green");
						}
						else{
							$("#codeInfo").css("color","red");
						}
						$("#codeInfo").html(data.message);
						$("#codeInfo").val(data.message);
					}
				});
			})
			$("#saveTypeBtn").click(function (){
				let code = $.trim($("#create-code").val());
				let name = $.trim($("#create-name").val());
				let description = $.trim($("#create-description").val());
				let verify = $("#codeInfo").val();
				alert(verify);
				if(code==""){
					alert("编码不能为空！");
					return;
				}
				if(verify!=""&&verify!="√"){
					alert(verify);
					return;
				}
					$.ajax({
						url:'settings/dictionary/type/addType.do',
						data:{
							code:code,
							name:name,
							description:description
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
		<h3>新增字典类型</h3>
	  	<div style="position: relative; top: -40px; left: 70%;">
			<button type="button" class="btn btn-primary" id="saveTypeBtn">保存</button>
			<button type="button" class="btn btn-default" onclick="window.history.back();">取消</button>
		</div>
		<hr style="position: relative; top: -40px;">
	</div>
	<form class="form-horizontal" role="form">
					
		<div class="form-group">
			<label for="create-code" class="col-sm-2 control-label">编码<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-code" style="width: 200%;">

			</div>
			<span style="position: relative; left: 270px; height: 34px; top: 8px; font-size: 14px;" id="codeInfo"></span>
		</div>
		
		<div class="form-group">
			<label for="create-name" class="col-sm-2 control-label">名称</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-name" style="width: 200%;">
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-description" class="col-sm-2 control-label">描述</label>
			<div class="col-sm-10" style="width: 300px;">
				<textarea class="form-control" rows="3" id="create-description" style="width: 200%;"></textarea>
			</div>
		</div>
	</form>
	
	<div style="height: 200px;"></div>
</body>
</html>