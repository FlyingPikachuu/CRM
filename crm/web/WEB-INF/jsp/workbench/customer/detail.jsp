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

		//给备注 “保存”按钮添加单击事件
		$("#saveBtn").click(function (){
			let noteContent = $.trim($("#create-noteContent").val());
			let customerId = '${cut.id}';

			if(noteContent==''){
				alert("备注内容不为空！");
				return;
			}

			$.ajax({
				url:'workbench/customer/addCustomerRemark.do',
				data:{
					noteContent:noteContent,
					customerId:customerId
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
						htmlStr+="<font color=\"gray\">客户</font> <font color=\"gray\">-</font> <b>${cut.name}</b> <small style=\"color: gray;\"> "+data.returnData.createTime+" 由${sessionScope.userInfo.name}</small>"
						htmlStr+="<div style=\"position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;\">"
						htmlStr+="<a class=\"myHref\" id=\"editA\" remarkId=\""+data.returnData.id+"\" href=\"javascript:void(0);\"><span class=\"glyphicon glyphicon-edit\" style=\"font-size: 20px; color: #E6E6E6;\"></span></a>"
						htmlStr+="&nbsp;&nbsp;&nbsp;&nbsp;"
						htmlStr+="<a class=\"myHref\" id=\"deleteA\" remarkId=\""+data.returnData.id+"\" href=\"javascript:void(0);\"><span class=\"glyphicon glyphicon-remove\" style=\"font-size: 20px; color: #E6E6E6;\"></span></a>"
						htmlStr+="</div>"
						htmlStr+="</div>"
						htmlStr+="</div>"
						$("#remarkHeader").after(htmlStr);

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
				url:'workbench/customer/editCustomerRemark.do',
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
				url:'workbench/customer/deleteCustomerRemark.do',
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

		//给新建联系人按钮添加单击事件
		$("#createContactBtn").click(function (){
			$("#createContactForm")[0].reset();
			$("#createContactsModal").modal("show");
		});

		//给“保存”按钮添加点击事件
		$("#saveContactBtn").click(function (){
			let owner=$("#create-owner").val();
			let source=$("#create-source").val();
			let customerName=$("#create-customerName").val();
			let fullname=$("#create-fullname").val();
			let appellation=$("#create-appellation").val();
			let email=$("#create-email").val();
			let mphone=$("#create-mphone").val();
			let job=$("#create-job").val();
			let birth=$("#create-birth").val();
			let description=$("#create-description").val();
			let contactSummary=$("#create-contactSummary").val();
			let nextContactTime=$("#create-nextContactTime").val();
			let address=$("#create-address").val();

			if(owner==null){
				alert("所有者不能为空！");
				return;
			}
			if(fullname==""){
				alert("姓名不能为空！");
				return;
			}
			let regExpEmail=/^\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$/;
			if(!regExpEmail.test(email)&&email!=""){
				alert("邮件格式不正确！");
				return;
			}
			let regExpMphone=/^(13[0-9]|14[5|7]|15[0|1|2|3|5|6|7|8|9]|18[0|1|2|3|5|6|7|8|9])\d{8}$/;
			if(!regExpMphone.test(mphone)&&mphone!=""){
				alert("手机格式不正确！");
				return;
			}

			$.ajax({
				url:'workbench/contact/addContact.do',
				data:{
					owner : owner,
					source : source,
					customerName: customerName,
					fullname : fullname,
					appellation : appellation,
					email : email,
					mphone : mphone,
					job : job,
					birth : birth,
					description : description,
					contactSummary : contactSummary,
					nextContactTime : nextContactTime,
					address :address
				},
				type:'post',
				datatype:'json',
				success:function (data){
					if(data.code=="1"){
						$("#createContactsModal").modal("hide");
						window.location.reload();
					}else{
						alert(data.message);
						$("#createContactsModal").modal("show");
					}
				}
			})
		})

		//给删除交易按钮添加单击事件
		$("#tranTbody").on("click","#deleteTranA",function (){
			let id='ids='+$(this).attr("tranId");
			alert(id);
			if(window.confirm("确定删除吗？")){
				$.ajax({
					url:'workbench/transaction/deleteTranByIds.do',
					data:id,
					type:'post',
					datatype: 'json',
					success:function (data){
						if(data.code=="1"){
							window.location.reload();
						}else{
							alert(data.message);
						}
					}
				});
			}

		});

		//给编辑按钮添加单击事件
		$("#editCustomerBtn").click(function (){
			$("#editCustomerModal").modal("show");
		});
		//给更新按钮添加点击事件
		$("#updateCustomerBtn").click(function (){
			let id=$("#edit-id1").val();
			let owner=$("#edit-owner").val();
			let website = $("#edit-website").val();
			let phone = $("#edit-phone").val();
			let name=$("#edit-name").val();
			let description=$("#edit-description").val();
			let contactSummary=$("#edit-contactSummary").val();
			let nextContactTime=$("#edit-nextContactTime").val();
			let address=$("#edit-address").val();

			if(owner==null){
				alert("所有者不能为空！");
				return;
			}
			if(name==''){
				alert("名称不能为空！");
				return;
			}
			let regExpPhone=/^((\d{3,4}-)|\d{3,4}-)?\d{7,8}$/;
			if(!regExpPhone.test(phone)&&phone!=""){
				alert("座机格式不正确！");
				return;
			}
			let regExpWebsite=/^(?:http(s)?:\/\/)?[\w.-]+(?:\.[\w\.-]+)+[\w\-\._~:/?#[\]@!\$&'\*\+,;=.]+$/;
			if(!regExpWebsite.test(website)&&website!=""){
				alert("公司网站格式不正确！");
				return;
			}

			$.ajax({
				url:'workbench/customer/editCustomer.do',
				data:{
					id : id,
					owner : owner,
					name:name,
					website:website,
					phone:phone,
					description : description,
					contactSummary : contactSummary,
					nextContactTime : nextContactTime,
					address :address
				},
				type:'post',
				datatype: 'json',
				success:function (data){
					if(data.code=="1"){
						$("#editCustomerModal").modal("hide");
						window.location.reload();
					}else{
						alert(data.message);
						$("#editCustomerModal").modal("show");
					}
				}
			})
		})

		//给删除客户按钮添加单击事件
		$("#customerBtnBox").on('click','#deleteCustomerBtn',function (){
			$("#removeCustomerModal").modal("show");
		});
		$("#removeCustomerBtn").click(function (){
			let id="ids="+this.value;

			$.ajax({
				url:'workbench/customer/deleteCustomer.do',
				data:id,
				type:'post',
				datatype:'json',
				success:function (data){
					if(data.code=="1"){
						window.location.href="workbench/customer/index.do";
					}else{
						alert(data.message);
					}
				}
			})
		});


	});
	function showBtn(){
		$.ajax({
			url:'workbench/showMenu.do',
			type:'post',
			datatype:'json',
			success:function (data){
				if(data.includes("删除客户")){
					let htmlStr ="";
					htmlStr="<button type=\"button\" class=\"btn btn-danger\" id=\"deleteCustomerBtn\"><span class=\"glyphicon glyphicon-minus\"></span> 删除</button>"
					$("#customerBtnBox").append(htmlStr);
				}
				if(!data.includes("删除交易")){
					let tr =$("#tranTbody a[id='deleteTranA']");
					for (let i = 0; i < tr.length; i++) {
						tr[i].remove()
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

	<!-- 修改客户的模态窗口 -->
	<div class="modal fade" id="editCustomerModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="editModalLabel">修改客户</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form">
						<input type="hidden" id="edit-id1" value="${cut.id}">
						<div class="form-group">
							<label for="edit-owner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-owner">
									<c:forEach items="${userList}" var="ul">
										<c:if test="${cut.owner==ul.id}">
											<option value="${ul.id}" selected>${ul.name}</option>
										</c:if>
										<c:if test="${cut.owner!=ul.id}">
											<option value="${ul.id}">${ul.name}</option>
										</c:if>
									</c:forEach>
								</select>
							</div>
							<label for="edit-name" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-name" value="${cut.name}">
							</div>
						</div>

						<div class="form-group">
							<label for="edit-website" class="col-sm-2 control-label">公司网站</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-website" value="${cut.website}">
							</div>
							<label for="edit-phone" class="col-sm-2 control-label">公司座机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-phone" value="${cut.phone}">
							</div>
						</div>

						<div class="form-group">
							<label for="edit-description" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="edit-description">${cut.description}</textarea>
							</div>
						</div>

						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>

						<div style="position: relative;top: 15px;">
							<div class="form-group">
								<label for="edit-contactSummary" class="col-sm-2 control-label">联系纪要</label>
								<div class="col-sm-10" style="width: 81%;">
									<textarea class="form-control" rows="3" id="edit-contactSummary">${cut.contactSummary}</textarea>
								</div>
							</div>
							<div class="form-group">
								<label for="edit-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
								<div class="col-sm-10" style="width: 300px;">
									<input type="text" class="form-control myDate" id="edit-nextContactTime" value="${cut.nextContactTime}" readonly>
								</div>
							</div>
						</div>

						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

						<div style="position: relative;top: 20px;">
							<div class="form-group">
								<label for="edit-address" class="col-sm-2 control-label">详细地址</label>
								<div class="col-sm-10" style="width: 81%;">
									<textarea class="form-control" rows="1" id="edit-address">${cut.address}</textarea>
								</div>
							</div>
						</div>
					</form>

				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="updateCustomerBtn">更新</button>
				</div>
			</div>
		</div>
	</div>
	<!-- 删除客户的模态窗口 -->
	<div class="modal fade" id="removeCustomerModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 30%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">删除客户</h4>
				</div>
				<div class="modal-body">
					<p>您确定要删除该客户吗？</p>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
					<button type="button" class="btn btn-danger" id="removeCustomerBtn" value="${cut.id}"}>删除</button>
				</div>
			</div>
		</div>
	</div>

	<!-- 删除联系人的模态窗口 -->
	<div class="modal fade" id="removeContactModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 30%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">删除联系人</h4>
				</div>
				<div class="modal-body">
					<p>您确定要删除该联系人吗？</p>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
					<button type="button" class="btn btn-danger" id="removeContactBtn">删除</button>
				</div>
			</div>
		</div>
	</div>

    <!-- 删除交易的模态窗口 -->
    <div class="modal fade" id="removeTransactionModal" role="dialog">
        <div class="modal-dialog" role="document" style="width: 30%;">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">
                        <span aria-hidden="true">×</span>
                    </button>
                    <h4 class="modal-title">删除交易</h4>
                </div>
                <div class="modal-body">
                    <p>您确定要删除该交易吗？</p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
                    <button type="button" class="btn btn-danger" id="removeTranBtn">删除</button>
                </div>
            </div>
        </div>
    </div>

	<!-- 创建联系人的模态窗口 -->
	<div class="modal fade" id="createContactsModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" onclick="$('#createContactsModal').modal('hide');">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabelx">创建联系人</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form" id="createContactForm">

						<div class="form-group">
							<label for="create-owner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-owner">
									<option selected disabled hidden>请选择选项</option>
									<c:forEach items="${userList}" var="ul">
										<option value="${ul.id}">${ul.name}</option>
									</c:forEach>
								</select>
							</div>
							<label for="create-source" class="col-sm-2 control-label">来源</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-source">
									<option></option>
									<c:forEach items="${sourceList}" var="sl">
										<option value="${sl.id}">${sl.value}</option>
									</c:forEach>
								</select>
							</div>
						</div>

						<div class="form-group">
							<label for="create-fullname" class="col-sm-2 control-label">姓名<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-fullname">
							</div>
							<label for="create-appellation" class="col-sm-2 control-label">称呼</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-appellation">
									<option></option>
									<c:forEach items="${appellationList}" var="apl">
										<option value="${apl.id}">${apl.value}</option>
									</c:forEach>
								</select>
							</div>

						</div>

						<div class="form-group">
							<label for="create-job" class="col-sm-2 control-label">职位</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-job">
							</div>
							<label for="create-mphone" class="col-sm-2 control-label">手机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-mphone">
							</div>
						</div>

						<div class="form-group" style="position: relative;">
							<label for="create-email" class="col-sm-2 control-label">邮箱</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-email">
							</div>
							<label for="create-birth" class="col-sm-2 control-label">生日</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control myDate" id="create-birth" readonly>
							</div>
						</div>

						<div class="form-group" style="position: relative;">
							<label for="create-customerName" class="col-sm-2 control-label">客户名称</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control customerName" id="create-customerName" placeholder="支持自动补全，输入客户不存在则新建" value="${cut.name}" readonly>
							</div>
						</div>

						<div class="form-group" style="position: relative;">
							<label for="create-description" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="create-description"></textarea>
							</div>
						</div>

						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>

						<div style="position: relative;top: 15px;">
							<div class="form-group">
								<label for="create-contactSummary" class="col-sm-2 control-label">联系纪要</label>
								<div class="col-sm-10" style="width: 81%;">
									<textarea class="form-control" rows="3" id="create-contactSummary"></textarea>
								</div>
							</div>
							<div class="form-group">
								<label for="create-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
								<div class="col-sm-10" style="width: 300px;">
									<input type="text" class="form-control" id="create-nextContactTime">
								</div>
							</div>
						</div>

						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

						<div style="position: relative;top: 20px;">
							<div class="form-group">
								<label for="create-address" class="col-sm-2 control-label">详细地址</label>
								<div class="col-sm-10" style="width: 81%;">
									<textarea class="form-control" rows="1" id="create-address"></textarea>
								</div>
							</div>
						</div>
					</form>

				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="saveContactBtn">保存</button>
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
			<h3>${cut.name} <small><a href="${cut.website}" target="_blank">${cut.website}</a></small></h3>
		</div>
		<div style="position: relative; height: 50px; width: 500px;  top: -72px; left: 700px;" id="customerBtnBox">
			<button type="button" class="btn btn-default" id="editCustomerBtn"><span class="glyphicon glyphicon-edit"></span> 编辑</button>
<%--			<button type="button" class="btn btn-danger" id="deleteCustomerBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>--%>
		</div>
	</div>
	
	<br/>
	<br/>
	<br/>

	<!-- 详细信息 -->
	<div style="position: relative; top: -70px;">
		<div style="position: relative; left: 40px; height: 30px;">
			<div style="width: 300px; color: gray;">所有者</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${cut.ownerName}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">名称</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${cut.name}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 10px;">
			<div style="width: 300px; color: gray;">公司网站</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${cut.website}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">公司座机</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${cut.phone}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 20px;">
			<div style="width: 300px; color: gray;">创建者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${cut.createBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${cut.createTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 30px;">
			<div style="width: 300px; color: gray;">修改者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${cut.editBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${cut.editTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
        <div style="position: relative; left: 40px; height: 30px; top: 40px;">
            <div style="width: 300px; color: gray;">联系纪要</div>
            <div style="width: 630px;position: relative; left: 200px; top: -20px;">
                <b>
                    ${cut.contactSummary}
                </b>
            </div>
            <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
        </div>
        <div style="position: relative; left: 40px; height: 30px; top: 50px;">
            <div style="width: 300px; color: gray;">下次联系时间</div>
            <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${cut.nextContactTime}</b></div>
            <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px; "></div>
        </div>
		<div style="position: relative; left: 40px; height: 30px; top: 60px;">
			<div style="width: 300px; color: gray;">描述</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b>
					${cut.description}
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
        <div style="position: relative; left: 40px; height: 30px; top: 70px;">
            <div style="width: 300px; color: gray;">详细地址</div>
            <div style="width: 630px;position: relative; left: 200px; top: -20px;">
                <b>
                    ${cut.address}
                </b>
            </div>
            <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
        </div>
	</div>
	
	<!-- 备注 -->
	<div id="remarkDivList" style="position: relative; top: 10px; left: 40px;">
		<div id="remarkHeader" class="page-header">
			<h4>备注</h4>
		</div>

		<c:forEach items="${cutrList}" var="cutr">
			<div id="div_${cutr.id}" class="remarkDiv" style="height: 60px;">
				<img title="${cutr.createBy}" src="image/user-thumbnail.png" style="width: 30px; height:30px;">
				<div style="position: relative; top: -40px; left: 40px;" >
					<h5>${cutr.noteContent}</h5>
					<font color="gray">客户</font> <font color="gray">-</font> <b>${cut.name}</b> <small style="color: gray;"> ${cutr.editFlag=="0"?cutr.createTime:cutr.editTime} 由${cutr.editFlag=="0"?cutr.createBy:cutr.editBy}${cutr.editFlag=='0'?'创建':'修改'}</small>
					<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">
						<a class="myHref" id="editA" remarkId="${cutr.id}" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>
						&nbsp;&nbsp;&nbsp;&nbsp;
						<a class="myHref" id="deleteA" remarkId="${cutr.id}" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>
					</div>
				</div>
			</div>
		</c:forEach>
<%--		<!-- 备注1 -->--%>
<%--		<div class="remarkDiv" style="height: 60px;">--%>
<%--			<img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">--%>
<%--			<div style="position: relative; top: -40px; left: 40px;" >--%>
<%--				<h5>哎呦！</h5>--%>
<%--				<font color="gray">客户</font> <font color="gray">-</font> <b>北京动力节点</b> <small style="color: gray;"> 2017-01-22 10:10:10 由zhangsan</small>--%>
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
<%--				<font color="gray">客户</font> <font color="gray">-</font> <b>北京动力节点</b> <small style="color: gray;"> 2017-01-22 10:20:10 由zhangsan</small>--%>
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
	
	<!-- 交易 -->
	<div>
		<div style="position: relative; top: 20px; left: 40px;">
			<div class="page-header">
				<h4>交易</h4>
			</div>
			<div style="position: relative;top: 0px;">
				<table id="activityTable2" class="table table-hover" style="width: 900px;">
					<thead>
						<tr style="color: #B3B3B3;">
							<td>名称</td>
							<td>金额</td>
							<td>阶段</td>
							<td>可能性</td>
							<td>预计成交日期</td>
							<td>类型</td>
							<td></td>
						</tr>
					</thead>
					<tbody id="tranTbody">
						<c:forEach items="${tranList}" var="tl">
							<tr>
								<td><a href="workbench/transaction/queryTransactionForDetailById.do/${tl.id}" style="text-decoration: none;">${tl.name}</a></td>
								<td>${tl.money}</td>
								<td>${tl.stage}</td>
								<td>${tl.possibility}%</td>
								<td>${tl.expectedDate}</td>
								<td>${tl.type}</td>
								<td><a href="javascript:void(0);" id="deleteTranA" tranId="${tl.id}" style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>删除</a></td>
							</tr>
						</c:forEach>
					</tbody>
				</table>
			</div>
			
			<div>
				<a href="workbench/transaction/toSave.do" style="text-decoration: none;"><span class="glyphicon glyphicon-plus"></span>新建交易</a>
			</div>
		</div>
	</div>
	
	<!-- 联系人 -->
	<div>
		<div style="position: relative; top: 20px; left: 40px;">
			<div class="page-header">
				<h4>联系人</h4>
			</div>
			<div style="position: relative;top: 0px;">
				<table id="activityTable" class="table table-hover" style="width: 900px;">
					<thead>
						<tr style="color: #B3B3B3;">
							<td>名称</td>
							<td>邮箱</td>
							<td>手机</td>
							<td></td>
						</tr>
					</thead>
					<tbody id="contactTbody">
					<c:forEach items="${cotList}" var="cotl">
						<tr>
							<td><a href="workbench/contact/toDetail.do/${cotl.id}" style="text-decoration: none;">${cotl.fullname}</a></td>
							<td>${cotl.email}</td>
							<td>${cotl.mphone}</td>
							<td><a href="javascript:void(0);" id="deleteContactA" contactId="${cotl.id}" style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>删除</a></td>
						</tr>
					</c:forEach>
					</tbody>
				</table>
			</div>
			
			<div>
				<a href="javascript:void(0);" id="createContactBtn" style="text-decoration: none;"><span class="glyphicon glyphicon-plus"></span>新建联系人</a>
			</div>
		</div>
	</div>
	
	<div style="height: 200px;"></div>
</body>
</html>