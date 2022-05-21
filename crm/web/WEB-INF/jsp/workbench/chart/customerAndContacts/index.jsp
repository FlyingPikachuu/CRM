<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/";
%>
<html>
<head>
    <base href="<%=basePath%>">
    <!--引入jquery-->
    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
    <!--引入echarts插件-->
    <script type="text/javascript" src="jquery/echarts/echarts.min.js"></script>
    <title>演示echarts插件</title>
    <script type="text/javascript">
        $(function () {
            //当容器加载完成之后，对容器调用工具函数

            // 基于准备好的dom，初始化echarts实例
            $.ajax({
                url:'workbench/chart/customerAndContacts/queryCountOfCustomerByCutAddress.do',
                type:'post',
                datatype:"json",
                success:function (data){
                    let myChart = echarts.init(document.getElementById('main'));

                    // 指定图表的配置项和数据
                    let option = {
                        title: {
                            text: '线索来源分布图',
                            subtext: '线索表中不同来源的线索数量',
                            left: 'left'
                        },
                        tooltip: {
                            trigger: 'item'
                        },
                        legend: {
                            top: 'bottom'
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
                url:'workbench/chart/customerAndContacts/queryCountOfContactBySource.do',
                type:'post',
                datatype:"json",
                success:function (data){
                    let myChart = echarts.init(document.getElementById('main2'));

                    // 指定图表的配置项和数据
                    let option = {
                        title: {
                            text: '线索阶段统计图表',
                            subtext: '线索表中各个阶段的线索数量'
                        },
                        legend: {
                            top: 'bottom'
                        },
                        toolbox: {
                            show: true,
                            feature: {
                                mark: { show: true },
                                dataView: { show: true, readOnly: false },
                                restore: { show: true },
                                saveAsImage: { show: true }
                            }
                        },
                        series: [
                            {
                                name: 'Nightingale Chart',
                                type: 'pie',
                                radius: [30, 150],
                                center: ['50%', '50%'],
                                roseType: 'area',
                                itemStyle: {
                                    borderRadius: 8
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
                url:'workbench/chart/customerAndContacts/queryCountOfCustomerByCreateMonth.do',
                type:'post',
                datatype:"json",
                success:function (data){
                    let myChart = echarts.init(document.getElementById('main3'));
                    let date = new Date();
                    let year = date.getFullYear();
                    // 指定图表的配置项和数据

                    let option = {

                        title: {
                            text: year+'年每月创建客户和交易对比统计图'
                        },
                        tooltip: {
                            trigger: 'axis',
                            axisPointer: {
                                type: 'shadow'
                            }
                        },
                        legend: {
                            right:'right'
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
                                name: '客户量',
                                type: 'bar',
                                data: data.returnData2
                            },
                            {
                                name: '交易量',
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
                url:'workbench/chart/customerAndContacts/queryCountOfCustomerByOwnerAndCreate.do',
                type:'post',
                datatype:"json",
                success:function (data){
                    let myChart = echarts.init(document.getElementById('main4'));
                    let date = new Date();
                    console.log(date)
                    let year = date.getFullYear();
                    let month = date.getMonth()+1;
                    // 指定图表的配置项和数据
                    let option = {
                        // color: ['#c23531'],
                        title: {//标题
                            text: year+'年'+month+'月职员创建客户数量Top10',
                            // subtext: '测试副标题',
                            // textStyle: {
                            //     fontStyle: 'italic'
                            // }
                        },
                        tooltip: {//提示框
                            textStyle: {

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
            $.ajax({
                url:'workbench/chart/customerAndContacts/queryCountOfContactByOwnerAndCreate.do',
                type:'post',
                datatype:"json",
                success:function (data){
                    let myChart = echarts.init(document.getElementById('main5'));
                    let date = new Date();
                    console.log(date)
                    let year = date.getFullYear();
                    let month = date.getMonth()+1;
                    // 指定图表的配置项和数据
                    let option = {
                        // color: ['#c23531'],
                        title: {//标题
                            text: year+'年'+month+'月职员创建联系人数量Top10',
                            // subtext: '测试副标题',
                            // textStyle: {
                            //     fontStyle: 'italic'
                            // }
                        },
                        tooltip: {//提示框
                            textStyle: {

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

        });
    </script>
</head>
<body>
<!-- 为ECharts准备一个具备大小（宽高）的Dom -->
<div id="main" style="width: 600px;height:400px;float:left"></div>
<div id="main2" style="width: 600px;height:400px; float:left"></div>
<div id="main3" style="width: 1215px;height:400px;float:left"></div>
<div id="main4" style="width: 600px;height:400px;float:left"></div>
<div id="main5" style="width: 600px;height:400px;float:left"></div>
</body>
</html>
