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
<link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />

<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>

<!--  PAGINATION plugin -->
<link rel="stylesheet" type="text/css" href="jquery/bs_pagination-master/css/jquery.bs_pagination.min.css">
<script type="text/javascript" src="jquery/bs_pagination-master/js/jquery.bs_pagination.min.js"></script>
<script type="text/javascript" src="jquery/bs_pagination-master/localization/en.js"></script>
<script type="text/javascript">

	$(function(){
		showBtn();
		//给线索“创建”按钮添加单击事件
		$("#createClueBtn").click(function (){
			//初始化模态窗口表单
			$("#createClueForm")[0].reset();
			//显示模态窗口
			$("#createClueModal").modal("show");
		})
		//给保存线索按钮添加单击事件
		$("#saveClueBtn").click(function (){
			//获取参数
			let fullname =$.trim($("#create-fullname").val());
			let appellation =$("#create-appellation").val();
			let owner =$("#create-owner").val();
			let company =$.trim($("#create-company").val());
			let job =$.trim($("#create-job").val());
			let email =$.trim($("#create-email").val());
			let phone =$.trim($("#create-phone").val());
			let website =$.trim($("#create-website").val());
			let mphone =$.trim($("#create-mphone").val());
			let state =$("#create-state").val();
			let source =$("#create-source").val();
			let description =$.trim($("#create-description").val());
			let contactSummary =$.trim($("#create-contactSummary").val());
			let nextContactTime =$.trim($("#create-nextContactTime").val());
			let address = $.trim($("#create-address").val());

			//表单验证
			if(company==""){
				alert("公司名不能为空！");
				return;
			}
			if(fullname==""){
				alert("客户名不能为空！");
				return;
			}
			let regExpEmail=/^\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$/;
			if(!regExpEmail.test(email)&&email!=""){
				alert("邮件格式不正确！");
				return;
			}
			let regExpPhone=/^((\d{3,4}-)|\d{3,4}-)?\d{7,8}$/;
			if(!regExpPhone.test(phone)&&phone!=""){
				alert("座机格式不正确！");
				return;
			}
			let regExpMphone=/^(13[0-9]|14[5|7]|15[0|1|2|3|5|6|7|8|9]|18[0|1|2|3|5|6|7|8|9])\d{8}$/;
			if(!regExpMphone.test(mphone)&&mphone!=""){
				alert("手机格式不正确！");
				return;
			}
			let regExpWebsite=/^(?:http(s)?:\/\/)?[\w.-]+(?:\.[\w\.-]+)+[\w\-\._~:/?#[\]@!\$&'\*\+,;=.]+$/;
			if(!regExpWebsite.test(website)&&website!=""){
				alert("公司网站格式不正确！");
				return;
			}

			//发送异步请求
			$.ajax({
				url:"workbench/clue/saveClue.do",
				data:{
					fullname:fullname,
					appellation:appellation,
					owner :owner ,
					company :company ,
					job :job ,
					email :email ,
					phone :phone ,
					website:website,
					mphone:mphone,
					state :state ,
					source :source ,
					description :description ,
					contactSummary:contactSummary,
					nextContactTime:nextContactTime,
					address :address
				},
				type:"post",
				datatype:"json",
				success:function (data){
					if(data.code==1){
						//关闭模态窗口
						$("#createClueModal").modal("hide");

						queryClueForPageByCondition(1,$("#clue_pag").bs_pagination("getOption","rowsPerPage"));

					}
					else{
						//提示信息
						alert(data.message);
						//显示模态窗口
						$("#createClueModal").modal("show");
					}
				}
				// ,
				// error:function (){
				// 	alert("您没有权限！");
				// 	$("#createClueModal").modal("hide");
				// }
			})
		})

		//容器加载完后，对容器调用工具类
		// $("input[name='myDate']").datetimepicker({})
		//容器内添加name 属性
		$(".myDate").datetimepicker({
			language:'zh-CN',//语言类型
			format:'yyyy-mm-dd',//日期格式
			minView:'month',//显示的最小时间
			initialDate:new Date(),//初始时间
			autoclose:true,//设置完时间后是否自动关闭
			todayBtn:true,//设置是否显示"今天"按钮，默认false
			clearBtn:true,// 设置是否显示"清空"按钮 默认false
			pickerPosition:'top-right'
		});

		//当线索主页面加载完成，查询所有数据的第一页以及所有数据的总条数,默认每页显示10条
		queryClueForPageByCondition(1,10);

		//给查询按钮添加单击事件
		$("#queryClueBtn").click(function (){
			queryClueForPageByCondition(1,$("#clue_pag").bs_pagination("getOption","rowsPerPage"));
		});
		
		//给“修改”按钮添加单击事件
		$("#editClueBtn").click(function (){
			let checkedIds = $("#clueTbody input[type='checkbox']:checked");
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
				url:'workbench/clue/queryClueByIdForEdit.do',
				data:{
					id:id
				},
				type:'post',
				datatype:'json',
				success:function (data){
					$("#edit-id").val(data.id);
					$("#edit-fullname").val(data.fullname);
					$("#edit-appellation").val(data.appellation);
					$("#edit-owner").val(data.owner);
					$("#edit-company").val(data.company);
					$("#edit-job").val(data.job);
					$("#edit-email").val(data.email);
					$("#edit-phone").val(data.phone);
					$("#edit-website").val(data.website);
					$("#edit-mphone").val(data.mphone);
					$("#edit-state").val(data.state);
					$("#edit-source").val(data.source);
					$("#edit-description").val(data.description);
					$("#edit-contactSummary").val(data.contactSummary);
					$("#edit-nextContactTime").val(data.nextContactTime);
					$("#edit-address").val(data.address);

					$("#editClueModal").modal("show");
				}
			})
		});
		//给“更新”按钮添加单击事件
		$("#updateClueBtn").click(function (){
			let id = $("#edit-id").val();
			let fullname =$.trim($("#edit-fullname").val());
			let appellation =$("#edit-appellation").val();
			let owner =$("#edit-owner").val();
			let company =$.trim($("#edit-company").val());
			let job =$.trim($("#edit-job").val());
			let email =$.trim($("#edit-email").val());
			let phone =$.trim($("#edit-phone").val());
			let website =$.trim($("#edit-website").val());
			let mphone =$.trim($("#edit-mphone").val());
			let state =$("#edit-state").val();
			let source =$("#edit-source").val();
			let description =$.trim($("#edit-description").val());
			let contactSummary =$.trim($("#edit-contactSummary").val());
			let nextContactTime =$.trim($("#edit-nextContactTime").val());
			let address = $.trim($("#edit-address").val());

			//表单验证
			if(company==""){
				alert("公司名不能为空！");
				return;
			}
			if(fullname==""){
				alert("客户名不能为空！");
				return;
			}
			let regExpEmail=/^\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$/;
			if(!regExpEmail.test(email)&&email!=""){
				alert("邮件格式不正确！");
				return;
			}
			let regExpPhone=/^((\d{3,4}-)|\d{3,4}-)?\d{7,8}$/;
			if(!regExpPhone.test(phone)&&phone!=""){
				alert("座机格式不正确！");
				return;
			}
			let regExpMphone=/^(13[0-9]|14[5|7]|15[0|1|2|3|5|6|7|8|9]|18[0|1|2|3|5|6|7|8|9])\d{8}$/;
			if(!regExpMphone.test(mphone)&&mphone!=""){
				alert("手机格式不正确！");
				return;
			}
			let regExpWebsite=/^(?:http(s)?:\/\/)?[\w.-]+(?:\.[\w\.-]+)+[\w\-\._~:/?#[\]@!\$&'\*\+,;=.]+$/;
			if(!regExpWebsite.test(website)&&website!=""){
				alert("公司网站格式不正确！");
				return;
			}

			$.ajax({
				url:'workbench/clue/editClue.do',
				data:{
					id :id,
					fullname:fullname,
					appellation:appellation,
					owner :owner ,
					company :company ,
					job :job ,
					email :email ,
					phone :phone ,
					website:website,
					mphone:mphone,
					state :state ,
					source :source ,
					description :description ,
					contactSummary:contactSummary,
					nextContactTime:nextContactTime,
					address :address
				},
				type:'post',
				datatype:'json',
				success:function (data){
					if(data.code=="1"){
						$("#editClueModal").modal("hide");
						queryClueForPageByCondition($("#clue_pag").bs_pagination("getOption","currentPage"),$("#clue_pag").bs_pagination("getOption","rowsPerPage"))
					}else{
						alert(data.message);
						$("#editClueModal").modal("show");
					}
				}
			})
		});
		
		//给“删除”按钮添加单击事件
		$("#clueBtnBox").on('click','#deleteClueBtn',function (){
			let checkedIds = $("#clueTbody input[type='checkbox']:checked");
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
					url:'workbench/clue/deleteClue.do',
					data:ids,
					type:'post',
					datatype:'json',
					success:function (data){
						if(data.code=="1"){
							queryClueForPageByCondition($("#clue_pag").bs_pagination("getOption","currentPage"),$("#clue_pag").bs_pagination("getOption","rowsPerPage"));
						}else{
							alert(data.message);
						}
					}
				})
			}

		});
	});
	function queryClueForPageByCondition(pageNo,pageSize){
		//收集参数
		let fullname  =$("#query-fullname").val();
		let company =$("#query-company ").val();
		let phone =$("#query-phone").val();
		let owner =$("#query-owner").val();
		let mphone =$("#query-mphone").val();
		let source =$("#query-source").val();
		let state =$("#query-state").val();
		console.log(state);

		//发送请求
		$.ajax({
			url:'workbench/clue/queryClueForPageByCondition.do',
			data:{
				fullname : fullname,
				company : company,
				phone  : phone,
				owner  : owner,
				mphone : mphone,
				source  : source,
				state  : state,
				pageNo  : pageNo,
				pageSize : pageSize
			},
			type:"get",
			datatype: "json",
			success:function (data) {
				//线索列表
				//遍历clueList,拼接所有行数据
				let htmlStr = "";
				$.each(data.clueList, function (index, obj) {
					htmlStr += "<tr>"
					htmlStr += "<td><input value='"+obj.id+"' type=\"checkbox\" /></td>"
					if(data.appellation==""||data.appellation==null){
						htmlStr += "<td><a style=\"text-decoration: none; cursor: pointer;\" onclick=\"window.location.href='workbench/clue/clueDetail.do/"+obj.id+"';\">" + obj.fullname + "</a></td>"
					}else{
						htmlStr += "<td><a style=\"text-decoration: none; cursor: pointer;\" onclick=\"window.location.href='workbench/clue/clueDetail.do/"+obj.id+"';\">" + obj.fullname + "" + obj.appellation + "</a></td>"
					}
					htmlStr += "<td>" + obj.company + "</td>"
					htmlStr += "<td>" + obj.phone + "</td>"
					htmlStr += "<td>" + obj.mphone + "</td>"
					htmlStr += "<td>" + obj.source + "</td>"
					htmlStr += "<td>" + obj.owner + "</td>"
					htmlStr += "<td>" + obj.state + "</td>"
					htmlStr += "</tr>"
				});
				$("#clueTbody").html(htmlStr);

				//取消全选按钮
				$("#checkAllClue").prop("checked", false);

				// 计算totalPages
				let totalPages = 1;
				if (data.totalRows % pageSize == 0) {
					totalPages = data.totalRows / pageSize;
				} else {
					totalPages = parseInt(data.totalRows / pageSize) + 1;
				}

				//执行函数时需保证已查到totalRows
				//对容器调用bs_pagination分页工具函数，显示翻页信息
				$("#clue_pag").bs_pagination({
					currentPage: pageNo,
					rowsPerPage: pageSize,
					totalRows: data.totalRows,
					totalPages: totalPages,

					visiblePageLinks: 5,

					showGoToPage: true,
					showRowsPerPage: true,
					showRowsInfo: true,

					//用户每次切换页号，触发本函数
					//返回每次切换也好厚的pageNo和pageSize
					onChangePage: function (event, pageObj) {
						queryClueForPageByCondition(pageObj.currentPage, pageObj.rowsPerPage);
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
				if(data.includes("删除线索")){
					let htmlStr ="";
					htmlStr="<button type=\"button\" class=\"btn btn-danger\" id=\"deleteClueBtn\"><span class=\"glyphicon glyphicon-minus\"></span> 删除</button>"
					$("#clueBtnBox").append(htmlStr);
				}
			}
		})
	}
	
</script>
</head>
<body>

	<!-- 创建线索的模态窗口 -->
	<div class="modal fade" id="createClueModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 90%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel">创建线索</h4>
				</div>
				<div class="modal-body">
					<form id="createClueForm" class="form-horizontal" role="form">
					
						<div class="form-group">
							<label for="create-owner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-owner">
								  <c:forEach items="${userList}" var="ul">
									  <option value="${ul.id}">${ul.name}</option>
								  </c:forEach>
								</select>
							</div>
							<label for="create-company" class="col-sm-2 control-label">公司<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-company">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-appellation" class="col-sm-2 control-label">称呼</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-appellation">
								  <option></option>
								  <c:forEach items="${appellation}" var="app">
									  <option value="${app.id}" >${app.value}</option>
								  </c:forEach>
								</select>
							</div>
							<label for="create-fullname" class="col-sm-2 control-label">姓名<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-fullname">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-job" class="col-sm-2 control-label">职位</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-job">
							</div>
							<label for="create-email" class="col-sm-2 control-label">邮箱</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-email">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-phone" class="col-sm-2 control-label">公司座机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-phone">
							</div>
							<label for="create-website" class="col-sm-2 control-label">公司网站</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-website">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-mphone" class="col-sm-2 control-label">手机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-mphone">
							</div>
							<label for="create-state" class="col-sm-2 control-label">线索状态</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-state">
								  <option></option>
								  <c:forEach items="${clueState}" var="cs">
									  <option value="${cs.id}">${cs.value}</option>
								  </c:forEach>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-source" class="col-sm-2 control-label">线索来源</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-source">
								  <option></option>
								  <c:forEach items="${source}" var="s">
									  <option value="${s.id}">${s.value}</option>
								  </c:forEach>
								</select>
							</div>
						</div>
						

						<div class="form-group">
							<label for="create-description" class="col-sm-2 control-label">线索描述</label>
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
					<button type="button" class="btn btn-primary" id="saveClueBtn">保存</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 修改线索的模态窗口 -->
	<div class="modal fade" id="editClueModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 90%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">修改线索</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form" id="editClueForm">
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
							<label for="edit-company" class="col-sm-2 control-label">公司<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-company" value="动力节点">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-appellation" class="col-sm-2 control-label">称呼</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-appellation">
								  <option></option>
									<c:forEach items="${appellation}" var="app">
										<option value="${app.id}" >${app.value}</option>
									</c:forEach>
								</select>
							</div>
							<label for="edit-fullname" class="col-sm-2 control-label">姓名<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-fullname" value="李四">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-job" class="col-sm-2 control-label">职位</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-job" value="CTO">
							</div>
							<label for="edit-email" class="col-sm-2 control-label">邮箱</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-email" value="lisi@bjpowernode.com">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-phone" class="col-sm-2 control-label">公司座机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-phone" value="010-84846003">
							</div>
							<label for="edit-website" class="col-sm-2 control-label">公司网站</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-website" value="http://www.bjpowernode.com">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-mphone" class="col-sm-2 control-label">手机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-mphone" value="12345678901">
							</div>
							<label for="edit-state" class="col-sm-2 control-label">线索状态</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-state">
								  <option></option>
									<c:forEach items="${clueState}" var="cs">
										<option value="${cs.id}">${cs.value}</option>
									</c:forEach>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-source" class="col-sm-2 control-label">线索来源</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-source">
								  <option></option>
									<c:forEach items="${source}" var="s">
										<option value="${s.id}">${s.value}</option>
									</c:forEach>
								</select>
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
									<textarea class="form-control" rows="3" id="edit-contactSummary">这个线索即将被转换</textarea>
								</div>
							</div>
							<div class="form-group">
								<label for="edit-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
								<div class="col-sm-10" style="width: 300px;">
									<input type="text" class="form-control myDate" id="edit-nextContactTime" value="2017-05-01" readonly>
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
					<button type="button" class="btn btn-primary" id="updateClueBtn">更新</button>
				</div>
			</div>
		</div>
	</div>
	
	
	
	
	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>线索列表</h3>
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
				      <input class="form-control" type="text" id="query-fullname">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">公司</div>
				      <input class="form-control" type="text" id="query-company">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">公司座机</div>
				      <input class="form-control" type="text" id="query-phone">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">线索来源</div>
					  <select class="form-control" id="query-source">
					  	  <option></option>
						  <c:forEach items="${source}" var="s">
							  <option value="${s.id}">${s.value}</option>
						  </c:forEach>
					  </select>
				    </div>
				  </div>
				  
				  <br>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">所有者</div>
				      <input class="form-control" type="text" id="query-owner">
				    </div>
				  </div>
				  
				  
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">手机</div>
				      <input class="form-control" type="text" id="query-mphone">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">线索状态</div>
					  <select class="form-control" id="query-state">
					  	<option></option>
						  <c:forEach items="${clueState}" var="cs">
							  <option value="${cs.id}">${cs.value}</option>
						  </c:forEach>
					  </select>
				    </div>
				  </div>

				  <button type="button" class="btn btn-default" id="queryClueBtn">查询</button>
				  
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 40px;">
				<div class="btn-group" style="position: relative; top: 18%;" id="clueBtnBox">
				  <button type="button" class="btn btn-primary" id="createClueBtn"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button type="button" class="btn btn-default" id="editClueBtn"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
<%--				  <button type="button" class="btn btn-danger" id="deleteClueBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>--%>
				</div>
				
				
			</div>
			<div style="position: relative;top: 50px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input type="checkbox" id="checkAllClue"/></td>
							<td>名称</td>
							<td>公司</td>
							<td>公司座机</td>
							<td>手机</td>
							<td>线索来源</td>
							<td>所有者</td>
							<td>线索状态</td>
						</tr>
					</thead>
					<tbody id="clueTbody">
<%--						<tr>--%>
<%--							<td><input type="checkbox" /></td>--%>
<%--							<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.html';">李四先生</a></td>--%>
<%--							<td>动力节点</td>--%>
<%--							<td>010-84846003</td>--%>
<%--							<td>12345678901</td>--%>
<%--							<td>广告</td>--%>
<%--							<td>zhangsan</td>--%>
<%--							<td>已联系</td>--%>
<%--						</tr>--%>
<%--                        <tr class="active">--%>
<%--                            <td><input type="checkbox" /></td>--%>
<%--                            <td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.html';">李四先生</a></td>--%>
<%--                            <td>动力节点</td>--%>
<%--                            <td>010-84846003</td>--%>
<%--                            <td>12345678901</td>--%>
<%--                            <td>广告</td>--%>
<%--                            <td>zhangsan</td>--%>
<%--                            <td>已联系</td>--%>
<%--                        </tr>--%>
					</tbody>
				</table>
				<div id="clue_pag"></div>
			</div>
			
<%--			<div style="height: 50px; position: relative;top: 60px;">--%>
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