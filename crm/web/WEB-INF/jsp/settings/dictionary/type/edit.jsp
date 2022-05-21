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
			$("#edit-code").blur(function (){
				$.ajax({
					url:"settings/dictionary/type/verifyEdit.do",
					data:{"code":$("#edit-code").val(),
					      "oldCode":'${dt.code}'       },
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
			$("#updateTypeBtn").click(function (){
				let code = $.trim($("#edit-code").val());
				let oldCode = '${dt.code}';
				let name = $.trim($("#edit-name").val());
				let description = $.trim($("#edit-description").val());
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
					url:'settings/dictionary/type/editType.do',
					data:{
						code:code,
						name:name,
						description:description,
						oldCode:oldCode
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
		<h3>修改字典类型</h3>
	  	<div style="position: relative; top: -40px; left: 70%;">
			<button type="button" class="btn btn-primary" id="updateTypeBtn">更新</button>
			<button type="button" class="btn btn-default" onclick="window.history.back();">取消</button>
		</div>
		<hr style="position: relative; top: -40px;">
	</div>
	<form class="form-horizontal" role="form">
					
		<div class="form-group">
			<label for="edit-code" class="col-sm-2 control-label">编码<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="edit-code" style="width: 200%;" value="${dt.code}">
			</div>
			<span style="position: relative; left: 270px; height: 34px; top: 8px; font-size: 14px;" id="codeInfo"></span>
		</div>
		
		<div class="form-group">
			<label for="edit-name" class="col-sm-2 control-label">名称</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="edit-name" style="width: 200%;" value="${dt.name}">
			</div>
		</div>
		
		<div class="form-group">
			<label for="edit-description" class="col-sm-2 control-label">描述</label>
			<div class="col-sm-10" style="width: 300px;">
				<textarea class="form-control" rows="3" id="edit-description" style="width: 200%;">${dt.description}</textarea>
			</div>
		</div>
	</form>
	
	<div style="height: 200px;"></div>
</body>
</html>