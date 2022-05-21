<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
String basePath=request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+request.getContextPath()+"/";
%>
<html>
<base href="<%=basePath%>">
<head>
<meta charset="UTF-8">
<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
<link href="jquery/zTree_v3-master/css/zTreeStyle/zTreeStyle.css" type="text/css" rel="stylesheet" />

<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
<script type="text/javascript" src="jquery/zTree_v3-master/js/jquery.ztree.all.min.js"></script>

<script type="text/javascript">
	var setting = {
		// edit: {
		// 	enable : true,
		// 	showRenameBtn : false,
		// 	showRemoveBtn : true
		// },
		data: {
			simpleData: {
				enable: true
			}
		}
	};

	let json = ${j} ;
	let zNodes = eval(json);
	$(document).ready(function(){
		$.fn.zTree.init($("#treeDemo"), setting, zNodes);
		window.open("settings/qx/permission/queryPermissionById.do/2","workAreaFrame2");
	});

</script>
	
</head>
<body>
	<div style="width: 20%; height: 100%; background-color: #F7F7F7; position: absolute; overflow:auto;">
		<ul id="treeDemo" class="ztree" style="position: relative; top: 15px; left: 15px;"></ul>
	</div>
	<div id="workArea" style="position: absolute; width: 80%; height: 100%; overflow: auto; left: 20%;">
			<iframe style="border-width: 0px; width: 100%; height: 100%;" name="workAreaFrame2">
			</iframe>

	</div>
</body>
</html>