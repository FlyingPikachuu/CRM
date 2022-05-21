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

<script type="text/javascript">

	$(function(){
		showBtn();
		queryCustomerByConditionForPage(1,10);
		$("#queryCustomerBtn").click(function (){
			queryCustomerByConditionForPage(1,$("#customer_pag").bs_pagination("getOption","rowsPerPage"));
		});
		$(".myDate").datetimepicker({
			language:'zh-CN',
			format:'yyyy-mm-dd',
			minView:'month',
			initialDate:new Date(),
			autoclose:true,
			todayBtn:true,
			clearBtn:true,
			pickerPosition:'top-right',
		});

		//定制字段
		$("#definedColumns > li").click(function(e) {
			//防止下拉菜单消失
	        e.stopPropagation();
	    });

		//给”创建“按钮添加单击事件
		$("#createCustomerBtn").click(function (){
			$("#createCustomerForm")[0].reset();
			$("#createCustomerModal").modal("show");
		});
		//给“保存”按钮添加点击事件
		$("#saveCustomerBtn").click(function (){
			let owner=$("#create-owner").val();
			let website = $("#create-website").val();
			let phone = $("#create-phone").val();
			let name=$("#create-name").val();
			let description=$("#create-description").val();
			let contactSummary=$("#create-contactSummary").val();
			let nextContactTime=$("#create-nextContactTime").val();
			let address=$("#create-address").val();

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
				url:'workbench/customer/addCustomer.do',
				data:{
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
				datatype:'json',
				success:function (data){
					if(data.code=="1"){
						$("#createCustomerModal").modal("hide");
						queryCustomerByConditionForPage(1,$("#customer_pag").bs_pagination("getOption","rowsPerPage"))
					}else{
						alert(data.message);
						$("#createCustomerModal").modal("show");
					}
				}
			})
		})

		//给'全选'复选框添加单击事件
		$("#checkAllCustomer").click(function (){
			$("#customerTbody input[type='checkbox']").prop("checked",this.checked);
		});
		//给列表的复选框添加单击事件 方式二 针对动态生成元素
		$("#customerTbody").on("click","input[type='checkbox']",function (){
			if($("#customerTbody input[type='checkbox']").size()==$("#customerTbody input[type='checkbox']:checked").size()){
				$("#checkAllCustomer").prop("checked",true);
			}
			else{
				$("#checkAllCustomer").prop("checked",false);
			}
		})
		//给”删除“按钮添加单击事件
		$("#customerBtnBox").on('click','#deleteCustomerBtn',function (){
			let checkedIds = $("#customerTbody input[type='checkbox']:checked");
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
					url:'workbench/customer/deleteCustomer.do',
					data:ids,
					type:'post',
					datatype:'json',
					success:function (data){
						if(data.code=="1"){
							queryCustomerByConditionForPage($("#customer_pag").bs_pagination("getOption","currentPage"),$("#customer_pag").bs_pagination("getOption","rowsPerPage"))
						}else{
							alert(data.message);
						}
					}
				})
			}

		});

		//给”修改“按钮添加点击事件
		$("#editCustomerBtn").click(function (){
			let checkedIds = $("#customerTbody input[type='checkbox']:checked");
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
				url:'workbench/customer/queryCustomerByIdForEdit.do',
				data:{
					id:id
				},
				type:'post',
				datatype:'json',
				success:function (data){
					$("#edit-id").val(data.id);
					$("#edit-owner").val(data.owner);
					$("#edit-website").val(data.website);
					$("#edit-phone").val(data.phone);
					$("#edit-name").val(data.name);
					$("#edit-description").val(data.description);
					$("#edit-contactSummary").val(data.contactSummary);
					$("#edit-nextContactTime").val(data.nextContactTime);
					$("#edit-address").val(data.address);

					$("#editCustomerModal").modal("show");
				}
			})
		});
		//给”更新“按钮添加点击事件
		$("#updateCustomerBtn").click(function (){
			let id=$("#edit-id").val();
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
						queryCustomerByConditionForPage($("#customer_pag").bs_pagination("getOption","currentPage"),$("#customer_pag").bs_pagination("getOption","rowsPerPage"))
					}else{
						alert(data.message);
						$("#editCustomerModal").modal("show");
					}
				}
			})
		})
		
	});
	function queryCustomerByConditionForPage(pageNo,pageSize){
		let name = $.trim($("#query-name").val());
		let owner = $.trim($("#query-owner").val());
		let phone = $.trim($("#query-phone").val());
		let website = $.trim($("#query-website").val());
		$.ajax({
			url:'workbench/customer/queryCustomerByConditionForPage.do',
			data:{
				name:name,
				owner:owner,
				phone:phone,
				website:website,
				pageNo:pageNo,
				pageSize:pageSize
			},
			type:'post',
			datatype:'json',
			success:function(data){
				let htmlStr='';
				$.each(data.cutList,function(index,cut){
					htmlStr+="<tr>"
					htmlStr+="<td><input value='"+cut.id+"' type=\"checkbox\" /></td>"
					htmlStr+="<td><a style=\"text-decoration: none; cursor: pointer;\" onclick=\"window.location.href='workbench/customer/toDetail.do/"+cut.id+"';\">"+cut.name+"</a></td>"
					htmlStr+="<td>"+cut.owner+"</td>"
					htmlStr+="<td>"+cut.phone+"</td>"
					htmlStr+="<td>"+cut.website+"</td>"
					htmlStr+="</tr>"
				});
				$("#customerTbody").html(htmlStr);
				//刷新checkbox
				$("#checkAllCustomer").prop("checked",false);

				let totalPages=1;
				if(data.totalRows%pageSize==0){
					totalPages=data.totalRows/pageSize;
				}else{
					totalPages=parseInt(data.totalRows/pageSize)+1;
				}

				$("#customer_pag").bs_pagination({
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
						queryCustomerByConditionForPage(pageObj.currentPage, pageObj.rowsPerPage);
					}
				});
			}
		})
	}
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
			}
		})
	}
</script>
</head>
<body>

	<!-- 创建客户的模态窗口 -->
	<div class="modal fade" id="createCustomerModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel1">创建客户</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form" id="createCustomerForm">
					
						<div class="form-group">
							<label for="create-owner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-owner">
								  <c:forEach items="${userList}" var="ul">
									  <option value="${ul.id}">${ul.name}</option>
								  </c:forEach>
								</select>
							</div>
							<label for="create-name" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-name">
							</div>
						</div>
						
						<div class="form-group">
                            <label for="create-website" class="col-sm-2 control-label">公司网站</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-website">
                            </div>
							<label for="create-phone" class="col-sm-2 control-label">公司座机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-phone">
							</div>
						</div>
						<div class="form-group">
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
                                    <input type="text" class="form-control myDate" id="create-nextContactTime" readonly>
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
					<button type="button" class="btn btn-primary" id="saveCustomerBtn">保存</button>
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
					<h4 class="modal-title" id="myModalLabel">修改客户</h4>
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
							<label for="edit-name" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-name" value="动力节点">
							</div>
						</div>
						
						<div class="form-group">
                            <label for="edit-website" class="col-sm-2 control-label">公司网站</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-website" value="http://www.bjpowernode.com">
                            </div>
							<label for="edit-phone" class="col-sm-2 control-label">公司座机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-phone" value="010-84846003">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-description" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="edit-description"></textarea>
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
                                    <textarea class="form-control" rows="1" id="edit-address">北京大兴大族企业湾</textarea>
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
	
	
	
	
	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>客户列表</h3>
			</div>
		</div>
	</div>
	
	<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
	
		<div style="width: 100%; position: absolute;top: 5px; left: 10px;">
		
			<div class="btn-toolbar" role="toolbar" style="height: 80px;">
				<form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">名称</div>
				      <input id="query-name" class="form-control" type="text">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">所有者</div>
				      <input id="query-owner" class="form-control" type="text">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">公司座机</div>
				      <input id="query-phone" class="form-control" type="text">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">公司网站</div>
				      <input id="query-website" class="form-control" type="text">
				    </div>
				  </div>
				  
				  <button type="button" class="btn btn-default" id="queryCustomerBtn">查询</button>
				  
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
				<div class="btn-group" style="position: relative; top: 18%;" id="customerBtnBox">
				  <button type="button" class="btn btn-primary" id="createCustomerBtn"></span> 创建</button>
				  <button type="button" class="btn btn-default" id="editCustomerBtn"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
<%--				  <button type="button" class="btn btn-danger" id="deleteCustomerBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>--%>
				</div>
				
			</div>
			<div style="position: relative;top: 10px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input id="checkAllCustomer" type="checkbox" /></td>
							<td>名称</td>
							<td>所有者</td>
							<td>公司座机</td>
							<td>公司网站</td>
						</tr>
					</thead>
					<tbody id="customerTbody">
<%--						<tr>--%>
<%--							<td><input type="checkbox" /></td>--%>
<%--							<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.html';">动力节点</a></td>--%>
<%--							<td>zhangsan</td>--%>
<%--							<td>010-84846003</td>--%>
<%--							<td>http://www.bjpowernode.com</td>--%>
<%--						</tr>--%>
<%--                        <tr class="active">--%>
<%--                            <td><input type="checkbox" /></td>--%>
<%--                            <td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.html';">动力节点</a></td>--%>
<%--                            <td>zhangsan</td>--%>
<%--                            <td>010-84846003</td>--%>
<%--                            <td>http://www.bjpowernode.com</td>--%>
<%--                        </tr>--%>
					</tbody>
				</table>
				<div id="customer_pag"></div>
			</div>
			
<%--			<div style="height: 50px; position: relative;top: 30px;">--%>
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
			
		</div>
		
	</div>
</body>
</html>