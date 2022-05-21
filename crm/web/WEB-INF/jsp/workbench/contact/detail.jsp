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
		$(document).keydown(function (event){
			if(event.keyCode == 13){
				$(".modal-content").each(function (){
					event.preventDefault();
				});
			}
		});
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
			let contactId = '${cot.id}';

			if(noteContent==''){
				alert("备注内容不为空！");
				return;
			}

			$.ajax({
				url:'workbench/contact/addContactRemark.do',
				data:{
					noteContent:noteContent,
					contactId:contactId
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
						htmlStr+="<font color=\"gray\">联系人</font> <font color=\"gray\">-</font> <b>${cot.fullname}${cot.appellation==null?"":cot.appellation}-${cot.customerId}</b> <small style=\"color: gray;\"> "+data.returnData.createTime+" 由${sessionScope.userInfo.name}</small>"
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
				url:'workbench/Contact/editContactRemark.do',
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
				url:'workbench/contact/deleteContactRemark.do',
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
			let contactId = '${cot.id}';

			//发送请求
			$.ajax({
				url:'workbench/contact/queryActivityForDetailByNameExpContactId.do',
				data:{
					activityName:activityName,
					contactId:contactId
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
			ids+="contactId=${cot.id}";

			//发送请求
			$.ajax({
				url:'workbench/contact/addRelation.do',
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
		$("#bundTbody").on("click","#unBundA",function (){
			//收集参数
			let activityId=$(this).attr("activityId");
			console.log(activityId);
			let contactId = '${cot.id}';

			if(window.confirm("确定解除吗？")){
				//发送请求
				$.ajax({
					url:'workbench/contact/deleteRelation.do',
					data:{
						activityId:activityId,
						contactId:contactId
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

		//给编辑按钮添加单击事件
		$("#editContactBtn").click(function (){
			$("#editContactsModal").modal("show");
		});
		//给”更新“按钮添加点击事件
		$("#updateContactBtn").click(function (){
			let id=$("#edit-id1").val();
			let owner=$("#edit-owner").val();
			let source=$("#edit-source").val();
			let customerName=$("#edit-customerName").val();
			let fullname=$("#edit-fullname").val();
			let appellation=$("#edit-appellation").val();
			let email=$("#edit-email").val();
			let mphone=$("#edit-mphone").val();
			let job=$("#edit-job").val();
			let birth=$("#edit-birth").val();
			let description=$("#edit-description").val();
			let contactSummary=$("#edit-contactSummary").val();
			let nextContactTime=$("#edit-nextContactTime").val();
			let address=$("#edit-address").val();

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
				url:'workbench/contact/editContact.do',
				data:{
					id : id,
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
				datatype: 'json',
				success:function (data){
					if(data.code=="1"){
						$("#editContactsModal").modal("hide");
						window.location.reload();
					}else{
						alert(data.message);
						$("#editContactsModal").modal("show");
					}
				}
			})
		})

		//给删除客户按钮添加单击事件
		$("#deleteContactBtn").click(function (){
			$("#removeContactModal").modal("show");
		});
		$("#removeContactBtn").click(function (){
			let id="ids="+this.value;
			alert(id);
			$.ajax({
				url:'workbench/contact/deleteContact.do',
				data:id,
				type:'post',
				datatype:'json',
				success:function (data){
					if(data.code=="1"){
						window.location.href="workbench/contact/index.do";
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
				if(!data.includes("删除交易")){
					let tr =$("#tranTbody a[name='deleteTranA']");
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

	<!-- 修改联系人的模态窗口 -->
	<div class="modal fade" id="editContactsModal" role="dialog">
	<div class="modal-dialog" role="document" style="width: 85%;">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal">
					<span aria-hidden="true">×</span>
				</button>
				<h4 class="modal-title" id="myModalLabel1">修改联系人</h4>
			</div>
			<div class="modal-body">
				<form class="form-horizontal" role="form">
					<input type="hidden" id="edit-id1" value="${cot.id}">
					<div class="form-group">
						<label for="edit-owner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
						<div class="col-sm-10" style="width: 300px;">
							<select class="form-control" id="edit-owner">
								<c:forEach items="${userList}" var="ul">
									<c:if test="${cot.owner==ul.id}">
										<option value="${ul.id}" selected>${ul.name}</option>
									</c:if>
									<c:if test="${cot.owner!=ul.id}">
										<option value="${ul.id}">${ul.name}</option>
									</c:if>
								</c:forEach>
							</select>
						</div>
						<label for="edit-source" class="col-sm-2 control-label">来源</label>
						<div class="col-sm-10" style="width: 300px;">
							<select class="form-control" id="edit-source">
								<option></option>
								<c:forEach items="${sourceList}" var="sl">
									<c:if test="${cot.source==sl.value}">
										<option value="${sl.id}" selected>${sl.value}</option>
									</c:if>
									<c:if test="${cot.source!=sl.value}">
										<option value="${sl.id}">${sl.value}</option>
									</c:if>
								</c:forEach>
							</select>
						</div>
					</div>

					<div class="form-group">
						<label for="edit-fullname" class="col-sm-2 control-label">姓名<span style="font-size: 15px; color: red;">*</span></label>
						<div class="col-sm-10" style="width: 300px;">
							<input type="text" class="form-control" id="edit-fullname" value="${cot.fullname}">
						</div>
						<label for="edit-appellation" class="col-sm-2 control-label">称呼</label>
						<div class="col-sm-10" style="width: 300px;">
							<select class="form-control" id="edit-appellation">
								<option></option>
								<c:forEach items="${appellationList}" var="apl">
									<c:if test="${cot.appellation==apl.value}">
										<option value="${apl.id}" selected>${apl.value}</option>
									</c:if>
									<c:if test="${cot.appellation!=apl.value}">
										<option value="${apl.id}">${apl.value}</option>
									</c:if>
								</c:forEach>
							</select>
						</div>
					</div>

					<div class="form-group">
						<label for="edit-job" class="col-sm-2 control-label">职位</label>
						<div class="col-sm-10" style="width: 300px;">
							<input type="text" class="form-control" id="edit-job" value="${cot.job}">
						</div>
						<label for="edit-mphone" class="col-sm-2 control-label">手机</label>
						<div class="col-sm-10" style="width: 300px;">
							<input type="text" class="form-control" id="edit-mphone" value="${cot.mphone}">
						</div>
					</div>

					<div class="form-group">
						<label for="edit-email" class="col-sm-2 control-label">邮箱</label>
						<div class="col-sm-10" style="width: 300px;">
							<input type="text" class="form-control" id="edit-email" value="${cot.email}">
						</div>
						<label for="edit-birth" class="col-sm-2 control-label">生日</label>
						<div class="col-sm-10" style="width: 300px;">
							<input type="text" class="form-control myDate" id="edit-birth" value="${cot.birth}" readonly>
						</div>
					</div>

					<div class="form-group">
						<label for="edit-customerName" class="col-sm-2 control-label">客户名称</label>
						<div class="col-sm-10" style="width: 300px;">
							<input type="text" class="form-control customerName" id="edit-customerName" placeholder="支持自动补全，输入客户不存在则新建" value="${cot.customerId}">
						</div>
					</div>

					<div class="form-group">
						<label for="edit-description" class="col-sm-2 control-label">描述</label>
						<div class="col-sm-10" style="width: 81%;">
							<textarea class="form-control" rows="3" id="edit-description">${cot.description}</textarea>
						</div>
					</div>

					<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>

					<div style="position: relative;top: 15px;">
						<div class="form-group">
							<label for="edit-contactSummary" class="col-sm-2 control-label">联系纪要</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="edit-contactSummary">${cot.contactSummary}</textarea>
							</div>
						</div>
						<div class="form-group">
							<label for="edit-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-nextContactTime" value="${cot.nextContactTime}">
							</div>
						</div>
					</div>

					<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

					<div style="position: relative;top: 20px;">
						<div class="form-group">
							<label for="edit-address" class="col-sm-2 control-label">详细地址</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="1" id="edit-address">${cot.address}</textarea>
							</div>
						</div>
					</div>
				</form>

			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
				<button type="button"class="btn btn-primary" id="updateContactBtn">更新</button>
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
					<button type="button" class="btn btn-danger" id="removeContactBtn" value="${cot.id}"}>删除</button>
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

	<!-- 修改联系人备注的模态窗口 -->
	<div class="modal fade" id="editRemarkModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 40%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" >修改备注</h4>
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

	<!-- 解除联系人和市场活动关联的模态窗口 -->
	<div class="modal fade" id="unbundActivityModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 30%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">解除关联</h4>
				</div>
				<div class="modal-body">
					<p>您确定要解除该关联关系吗？</p>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
					<button type="button" class="btn btn-danger" data-dismiss="modal">解除</button>
				</div>
			</div>
		</div>
	</div>

	<!-- 联系人和市场活动关联的模态窗口 -->
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
					<table id="unBundActivityTable" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
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
			<h3>${cot.fullname}${cot.appellation==null?"":cot.appellation} <small> - ${cot.customerId}</small></h3>
		</div>
		<div style="position: relative; height: 50px; width: 500px;  top: -72px; left: 700px;">
			<button type="button" class="btn btn-default" id="editContactBtn"><span class="glyphicon glyphicon-edit"></span> 编辑</button>
			<button type="button" class="btn btn-danger" id="deleteContactBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
		</div>
	</div>

	<br/>
	<br/>
	<br/>

	<!-- 详细信息 -->
	<div style="position: relative; top: -70px;">
		<div style="position: relative; left: 40px; height: 30px;">
			<div style="width: 300px; color: gray;">所有者</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${cot.ownerName}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">来源</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${cot.source}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 10px;">
			<div style="width: 300px; color: gray;">客户名称</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${cot.customerId}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">姓名</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${cot.fullname}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 20px;">
			<div style="width: 300px; color: gray;">邮箱</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${cot.email}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">手机</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${cot.mphone}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 30px;">
			<div style="width: 300px; color: gray;">职位</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${cot.job}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">生日</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${cot.birth}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 40px;">
			<div style="width: 300px; color: gray;">创建者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${cot.createBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${cot.createTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 50px;">
			<div style="width: 300px; color: gray;">修改者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${cot.editBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${cot.editTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 60px;">
			<div style="width: 300px; color: gray;">描述</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b>
					${cot.description}
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 70px;">
			<div style="width: 300px; color: gray;">联系纪要</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b>
					${cot.contactSummary}
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 80px;">
			<div style="width: 300px; color: gray;">下次联系时间</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${cot.nextContactTime}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
        <div style="position: relative; left: 40px; height: 30px; top: 90px;">
            <div style="width: 300px; color: gray;">详细地址</div>
            <div style="width: 630px;position: relative; left: 200px; top: -20px;">
                <b>
                    ${cot.address}
                </b>
            </div>
            <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
        </div>
	</div>
	<!-- 备注 -->
	<div id="remarkDivList" style="position: relative; top: 20px; left: 40px;">
		<div id="remarkHeader" class="page-header">
			<h4>备注</h4>
		</div>

		<c:forEach items="${cotrList}" var="cotr">
			<div id="div_${cotr.id}" class="remarkDiv" style="height: 60px;">
				<img title="${cotr.createBy}" src="image/user-thumbnail.png" style="width: 30px; height:30px;">
				<div style="position: relative; top: -40px; left: 40px;" >
					<h5>${cotr.noteContent}</h5>
					<font color="gray">联系人</font> <font color="gray">-</font> <b>${cot.fullname}${cot.appellation==null?"":cot.appellation}-${cot.customerId}</b> <small style="color: gray;"> ${cotr.editFlag=="0"?cotr.createTime:cotr.editTime} 由${cotr.editFlag=="0"?cotr.createBy:cotr.editBy}${cotr.editFlag=='0'?'创建':'修改'}</small>
					<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">
						<a class="myHref" id="editA" remarkId="${cotr.id}" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>
						&nbsp;&nbsp;&nbsp;&nbsp;
						<a class="myHref" id="deleteA" remarkId="${cotr.id}" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>
					</div>
				</div>
			</div>
		</c:forEach>
<%--		<!-- 备注1 -->--%>
<%--		<div class="remarkDiv" style="height: 60px;">--%>
<%--			<img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">--%>
<%--			<div style="position: relative; top: -40px; left: 40px;" >--%>
<%--				<h5>哎呦！</h5>--%>
<%--				<font color="gray">联系人</font> <font color="gray">-</font> <b>李四先生-北京动力节点</b> <small style="color: gray;"> 2017-01-22 10:10:10 由zhangsan</small>--%>
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
<%--				<font color="gray">联系人</font> <font color="gray">-</font> <b>李四先生-北京动力节点</b> <small style="color: gray;"> 2017-01-22 10:20:10 由zhangsan</small>--%>
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
				<table id="tranTable" class="table table-hover" style="width: 900px;">
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
							<td><a href="javascript:void(0);" name="deleteTranA"  tranId="${tl.id}" style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>删除</a></td>
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
	
	<!-- 市场活动 -->
	<div>
		<div style="position: relative; top: 60px; left: 40px;">
			<div class="page-header">
				<h4>市场活动</h4>
			</div>
			<div style="position: relative;top: 0px;">
				<table id="bundActivityTable" class="table table-hover" style="width: 900px;">
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
						<c:forEach items="${aList}" var="al">
							<tr id="tr_${al.id}">
								<td><a id="toDetailA" href="workbench/activity/queryActivityDetail.do/${al.id}" style="text-decoration: none;">${al.name}</a></td>
								<td>${al.startDate}</td>
								<td>${al.endDate}</td>
								<td>${al.owner}</td>
								<td><a id="unBundA" href="javascript:void(0);" id="unBundA" activityId="${al.id}" style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>解除关联</a></td>
							</tr>
						</c:forEach>
					</tbody>
				</table>
			</div>
			
			<div>
				<a href="javascript:void(0);" id="addBundBtn" style="text-decoration: none;"><span class="glyphicon glyphicon-plus"></span>关联市场活动</a>
			</div>
		</div>
	</div>
	
	
	<div style="height: 200px;"></div>
</body>
</html>