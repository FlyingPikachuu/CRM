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

<style type="text/css">
.mystage{
	font-size: 20px;
	vertical-align: middle;
	cursor: pointer;
}
.closingDate{
	font-size : 15px;
	cursor: pointer;
	vertical-align: middle;
}
</style>
	
<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>

<script type="text/javascript">

	//默认情况下取消和保存按钮是隐藏的
	var cancelAndSaveBtnDefault = true;
	
	$(function(){
		showRemarkA();
		$("#create-noteContent").focus(function(){
			if(cancelAndSaveBtnDefault){
				//设置remarkDiv的高度为130px
				$("#remarkDiv").css("height","130px");
				//显示
				$("#cancelAndSaveBtn").show("2000");
				cancelAndSaveBtnDefault = false;
			}
		});
		
		$("#cancelBtn").click(function(){
			//显示
			$("#cancelAndSaveBtn").hide();
			//设置remarkDiv的高度为130px
			$("#remarkDiv").css("height","90px");
			cancelAndSaveBtnDefault = true;
		});

		$("#remarkDivList").on("mouseover",".remarkDiv",function (){
			$(this).children("div").children("div").show();
		})

		$("#remarkDivList").on("mouseout",".remarkDiv",function (){
			$(this).children("div").children("div").hide();
		})

		$("#remarkDivList").on("mouseover",".myHref",function (){
			$(this).children("span").css("color","red");
		});

		$("#remarkDivList").on("mouseout",".myHref",function (){
			$(this).children("span").css("color","#E6E6E6");
		});
		//阶段提示框
		$(".mystage").popover({
            trigger:'manual',
            placement : 'bottom',
            html: 'true',
            animation: false
        }).on("mouseenter", function () {
                    var _this = this;
                    $(this).popover("show");
                    $(this).siblings(".popover").on("mouseleave", function () {
                        $(_this).popover('hide');
                    });
                }).on("mouseleave", function () {
                    var _this = this;
                    setTimeout(function () {
                        if (!$(".popover:hover").length) {
                            $(_this).popover("hide")
                        }
                    }, 100);
                });

		//给备注 “保存”按钮添加单击事件
		$("#saveBtn").click(function (){
			let noteContent = $.trim($("#create-noteContent").val());
			let tranId = '${ts.id}';

			if(noteContent==''){
				alert("备注内容不为空！");
				return;
			}

			$.ajax({
				url:'workbench/transaction/addTranRemark.do',
				data:{
					noteContent:noteContent,
					tranId:tranId
				},
				type:'post',
				datatype:'json',
				success:function (data){
					if(data.code=="1"){
						let htmlStr='';
						htmlStr+="<div id=\"div_"+data.returnData.id+"\" class=\"remarkDiv\" style=\"height: 60px;\">"
						htmlStr+="<img title=\"${sessionScope.userInfo.name}\" src=\"image/user-thumbnail.png\" style=\"width: 30px; height:30px;\">"
						htmlStr+="<div style=\"position: relative; top: -40px; left: 40px;\" >"
						htmlStr+="<h5>"+data.returnData.noteContent+"</h5>"
						htmlStr+="<font color=\"gray\">交易</font> <font color=\"gray\">-</font> <b>${ts.name}</b> <small style=\"color: gray;\" id='createName'> "+data.returnData.createTime+" 由${sessionScope.userInfo.name}</small>"
						htmlStr+="<div style=\"position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;\">"
						htmlStr+="<a class=\"myHref\" id=\"editA\" remarkId=\""+data.returnData.id+"\" href=\"javascript:void(0);\"><span class=\"glyphicon glyphicon-edit\" style=\"font-size: 20px; color: #E6E6E6;\"></span></a>"
						htmlStr+="&nbsp;&nbsp;&nbsp;&nbsp;"
						htmlStr+="<a class=\"myHref\" id=\"deleteA\" remarkId=\""+data.returnData.id+"\" href=\"javascript:void(0);\"><span class=\"glyphicon glyphicon-remove\" style=\"font-size: 20px; color: #E6E6E6;\"></span></a>"
						htmlStr+="</div>"
						htmlStr+="</div>"
						htmlStr+="</div>"
						$("#remarkHeader").after(htmlStr);
						showRemarkA();
						$("#create-noteContent").val("");
					}
					else{
						alert(data.message);
					}
				}
			})
		});

		//给备注 ‘修改"按钮添加单击事件
		$("#remarkDivList").on("click","#editA",function (){
			let id = $(this).attr("remarkId");
			let noteContent = $("#div_"+id+" h5").text();
			alert(noteContent);

			$("#edit-id").val(id);
			$("#edit-noteContent").text(noteContent);
			$("#editRemarkModal").modal("show");
		});
		//给备注修改模态窗口，“更新”按钮添加单击事件
		$("#updateRemarkBtn").click(function (){
			let noteContent = $("#edit-noteContent").val();
			alert(noteContent)
			let id = $("#edit-id").val();

			if(noteContent==''){
				alert("备注内容不为空！");
				return;
			}

			$.ajax({
				url:'workbench/transaction/editTranRemark.do',
				data:{
					id:id,
					noteContent:noteContent
				},
				type:'post',
				datatype:'json',
				success:function (data){
					if(data.code=="1"){
						$("#editRemarkModal").modal("hide");
						$("#div_"+id+" h5").text(data.returnData.noteContent);
						$("#div_"+id+" small").text(" "+data.returnData.editTime+" 由${sessionScope.userInfo.name}修改");

					}
					else{
						alert(data.message);
						$("#editRemarkModal").modal("show");
					}
				}
			});
		});
		//给备注“删除”按钮添加单击事件
		$("#remarkDivList").on("click","#deleteA",function (){
			let id = $(this).attr("remarkId");
			$.ajax({
				url:'workbench/transaction/deleteTranRemark.do',
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
		$("#fontDiv").on("click","span",function (){
			let stage = $(this).attr("stageId");
			let stageName = $(this).attr("data-content");
			let oldStageName= '${ts.stage}';
			let id = '${ts.id}';
			if(stageName==oldStageName){
				alert("交易目前正在此阶段，无需修改");
				return;
			}
			$.ajax({
				url:'workbench/transaction/editTranStage.do',
				data:{
					id:id,
					stage:stage
				},
				type:"post",
				datatype:"json",
				success:function (data){
					if(data.code=="1"){
						window.location.reload();
					}else {
						alert(data.message);
					}
				}
			})
		})

	});
	function showRemarkA(){
		$.ajax({
			url:'workbench/showMenu.do',
			type:'post',
			datatype:'json',
			success:function (data){
				if(!data.includes("备注管理")){
					let user = '${sessionScope.userInfo.name}'
					let createBy = $("#remarkDivList small[id='createName']");
					let a = $("#remarkDivList div[id='remarkABox']");
					for (let i = 0; i < createBy.length; i++) {
						// console.log(createBy[i].innerText)
						if(!createBy[i].innerText.includes(user)) {
							a[i].remove();
						}
					}
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

	<!-- 返回按钮 -->
	<div style="position: relative; top: 35px; left: 10px;">
		<a href="javascript:void(0);" onclick="window.history.back();"><span class="glyphicon glyphicon-arrow-left" style="font-size: 20px; color: #DDDDDD"></span></a>
	</div>
	
	<!-- 大标题 -->
	<div style="position: relative; left: 40px; top: -30px;">
		<div class="page-header">
			<h3>${ts.name} <small>￥${ts.money}</small></h3>
		</div>
		
	</div>

	<br/>
	<br/>
	<br/>

	<!-- 阶段状态 -->
	<div style="position: relative; left: 40px; top: -50px;" id="fontDiv">
		阶段&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		<c:forEach items="${stageList}" var="stl">
			<!--如果stage就是当前交易所处阶段，则图标显示为map-marker，颜色显示为绿色-->
			<c:if test="${ts.orderNo=='8'||ts.orderNo=='9'}">
				<c:if test="${ts.stage==stl.value}">
					<span class="glyphicon glyphicon-map-marker mystage" data-toggle="popover" data-placement="bottom" data-content="${stl.value}" style="color: #90F790;" stageId="${stl.id}"></span>
					-----------
				</c:if>
				<!--如果stage处在当前交易所处阶段前边，则图标显示为ok-circle，颜色显示为绿色-->
				<c:if test="${ts.orderNo>stl.orderNo}">
					<span class="glyphicon glyphicon-record mystage" data-toggle="popover" data-placement="bottom" data-content="${stl.value}" stageId="${stl.id}"></span>
					-----------
				</c:if>
				<!--如果stage处在当前交易所处阶段的后边。则图标显示为record，颜色为黑色-->
				<c:if test="${ts.orderNo<stl.orderNo}">
					<span class="glyphicon glyphicon-record mystage" data-toggle="popover" data-placement="bottom" data-content="${stl.value}" stageId="${stl.id}"></span>
					-----------
				</c:if>
			</c:if>
			<c:if test="${ts.orderNo!='8'&&ts.orderNo!='9'}">
				<c:if test="${ts.stage==stl.value}">
					<span class="glyphicon glyphicon-map-marker mystage" data-toggle="popover" data-placement="bottom" data-content="${stl.value}" style="color: #90F790;" stageId="${stl.id}"></span>
					-----------
				</c:if>
				<!--如果stage处在当前交易所处阶段前边，则图标显示为ok-circle，颜色显示为绿色-->
				<c:if test="${ts.orderNo>stl.orderNo}">
					<span class="glyphicon glyphicon-ok-circle mystage" data-toggle="popover" data-placement="bottom" data-content="${stl.value}" style="color: #90F790;" stageId="${stl.id}"></span>
					-----------
				</c:if>
				<!--如果stage处在当前交易所处阶段的后边。则图标显示为record，颜色为黑色-->
				<c:if test="${ts.orderNo<stl.orderNo}">
					<span class="glyphicon glyphicon-record mystage" data-toggle="popover" data-placement="bottom" data-content="${stl.value}" stageId="${stl.id}"></span>
					-----------
				</c:if>
			</c:if>
		</c:forEach>
<%--		<span class="glyphicon glyphicon-ok-circle mystage" data-toggle="popover" data-placement="bottom" data-content="资质审查" style="color: #90F790;"></span>--%>
<%--		-------------%>
<%--		<span class="glyphicon glyphicon-ok-circle mystage" data-toggle="popover" data-placement="bottom" data-content="需求分析" style="color: #90F790;"></span>--%>
<%--		-------------%>
<%--		<span class="glyphicon glyphicon-ok-circle mystage" data-toggle="popover" data-placement="bottom" data-content="价值建议" style="color: #90F790;"></span>--%>
<%--		-------------%>
<%--		<span class="glyphicon glyphicon-ok-circle mystage" data-toggle="popover" data-placement="bottom" data-content="确定决策者" style="color: #90F790;"></span>--%>
<%--		-------------%>
<%--		<span class="glyphicon glyphicon-map-marker mystage" data-toggle="popover" data-placement="bottom" data-content="提案/报价" style="color: #90F790;"></span>--%>
<%--		-------------%>
<%--		<span class="glyphicon glyphicon-record mystage" data-toggle="popover" data-placement="bottom" data-content="谈判/复审"></span>--%>
<%--		-------------%>
<%--		<span class="glyphicon glyphicon-record mystage" data-toggle="popover" data-placement="bottom" data-content="成交"></span>--%>
<%--		-------------%>
<%--		<span class="glyphicon glyphicon-record mystage" data-toggle="popover" data-placement="bottom" data-content="丢失的线索"></span>--%>
<%--		-------------%>
<%--		<span class="glyphicon glyphicon-record mystage" data-toggle="popover" data-placement="bottom" data-content="因竞争丢失关闭"></span>--%>
<%--		-------------%>
		<span class="closingDate">${ts.expectedDate}</span>
	</div>

	<!-- 详细信息 -->
	<div style="position: relative; top: 0px;">
		<div style="position: relative; left: 40px; height: 30px;">
			<div style="width: 300px; color: gray;">所有者</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${ts.owner}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">金额</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${ts.money}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 10px;">
			<div style="width: 300px; color: gray;">名称</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${ts.name}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">预计成交日期</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${ts.expectedDate}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 20px;">
			<div style="width: 300px; color: gray;">客户名称</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${ts.customerId}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">阶段</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${ts.stage}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 30px;">
			<div style="width: 300px; color: gray;">类型</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${ts.type}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">可能性</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${ts.possibility}%</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 40px;">
			<div style="width: 300px; color: gray;">来源</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${ts.source}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">市场活动源</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${ts.activityId}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 50px;">
			<div style="width: 300px; color: gray;">联系人名称</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${ts.contactId}</b></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 60px;">
			<div style="width: 300px; color: gray;">创建者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${ts.createBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${ts.createTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 70px;">
			<div style="width: 300px; color: gray;">修改者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${ts.editBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${ts.editTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 80px;">
			<div style="width: 300px; color: gray;">描述</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b>
					${ts.description}
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 90px;">
			<div style="width: 300px; color: gray;">联系纪要</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b>
					${ts.contactSummary}
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 100px;">
			<div style="width: 300px; color: gray;">下次联系时间</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${ts.nextContactTime}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
	</div>
	
	<!-- 备注 -->
	<div id="remarkDivList" style="position: relative; top: 100px; left: 40px;">
		<div id="remarkHeader" class="page-header">
			<h4>备注</h4>
		</div>
		<c:forEach items="${trList}" var="trl">
			<div id="div_${trl.id}" class="remarkDiv" style="height: 60px;">
				<img title="${trl.createBy}" src="image/user-thumbnail.png" style="width: 30px; height:30px;">
				<div style="position: relative; top: -40px; left: 40px;" >
					<h5>${trl.noteContent}</h5>
					<font color="gray">交易</font> <font color="gray">-</font> <b>${ts.name}</b> <small style="color: gray;" id="createName"> ${trl.editFlag=="1"?trl.editTime:trl.createTime} 由${trl.editFlag=="1"?trl.editBy:trl.createBy}${trl.editFlag=="1"?"修改":"创建"}</small>
					<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;" id="remarkABox">
						<a class="myHref" id="editA" remarkId="${trl.id}" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>
						&nbsp;&nbsp;&nbsp;&nbsp;
						<a class="myHref" id="deleteA" remarkId="${trl.id}" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>
					</div>
				</div>
			</div>
		</c:forEach>
<%--		<!-- 备注1 -->--%>
<%--		<div class="remarkDiv" style="height: 60px;">--%>
<%--			<img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">--%>
<%--			<div style="position: relative; top: -40px; left: 40px;" >--%>
<%--				<h5>哎呦！</h5>--%>
<%--				<font color="gray">交易</font> <font color="gray">-</font> <b>动力节点-交易01</b> <small style="color: gray;"> 2017-01-22 10:10:10 由zhangsan</small>--%>
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
<%--				<font color="gray">交易</font> <font color="gray">-</font> <b>动力节点-交易01</b> <small style="color: gray;"> 2017-01-22 10:20:10 由zhangsan</small>--%>
<%--				<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">--%>
<%--					<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>--%>
<%--					&nbsp;&nbsp;&nbsp;&nbsp;--%>
<%--					<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>--%>
<%--				</div>--%>
<%--			</div>--%>
<%--		</div>--%>
		
		<div id="remarkDiv" style="background-color: #E6E6E6; width: 870px; height: 90px;">
			<form role="form" style="position: relative;top: 10px; left: 10px;">
				<textarea id="create-noteContent" class="form-control" style="width: 850px; resize : none;" rows="2"  placeholder="添加备注..."></textarea>
				<p id="cancelAndSaveBtn" style="position: relative;left: 737px; top: 10px; display: none;">
					<button id="cancelBtn" type="button" class="btn btn-default">取消</button>
					<button id="saveBtn" type="button" class="btn btn-primary">保存</button>
				</p>
			</form>
		</div>
	</div>
	
	<!-- 阶段历史 -->
	<div>
		<div style="position: relative; top: 100px; left: 40px;">
			<div class="page-header">
				<h4>阶段历史</h4>
			</div>
			<div style="position: relative;top: 0px;">
				<table id="activityTable" class="table table-hover" style="width: 900px;">
					<thead>
						<tr style="color: #B3B3B3;">
							<td>阶段</td>
							<td>金额</td>
							<td>预计成交日期</td>
							<td>创建时间</td>
							<td>创建人</td>
						</tr>
					</thead>
					<tbody id="thTbody">
					<c:forEach items="${thList}" var="thl">
						<tr>
							<td>${thl.stage}</td>
							<td>${thl.money}</td>
							<td>${thl.expectedDate}</td>
							<td>${thl.createTime}</td>
							<td>${thl.createBy}</td>
						</tr>
					</c:forEach>
<%--						<tr>--%>
<%--							<td>资质审查</td>--%>
<%--							<td>5,000</td>--%>
<%--							<td>2017-02-07</td>--%>
<%--							<td>2016-10-10 10:10:10</td>--%>
<%--							<td>zhangsan</td>--%>
<%--						</tr>--%>
<%--						<tr>--%>
<%--							<td>需求分析</td>--%>
<%--							<td>5,000</td>--%>
<%--							<td>20</td>--%>
<%--							<td>2017-02-07</td>--%>
<%--							<td>2016-10-20 10:10:10</td>--%>
<%--							<td>zhangsan</td>--%>
<%--						</tr>--%>
<%--						<tr>--%>
<%--							<td>谈判/复审</td>--%>
<%--							<td>5,000</td>--%>
<%--							<td>90</td>--%>
<%--							<td>2017-02-07</td>--%>
<%--							<td>2017-02-09 10:10:10</td>--%>
<%--							<td>zhangsan</td>--%>
<%--						</tr>--%>
					</tbody>
				</table>
			</div>
			
		</div>
	</div>
	
	<div style="height: 200px;"></div>
	
</body>
</html>