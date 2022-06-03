<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
	String basePath=request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+request.getContextPath()+"/";
%>
<html>
<base href="<%=basePath%>">
<head>
	<head>
		<meta charset="utf-8" />
		<meta name="viewport" content="width=device-width, initial-scale=1.0" />
		<title>Home</title>
		<!-- FontAwesome Styles-->
		<link rel="stylesheet" type="text/css" href="assets/fonts/font-awesome-4.7.0/css/font-awesome.min.css">
		<%--jquery框架--%>
		<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
		<%--	bootstrap框架--%>
		<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" /><script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
		<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
		<!-- Custom Styles-->
		<link href="assets/css/custom-styles.css" rel="stylesheet" />
		<%--	bootstrap日历插件--%>
		<link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />
		<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
		<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
		<!--引入echarts插件-->
		<script type="text/javascript" src="jquery/echarts/echarts.min.js"></script>
		<script type="text/javascript">
			$(function (){
				showPageHeader();
				initDateInput();
				showNew();
				showCustomerBar();
				showFunnel();
				showPieChart();
				$("#queryBarBtn").click(function(){
					showNew();
					showCustomerBar();
					showFunnel();
					showPieChart();
				})
				$(".myDate").datetimepicker({
					language:'zh-CN',//语言类型
					format:'yyyy-mm-dd',//日期格式
					minView:'month',//显示的最小时间
					initialDate:new Date(),//初始时间
					autoclose:true,//设置完时间后是否自动关闭
					todayBtn:true,//设置是否显示"今天"按钮，默认false
					clearBtn:true// 设置是否显示"清空"按钮 默认false
				});


				$.ajax({
					url:'workbench/chart/transaction/queryCountOfTranAndSumMoneyGroupByCut.do',
					type:'post',
					datatype:"json",
					success:function (data){
						let myChart = echarts.init(document.getElementById('bar-chart'));
						const colors = ['#91CC75', '#EE6666'];
						// 指定图表的配置项和数据
						let option = {
							color: colors,
							tooltip: {
								trigger: 'axis',
								axisPointer: {
									type: 'cross'
								}
							},
							grid: {
								right: '20%'
							},
							toolbox: {
								feature: {
									dataView: { show: true, readOnly: false },
									restore: { show: true },
									saveAsImage: { show: true }
								}
							},
							legend: {

							},
							xAxis: [
								{
									type: 'category',
									axisTick: {
										alignWithLabel: true
									},
									// prettier-ignore
									data: data.returnData
								}
							],
							yAxis: [
								{
									type: 'value',
									name: '总交易量',
									position: 'right',
									alignTicks: true,
									axisLine: {
										show: true,
										lineStyle: {
											color: colors[0]
										}
									},
									axisLabel: {
										formatter: '{value}个'
									}
								},
								{
									type: 'value',
									name: '总金额',
									position: 'left',
									alignTicks: true,
									axisLine: {
										show: true,
										lineStyle: {
											color: colors[1]
										}
									},
									axisLabel: {
										formatter: '{value}元'
									}
								}
							],
							series: [
								{
									name: '总创建量',
									type: 'bar',
									data: data.returnData2
								},
								{
									name: '总金额',
									type: 'line',
									yAxisIndex: 1,
									data: data.returnData3
								}
							]
						};

						// 使用刚指定的配置项和数据显示图表。
						myChart.setOption(option);
					}
				})
				$.ajax({
					url:'workbench/chart/customerAndContacts/queryCountOfCustomerByCutAddress.do',
					type:'post',
					datatype:"json",
					success:function (data){
						let myChart = echarts.init(document.getElementById('pie-chart'));

						// 指定图表的配置项和数据
						let option = {
							tooltip: {
								trigger: 'item'
							},
							legend: {
								orient: 'vertical',
								left: 'left'
							},
							series: [
								{
									name: '客户地址',
									type: 'pie',
									radius: ['40%', '70%'],
									avoidLabelOverlap: false,
									itemStyle: {
										borderRadius: 10,
										borderColor: '#fff',
										borderWidth: 2
									},
									label: {
										show: false,
										position: 'center'
									},
									emphasis: {
										label: {
											show: true,
											fontSize: '40',
											fontWeight: 'bold'
										}
									},
									labelLine: {
										show: false
									},
									data: data
								}
							]
						};

						// 使用刚指定的配置项和数据显示图表。
						myChart.setOption(option);
					}
				})
				$.ajax({
					url:'workbench/chart/transaction/queryCountOfTranByCreateMonth.do',
					type:'post',
					datatype:"json",
					success:function (data){
						let myChart = echarts.init(document.getElementById('tran-bar-chart'));
						// 指定图表的配置项和数据

						let option = {
							tooltip: {
								trigger: 'axis',
								axisPointer: {
									type: 'shadow'
								}
							},
							toolbox: {
								feature: {
									dataView: { show: true, readOnly: false },
									restore: { show: true },
									saveAsImage: { show: true }
								}
							},
							legend: {
								left:'center'
							},
							grid: {
								left: '3%',
								right: '4%',
								bottom: '3%',
								containLabel: true
							},
							xAxis: {
								type: 'category',
								boundaryGap: [0, 0.01],
								data: data.returnData
							},
							yAxis: {
								type: 'value',

							},
							series: [
								{
									name: '创建量',
									type: 'bar',
									data: data.returnData2
								},
								{
									name: '成交量',
									type: 'bar',
									data: data.returnData3
								}
							]

						};

						// 使用刚指定的配置项和数据显示图表。
						myChart.setOption(option);
					}
				})
				$.ajax({
					url:'workbench/chart/transaction/querySumMoneyGroupByOwner.do',
					type:'post',
					datatype:"json",
					success:function (data){
						let myChart = echarts.init(document.getElementById('money-bar-chart'));
						// 指定图表的配置项和数据
						let option = {
							// color: ['#c23531'],
							tooltip: {//提示框
								textStyle: {

								}
							},
							toolbox: {
								feature: {
									dataView: { show: true, readOnly: false },
									restore: { show: true },
									saveAsImage: { show: true }
								}
							},
							// legend: {//图例
							//
							// },
							xAxis: {//x轴：数据项轴
								type:'value',

							},
							yAxis: {
								type:'category',
								data: data.returnData
							},//y轴：数量轴
							series: [{//系列
								name: '数量',//系列的名称
								type: 'bar',//系列的类型：bar--柱状图，line--折线图
								data: data.returnData2,//系列的数据
								itemStyle: {
									normal: {
										//这里是重点
										color: function(params) {
											//注意，如果颜色太少的话，后面颜色不会自动循环，最好多定义几个颜色
											var colorList = ['#c23531','#2f4554', '#61a0a8', '#d48265', '#91c7ae','#749f83', '#ca8622'];
											if (params.dataIndex >= colorList.length) {
												let index = params.dataIndex - colorList.length;
												return colorList[index];
											}
											return colorList[params.dataIndex];
											//给大于颜色数量的柱体添加循环颜色的判断

										}
									}
								}

							}]
						};

						// 使用刚指定的配置项和数据显示图表。
						myChart.setOption(option);
					}
				})


			})

			function showPageHeader(){
				let date = new Date();
				let year = date.getFullYear();
				let month = date.getMonth()+1;
				let name1 = year+'年每月交易创建和成交情况对比统计图';
				let name2 = year+'年'+month+'月职员业绩Top10';
				$("#tran-bar-head").text(name1);
				$("#money-bar-head").text(name2)
				let htmlStr="";
				let hello="";
				let name = '${sessionScope.userInfo.name}';
				console.log(date);
				if(date.getHours()>6&&date.getHours()<=12){
					hello="上午好！"
					htmlStr+=""+hello+" <small>"+name+"</small>"
				}
				if(date.getHours()>12&&date.getHours()<=18){
					hello="下午好！"
					htmlStr+=""+hello+" <small>"+name+"</small>"
				}
				if(date.getHours()>18&&date.getHours()<=24){
					hello ="晚上好"
					htmlStr+=""+hello+" <small>"+name+"</small>"
				}
				if(date.getHours()>0&&date.getHours()<=6){
					hello ="时间不早了，工作完，早点休息哦"
					htmlStr+=""+hello+" <small>"+name+"</small>"
				}

				$("#pageHeader").html(htmlStr);

			}
			function showCustomerBar(){

				let startDate = $("#startDate").val();
				let endDate = $("#endDate").val();
				if(startDate>endDate) {
					alert("开始时间必须小于等于结束时间!");
					return;
				}
				$.ajax({
					url:'workbench/chart/activity/queryActivityGroupByOwner.do',
					data:{
						startDate:startDate,
						endDate:endDate
					},
					type:'post',
					datatype:"json",
					success:function (data){
						let myChart = echarts.init(document.getElementById('customer-bar-chart'));

						// 指定图表的配置项和数据
						let option = {
							tooltip: {//提示框
								textStyle: {

								}
							},
							xAxis: {//x轴：数据项轴
								data: data.returnData
							},
							yAxis: {},//y轴：数量轴
							series: [{//系列
								name: '数量',//系列的名称
								type: 'bar',//系列的类型：bar--柱状图，line--折线图
								data: data.returnData2,//系列的数据
								itemStyle: {
									normal: {
										//这里是重点
										color: function(params) {
											//注意，如果颜色太少的话，后面颜色不会自动循环，最好多定义几个颜色
											var colorList = ['#c23531','#2f4554', '#61a0a8', '#d48265', '#91c7ae','#749f83', '#ca8622'];
											if (params.dataIndex >= colorList.length) {
												let index = params.dataIndex - colorList.length;
												return colorList[index];
											}
											return colorList[params.dataIndex];
											//给大于颜色数量的柱体添加循环颜色的判断

										}
									}
								}
							}]
						};

						// 使用刚指定的配置项和数据显示图表。
						myChart.setOption(option);
					}
				})

			}
			function showFunnel(){
				let startDate = $("#startDate").val();
				let endDate = $("#endDate").val();
				if(startDate>endDate) {
					alert("开始时间必须小于等于结束时间!");
					return;
				}
				$.ajax({
					url:'workbench/chart/transaction/queryCountOfTranGroupByStage.do',
					data:{
						startDate:startDate,
						endDate:endDate
					},
					type:'post',
					datatype:'json',
					success:function (data){
						//当容器加载完成之后，对容器调用工具函数

						// 基于准备好的dom，初始化echarts实例
						let myChart = echarts.init(document.getElementById('funnel-chart'));

						// 指定图表的配置项和数据
						let option = {
							tooltip: {
								trigger: 'item',
								formatter: "{a} <br/>{b} : {c}"
							},
							toolbox: {
								feature: {
									dataView: {readOnly: false},
									restore: {},
									saveAsImage: {}
								}
							},
							series: [
								{
									name: '数据量',
									type: 'funnel',
									left: '10%',
									width: '80%',
									label: {
										formatter: '{b}'
									},
									labelLine: {
										show: true
									},
									itemStyle: {
										opacity: 0.7
									},
									emphasis: {
										label: {
											position: 'inside',
											formatter: '{b}: {c}'
										}
									},
									data: data
								}
							]
						};

						// 使用刚指定的配置项和数据显示图表。
						myChart.setOption(option);

					}
				})
			}
			function  showPieChart(){
				let startDate = $("#startDate").val();
				let endDate = $("#endDate").val();
				if(startDate>endDate) {
					alert("开始时间必须小于等于结束时间!");
					return;
				}
				$.ajax({
						url: 'workbench/main/showPieChart.do',
						data: {
							startDate: startDate,
							endDate: endDate
						},
						type: 'post',
						datatype: "json",
						success: function (data) {

							$("#blue-span").text(data[0]+'%');
							$("#easypiechart-blue").attr("data-percent",data[0]);
							$("#easypiechart-blue canvas").remove();
							$("#teal-span").text(data[2]+'%');
							$("#easypiechart-teal").attr("data-percent",data[2]);
							$("#easypiechart-teal canvas").remove();
							$("#orange-span").text(data[3]+'%');
							$("#easypiechart-orange").attr("data-percent",data[3]);
							$("#easypiechart-orange canvas").remove();
							$("#red-span").text(data[1]+'%');
							$("#easypiechart-red").attr("data-percent",data[1]);
							$("#easypiechart-red canvas").remove();
							initpiechart();
						}
					});
			}
			function showNew(){
				let startDate = $("#startDate").val();
				let endDate = $("#endDate").val();
				if(startDate>endDate) {
					alert("开始时间必须小于等于结束时间!");
					return;
				}
				$.ajax({
					url: 'workbench/main/showNew.do',
					data: {
						startDate: startDate,
						endDate: endDate
					},
					type: 'post',
					datatype: "json",
					success: function (data) {

						$("#newActivityNum").text(data[0]);
						$("#newClueNum").text(data[1]);
						$("#newCustomerNum").text(data[2]);
						$("#newTranNum").text(data[3]);
					}
				})
			}
			function initDateInput(){
				let date = new Date();
				let year = date.getFullYear();
				let month = date.getMonth()+1;
				let sdate = new Date(date.getTime()-144*60*60*1000);
				let syear = sdate.getFullYear();
				let smonth = sdate.getMonth()+1;
				let sday = sdate.getDate();
				let day = date.getDate();
				month=addZero(month);
				smonth=addZero(smonth);
				sday=addZero(sday);
				day=addZero(day);
				let start = year+'-'+smonth+'-'+sday;
				let end = year+'-'+month+'-'+day;
				console.log(start);
				console.log(end);
				$("#startDate").val(start);
				$("#endDate").val(end);
			}
			function addZero(num){
				if(num>0&&num<10){
					num="0"+num;
				}
				return num;
			}
		</script>
	</head>

<body>
<div id="wrapper" style="background: whitesmoke;">

	<!-- /. NAV SIDE  -->
		<div id="page-inner" style="background-color: whitesmoke;margin:0px 0px 0px 0px;" >
			<div class="row" style="width: 1243px">
				<div class="col-md-3">
					<h1 class="page-header" id="pageHeader">
					</h1>
<%--					<ol class="breadcrumb">--%>
<%--						<li><a href="workbench/main/index2.do">Home</a></li>--%>
<%--						<li class="active">Data</li>--%>
<%--						<li class="active">日期:<input  id="startDate" type="text" class="myDate" readonly style="width: 213px">~<input id="endDate" type="text" class="myDate" readonly style="width: 213px">  <button type="button" id="queryBarBtn" >查询</button> </li>--%>
<%--					</ol>--%>

				</div>
				<div class="col-md-9">
					<div style="position:relative;top:20px;left: 350px">
						<div class="input-group">
							<div class="input-group-addon">日期:</div>
							<input class="form-control myDate" id="startDate" type="text"  readonly style="width: 213px"><input class="form-control myDate" id="endDate" type="text" readonly style="width: 213px">  <button type="button" class="btn btn-primary" id="queryBarBtn" >查询</button> </li>
						</div>
					</div>
				</div>
			</div>


			<!-- /. ROW  -->

			<div class="row" style="width: 1243px;">
				<div class="col-md-3 col-sm-12 col-xs-12">
					<div class="panel panel-primary text-center no-boder bg-color-brown brown">
						<div class="panel-left pull-left brown">
							<i class="fa fa-play-circle fa-5x"></i>

						</div>
						<div class="panel-right pull-right" style="height: 125px">
							<h3 id="newActivityNum">8,457</h3>
							<strong> 市场活动</strong>
						</div>
					</div>
				</div>
				<div class="col-md-3 col-sm-12 col-xs-12">
					<div class="panel panel-primary text-center no-boder bg-color-blue blue">
						<div class="panel-left pull-left blue">
							<i class="fa fa-search fa-5x"></i>
						</div>

						<div class="panel-right pull-right" style="height: 125px">
							<h3 id="newClueNum">52,160 </h3>
							<strong> 线索</strong>

						</div>
					</div>
				</div>
				<div class="col-md-3 col-sm-12 col-xs-12">
					<div class="panel panel-primary text-center no-boder bg-color-gree green">
						<div class="panel-left pull-left green">
							<i class="fa fa-user fa-5x"></i>

						</div>
						<div class="panel-right pull-right" style="height: 125px">
							<h3 id="newCustomerNum">15,823 </h3>
							<strong> 客户</strong>

						</div>
					</div>
				</div>
				<div class="col-md-3 col-sm-12 col-xs-12">
					<div class="panel panel-primary text-center no-boder bg-color-red red">
						<div class="panel-left pull-left red">
							<i class="fa fa-usd fa-5x"></i>

						</div>
						<div class="panel-right pull-right" style="height: 125px">
							<h3 id="newTranNum">36,752 </h3>
							<strong> 交易</strong>

						</div>
					</div>
				</div>
			</div>


			<div class="row" style="width: 1243px">
				<div class="col-md-4 col-sm-12 col-xs-12">
					<div class="panel panel-default">
						<div class="panel-heading" id="">
							职员新增市场活动数量统计图
						</div>
						<div class="panel-body">
							<div id="customer-bar-chart" style="width: 400px;height:400px;float: left">></div>
						</div>
					</div>
				</div>
				<div class="col-md-8 col-sm-12 col-xs-12">
					<div class="panel panel-default" >
						<div class="panel-heading">
							新增交易统计图表
						</div>
						<div class="panel-body">
							<div id="funnel-chart" style="width: 750px;height:400px;float: left"></div>
						</div>
					</div>
				</div>


			</div>



			<div class="row" style="width: 1243px">
				<div class="col-xs-6 col-md-3">
					<div class="panel panel-default">
						<div class="panel-body easypiechart-panel">
							<h4>新增市场活动产出线索率</h4>
							<div class="easypiechart" id="easypiechart-blue" data-percent="80" ><span class="percent" id="blue-span">80%</span>
							</div>
						</div>
					</div>
				</div>
				<div class="col-xs-6 col-md-3">
					<div class="panel panel-default">
						<div class="panel-body easypiechart-panel">
							<h4>新增线索已联系率</h4>
							<div class="easypiechart" id="easypiechart-orange" data-percent="88" ><span class="percent" id="orange-span">55%</span>
							</div>
						</div>
					</div>
				</div>
				<div class="col-xs-6 col-md-3">
					<div class="panel panel-default">
						<div class="panel-body easypiechart-panel">
							<h4>新增客户创建交易率</h4>
							<div class="easypiechart" id="easypiechart-teal" data-percent="84" ><span class="percent" id="teal-span">84%</span>
							</div>
						</div>
					</div>
				</div>
				<div class="col-xs-6 col-md-3" >
					<div class="panel panel-default" >
						<div class="panel-body easypiechart-panel" >
							<h4>新增交易成交率</h4>
							<div class="easypiechart" id="easypiechart-red" data-percent="46" ><span class="percent" id="red-span">46%</span>
							</div>
						</div>
					</div>
				</div>
			</div><!--/.row-->


			<div class="row" style="width: 1243px">
				<div class="col-md-7 col-sm-12 col-xs-12">
					<div class="panel panel-default" >
						<div class="panel-heading">
							历史成交客户交易创建量及总成交金额统计图
						</div>
						<div class="panel-body">
							<div id="bar-chart" style="width: 650px;height:400px;float: left"></div>
						</div>
					</div>
				</div>
				<div class="col-md-5 col-sm-12 col-xs-12">
					<div class="panel panel-default">
						<div class="panel-heading" id="money-bar-head">

						</div>
						<div class="panel-body">
							<div id="money-bar-chart" style="width: 450px;height:400px;float: left"></div>
						</div>
					</div>
				</div>

			</div>
			<div class="row" style="width: 1243px">
				<div class="col-md-12">
					<div class="panel panel-default">
						<div class="panel-heading" id="tran-bar-head">
							Area Chart
						</div>
						<div class="panel-body">
							<div id="tran-bar-chart" style="width: 1150px;height:400px;float: left"></div>
						</div>
					</div>
				</div>
			</div>
			<!-- /. ROW  -->





			<div class="row" style="width: 1243px">
				<div class="col-md-4 col-sm-12 col-xs-12">
					<div class="panel panel-default">
						<div class="panel-heading">
							线索来源分布图
						</div>
						<div class="panel-body">
							<div id="pie-chart" style="width: 400px;height:296px;float: left">
<%--							<div class="list-group">--%>

<%--								<a href="#" class="list-group-item">--%>
<%--									<span class="badge">7 minutes ago</span>--%>
<%--									<i class="fa fa-fw fa-comment"></i> Commented on a post--%>
<%--								</a>--%>
<%--								<a href="#" class="list-group-item">--%>
<%--									<span class="badge">16 minutes ago</span>--%>
<%--									<i class="fa fa-fw fa-truck"></i> Order 392 shipped--%>
<%--								</a>--%>
<%--								<a href="#" class="list-group-item">--%>
<%--									<span class="badge">36 minutes ago</span>--%>
<%--									<i class="fa fa-fw fa-globe"></i> Invoice 653 has paid--%>
<%--								</a>--%>
<%--								<a href="#" class="list-group-item">--%>
<%--									<span class="badge">1 hour ago</span>--%>
<%--									<i class="fa fa-fw fa-user"></i> A new user has been added--%>
<%--								</a>--%>
<%--								<a href="#" class="list-group-item">--%>
<%--									<span class="badge">1.23 hour ago</span>--%>
<%--									<i class="fa fa-fw fa-user"></i> A new user has added--%>
<%--								</a>--%>
<%--								<a href="#" class="list-group-item">--%>
<%--									<span class="badge">yesterday</span>--%>
<%--									<i class="fa fa-fw fa-globe"></i> Saved the world--%>
<%--								</a>--%>
<%--							</div>--%>
<%--							<div class="text-right">--%>
<%--								<a href="#">More Tasks <i class="fa fa-arrow-circle-right"></i></a>--%>
<%--							</div>--%>
						</div>
					</div>
					</div>
				</div>
				<div class="col-md-8 col-sm-12 col-xs-12">

					<div class="panel panel-default">
						<div class="panel-heading">
							北京客户总成交额TOP6
						</div>
						<div class="panel-body">
							<div class="table-responsive">
								<table class="table table-striped table-bordered table-hover">
									<thead>
									<tr>
										<th>序号</th>
										<th>客户名称</th>
										<th>客户座机</th>
										<th>客户网站</th>
										<th>客户总成交额</th>
									</tr>
									</thead>
									<tbody>
									<c:forEach items="${customerList}" var="cutl" varStatus="s">
										<tr >
											<td>${s.count}</td>
											<td>${cutl.name}</td>
											<td>${cutl.phone}</td>
											<td>${cutl.website}</td>
											<td> <fmt:formatNumber type="number" value="${cutl.money}" maxFractionDigits="0"/></td>
										</tr>
									</c:forEach>
<%--									<tr>--%>
<%--										<td>1</td>--%>
<%--										<td>John</td>--%>
<%--										<td>Doe</td>--%>
<%--										<td>John15482</td>--%>
<%--										<td>name@site.com</td>--%>
<%--									</tr>--%>
<%--									<tr>--%>
<%--										<td>2</td>--%>
<%--										<td>Kimsila</td>--%>
<%--										<td>Marriye</td>--%>
<%--										<td>Kim1425</td>--%>
<%--										<td>name@site.com</td>--%>
<%--									</tr>--%>
<%--									<tr>--%>
<%--										<td>3</td>--%>
<%--										<td>Rossye</td>--%>
<%--										<td>Nermal</td>--%>
<%--										<td>Rossy1245</td>--%>
<%--										<td>name@site.com</td>--%>
<%--									</tr>--%>
<%--									<tr>--%>
<%--										<td>4</td>--%>
<%--										<td>Richard</td>--%>
<%--										<td>Orieal</td>--%>
<%--										<td>Rich5685</td>--%>
<%--										<td>name@site.com</td>--%>
<%--									</tr>--%>
<%--									<tr>--%>
<%--										<td>5</td>--%>
<%--										<td>Jacob</td>--%>
<%--										<td>Hielsar</td>--%>
<%--										<td>Jac4587</td>--%>
<%--										<td>name@site.com</td>--%>
<%--									</tr>--%>
<%--									<tr>--%>
<%--										<td>6</td>--%>
<%--										<td>Wrapel</td>--%>
<%--										<td>Dere</td>--%>
<%--										<td>Wrap4585</td>--%>
<%--										<td>name@site.com</td>--%>
<%--									</tr>--%>
									</tbody>
								</table>
							</div>
						</div>
					</div>

				</div>
			</div>
			<!-- /. ROW  -->
			<footer><p>Copyright &copy; 2022.Aloha All rights reserved.</p></footer>
		</div>
		<!-- /. PAGE INNER  -->

	<!-- /. PAGE WRAPPER  -->
</div>
<!-- /. WRAPPER  -->


<script src="assets/js/easypiechart.js"></script>
<%--<script src="assets/js/easypiechart-data.js"></script>--%>
<script type="text/javascript">
	function initpiechart(){
		$('#easypiechart-teal').easyPieChart({
			scaleColor: false,
			barColor: '#1ebfae'
		});
		$('#easypiechart-orange').easyPieChart({
			scaleColor: false,
			barColor: '#ffb53e'
		});
		$('#easypiechart-red').easyPieChart({
			scaleColor: false,
			barColor: '#f9243f'
		});
		$('#easypiechart-blue').easyPieChart({
			scaleColor: false,
			barColor: '#30a5ff'
		});
	};





</script>




</body>

</html>