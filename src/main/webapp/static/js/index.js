/*能耗人流chart图切换*/
$(function(){
	var flag = false;
	$(".online-type div").click(function(){
		var _width = $("#box-middle").width(),
			_height = $("#box-middle").height();
			$("#highlight").css("z-index",10);
			$("#onAbanLine").css("z-index",-10);
		var thisId = $(this).attr("id");
		if(flag == false){
			$(this).addClass("start").siblings().removeClass("start");
			if(thisId == "person-scatter"){
				//$("#scatter").css({"width":_width,"height":_height});
				$("#scatter").addClass("show").siblings().removeClass("show");
				flag = true;
			}else if(thisId == "energy-heatmap"){
				$("#heatChart").addClass("show").siblings().removeClass("show");
				flag = true;
			}else{
				$("#onAbanLine").css("z-index",10);
				$("#highlight").css("z-index",-10);
				$("#onAbanLine").addClass("show").siblings().removeClass("show");
				flag = true;
			}
		}else{
			$(this).removeClass("start").siblings().removeClass("start");
			if(thisId == "person-scatter"){
				$("#scatter").removeClass("show").siblings().removeClass("show");
				flag = false;
			}else if(thisId == "energy-heatmap"){
				$("#scatter").removeClass("show").siblings().removeClass("show");
				flag = false;
			}else{
				$("#onAbanLine").css("z-index",10);
				$("#highlight").css("z-index",-10);
				$("#onAbanLine").removeClass("show").siblings().removeClass("show");
				flag = false;
			}
		}
	});
	
	tooltip();
})

/*区域悬浮框*/
function tooltip(){
	$("#highlight>div").mouseover(function(){
		var num = $(this).data("id"),
			RL = $(this).data("renliu"),
			NH = $(this).data("nenghao");
		var html = '<div><p>区域'+num+'</p><p>人流：<span>'+RL+'</span></p><p>能耗：<span>'+NH+'</span></p></div>';
		$(this).append(html);
	})
}

/*近一周用水情况*/
var myChart = echarts.init(document.getElementById('week-water-chart'));
var data1 = [1500,1600,1650,1700,1800,1950,2100]
option = {
    title : {
        text: '',
    },
    tooltip : {
        trigger: 'axis'
    },
    legend: {
        data:[]
    },
    calculable : true,
    grid:{
        x:40,
        y:10,
        x2:10,
        y2:20,
        borderWidth:0,
    },
    xAxis : [
        {
            type : 'category',
            boundaryGap : false,
            data : ['1','2','3','4','5','6','7'],
            axisLine:{
                lineStyle:{
                    color:'#8dc4c9',
                    width:1,//这里是为了突出显示加上的
                }
            }
        }
    ],
    yAxis : [
        {
            type : 'value',
            data : [500,1000,1500,2000,2500],
            axisLine:{
                lineStyle:{
                    color:'#8dc4c9',
                    width:1,//这里是为了突出显示加上的
                }
            },
            splitLine:{show: false}//去除网格线
        }
    ],
    series : [
        {
            name:'用水量',
            type:'line',
            smooth:true,
            itemStyle: {
                normal: {
                    color: '#0188a8',
                    borderColor: '#1fa6b9',
                    areaStyle: {
                        type: 'default',
                        opacity: 0.5
                    }
                }
            },
            data:data1
        }
    ]
};

myChart.setOption(option);

/*近一周用电情况*/
var myChartOne = echarts.init(document.getElementById('week-elec-chart'));
var data1 = [1500,1600,1650,1700,1800,1950,2100]
optionOne = {
    title : {
        text: '',
    },
    tooltip : {
        trigger: 'axis'
    },
    legend: {
        data:[]
    },
    calculable : true,
     grid:{
        x:40,
        y:10,
        x2:10,
        y2:20,
        borderWidth:1
    },
    xAxis : [
        {
            type : 'category',
            boundaryGap : false,
            data : ['1','2','3','4','5','6','7'],
            axisLine:{
                lineStyle:{
                    color:'#8dc4c9',
                    width:1,//这里是为了突出显示加上的
                }
            }
        }
    ],
    yAxis : [
        {
            type : 'value',
            data : [500,1000,1500,2000,2500],
            axisLine:{
                lineStyle:{
                    color:'#8dc4c9',
                    width:1,//这里是为了突出显示加上的
                }
            },
            splitLine:{show: false}
        }
    ],
    series : [
        {
            name:'用电量',
            type:'line',
            smooth:true,
            itemStyle: {
                normal: {
                    color: '#9b7abf',
                    borderColor: '#fa92df',
                    areaStyle: {
                        type: 'default',
                        opacity: 0.5
                    }
                }
            },
            data:data1
        }
    ]
};

myChartOne.setOption(optionOne);

/*气温与暖通能耗曲线*/
var myChartTwo = echarts.init(document.getElementById('temperature-chart'));
var data1 = [90,85,80,85,82,80,78,77,76,78,65,75],
	data2 = [60,65,67,78,82,85,80,82,84,88,86,88];
optionTwo = {
    title : {
        text: '',
    },
    tooltip : {
        trigger: 'axis'
    },
    legend: {
        data:[
        {
        	name:'气温',
         	icon:"circle"
        },{
        	name:'暖通能耗',
        	icon:"circle"
        }],
        textStyle: {color: '#fff'},
        left:20,
        y:"bottom"
    },
    calculable : true,
    grid:{
        x:40,
        y:10,
        x2:10,
        y2:50,
        borderWidth:1
    },
    xAxis : [
        {
            type : 'category',
            boundaryGap : false,
            data : ['1','2','3','4','5','6','7','8','9','10','11','12'],
            axisLine:{
                lineStyle:{
                    color:'#8dc4c9',
                    width:1,//这里是为了突出显示加上的
                }
            }
        }
    ],
    yAxis : [
        {
            type : 'value',
            data : [20,40,60,80,100],
            axisLine:{
                lineStyle:{
                    color:'#8dc4c9',
                    width:1,//这里是为了突出显示加上的
                }
            },
            splitLine:{show: false}
        }
    ],
    series : [
        {
            name:'气温',
            type:'line',
            smooth:true,
            itemStyle: {
                normal: {
                    color: '#5c7f3d',
                    borderColor: '#bff336',
                    areaStyle: {
                        type: 'default',
                        opacity: 0.5
                    }
                }
            },
            data:data2
        },
        {
            name:'暖通能耗',
            type:'line',
            smooth:true,
            itemStyle: {
                normal: {
                    color: '#4f4367',
                    borderColor: '#fe9ada',
                    areaStyle: {
                        type: 'default',
                        opacity: 0.5
                    }
                }
            },
            data:data1
        }
    ]
};

myChartTwo.setOption(optionTwo);


/*能耗排名*/
var myChartThree = echarts.init(document.getElementById('energy-ranking-chart'));
var optionThree = {
    title : {
        text: '',
        subtext: ''
    },
    tooltip : {
        trigger: 'axis'
    },
    legend: {
        data:[]
    },
    grid:{
        x:40,
        y:10,
        x2:10,
        y2:20,
    },
    xAxis : [
        {
            type : 'category',
            data : ['暖通','电暖','照明'],
            axisLine:{
                lineStyle:{
                    color:'#8dc4c9',
                    width:1,
                }
            }
        }
    ],
    yAxis : [
        {
            type : 'value',
            data : [500,1000,1500,2000,2500],
            axisLine:{
                lineStyle:{
                    color:'#8dc4c9',
                    width:1,//这里是为了突出显示加上的
                }
            },
            splitLine:{show: false}
        }
    ],
    series : [
        {
            type:'bar',
            itemStyle: {
	            normal: {
	                // 定制显示（按顺序）
	                color: function(params) { 
	                    var colorList = ['#c490e2','#a47fc5','#e9eb7e']; 
	                    return colorList[params.dataIndex] 
	                }
	            },
	        },
            data:[2400,1700,2000],
            barWidth:'40',  
        }
    ]
};

myChartThree.setOption(optionThree);