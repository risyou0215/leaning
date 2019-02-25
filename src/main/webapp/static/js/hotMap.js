/*var dom = document.getElementById("heatChart");
var myChart = echarts.init(dom);
var app = {};
option = null;
app.title = '热力图 - 颜色的离散映射';*/

var heatData = [] ,xData = [], yData = [];

for (var i = 1; i <= 150; i++) {
	xData.push(i);
};
for (var i = 1; i <= 100; i++) {
	yData.push(i);
};

//构造随机数
var random = function (lowerValue,upperValue){
    return parseInt(Math.random() * (upperValue - lowerValue) + lowerValue);
};
var randomVal = function (lowerValue,upperValue){
    return parseFloat(Math.random() * (upperValue - lowerValue) + lowerValue).toFixed(1);
};

//将数据装载到不同区域数组中
/*for (var i = 0; i < 1500; i++) {
   heatData.push([random(100,140),random(30,70),randomVal(0,1)]);
};*/
heatData = [[100,50,0.8],[60,50,1]];

// 基于准备好的dom，初始化echarts图表
var myChart = echarts.init(document.getElementById('heatChart')); 
var option = {
        title : {
            text: ''
        },
        xAxis: {
        	show:true,
	        type: 'category',
	        data:xData
	    },
	    yAxis: {
	    	show:true,
	        type: 'category',
	        data:yData
	    },
	    visualMap: {
	        min: 0,
	        max: 1,
	        calculable: true,
	        realtime: false,
	        inRange: {
	            color: ['#313695', '#4575b4', '#74add1', '#abd9e9', '#e0f3f8', '#ffffbf', '#fee090', '#fdae61', '#f46d43', '#d73027', '#a50026']
	        }
	    },
        series : [
            {
                type : 'heatmap',
                data : heatData,
                hoverable : false,
                visualMap : false,
                /*blurSize : 20,
                pointSize: 10,5796271*/
                gradientColors: [{
                    offset: 0.4,
                    color: 'green'
                }, {
                    offset: 0.5,
                    color: 'yellow'
                }, {
                    offset: 0.8,
                    color: 'orange'
                }, {
                    offset: 1,
                    color: 'red'
                }],
               /* minAlpha: 0.2,
                valueScale: 2,
                opacity: 0.6*/
            }
        ]
    };

// 为echarts对象加载数据 
myChart.setOption(option); 

