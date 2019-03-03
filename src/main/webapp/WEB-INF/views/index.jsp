<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Leaning 平台</title>
<c:set var="path" value="${pageContext.request.contextPath}"></c:set>
<link rel="stylesheet" href="${path}/static/css/common.css">
<link rel="stylesheet" href="${path}/static/css/index.css">
<script type="text/javascript" src="${path}/static/js/jquery-3.3.1.min.js"></script>
<script type="text/javascript" src="${path}/static/js/echarts.js"></script>
</head>
<body>
	<div id="big-bg">
		<div id="box-left">
			<div id="energy-survey">
				<p class="top-tile">
					<i class="lf"></i> <span class="lf">能1耗概览</span> <i class="lf"></i>
				</p>
				<div>
					<div class="energy-lv energy-chart">
						<div class="circle-img">
							<p>180</p>
							<p>能耗评级</p>
						</div>
						<div class="energy-type">偏高</div>
						<div class="today-energy today-water">
							<div class="type-img"></div>
							<div>
								<p>98</p>
								<p>今日用水</p>
							</div>
						</div>
					</div>
					<div class="energy-person energy-chart">
						<div class="circle-img">
							<p>180</p>
							<p>人均能耗</p>
						</div>
						<div class="energy-type">偏高</div>
						<div class="today-energy today-elec">
							<div class="type-img"></div>
							<div>
								<p>2697</p>
								<p>今日用电</p>
							</div>
						</div>
					</div>
				</div>
			</div>
			<div id="equipment-data">
				<p class="top-tile">
					<i class="lf"></i> <span class="lf">设备实时数据</span> <i class="lf"></i>
				</p>
				<div>
					<table>
						<tr>
							<td>序号</td>
							<td>位置</td>
							<td>状态</td>
							<td>温度设定</td>
						</tr>
						<tr>
							<td>1</td>
							<td>弱电机房</td>
							<td>正常</td>
							<td>22</td>
						</tr>
						<tr>
							<td>1</td>
							<td>控制中心</td>
							<td>正常</td>
							<td>22</td>
						</tr>
						<tr>
							<td>1</td>
							<td>监控室</td>
							<td>正常</td>
							<td>22</td>
						</tr>
						<tr>
							<td>1</td>
							<td>变电所</td>
							<td>正常</td>
							<td>22</td>
						</tr>
					</table>
				</div>
			</div>
		</div>
		<div id="top-title">
			<div class="online-type">
				<div id="person-scatter">
					<i></i>人流
				</div>
				<div id="energy-heatmap">
					<i></i>能耗
				</div>
			</div>
			<div class="icon-type">
				<div class="today-energy room">
					<div class="type-img"></div>
					<div>
						<p>23</p>
						<p>室内温度</p>
					</div>
				</div>
				<div class="today-energy roomout">
					<div class="type-img"></div>
					<div>
						<p>14</p>
						<p>室外温度</p>
					</div>
				</div>
				<div class="today-energy dampness">
					<div class="type-img"></div>
					<div>
						<p>56</p>
						<p>湿度</p>
					</div>
				</div>
			</div>
		</div>
		<div id="box-middle">
			<div id="scatter"></div>
			<div id="heatChart"></div>
		</div>
		<div id="box-right">
			<div id="temperature">
				<p class="top-tile">
					<i class="lf"></i> <span class="lf">气温与暖通能耗曲线</span> <i class="lf"></i>
				</p>
				<div id="temperature-chart"></div>
			</div>
			<div id="big-event">
				<p class="top-tile">
					<i class="lf"></i> <span class="lf">重大事件</span> <i class="lf"></i>
				</p>
				<div>
					<ul>
						<li>[报警]&nbsp;&nbsp;非法闯入</li>
						<li>[预警]&nbsp;&nbsp;历史文化区温度过高</li>
						<li>[报警]&nbsp;&nbsp;非法闯入</li>
						<li>[预警]&nbsp;&nbsp;历史文化区温度过高</li>
						<li>[报警]&nbsp;&nbsp;非法闯入</li>
						<li>[预警]&nbsp;&nbsp;历史文化区温度过高</li>
					</ul>
				</div>
			</div>
		</div>
		<div id="box-bottom">
			<div id="week-water">
				<p class="top-tile">
					<i class="lf"></i> <span class="lf">近一周用水情况</span> <i class="lf"></i>
				</p>
				<div id="week-water-chart"></div>
			</div>
			<div id="energy-ranking">
				<p class="top-tile">
					<i class="lf"></i> <span class="lf">能耗排名</span> <i class="lf"></i>
				</p>
				<div id="energy-ranking-chart"></div>
			</div>
			<div id="week-elec">
				<p class="top-tile">
					<i class="lf"></i> <span class="lf">近一周用电情况</span> <i class="lf"></i>
				</p>
				<div id="week-elec-chart"></div>
			</div>
			<div id="contrast">
				<ul>
					<li>
						<div class="contrast-icon"></div>
						<div class="contrast-text">
							<p>暖通能耗</p>
							<p class="jump">环比下降</p>
						</div>
						<div class="jump">
							<i></i> <span>13%</span>
						</div>
					</li>
					<li>
						<div class="contrast-icon"></div>
						<div class="contrast-text">
							<p>电暖能耗</p>
							<p class="up">环比增长</p>
						</div>
						<div class="up">
							<i></i> <span>8%</span>
						</div>
					</li>
					<li>
						<div class="contrast-icon"></div>
						<div class="contrast-text">
							<p>照明能耗</p>
							<p class="jump">环比下降</p>
						</div>
						<div class="jump">
							<i></i> <span>28%</span>
						</div>
					</li>
				</ul>
			</div>
		</div>
	</div>
</body>
<script type="text/javascript" src="${path}/static/js/jquery-3.3.1.min.js"></script>
<script type="text/javascript" src="${path}/static/js/echarts.js"></script>
<script type="text/javascript" src="${path}/static/js/scatter.js"></script>
<script type="text/javascript" src="${path}/static/js/heatmap.js"></script>
<script type="text/javascript" src="${path}/static/js/index.js"></script>
<script type="text/javascript">
	var random = function(lowerValue, upperValue) {
		return Math.floor(Math.random() * (upperValue - lowerValue)
				+ lowerValue);
	};

	var _width = $("#heatChart").width(), _height = $("#heatChart").height();
	var heatmapInstance = h337.create({
		container : document.getElementById('heatChart'),
	});
	//构建随机数据点
	var points = [];
	var max = 0;
	var width = _width;
	var height = _height;
	var len = 200;
	while (len--) {
		var val = Math.floor(Math.random() * 100);
		max = Math.max(max, val);
		var point = {
			x : random(_width * 0.4, _width * 0.9),
			y : random(_height * 0.1, _height * 0.8),
			value : val
		};
		points.push(point);
	}
	var data = {
		max : max,
		data : points
	};
	heatmapInstance.setData(data);
</script>
</html>
