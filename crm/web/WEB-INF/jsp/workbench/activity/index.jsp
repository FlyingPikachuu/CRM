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
		//给创建按钮添加单击事件
		$("#createActivityBtn").click(function (){
			//初始化
			$("#createActivityForm").get(0).reset();
			// $("#createActivityForm")[0].reset();
			//弹出创建市场活动的模态窗口
			$("#createActivityModal").modal("show");
		})
		//给保存按钮添加单击事件
		$("#saveCreateActivityBtn").click(function (){
			let owner=$("#create-marketActivityOwner").val();
			let name=$.trim($("#create-marketActivityName").val());
			let startDate=$("#create-startDate").val();
			let endDate=$("#create-endDate").val();
			let cost=$.trim($("#create-cost").val());
			let description=$.trim($("#create-description").val());

			//表单验证 必填项
			if(owner==""){
				alert("所有者不能为空！");
				return;
			}
			if(name==""){
				alert("活动名称不能为空！");
				return;
			}
			if(startDate!=""&&endDate!=""){
				if(startDate>endDate){
					//使用字符串的大小代替日期的大小
					alert("结束日期比开始日期小！");
					return;
				}
			}
			let regExp= /^(([1-9]\d*)|0)$/;
			if(!regExp.test(cost)){
				alert("成本只能是非负整数！");
				return;
			}
			$.ajax({
				url:'workbench/activity/addActivity.do',
				data:{
					owner:owner,
					name:name,
					startDate:startDate,
					endDate:endDate,
					cost:cost,
					description:description
				},
				type:"post",
				dataType:"json",
				success:function (data){
					if(data.code==1){
						$("#createActivityModal").modal("hide");
						//刷新市场活动列，显示第一页数据，
						// 保持每页条数不变（前提：分页查询功能）
						queryActivityByConditionForPage(1,$("#activity_pag").bs_pagination("getOption","rowsPerPage"));

					}
					else{
						//提示信息
						alert(data.message);
						//模态窗口不关闭
						$("#createActivityModal").modal("show");
					}
				}

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
			clearBtn:true// 设置是否显示"清空"按钮 默认false
		});

		//当市场活动主页面加载完成，查询所有数据的第一页以及所有数据的总条数,默认每页显示10条
		queryActivityByConditionForPage(1,10);

		//给"查询"按钮添加单击事件
		$("#queryActivityBtn").click(function () {
			//查询所有符合条件数据的第一页以及所有符合条件数据的总条数;
			// 实现翻页查询每页显示条数不变
			//pagination插件 getOption 函数 获取当前客户端分页工具中用户选择的参数值
			queryActivityByConditionForPage(1,$("#activity_pag").bs_pagination("getOption","rowsPerPage"));
		});

		//给'全选'复选框添加单击事件
		$("#checkAllActivity").click(function (){
			//如果"全选"按钮是选中状态，则列表中所有checkbox都选中
			/* if(this.checked==true){
				$("#tBody input[type='checkbox']").prop("checked",true);
			}else{
				$("#tBody input[type='checkbox']").prop("checked",false);
			}*/
			$("#tBody input[type='checkbox']").prop("checked",this.checked);
		});

		 //给列表的复选框加单击事件 元素添加事件方式一 不可取，不执行
		// $("#tBody input[type='checkbox']").click(function (){
		//
		// })

		//给列表的复选框添加单击事件 方式二 针对动态生成元素
		$("#tBody").on("click","input[type='checkbox']",function (){
			//如果列表中的checkbox都选中，则”全选“按钮也选中
			//如果列表中的checkbox有至少一个未选中，则”全选“按钮也不选中

			//方式一；遍历 选择器获取了列表中所有的checkbox——jq对象，
			// 里面包含一个数组，数组由所有被选择的元素（dom对象）所组成，
			//遍历这个数组，判断每个checkbox为true还是false，若都是true那就都选中了，
			// 有一个不是就结束遍历，表示有没选中的
			//方式二：通过选择器获取列表中所有的checkbox，和列表中所有被选中的checkbox，
			// 两者都是由指定的dom对象所组成，比较两者长度，来判断是否都选中
			if($("#tBody input[type='checkbox']").size()==$("#tBody input[type='checkbox']:checked").size()){
				$("#checkAllActivity").prop("checked",true);
			}
			else{
				$("#checkAllActivity").prop("checked",false);
			}
		})

		//给”删除“按钮加单击事件
		$("#deleteActivityBtn").click(function (){
			//收集参数
			//获取列表中的所有被选中的checkbox 因为checkbox与id绑定
			let checkedIds=$("#tBody input[type='checkbox']:checked");
			if(checkedIds.size()==0){
				alert("请选择要删除的市场获得");
				return;
			}
			//confirm对话框是阻塞函数，不点就一直停在那，阻塞主，同意返回true，取消false
			if(window.confirm("确定删除吗？")){
				//获取所有 选择的checkbox上value属性值上绑定的id
				// 遍历checkedIds变量 选择jq函数
				let ids="";
				$.each(checkedIds,function (){
					//this 和 obj一样 从变量中取出元素放这俩里面
					//一般只有一个属性值时，用this 简单
					//!!!!!注意 这里拼接的ids要与controller方法中参数名相同
					ids+="ids="+this.value+"&";
				});
					//去除最后的&
					ids=ids.substr(0,ids.length-1);
					//发送请求
					alert(ids);
					$.ajax({
						url:'workbench/activity/deleteActivityByIds.do',
						data:ids,
						type:"post",
						dataType:'json',
						success:function (data){
							if(data.code=="1"){
								//刷新市场活动列表，显示第一页数据,保持翻页查询每页显示条数不变
								queryActivityByConditionForPage(1,$("#activity_pag").bs_pagination("getOption","rowsPerPage"));
							}
							else{
								//提示信息
								alert(data.message);
							}
						}
					});
			}
		});

		//给“修改”按钮加单击事件
		$("#editActivityBtn").click(function (){
			//收集参数
			//获取列表中选中的checkbox
			let checkedIds=$("#tBody input[type='checkbox']:checked");
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
			//发送请求
			$.ajax({
				url:'workbench/activity/queryActivityById.do',
				data:{
					id:id
				},
				type:'post',
				dataType:'json',
				success:function (data){
					//把要修改的活动信息显示在修改的模态窗口上
					$("#edit-id").val(data.id);
					$("#edit-marketActivityOwner").val(data.owner);
					$("#edit-marketActivityName").val(data.name);
					$("#edit-startDate").val(data.startDate);
					$("#edit-endDate").val(data.endDate);
					$("#edit-cost").val(data.cost);
					$("#edit-description").val(data.description);
					//弹出模态窗口
					$("#editActivityModal").modal("show");
				}
			})
		});

		//给“更新”按钮加单击事件
		$("#updateActivityBtn").click(function (){
			//收集参数
			let id = $("#edit-id").val();
			let owner = $("#edit-marketActivityOwner").val();
			let name = $("#edit-marketActivityName").val();
			let startDate= $("#edit-startDate").val();
			let endDate = $("#edit-endDate").val();
			let cost = $("#edit-cost").val();
			let description = $("#edit-description").val();

			//表单验证
			if(owner==""){
				alert("所有者不能为空！");
				return
			}
			if(name==""){
				alert("活动名称不能为空！");
				return;
			}
			if(startDate!=""&&endDate!=""){
				if(startDate>endDate){
					alert("结束时间小于开始时间！");
					return;
				}
			}
			let regExp=/^(([1-9]\d*)|0)$/;
			// test一个数据,匹配成功返回true 失败返回false
			if(!regExp.test(cost)){
				alert("成本必须为非负整数！");
				return;
			}

			//发送请求
			$.ajax({
				url:'workbench/activity/saveEditActivityById.do',
				data:{
					id:id,
					owner:owner,
					name:name,
					startDate:startDate,
					endDate:endDate,
					cost:cost,
					description,description
				},
				type:'post',
				dataType:'json',
				success:function (data){
					if(data.code==1){
						//关闭模态窗口
						$("#editActivityModal").modal("hide");
						//刷新市场活动列表，保持页数和每页显示条数不变
						queryActivityByConditionForPage($("#activity_pag").bs_pagination("getOption","currentPage"),$("#activity_pag").bs_pagination("getOption","rowsPerPage"));
					}
					else{
						//提示信息
						alert(data.message);
						//模态窗口不关闭
						$("#editActivityModal").modal("show");
					}
				}
			})
		})

		$("#exportActivityAllBtn").click(function (){
			//发送同步请求
			window.location.href="workbench/activity/exportQueryAllActivity.do";

		})

		//给上传按钮添加单击事件
		$("#uploadActivityBtn").click(function (){
			$("#importActivityModal").modal("show");
		})
		//给”导入”按钮加单击事件
		$("#importActivityBtn").click(function (){
			//收集参数
			let activityFileName = $("#activityFile").val();
			//表单验证
			let suffix=activityFileName.substr(activityFileName.lastIndexOf(".")+1).toLocaleLowerCase();
			if(suffix!="xls"){
				alert("系统仅支持xls文件");
				return;
			}
			let activityFile=$("#activityFile")[0].files[0];
			if(activityFile.size>5*1024*1024){
				alert("文件大小不能超过5MB！");
				return;
			}
			//FormData 是ajax提供的一个接口（js接口——就相当于java里的类，可以new对象，可以调方法）
			//可以模拟键值对向后台提交参数
			//最大优势，不但能提交文本数据字符串，还能提交二进制数据，以字节为单位
			let formData = new FormData();
			formData.append("activityFile",activityFile);
			formData.append("username","qsy");

			//发送请求
			$.ajax({
				url:'workbench/activity/importActivity.do',
				data:formData,
				processData:false,//用来设置ajax向后台提交参数前，是否把参数统一转换为字符串，true是(默认），false不是
				contentType:false,//用来设置ajax向后台提交参数前，是否把参数统一按urlencoded编码，true是(默认），false不是
				type:"post",
				dataType:"json",
				//处理响应
				success:function (data){
					if(data.code==1){
						//提示成功导入记录条数
						alert("成功导入"+data.returnData+"条记录");
						//关闭模态窗口
						$("#importActivityModal").modal("hide");
						//刷新市场活动列表,显示第一页数据,保持每页显示条数不变
						queryActivityByConditionForPage(1,$("#activity_pag").bs_pagination("getOption","rowsPerPage"));
					}
					else {
						//导入失败,提示信息
						alert(data.message);
						//模态窗口不关闭,列表也不刷新
						$("#importActivityModal").modal("show");

					}
				}

			});
		});



	});



	//分页查询封装函数
	function queryActivityByConditionForPage(pageNo,pageSize){
		let name=$("#query-Name").val();
		let owner=$("#query-Owner").val();
		let startDate=$("#query-startDate").val();
		let endDate=$("#query-endDate").val();
		// let pageNo=1;
		// let pageSize=10;
		$.ajax({
			url:'workbench/activity/queryActivityByConditionForPage.do',
			data:{
				name:name,
				owner:owner,
				startDate:startDate,
				endDate:endDate,
				pageNo:pageNo,
				pageSize:pageSize
			},
			type:'post',
			dataType:'json',
			success:function (data) {
				//显示总条数
				// $("#totalRowsB").text(data.totalRows);
				//显示市场活动的列表
				//遍历activityList，拼接所有行数据
				let htmlStr = "";
				$.each(data.activityList, function (index, obj) {
					htmlStr += "<tr class=\"active\">";
					htmlStr += "<td><input type=\"checkbox\" value=\"" + obj.id + "\"/></td>";
					htmlStr += "<td><a style=\"text-decoration: none; cursor: pointer;\" onclick=\"window.location.href='workbench/activity/queryActivityDetail.do?id="+obj.id+"'\">" + obj.name + "</a></td>";
					htmlStr += "<td>" + obj.owner + "</td>";
					htmlStr += "<td>" + obj.startDate + "</td>";
					htmlStr += "<td>" + obj.endDate + "</td>";
					htmlStr += "</tr>";
				});
				$("#tBody").html(htmlStr);

				//ajax 异步刷新只刷了表单没有刷表头
				//取消全选按钮
				$("#checkAllActivity").prop("checked",false);

				//计算totalPages
				let totalPages=1;
				if(data.totalRows%pageSize==0){
					totalPages=data.totalRows/pageSize;
				}
				else{
					totalPages=parseInt(data.totalRows/pageSize)+1;
				}


				//函数位置选择，执行函数需要保证已查到totalRows
				//对容器调用bs_pagination分页工具函数，显示翻页信息
				$("#activity_pag").bs_pagination({
					currentPage:pageNo,//当前页号,默认1相当于pageNo

					rowsPerPage:pageSize,//每页显示条数,默认10,相当于pageSize m
					totalRows:data.totalRows,//总条数 默认1000
					totalPages: totalPages,  //总页数,必填参数.

					visiblePageLinks:5,//最多可以显示的翻页卡片数

					showGoToPage:true,//是否显示"跳转到"功能,默认true--显示
					showRowsPerPage:true,//是否显示"每页显示条数"功能。默认true--显示
					showRowsInfo:true,//是否显示记录的信息，默认true--显示

					//用户每次切换页号，都自动触发本函数;
					//功能：返回每次切换页号之后的pageNo和pageSize
					onChangePage:function (event,pageObj){
						//pageObj就代表{}函数可以调用属性
						//js代码
						// alert(pageObj.currentPage);
						// alert(pageObj.rowsPerPage);
						queryActivityByConditionForPage(pageObj.currentPage,pageObj.rowsPerPage);
					}
				});
			}
		});
	}

</script>
</head>
<body>

	<!-- 创建市场活动的模态窗口 -->
	<div class="modal fade" id="createActivityModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel1">创建市场活动</h4>
				</div>
				<div class="modal-body">
				
					<form  id="createActivityForm" class="form-horizontal" role="form">
					
						<div class="form-group">
							<label for="create-marketActivityOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-marketActivityOwner">
									<c:forEach items="${userList}" var="users">
										<option value="${users.id}">${users.name}</option>
									</c:forEach>
								</select>
							</div>
                            <label for="create-marketActivityName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-marketActivityName">
                            </div>
						</div>
						
						<div class="form-group">
							<label for="create-startDate" class="col-sm-2 control-label">开始日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control myDate" name="myDate" id="create-startDate" readonly>
							</div>
							<label for="create-endDate" class="col-sm-2 control-label">结束日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control myDate" name="myDate"  id="create-endDate" readonly>
							</div>
						</div>
                        <div class="form-group">

                            <label for="create-cost" class="col-sm-2 control-label">成本</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-cost">
                            </div>
                        </div>
						<div class="form-group">
							<label for="create-description" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="create-description"></textarea>
							</div>
						</div>
						
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="saveCreateActivityBtn">保存</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 修改市场活动的模态窗口 -->
	<div class="modal fade" id="editActivityModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel2">修改市场活动</h4>
				</div>
				<div class="modal-body">
				
					<form class="form-horizontal" role="form">
						<input type="hidden" id="edit-id">
						<div class="form-group">
							<label for="edit-marketActivityOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-marketActivityOwner">
									<c:forEach items="${userList}" var="users">
										<option value="${users.id}">${users.name}</option>
									</c:forEach>
								</select>
							</div>
                            <label for="edit-marketActivityName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-marketActivityName" value="发传单">
                            </div>
						</div>

						<div class="form-group">
							<label for="edit-startDate" class="col-sm-2 control-label">开始日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control myDate" id="edit-startDate" value="2020-10-10" readonly>
							</div>
							<label for="edit-endDate" class="col-sm-2 control-label">结束日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control myDate" id="edit-endDate" value="2020-10-20" readonly>
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-cost" class="col-sm-2 control-label">成本</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-cost" value="5,000">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-description" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="edit-description">市场活动Marketing，是指品牌主办或参与的展览会议与公关市场活动，包括自行主办的各类研讨会、客户交流会、演示会、新产品发布会、体验会、答谢会、年会和出席参加并布展或演讲的展览会、研讨会、行业交流会、颁奖典礼等</textarea>
							</div>
						</div>
						
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="updateActivityBtn">更新</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 导入市场活动的模态窗口 -->
    <div class="modal fade" id="importActivityModal" role="dialog">
        <div class="modal-dialog" role="document" style="width: 85%;">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">
                        <span aria-hidden="true">×</span>
                    </button>
                    <h4 class="modal-title" id="myModalLabel">导入市场活动</h4>
                </div>
                <div class="modal-body" style="height: 350px;">
                    <div style="position: relative;top: 20px; left: 50px;">
                        请选择要上传的文件：<small style="color: gray;">[仅支持.xls]</small>
                    </div>
                    <div style="position: relative;top: 40px; left: 50px;">
                        <input type="file" id="activityFile">
                    </div>
                    <div style="position: relative; width: 400px; height: 320px; left: 45% ; top: -40px;" >
                        <h3>重要提示</h3>
                        <ul>
                            <li>操作仅针对Excel，仅支持后缀名为XLS的文件。</li>
                            <li>给定文件的第一行将视为字段名。</li>
                            <li>请确认您的文件大小不超过5MB。</li>
                            <li>日期值以文本形式保存，必须符合yyyy-MM-dd格式。</li>
                            <li>日期时间以文本形式保存，必须符合yyyy-MM-dd HH:mm:ss的格式。</li>
                            <li>默认情况下，字符编码是UTF-8 (统一码)，请确保您导入的文件使用的是正确的字符编码方式。</li>
                            <li>建议您在导入真实数据之前用测试文件测试文件导入功能。</li>
                        </ul>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                    <button id="importActivityBtn" type="button" class="btn btn-primary">导入</button>
                </div>
            </div>
        </div>
    </div>
	
	
	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>市场活动列表</h3>
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
				      <input class="form-control" type="text" id="query-Name">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">所有者</div>
				      <input class="form-control" type="text" id="query-Owner">
				    </div>
				  </div>


				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">开始日期</div>
					  <input class="form-control myDate" type="text" id="query-startDate" readonly/>
				    </div>
				  </div>
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">结束日期</div>
					  <input class="form-control myDate" type="text" id="query-endDate" readonly/>
				    </div>
				  </div>
				  
				  <button type="button" class="btn btn-default" id="queryActivityBtn">查询</button>
				  
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button type="button" class="btn btn-primary" id="createActivityBtn"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button type="button" class="btn btn-default" id="editActivityBtn"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button type="button" class="btn btn-danger" id="deleteActivityBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
				<div class="btn-group" style="position: relative; top: 18%;">
                    <button type="button" class="btn btn-default" id="uploadActivityBtn" ><span class="glyphicon glyphicon-import"></span> 上传列表数据（导入）</button>
                    <button id="exportActivityAllBtn" type="button" class="btn btn-default"><span class="glyphicon glyphicon-export"></span> 下载列表数据（批量导出）</button>
                    <button id="exportActivityXzBtn" type="button" class="btn btn-default"><span class="glyphicon glyphicon-export"></span> 下载列表数据（选择导出）</button>
                </div>
			</div>
			<div style="position: relative;top: 10px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input type="checkbox" id="checkAllActivity" /></td>
							<td>名称</td>
                            <td>所有者</td>
							<td>开始日期</td>
							<td>结束日期</td>
						</tr>
					</thead>
					<tbody id="tBody">
					</tbody>
				</table>
				<div id="activity_pag"></div>
			</div>
			
<%--			<div style="height: 50px; position: relative;top: 30px;">--%>
<%--				<div>--%>
<%--					<button type="button" class="btn btn-default" style="cursor: default;">共<b id="totalRowsB">50</b>条记录</button>--%>
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