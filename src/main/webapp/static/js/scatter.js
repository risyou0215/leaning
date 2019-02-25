// 初始化echarts实例
    var myChart = echarts.init(document.getElementById('scatter'));

    var data1 = [];//数据区域缩放组件
    var data2 = [];
    var data3 = [];

    //构造随机数
    var random = function (lowerValue,upperValue){
        return parseFloat(Math.random() * (upperValue - lowerValue) + lowerValue).toFixed(2);
    };


    //将数据装载到不同区域数组中
  	for (var i = 0; i < 150; i++) {
       data2.push([random(8.5,10), random(6.5,7.2), random(0,1)]);
    };
    for (var i = 0; i < 300; i++) {
       data2.push([random(9,11.5), random(3.5,5.5), random(0,1)]);
    };
    for (var i = 0; i < 100; i++) {
       	data1.push([random(7,9), random(2,4), random(0,1)]);
       	data2.push([random(6.2,8.5), random(5.5,6.8), random(0,1)]);
       	data2.push([random(10,14), random(5,8), random(0,1)]);
    };
    for (var i = 0; i < 30; i++) {
       data3.push([random(6.2,9), random(4,5.5), random(0,1)]);
       data3.push([random(7,10), random(7.2,8.5), random(0,1)]);
       data3.push([random(9,13), random(2.5,3.5), random(0,1)]);
       data3.push([random(0,15), random(2,8), random(0,1)]);
    };

    //3、配置option项
    option = {
        animation: false,//是否开启动画，默认是开启的，true是开启的,false是关闭的

        //图例
        legend: {
            data: [
               /* {
                    name:'scatter2',
                    icon:'circle',//强制设置图形长方形
                    textStyle:
                        {color:'red'}//设置文本为红色
                },
                {
                    name:'scatter',
                    icon:'rectangular',//强制设置图形为长方形
                    textStyle:
                        {color:'red'}//设置文本为红色
                },
                {
                    name:'scatter3',
                    icon:'rectangular',//强制设置图形为长方形
                    textStyle:
                        {color:'red'}//设置文本为红色
                }*/
            ],
            zlevel:5,//设置Canvas分层 zlevel值不同会被放在不同的动画效果中,传说中z值小的图形会被z值大的图形覆盖
            z:3,//z的级别比zlevel低，传说中z值小的会被z值大的覆盖，但不会重新创建Canvas
            //left:'center',//图例组件离容器左侧的距离。可以是像 '20%' 这样相对于容器高宽的百分比，也可以是 'left', 'center', 'right'。
            //top:'top',
            width:'auto',//设置图例组件的宽度，默认值为auto,好像只能够使用px
            orient:'horizontal',//设置图例组件的朝向默认是horizontal水平布局，'vertical'垂直布局
            align:'auto',//'left'  'right'设置图例标记和文本的对齐，默认是auto
            padding:[20,20,20,20],//设置图例内边距 默认为上下左右都是5，接受数组分别设定
            itemGap:20,//图例每项之间的间隔，横向布局时为水平间隔，纵向布局时为纵向间隔。默认为10
            itemWidth:30,//图例标记的图形宽度，默认为25
            itemHeight:20,//图例标记的图形高度，默认为14
            formatter:function(name){
                return 'Legend  '+name;
            },
            selectedMode:'multiple',//图例的选择模式，默认为开启，也可以设置成single或者multiple
            inactiveColor:'#ccc',//图例关闭时的颜色，默认是'#ccc'
            selected:{
                'scatter2':true,//设置图例的选中状态
                'scatter':true,
                'scatter3':true
            },
            tooltip: {//图例的tooltip 配置，默认不显示,可以在文件较多的时候开启tooltip对文字进行剪切
                show: true
            },
            shadowBlur:30,//图例阴影的模糊大小
            shadowColor:'rgb(128, 128, 56)'//阴影的颜色
        },


        //网格
        grid:{
            show:false,//是否显示直角坐标系的网格,true显示，false不显示
            left:20,//grid组件离容器左侧的距离
            right:0,
            top:0,
            bottom:20,
            containLabel:false,
        },
        xAxis: {
        	show:false,
            type: 'value',
            min: 0,
            name:'',
            nameLocation:'end',//x轴名称的显示位置'middle'，'end'
            max: 15,
            gridIndex:0,//x轴所在的grid的索引，默认位于第一个grid
            type:'value',//数值轴适用于连续型数据
            inverse:false,//是否反向坐标
            //boundaryGap:['20%','20%'],//坐标轴两边留白策略，类目轴和非类目轴的设置和表现不一样。
            splitLine: {
                show: false
            }
        },

        //Y轴
        yAxis: {
        	show:false,
            type: 'value',
            min: 0,
            max: 10,
            splitLine: {
                show: false
            }
        },



        //装载数据
        series: [
            {
                name: 'scatter',
                type: 'scatter',
                itemStyle: {
                    normal: {
                        opacity: 0.8,
                   		color:"#34ffff"
                    }
                },
                symbolSize: 5,
                data: data1
            },
            {
                name: 'scatter2',
                type: 'scatter',
                itemStyle: {
                    normal: {
                        opacity: 0.8,
                   		color:"#34ffff"
                    }
                },
                symbolSize: 5,
                data: data2
            },
            {
                name: 'scatter3',
                type: 'scatter',//散点图
                itemStyle: {
                    normal: {
                        opacity: 0.8,
                   		color:"#34ffff"
                    }
                },
                symbolSize: 5,
                data: data3
            }
        ]
    };

    // 使用刚指定的配置项和数据显示图表
    myChart.setOption(option);