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

	//默认情况下取消和保存按钮是隐藏的
	var cancelAndSaveBtnDefault = true;
	
	$(function(){
		showBtn();
		//阻止BootStrap框架默认回车键刷新表单，导致模态窗口关闭，页面内容消失的问题
		$(document).keydown(function(event){
			if (event.keyCode == 13) {
				$('.modal-content').each(function() {
					event.preventDefault();
				});
			}
		});

		//添加备注的保存取消按钮默认不显示
		$("#add-ClueRemark").focus(function(){
			if(cancelAndSaveBtnDefault){
				//设置remarkDiv的高度为130px
				$("#remarkDiv").css("height","130px");
				//显示
				$("#cancelAndSaveBtn").show("2000");
				cancelAndSaveBtnDefault = false;
			}
		});

		//点击取消按钮，保存取消按钮隐藏
		$("#cancelBtn").click(function(){
			//显示
			$("#cancelAndSaveBtn").hide();
			//设置remarkDiv的高度为130px
			$("#remarkDiv").css("height","90px");
			cancelAndSaveBtnDefault = true;
		});
		
		// $(".remarkDiv").mouseover(function(){
		// 	$(this).children("div").children("div").show();
		// });
		$("#remarkDivList").on("mouseover",".remarkDiv",function (){
			$(this).children("div").children("div").show();
		});
		
		// $(".remarkDiv").mouseout(function(){
		// 	$(this).children("div").children("div").hide();
		// });
		$("#remarkDivList").on("mouseout",".remarkDiv",function (){
			$(this).children("div").children("div").hide();
		});
		
		// $(".myHref").mouseover(function(){
		// 	$(this).children("span").css("color","red");
		// });
		$("#remarkDivList").on("mouseover",".myHref",function () {
			$(this).children("span").css("color", "red");
		});
		// $(".myHref").mouseout(function(){
		// 	$(this).children("span").css("color","#E6E6E6");
		// });
		$("#remarkDivList").on("mouseout",".myHref",function () {
			$(this).children("span").css("color","#E6E6E6");
		});

		//给添加备注的保存按钮添加单击事件
		$("#saveBtn").click(function (){
			let noteContent=$.trim($("#add-ClueRemark").val());
			let clueId = '${clue.id}';

			if(noteContent==""){
				alert("备注内容不能为空！");
				return;
			}

			$.ajax({
				url:'workbench/clue/addClueRemark.do',
				data:{
					noteContent:noteContent,
					clueId:clueId
				},
				type:'post',
				datatype:'json',
				success:function (data){
					if(data.code=="1"){
						let htmlStr="";
						htmlStr+="<div class=\"remarkDiv\" style=\"height: 60px;\" id=\"div_"+data.returnData.id+"\">";
						htmlStr+="<img title=\"${sessionScope.userInfo.name}\" src=\"image/user-thumbnail.png\" style=\"width: 30px; height:30px;\">";
						htmlStr+="<div style=\"position: relative; top: -40px; left: 40px;\" >";
						htmlStr+="<h5>"+data.returnData.noteContent+"</h5>";
						htmlStr+="<font color=\"gray\">线索</font> <font color=\"gray\">-</font> <b>${clue.fullname}${clue.appellation}-${clue.company}</b> <small style=\"color: gray;\" id='createName'> "+data.returnData.createTime+" 由${sessionScope.userInfo.name}创建</small>";
						htmlStr+="<div id='remarkABox' style=\"position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;\">";
						htmlStr+="<a class=\"myHref\" id=\"editA\" remarkId=\""+data.returnData.id+"\" href=\"javascript:void(0);\"><span class=\"glyphicon glyphicon-edit\" style=\"font-size: 20px; color: #E6E6E6;\"></span></a>";
						htmlStr+="&nbsp;&nbsp;&nbsp;&nbsp;";
						htmlStr+="<a class=\"myHref\" id=\"deleteA\" remarkId=\""+data.returnData.id+"\" href=\"javascript:void(0);\"><span class=\"glyphicon glyphicon-remove\" style=\"font-size: 20px; color: #E6E6E6;\"></span></a>";
						htmlStr+="</div>";
						htmlStr+="</div>";
						htmlStr+="</div>";

						$("#remarkHeader").after(htmlStr);
						showBtn();
						$("#add-ClueRemark").val("");
					}
					else{
						alert(data.message);
					}
				}
			});
		});

		//给修改备注添加单击事件
		$("#remarkDivList").on("click","#editA",function (){
			let id = $(this).attr("remarkId");
			console.log(id);
			let noteContent = $("#div_"+id+" h5").text();
			console.log(noteContent);

			$("#edit-id").val(id);
			$("#edit-noteContent").val(noteContent);
			$("#editRemarkModal").modal("show");

		});

        //给修改备注”保存“按钮添加单击事件
		$("#updateRemarkBtn").click(function (){
			let id = $("#edit-id").val();
			let noteContent= $.trim($("#edit-noteContent").val());

			if(noteContent==""){
				alert("修改备注内容不能为空！");
				return;
			}

			$.ajax({
				url:'workbench/clue/editClueRemark.do',
				data:{
					noteContent:noteContent,
					id:id
				},
				type:'post',
				datatype:'json',
				success:function (data){
					if(data.code=="1"){
						$("#editRemarkModal").modal("hide");

						//刷新列表
						$("#div_"+id+" h5").text(data.returnData.noteContent);
						$("#div_"+id+" small").text(" "+data.returnData.editTime+" 由${sessionScope.userInfo.name}修改");
					}else{
						alert(data.message);
						$("#editRemarkModal").modal("show");
					}
				}
			});
		});

		//给删除备注的删除按钮添加单击事件
		$("#remarkDivList").on("click","#deleteA",function (){
			let id= $(this).attr("remarkId");
			$.ajax({
				url:'workbench/clue/deleteClueRemark.do',
				data:{
					id:id
				},
				type:'post',
				datatype:'json',
				success:function (data){
					if(data.code=="1"){
						$("#div_"+id).remove();
					}else{
						alert(data.message);
					}
				}
			});
		});

		//给添加关联按钮添加点击事件
		$("#addBundBtn").click(function (){


			$("#bundModal").modal("show");

		});

		//给关联活动模态窗口搜索框添加键盘弹起事件
		$("#activityNameInput").keyup(function (){
			//获取参数
			let activityName=this.value;
			let clueId = '${clue.id}';

			//发送请求
			$.ajax({
				url:'workbench/clue/queryActivityByName.do',
				data:{
					activityName:activityName,
					clueId:clueId
				},
				type:"post",
				datatype:"json",
				success:function (data){
					let htmlStr="";
					$.each(data,function (index,obj){
						htmlStr+="<tr id=\"tr_"+obj.id+"\" >"
						htmlStr+="<td><input type=\"checkbox\" value='"+obj.id+"'/></td>"
						htmlStr+="<td>"+obj.name+"</td>"
						htmlStr+="<td>"+obj.startDate+"</td>"
						htmlStr+="<td>"+obj.endDate+"</td>"
						htmlStr+="<td>"+obj.owner+"</td>"
						htmlStr+="</tr>"
					});
					$("#bundModalTbody").html(htmlStr);

				}
			})
		});

		//给关联模态窗口全选checkbox添加单击事件
		$("#checkAllActivity").click(function (){
			$("#bundModalTbody input[type='checkbox']").prop("checked",this.checked);
		});
		//给关联模态窗口列表的checkbox添加单击事件
		$("#bundModalTbody").on("click","input[type='checkbox']",function (){
			//如果列表中的checkbox都选中，则”全选“按钮也选中
			//如果列表中的checkbox有至少一个未选中，则”全选“按钮也不选中
			if($("#bundModalTbody input[type='checkbox']").size()==$("#bundModalTbody input[type='checkbox']:checked").size()){
				$("#checkAllActivity").prop("checked",true);
			}else{
				$("#checkAllActivity").prop("checked",false);
			}
		});

		//给保存关联按钮添加单击事件
		$("#saveBundBtn").click(function (){
			let checkIds=$("#bundModalTbody input[type='checkbox']:checked");
			//表单验证
			if(checkIds.size()==0){
				alert("请选择要关联的活动");
				return;
			}
			let ids="";
			$.each(checkIds,function (){
				ids+="activityId="+this.value+"&";
			})
			ids+="clueId=${clue.id}";

			//发送请求
			$.ajax({
				url:'workbench/clue/addRelation.do',
				data:ids,
				type:'post',
				datatype:'json',
				success:function (data){
					if(data.code==1){
						$("#bundModal").modal("hide");
						let htmlStr="";
						$.each(data.returnData,function (index,obj){
							htmlStr+="<tr id='tr_"+obj.id+"'>"
							htmlStr+="<td>"+obj.name+"</td>"
							htmlStr+="<td>"+obj.startDate+"</td>"
							htmlStr+="<td>"+obj.endDate+"</td>"
							htmlStr+="<td>"+obj.owner+"</td>"
							htmlStr+="<td><a href=\"javascript:void(0);\"    activityId=\""+obj.id+"\" style=\"text-decoration: none;\"><span class=\"glyphicon glyphicon-remove\"></span>解除关联</a></td>"
							htmlStr+="</tr>"
						});
						$("#bundTbody").append(htmlStr);
						$.each(checkIds,function (){
							$("#tr_"+this.value).remove();
						})
					}
					else{
						alert(data.message);

						$("#bundModal").modal("show");
					}

				}
			});
		});

		//给解除关联按钮添加单击事件
		$("#bundTbody").on("click","a",function (){
			//收集参数
			let activityId=$(this).attr("activityId");
			console.log(activityId);
			let clueId = '${clue.id}';

			if(window.confirm("确定解除吗？")){
				//发送请求
				$.ajax({
					url:'workbench/clue/deleteRelation.do',
					data:{
						activityId:activityId,
						clueId:clueId
					},
					type:"post",
					datatype:"json",
					success:function (data){
						if(data.code==1){
							//刷新关联活动列表
							$("#tr_"+activityId).remove();
						}else{
							alert(data.message);
						}
					}
				});
			}
		});

		$("#convertDiv").on('click','#convertClueBtn',function (){
			let id='${clue.id}';
			window.location.href='workbench/clue/toConvert.do?id='+id;
		});
	});
	function showBtn(){
		$.ajax({
			url:'workbench/showMenu.do',
			type:'post',
			datatype:'json',
			success:function (data){
				if(data.includes("线索转换")){
					let htmlStr ="";
					htmlStr="<button type=\"button\" class=\"btn btn-default\" id=\"convertClueBtn\"><span class=\"glyphicon glyphicon-retweet\"></span> 转换</button>"
					$("#convertDiv").html(htmlStr);
				}
				if(!data.includes("备注管理")){
					showRemarkA()
				}else{
					let user = '${sessionScope.userInfo.name}'
					let createBy = $("#remarkDivList small[id='createName']");
					let a = $("#remarkDivList div[id='remarkABox']");
					let updA = $("#remarkABox a[id='editA']");
					for (let i = 0; i < createBy.length; i++) {
						// console.log(createBy[i].innerText)
						if(!createBy[i].innerText.includes(user)) {
							for (let j = 0; j < updA.length; j++) {
								// console.log(createBy[i].innerText)
								updA[i].remove();
							}
						}
					}
				}
			}
		})
	}
	function showRemarkA(){
		let user = '${sessionScope.userInfo.name}'
		let createBy = $("#remarkDivList small[id='createName']");
		let a = $("#remarkDivList div[id='remarkABox']");
		for (let i = 0; i < createBy.length; i++) {
			// console.log(createBy[i].innerText)
			if(!createBy[i].innerText.includes(user)) {
				a[i].remove();
			}
		}
	}


</script>

</head>
<body>
	<!-- 修改线索备注的模态窗口 -->
	<div class="modal fade" id="editRemarkModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 40%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel">修改备注</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form">
						<input type="hidden" id="edit-id">
						<div class="form-group">
							<label for="edit-noteContent" class="col-sm-2 control-label">内容</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="edit-noteContent"></textarea>
							</div>
						</div>
					</form>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="updateRemarkBtn">更新</button>
				</div>
			</div>
		</div>
	</div>

	<!-- 关联市场活动的模态窗口 -->
	<div class="modal fade" id="bundModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 80%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">关联市场活动</h4>
				</div>
				<div class="modal-body">
					<div class="btn-group" style="position: relative; top: 18%; left: 8px;">
						<form class="form-inline" role="form">
						  <div class="form-group has-feedback">
						    <input id="activityNameInput" type="text" class="form-control" style="width: 300px;" placeholder="请输入市场活动名称，支持模糊查询">
						    <span class="glyphicon glyphicon-search form-control-feedback"></span>
						  </div>
						</form>
					</div>
					<table id="activityTable" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
						<thead>
							<tr style="color: #B3B3B3;">
								<td><input type="checkbox" id="checkAllActivity" /></td>
								<td>名称</td>
								<td>开始日期</td>
								<td>结束日期</td>
								<td>所有者</td>
								<td></td>
							</tr>
						</thead>
						<tbody id="bundModalTbody">
<%--							<tr>--%>
<%--								<td><input type="checkbox"/></td>--%>
<%--								<td>发传单</td>--%>
<%--								<td>2020-10-10</td>--%>
<%--								<td>2020-10-20</td>--%>
<%--								<td>zhangsan</td>--%>
<%--							</tr>--%>
<%--							<tr>--%>
<%--								<td><input type="checkbox"/></td>--%>
<%--								<td>发传单</td>--%>
<%--								<td>2020-10-10</td>--%>
<%--								<td>2020-10-20</td>--%>
<%--								<td>zhangsan</td>--%>
<%--							</tr>--%>
						</tbody>
					</table>
				</div>
				<div id="bundDiv" class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
					<button type="button" class="btn btn-primary" id="saveBundBtn">关联</button>
				</div>
			</div>
		</div>
	</div>


	<!-- 返回按钮 -->
	<div style="position: relative; top: 35px; left: 10px;">
		<a href="javascript:void(0);" onclick="window.history.back();"><span class="glyphicon glyphicon-arrow-left" style="font-size: 20px; color: #DDDDDD"></span></a>
	</div>
	
	<!-- 大标题 -->
	<div style="position: relative; left: 40px; top: -30px;">
		<div class="page-header">
			<h3>${clue.fullname}${clue.appellation==null?"":clue.appellation} <small>${clue.company}</small></h3>
		</div>
		<div style="position: relative; height: 50px; width: 500px;  top: -72px; left: 700px;" id="convertDiv">
<%--			<button type="button" class="btn btn-default" id="convertClueBtn"><span class="glyphicon glyphicon-retweet"></span> 转换</button>--%>
			
		</div>
	</div>
	
	<br/>
	<br/>
	<br/>

	<!-- 详细信息 -->
	<div style="position: relative; top: -70px;">
		<div style="position: relative; left: 40px; height: 30px;">
			<div style="width: 300px; color: gray;">名称</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${clue.fullname}${clue.appellation}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">所有者</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${clue.owner}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 10px;">
			<div style="width: 300px; color: gray;">公司</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${clue.company}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">职位</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${clue.job}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 20px;">
			<div style="width: 300px; color: gray;">邮箱</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${clue.email}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">公司座机</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${clue.phone}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 30px;">
			<div style="width: 300px; color: gray;">公司网站</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${clue.website}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">手机</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${clue.mphone}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 40px;">
			<div style="width: 300px; color: gray;">线索状态</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${clue.state}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">线索来源</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${clue.source}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 50px;">
			<div style="width: 300px; color: gray;">创建者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${clue.createBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${clue.createTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 60px;">
			<div style="width: 300px; color: gray;">修改者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${clue.editBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${clue.editTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 70px;">
			<div style="width: 300px; color: gray;">描述</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b>
					${clue.description}
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 80px;">
			<div style="width: 300px; color: gray;">联系纪要</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b>
					${clue.contactSummary}
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 90px;">
			<div style="width: 300px; color: gray;">下次联系时间</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${clue.nextContactTime}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px; "></div>
		</div>
        <div style="position: relative; left: 40px; height: 30px; top: 100px;">
            <div style="width: 300px; color: gray;">详细地址</div>
            <div style="width: 630px;position: relative; left: 200px; top: -20px;">
                <b>
                    ${clue.address}
                </b>
            </div>
            <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
        </div>
	</div>
	
	<!-- 备注 -->
	<div id="remarkDivList" style="position: relative; top: 40px; left: 40px;">
		<div id="remarkHeader"  class="page-header">
			<h4>备注</h4>
		</div>

		<c:forEach items="${clueRemarkList}" var="crl">
			<div class="remarkDiv" style="height: 60px;" id="div_${crl.id}">
				<img title="${crl.createBy}" src="image/user-thumbnail.png" style="width: 30px; height:30px;">
				<div style="position: relative; top: -40px; left: 40px;" >
					<h5>${crl.noteContent}</h5>
					<font color="gray">线索</font> <font color="gray">-</font> <b>${clue.fullname}${clue.appellation}-${clue.company}</b> <small style="color: gray;" id="createName"> ${crl.editFlag=="0"?crl.createTime:crl.editTime} 由${crl.editFlag=="0"?crl.createBy:crl.editBy}${crl.editFlag=='0'?'创建':'修改'}</small>
					<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;" id="remarkABox">
						<a class="myHref" id="editA" remarkId="${crl.id}" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>
						&nbsp;&nbsp;&nbsp;&nbsp;
						<a class="myHref" id="deleteA" remarkId="${crl.id}" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>
					</div>
				</div>
			</div>
		</c:forEach>
<%--		<!-- 备注1 -->--%>
<%--		<div class="remarkDiv" style="height: 60px;">--%>
<%--			<img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">--%>
<%--			<div style="position: relative; top: -40px; left: 40px;" >--%>
<%--				<h5>哎呦！</h5>--%>
<%--				<font color="gray">线索</font> <font color="gray">-</font> <b>李四先生-动力节点</b> <small style="color: gray;"> 2017-01-22 10:10:10 由zhangsan</small>--%>
<%--				<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">--%>
<%--					<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>--%>
<%--					&nbsp;&nbsp;&nbsp;&nbsp;--%>
<%--					<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>--%>
<%--				</div>--%>
<%--			</div>--%>
<%--		</div>--%>
<%--		--%>
<%--		<!-- 备注2 -->--%>
<%--		<div class="remarkDiv" style="height: 60px;">--%>
<%--			<img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">--%>
<%--			<div style="position: relative; top: -40px; left: 40px;" >--%>
<%--				<h5>呵呵！</h5>--%>
<%--				<font color="gray">线索</font> <font color="gray">-</font> <b>李四先生-动力节点</b> <small style="color: gray;"> 2017-01-22 10:20:10 由zhangsan</small>--%>
<%--				<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">--%>
<%--					<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>--%>
<%--					&nbsp;&nbsp;&nbsp;&nbsp;--%>
<%--					<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>--%>
<%--				</div>--%>
<%--			</div>--%>
<%--		</div>--%>
<%--		--%>
		<div id="remarkDiv" style="background-color: #E6E6E6; width: 870px; height: 90px;">
			<form role="form" style="position: relative;top: 10px; left: 10px;">
				<textarea id="add-ClueRemark" class="form-control" style="width: 850px; resize : none;" rows="2"  placeholder="添加备注..."></textarea>
				<p id="cancelAndSaveBtn" style="position: relative;left: 737px; top: 10px; display: none;">
					<button id="cancelBtn" type="button" class="btn btn-default">取消</button>
					<button id="saveBtn" type="button" class="btn btn-primary">保存</button>
				</p>
			</form>
		</div>
	</div>
	
	<!-- 市场活动 -->
	<div>
		<div style="position: relative; top: 60px; left: 40px;">
			<div class="page-header">
				<h4>市场活动</h4>
			</div>
			<div style="position: relative;top: 0px;">
				<table class="table table-hover" style="width: 900px;">
					<thead>
						<tr style="color: #B3B3B3;">
							<td>名称</td>
							<td>开始日期</td>
							<td>结束日期</td>
							<td>所有者</td>
							<td></td>
						</tr>
					</thead>
					<tbody id="bundTbody">
					<c:forEach items="${activityList}" var="al">
						<tr id="tr_${al.id}">
							<td>${al.name}</td>
							<td>${al.startDate}</td>
							<td>${al.endDate}</td>
							<td>${al.owner}</td>
							<td><a href="javascript:void(0);" id="unbundA" activityId="${al.id}" style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>解除关联</a></td>
						</tr>
					</c:forEach>

<%--						<tr>--%>
<%--							<td>发传单</td>--%>
<%--							<td>2020-10-10</td>--%>
<%--							<td>2020-10-20</td>--%>
<%--							<td>zhangsan</td>--%>
<%--							<td><a href="javascript:void(0);"  style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>解除关联</a></td>--%>
<%--						</tr>--%>
					</tbody>
				</table>
			</div>
			
			<div>
				<a href="javascript:void(0);" id="addBundBtn"  style="text-decoration: none;"><span class="glyphicon glyphicon-plus"></span>关联市场活动</a>
			</div>
		</div>
	</div>
	
	
	<div style="height: 200px;"></div>
</body>
</html>