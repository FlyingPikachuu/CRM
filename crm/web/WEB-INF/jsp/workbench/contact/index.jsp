<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
String basePath=request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+request.getContextPath()+"/";
%>
<html>
<base href="<%=basePath%>">
<head>
<meta charset="UTF-8">

	<%--jquery框架--%>
	<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
	<%--	bootstrap框架--%>
	<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" /><script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
	<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
	<%--	bootstrap日历插件--%>
	<link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />
	<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
	<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>

	<!--  PAGINATION plugin -->
	<link rel="stylesheet" type="text/css" href="jquery/bs_pagination-master/css/jquery.bs_pagination.min.css">
	<script type="text/javascript" src="jquery/bs_pagination-master/js/jquery.bs_pagination.min.js"></script>
	<script type="text/javascript" src="jquery/bs_pagination-master/localization/en.js"></script>

	<!--TYPEAHEAD-->
	<script type="text/javascript" src="jquery/bs_typeahead/bootstrap3-typeahead.min.js"></script>
<script type="text/javascript">

	$(function(){
		//自动补充客户名称
		$(".customerName").typeahead({
			source: function (jquery,process){
				//每次键盘弹起，都自动触发本函数；我们可以向后台送请求，查询客户表中所有的名称，把客户名称以[]字符串形式返回前台，赋值给source
				//process：是个函数，能够将['xxx','xxxxx','xxxxxx',.....]字符串赋值给source，从而完成自动补全
				//jquery：在容器中输入的关键字
				//var customerName=$("#customerName").val();
				//发送查询请求
				$.ajax({
					url:'workbench/contact/queryCustomerNameByName.do',
					data:{
						customerName: jquery
					},
					type:'post',
					datatype:'json',
					success:function (data){
						process(data);
					}
				})
			}
		});

		//日历插件
		$(".birth").datetimepicker({
			language:'zh-CN',
			format:'yyyy-mm-dd',
			minView:'month',
			initialDate:new Date(),
			autoclose:true,
			todayBtn:true,
			clearBtn:true
		})
		$(".myDate").datetimepicker({
			language:'zh-CN',
			format:'yyyy-mm-dd',
			minView:'month',
			initialDate:new Date(),
			autoclose:true,
			todayBtn:true,
			clearBtn:true,
			pickerPosition:'top-right'
		})

		//定制字段
		$("#definedColumns > li").click(function(e) {
			//防止下拉菜单消失
	        e.stopPropagation();
	    });

		//给”创建“按钮添加单击事件
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
						queryContactByConditionForPage(1,$("#contact_pag").bs_pagination("getOption","rowsPerPage"))
					}else{
						alert(data.message);
						$("#createContactsModal").modal("show");
					}
				}
			})
		})
		//当联系人主页面加载完成之后,显示所有数据的第一页，默认pageSize=10
		queryContactByConditionForPage(1,10);
		//条件查询，保持当前的pageSize
		$("#queryContactBtn").click(function (){
			queryContactByConditionForPage(1,$("#contact_pag").bs_pagination("getOption","rowsPerPage"));
		});

		//给'全选'复选框添加单击事件
		$("#checkAllContact").click(function (){
			$("#contactTbody input[type='checkbox']").prop("checked",this.checked);
		});
		//给列表的复选框添加单击事件 方式二 针对动态生成元素
		$("#contactTbody").on("click","input[type='checkbox']",function (){
			if($("#contactTbody input[type='checkbox']").size()==$("#contactTbody input[type='checkbox']:checked").size()){
				$("#checkAllContact").prop("checked",true);
			}
			else{
				$("#checkAllContact").prop("checked",false);
			}
		})
		//给”删除“按钮添加单击事件
		$("#deleteContactBtn").click(function (){
			let checkedIds = $("#contactTbody input[type='checkbox']:checked");
			if(checkedIds.size()==0){
				alert("请选择要删除的联系人");
				return;
			}
			if(window.confirm("确定删除吗？")){
				let ids="";
				$.each(checkedIds,function (){
					ids+="ids="+this.value+"&";
				})
				//去除最后一个&
				ids = ids.substr(0,ids.length-1);
				$.ajax({
					url:'workbench/contact/deleteContact.do',
					data:ids,
					type:'post',
					datatype:'json',
					success:function (data){
						if(data.code=="1"){
							queryContactByConditionForPage($("#contact_pag").bs_pagination("getOption","currentPage"),$("#contact_pag").bs_pagination("getOption","rowsPerPage"))
						}else{
							alert(data.message);
						}
					}
				})
			}

		});
		//给”修改“按钮添加点击事件
		$("#editContactBtn").click(function (){
			let checkedIds = $("#contactTbody input[type='checkbox']:checked");
			if(checkedIds.size()==0){
				alert("请选择要修改的市场活动");
				return;
			}
			if(checkedIds.size()>1){
				alert("每次只能修改一条市场活动");
				return;
			}
			// 取dom对象属性值三种方法
			// let id=checkedIds.val();
			// let id=checkedIds.get(0).value;
			let id=checkedIds[0].value;
			$.ajax({
				url:'workbench/contact/queryContactByIdForEdit.do',
				data:{
					id:id
				},
				type:'post',
				datatype:'json',
				success:function (data){
					$("#edit-id").val(id);
					$("#edit-owner").val(data.owner);
					$("#edit-source").val(data.source);
					$("#edit-customerName").val(data.customerId);
					$("#edit-fullname").val(data.fullname);
					$("#edit-appellation").val(data.appellation);
					$("#edit-email").val(data.email);
					$("#edit-mphone").val(data.mphone);
					$("#edit-job").val(data.job);
					$("#edit-birth").val(data.birth);
					$("#edit-description").val(data.description);
					$("#edit-contactSummary").val(data.contactSummary);
					$("#edit-nextContactTime").val(data.nextContactTime);
					$("#edit-address").val(data.address);

					$("#editContactsModal").modal("show");
				}
			})
		});

		//给”更新“按钮添加点击事件
		$("#updateContactBtn").click(function (){
			let id=$("#edit-id").val();
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
						queryContactByConditionForPage($("#contact_pag").bs_pagination("getOption","currentPage"),$("#contact_pag").bs_pagination("getOption","rowsPerPage"))
					}else{
						alert(data.message);
						$("#editContactsModal").modal("show");
					}
				}
			})
		})

		
	});

	function queryContactByConditionForPage(pageNo,pageSize){
		let owner = $.trim($("#query-owner").val());
		let fullname = $.trim($("#query-fullname").val());
		let customerName = $("#query-customerName").val();
		let source = $("#query-source").val();
		let birth = $("#query-birth").val();

		$.ajax({
			url:'workbench/contact/queryContactByConditionForPage.do',
			data:{
				owner:owner,
				fullname:fullname,
				customerName:customerName,
				source:source,
				birth:birth,
				pageNo:pageNo,
				pageSize:pageSize
			},
			type:'post',
			datatype:'json',
			success:function (data){
				let htmlStr='';
				$.each(data.cotList,function (index,cot){
					htmlStr+="<tr>"
					htmlStr+="<td><input type=\"checkbox\" value='"+cot.id+"'/></td>"
					htmlStr+="<td><a style=\"text-decoration: none; cursor: pointer;\" onclick=\"window.location.href='workbench/contact/toDetail.do/"+cot.id+"';\">"+cot.fullname+"</a></td>"
					htmlStr+="<td>"+cot.customerId+"</td>"
					htmlStr+="<td>"+cot.owner+"</td>"
					htmlStr+="<td>"+cot.source+"</td>"
					htmlStr+="<td>"+cot.birth+"</td>"
					htmlStr+="</tr>"
				});
				$("#contactTbody").html(htmlStr);

				//ajax 异步刷新只刷了表单没有刷表头
				//取消全选按钮
				$("#checkAllContact").prop("checked",false);

				//计算totalPages
				let totalPages=1;
				if(data.totalRows%pageSize==0){
					totalPages=data.totalRows/pageSize;
				}else{
					totalPages=parseInt(data.totalRows/pageSize)+1;
				}


				//函数位置选择，执行函数需要保证已查到totalRows
				//对容器调用bs_pagination分页工具函数，显示翻页信息
				$("#contact_pag").bs_pagination({
					currentPage: pageNo,//当前页号,默认1相当于pageNo

					rowsPerPage: pageSize,//每页显示条数,默认10,相当于pageSize m
					totalRows: data.totalRows,//总条数 默认1000
					totalPages: totalPages,  //总页数,必填参数.

					visiblePageLinks: 5,//最多可以显示的翻页卡片数

					showGoToPage: true,//是否显示"跳转到"功能,默认true--显示
					showRowsPerPage: true,//是否显示"每页显示条数"功能。默认true--显示
					showRowsInfo: true,//是否显示记录的信息，默认true--显示

					//用户每次切换页号，都自动触发本函数;
					//功能：返回每次切换页号之后的pageNo和pageSize
					onChangePage: function (event, pageObj) {
						//pageObj就代表{}函数可以调用属性
						//js代码
						// alert(pageObj.currentPage);
						// alert(pageObj.rowsPerPage);
						queryContactByConditionForPage(pageObj.currentPage, pageObj.rowsPerPage);
					}
				});
			}
		});

	};

</script>
</head>
<body>

	
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
								<input type="text" class="form-control customerName" id="create-customerName" placeholder="支持自动补全，输入客户不存在则新建">
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
									<input type="text" class="form-control myDate" id="create-nextContactTime" readonly >
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
						<input type="hidden" id="edit-id">
						<div class="form-group">
							<label for="edit-owner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-owner">
									<c:forEach items="${userList}" var="ul">
										<option value="${ul.id}">${ul.name}</option>
									</c:forEach>
								</select>
							</div>
							<label for="edit-source" class="col-sm-2 control-label">来源</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-source">
								  <option></option>
									<c:forEach items="${sourceList}" var="sl">
										<option value="${sl.id}">${sl.value}</option>
									</c:forEach>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-fullname" class="col-sm-2 control-label">姓名<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-fullname" value="李四">
							</div>
							<label for="edit-appellation" class="col-sm-2 control-label">称呼</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-appellation">
								  <option></option>
									<c:forEach items="${appellationList}" var="apl">
										<option value="${apl.id}">${apl.value}</option>
									</c:forEach>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-job" class="col-sm-2 control-label">职位</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-job" value="CTO">
							</div>
							<label for="edit-mphone" class="col-sm-2 control-label">手机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-mphone" value="12345678901">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-email" class="col-sm-2 control-label">邮箱</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-email" value="lisi@bjpowernode.com">
							</div>
							<label for="edit-birth" class="col-sm-2 control-label">生日</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control myDate" id="edit-birth" readonly>
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-customerName" class="col-sm-2 control-label">客户名称</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control customerName" id="edit-customerName" placeholder="支持自动补全，输入客户不存在则新建" value="动力节点">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-description" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="edit-description">这是一条线索的描述信息</textarea>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>
						
						<div style="position: relative;top: 15px;">
							<div class="form-group">
								<label for="edit-contactSummary" class="col-sm-2 control-label">联系纪要</label>
								<div class="col-sm-10" style="width: 81%;">
									<textarea class="form-control" rows="3" id="edit-contactSummary"></textarea>
								</div>
							</div>
							<div class="form-group">
								<label for="edit-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
								<div class="col-sm-10" style="width: 300px;">
									<input type="text" class="form-control myDate" id="edit-nextContactTime" readonly>
								</div>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                        <div style="position: relative;top: 20px;">
                            <div class="form-group">
                                <label for="edit-address" class="col-sm-2 control-label">详细地址</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="1" id="edit-address">北京大兴区大族企业湾</textarea>
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
	
	
	
	
	
	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>联系人列表</h3>
			</div>
		</div>
	</div>
	
	<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
	
		<div style="width: 100%; position: absolute;top: 5px; left: 10px;">
		
			<div class="btn-toolbar" role="toolbar" style="height: 80px;">
				<form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">所有者</div>
				      <input id="query-owner" class="form-control" type="text">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">姓名</div>
				      <input id="query-fullname" class="form-control" type="text">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">客户名称</div>
				      <input id="query-customerName" class="form-control customerName" type="text">
				    </div>
				  </div>
				  
				  <br>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">来源</div>
				      <select id="query-source" class="form-control">
						  <option></option>
						  <c:forEach items="${sourceList}" var="sl">
							  <option value="${sl.id}">${sl.value}</option>
						  </c:forEach>
						</select>
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">生日</div>
				      <input id="query-birth" class="form-control birth" type="text" readonly placeholder="查询输入日期前一周内生日的联系人" style="width: 300px">
				    </div>
				  </div>
				  
				  <button type="button" class="btn btn-default"  id="queryContactBtn">查询</button>
				  
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 10px;">
				<div class="btn-group" style="position: relative; top: 18%;" id="contactBtnBox">
				  <button type="button" class="btn btn-primary" id="createContactBtn"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button type="button" class="btn btn-default" id="editContactBtn"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button type="button" class="btn btn-danger" id="deleteContactBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
				
				
			</div>
			<div style="position: relative;top: 20px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input id="checkAllContact" type="checkbox" /></td>
							<td>姓名</td>
							<td>客户名称</td>
							<td>所有者</td>
							<td>来源</td>
							<td>生日</td>
						</tr>
					</thead>
					<tbody id="contactTbody">
<%--						<tr>--%>
<%--							<td><input type="checkbox" /></td>--%>
<%--							<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.html';">李四</a></td>--%>
<%--							<td>动力节点</td>--%>
<%--							<td>zhangsan</td>--%>
<%--							<td>广告</td>--%>
<%--							<td>2000-10-10</td>--%>
<%--						</tr>--%>
<%--                        <tr class="active">--%>
<%--                            <td><input type="checkbox" /></td>--%>
<%--                            <td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.html';">李四</a></td>--%>
<%--                            <td>动力节点</td>--%>
<%--                            <td>zhangsan</td>--%>
<%--                            <td>广告</td>--%>
<%--                            <td>2000-10-10</td>--%>
<%--                        </tr>--%>
					</tbody>
				</table>
				<div id="contact_pag"></div>
			</div>
			
<%--			<div style="height: 50px; position: relative;top: 10px;">--%>
<%--				<div>--%>
<%--					<button type="button" class="btn btn-default" style="cursor: default;">共<b>50</b>条记录</button>--%>
<%--				</div>--%>
<%--				<div class="btn-group" style="position: relative;top: -34px; left: 110px;">--%>
<%--					<button type="button" class="btn btn-default" style="cursor: default;">显示</button>--%>
<%--					<div class="btn-group">--%>
<%--						<button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown">--%>
<%--							10--%>
<%--							<span class="caret"></span>--%>
<%--						</button>--%>
<%--						<ul class="dropdown-menu" role="menu">--%>
<%--							<li><a href="#">20</a></li>--%>
<%--							<li><a href="#">30</a></li>--%>
<%--						</ul>--%>
<%--					</div>--%>
<%--					<button type="button" class="btn btn-default" style="cursor: default;">条/页</button>--%>
<%--				</div>--%>
<%--				<div style="position: relative;top: -88px; left: 285px;">--%>
<%--					<nav>--%>
<%--						<ul class="pagination">--%>
<%--							<li class="disabled"><a href="#">首页</a></li>--%>
<%--							<li class="disabled"><a href="#">上一页</a></li>--%>
<%--							<li class="active"><a href="#">1</a></li>--%>
<%--							<li><a href="#">2</a></li>--%>
<%--							<li><a href="#">3</a></li>--%>
<%--							<li><a href="#">4</a></li>--%>
<%--							<li><a href="#">5</a></li>--%>
<%--							<li><a href="#">下一页</a></li>--%>
<%--							<li class="disabled"><a href="#">末页</a></li>--%>
<%--						</ul>--%>
<%--					</nav>--%>
<%--				</div>--%>
<%--			</div>--%>
<%--			--%>
		</div>
		
	</div>
</body>
</html>