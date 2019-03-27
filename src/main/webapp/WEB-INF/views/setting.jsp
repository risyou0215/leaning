<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="shiro"  uri="http://shiro.apache.org/tags" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Oscar Manager System</title>
<c:set var="path" value="${pageContext.request.contextPath}"></c:set>
<link rel="stylesheet" type="text/css" href="${path}/static/jquery-easyui/themes/default/easyui.css" />
<link rel="stylesheet" type="text/css" href="${path}/static/jquery-easyui/themes/icon.css" />
<script type="text/javascript" src="${path}/static/jquery-easyui/jquery.min.js"></script>
<script type="text/javascript" src="${path}/static/jquery-easyui/jquery.easyui.min.js"></script>
<script type="text/javascript" src="${path}/static/jquery-easyui/locale/easyui-lang-zh_CN.js"></script>
<script type="text/javascript" src="${path}/static/js/common.js"></script>
<script type="text/javascript" src="${path}/static/echarts/echarts.min.js"></script>
</head>
<body class="easyui-layout">
	<div data-options="region:'north',border:false" style="height:60px;background:#B3DFDA;padding:10px">
		<div style="text-align: right">
			<a href="#" class="easyui-menubutton" data-options="menu:'#userMenu',plain:true,iconCls:'icon-man'"><shiro:principal/></a>
			<div id="userMenu" class="easyui-menu" data-options="onClick:onUserMenuClick">
				<div data-options="iconCls:'icon-lock'">修改密码</div>
				<div data-options="iconCls:'icon-undo'">退出登录</div>
			</div>
		</div>
	</div>
    <div data-options="region:'west',split:true,title:'系统菜单'" style="width:300px;">
        <div id="menu-accordion" class="easyui-accordion" data-options="border:false,fit:true" style="width:100%;">
        </div>
    </div>
    <div data-options="region:'east',split:true,collapsed:true,title:'待办事项'" style="width:300px;padding:10px;">east region</div>
    <div data-options="region:'south',border:false" style="height:50px;background:#A9FACD;padding:10px;">south region</div>
    <div data-options="region:'center'">
        <div id="mainframe" data-options="border:false" class="easyui-tabs" style="width:100%;height:100%;">
            <div title="Home" style="padding:10px">
            	<div class="easyui-panel" title="月度报告" style="height:100%;">
            		<div style="height:40px; padding:10px">
            			<div style="margin-bottom:20px">
							<input class="easyui-datetimespinner" value="2017-2" data-options="formatter:formatter2,parser:parser2,selections:[[0,4],[5,7]]">
							<a href="#" class="easyui-linkbutton easyui-tooltip" title="刷新" data-options="plain:true,iconCls:'icon-reload'"></a>
						</div>
            		</div>
            		<div id="container" style="float:left;height:260px;width:400px;margin:10px"></div>
            		<div style="margin:10px">
            			<div class="easyui-panel" style="height:260px;width:400px;padding:60px 30px;" data-options="border:false">
            				<div style="margin-bottom:20px">总销售额:</div>
            				<div style="margin-bottom:20px">总成本额:</div>
            				<div style="margin-bottom:20px">总利润额:</div>
            			</div>
            		</div>
            		<div id="salesVolumn" style="float:left;height:260px;width:400px;margin:10px"></div>
            		<div id="salesAmount" style="float:left;height:260px;width:400px;margin:10px"></div>
            		<div id="salesProfit" style="float:left;height:260px;width:400px;margin:10px"></div>
            	</div>
            </div>
        </div>
    </div>
</body>
<script type="text/javascript">
    $(function(){
        $.ajax({
            url:'${path}/system/menu/0',
            type:'GET',
            data:{},
            success:function(data){
                for(menu in data) {
                    addMenu(data[menu].id, data[menu].text, data[menu].children, menu == 0 ? true : false);
                }
            }
        });
        
        showCalendar();
        showSalesVolume();
        showSalesAmount();
        showSalesProfit();
        
    });
    
    function formatter2(date){
		if (!date){return '';}
		var y = date.getFullYear();
		var m = date.getMonth() + 1;
		return y + '-' + (m<10?('0'+m):m);
	}
    
	function parser2(s){
		if (!s){return null;}
		var ss = s.split('-');
		var y = parseInt(ss[0],10);
		var m = parseInt(ss[1],10);
		if (!isNaN(y) && !isNaN(m)){
			return new Date(y,m-1,1);
		} else {
			return new Date();
		}
	}
    
    function showCalendar() {
    	var dom = $('#container');
        var myChart = echarts.init(dom[0]);
        var data = getVirtulData(2017);
        var option = {
        	title : {
    			text : '销售总览'
    		},
            tooltip: {
                position: 'top'
            },
            calendar: [
                {
                    orient: 'vertical',
                    yearLabel: {
                        margin: 40
                    },
                    monthLabel: {
                        nameMap: 'cn',
                        margin: 20
                    },
                    dayLabel: {
                        firstDay: 1,
                        nameMap: 'cn'
                    },
                    cellSize: 40,
                    range: '2017-02'
                }
            ],
            series:[
                {
                    type: 'scatter',
                    coordinateSystem: 'calendar',
                    calendarIndex: 0,
                    symbolSize: function (val) {
                        return val[1] / 40;
                    },
                    data: data
                },
                {
                    type: 'effectScatter',
                    coordinateSystem: 'calendar',
                    calendarIndex: 0,
                    symbolSize: function (val) {
                        return val[1] / 40;
                    },
                    data: data.sort(function (a, b) {
                        return b[1] - a[1];
                    }).slice(0, 5),
                }
            ]
        };

        myChart.setOption(option);
    }
    
    
	function showSalesVolume() {
		var myChart = echarts.init(document.getElementById('salesVolumn'));

		var option = {
			title : {
				text : '销售量Top5'
			},
			tooltip : {},
			xAxis : {
				data : [ '衬衫', '羊毛衫', '雪纺衫', '裤子', '高跟鞋']
			},
			yAxis : {},
			series : [ {
				name : '销售量',
				type : 'bar',
				data : [ 5, 20, 36, 10, 10 ]
			} ]
		};

		myChart.setOption(option);
	}

	function showSalesAmount() {
		var myChart = echarts.init(document.getElementById('salesAmount'));

		var option = {
			title : {
				text : '销售额Top5'
			},
			tooltip : {},
			xAxis : {
				data : [ '衬衫', '羊毛衫', '雪纺衫', '裤子', '高跟鞋' ]
			},
			yAxis : {},
			series : [ {
				name : '销售额',
				type : 'bar',
				data : [ 5, 20, 36, 10, 10 ]
			} ]
		};

		myChart.setOption(option);
	}

	function showSalesProfit() {
		var myChart = echarts.init(document.getElementById('salesProfit'));

		var option = {
			title : {
				text :  '利润额Top5'
			},
			tooltip : {},
			xAxis : {
				data : [ '衬衫', '羊毛衫', '雪纺衫', '裤子', '高跟鞋' ]
			},
			yAxis : {},
			series : [ {
				name : '利润额',
				type : 'bar',
				data : [ 5, 20, 36, 10, 10 ]
			} ]
		};

		myChart.setOption(option);
	}

	function getVirtulData(year) {
		year = year || '2017';
		var date = +echarts.number.parseDate('2017-02-01');
		var end = +echarts.number.parseDate('2017-02-28');
		var dayTime = 3600 * 24 * 1000;
		var data = [];
		for (var time = date; time < end; time += dayTime) {
			data.push([ echarts.format.formatTime('yyyy-MM-dd', time),
					Math.floor(Math.random() * 1000) ]);
		}
		console.log(data[data.length - 1]);
		return data;
	}

	function addMenu(id, title, data, selected) {
		$('#menu-accordion')
				.accordion(
						'add',
						{
							id : id,
							title : title,
							content : '<div id="tree' + id + '" class="easyui-tree" data-options="fit:true, border:false,onSelect:onMenuSelect"></div>',
							selected : selected
						});
		$('#tree' + id).tree('loadData', data);
	}

	function onMenuSelect(node) {
		if ($(this).tree('isLeaf', node.target) == true) {
			var action = node.attributes.action;
			if (typeof action != "undefined" && action != null && action != "") {
				addTab($('#mainframe'), node.id, node.text, '${path}/' + action);
			}
		}
	}

	function reflushSubFrame(title) {
		var tabs = $('#mainframe');
		var panel = tabs.tabs('getTab', title);
		if (panel == null)
			return;
		var frame = panel.find('iframe');
		if (frame.length > 0) {
			if (typeof frame[0].contentWindow.reflushMe == 'function') {
				frame[0].contentWindow.reflushMe();
			}
		}
	}

	function onUserMenuClick(item) {
		$(location).attr('href', '${path}/logout');
	}
</script>
</html>