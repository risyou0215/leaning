<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>监控预览</title>
<c:set var="path" value="${pageContext.request.contextPath}"></c:set>
<link rel="stylesheet" type="text/css" href="${path}/static/jquery-easyui/themes/default/easyui.css" />
<link rel="stylesheet" type="text/css" href="${path}/static/jquery-easyui/themes/icon.css" />
<script type="text/javascript" src="${path}/static/jquery-easyui/jquery.min.js"></script>
<script type="text/javascript" src="${path}/static/jquery-easyui/jquery.easyui.min.js"></script>
<script type="text/javascript" src="${path}/static/jquery-easyui/locale/easyui-lang-zh_CN.js"></script>
<script type="text/javascript" src="${path}/static/js/common.js"></script>

</head>
<body class="easyui-layout">
	<div id="p" data-options="region:'west',split:true" title="监控设备" style="width: 300px;">
		<div id="monitor-equipments" class="easyui-tree" data-options="fit:true, border:false,formatter:equipmentTreeFormatter">
		</div>
	</div>
	<div data-options="region:'center'" title="设备一览">
		<div id="toolbar" style="padding: 2px 5px">
			<input id="datetimeFrom" class="easyui-datetimespinner" label="开始时间:" labelPosition="left" value="" style="width:250px;" />
			<input id="datetimeTo" class="easyui-datetimespinner" label="结束时间:" labelPosition="left" value="" style="width:250px;"> 
			<a href="#" class="easyui-linkbutton easyui-tooltip" title="播放" data-options="plain:true,iconCls:'icon-play',onClick:replay"></a>
			<a href="#" class="easyui-linkbutton easyui-tooltip" title="停止" data-options="plain:true,iconCls:'icon-stop',onClick:stop"></a>
		</div>
		<div id="divPlugin" class="plugin" style="width:1000px; height:600px;"></div>
	</div>
</body>
<script type="text/javascript" id="videonode" src="${path}/static/video/webVideoCtrl.js"></script>
<script type="text/javascript">
	var g_iWndIndex = 0;
	var g_szDeviceIdentify = '';
	/**
	  *	 @method 页面载入
	*/
	$(function() {
		$.ajax({
			url:'${path}/monitor/list',
			type:'get',
			data:{},
			cache:false,
			success:function(data){
				$('#monitor-equipments').tree('loadData', data);
			}
		});
		
		var date = new Date();
	    var strDate = date.Format("yyyy-MM-dd");
	    $('#datetimeFrom').datetimespinner('setValue', strDate + ' 00:00:00');
	    $('#datetimeTo').datetimespinner('setValue', strDate + ' 23:59:59');
		
		var iRet = WebVideoCtrl.I_CheckPluginInstall();
	    if (-1 == iRet) {
	        alert("您还未安装过插件，双击开发包目录里的WebComponentsKit.exe安装！");
	        return;
	    }
	    
	    WebVideoCtrl.I_InitPlugin(1000, 600, {
	        bWndFull: true,     //是否支持单窗口双击全屏，默认支持 true:支持 false:不支持
	        iPackageType: 2,    //2:PS 11:MP4
	        iWndowType: 1,
	        bNoPlugin: true,
	        cbSelWnd: function (xmlDoc) {
	            g_iWndIndex = parseInt($(xmlDoc).find("SelectWnd").eq(0).text(), 10);
	            var szInfo = "当前选择的窗口编号：" + g_iWndIndex;
	        },
	        cbDoubleClickWnd: function (iWndIndex, bFullScreen) {
	            var szInfo = "当前放大的窗口编号：" + iWndIndex;
	            if (!bFullScreen) {            
	                szInfo = "当前还原的窗口编号：" + iWndIndex;
	            }
	                        
	            
	        },
	        cbEvent: function (iEventType, iParam1, iParam2) {
	            if (2 == iEventType) {// 回放正常结束
	              
	            } else if (-1 == iEventType) {
	                
	            } else if (3001 == iEventType) {
	                
	            }
	        },
	        cbRemoteConfig: function () {
	          
	        },
	        cbInitPluginComplete: function () {
	            WebVideoCtrl.I_InsertOBJECTPlugin("divPlugin");

	            // 检查插件是否最新
	            if (-1 == WebVideoCtrl.I_CheckPluginVersion()) {
	                alert("检测到新的插件版本，双击开发包目录里的WebComponentsKit.exe升级！");
	                return;
	            }
	        }
	    });
	});
	
	function equipmentTreeFormatter(node) {
		return node.name;
	}
	
	function replay(){
		var cfg = $('#monitor-equipments').tree('getSelected');
		if (cfg.id != null) return;
	    var szIP = cfg.address,
	        szPort = '80',
	        szUsername = cfg.username,
	        szPassword = cfg.password;

	    if ("" == szIP || "" == szPort) {
	        return;
	    }
	   	
	    var szDeviceIdentify = szIP + "_" + szPort;
	    g_szDeviceIdentify = szDeviceIdentify;

	    var iRet = WebVideoCtrl.I_Login(szIP, 1, szPort, szUsername, szPassword, {
	        success: function (xmlDoc) {            
	        	startPlayback(parseInt(cfg.no) + 1);
	        },
	        error: function (status, xmlDoc) {
	        	alert('登录失败');
	        }
	    });
	    
	    if (-1 == iRet) {
	    	startPlayback(parseInt(cfg.no) + 1);
	    }
	}
	
	function startPlayback(channel) {
		var szStartTime = $('#datetimeFrom').datetimespinner('getValue');
		var szEndTime = $('#datetimeTo').datetimespinner('getValue');
		
		var oWndInfo = WebVideoCtrl.I_GetWindowStatus(g_iWndIndex);
		if (oWndInfo != null) {// 已经在播放了，先停止
	        WebVideoCtrl.I_Stop({
	            success: function () {
	            	WebVideoCtrl.I_StartPlayback(g_szDeviceIdentify, {
	                    iChannelID: channel,
	                    szStartTime: szStartTime,
	                    szEndTime: szEndTime,
	                    success: function () {
	                        
	                    },
	                    error: function (status, xmlDoc) {
	                        if (403 === status) {
	                             alert("设备不支持Websocket取流！");
	                        } else {
	                        	alert("开始回放失败！");
	                        }
	                    }
	                });
	            }
	        });
	    }  else {
	    	WebVideoCtrl.I_StartPlayback(g_szDeviceIdentify, {
                iChannelID: channel,
                szStartTime: szStartTime,
                szEndTime: szEndTime,
                success: function () {
                    
                },
                error: function (status, xmlDoc) {
                    if (403 === status) {
                    	alert("设备不支持Websocket取流！");
                    } else {
                    	alert("开始回放失败！");
                    }
                }
            });
	    }
	}
	
	function stop() {
		var oWndInfo = WebVideoCtrl.I_GetWindowStatus(g_iWndIndex);

	    if (oWndInfo != null) {
	        WebVideoCtrl.I_Stop({
	            success: function () {
	            	
	            },
	            error: function () {
	            	alert("停止回放失败！");
	            }
	        });
	    }
	}
	
	Date.prototype.Format = function(fmt) {
	    var o = {
	        "M+": this.getMonth() + 1,
	        "d+": this.getDate(),
	        "h+": this.getHours(),
	        "m+": this.getMinutes(),
	        "s+": this.getSeconds(),
	        "q+": Math.floor((this.getMonth() + 3) / 3),
	        "S": this.getMilliseconds()
	    };
	    if (/(y+)/.test(fmt))
	        fmt = fmt.replace(RegExp.$1, (this.getFullYear() + "").substr(4 - RegExp.$1.length));
	    for (var k in o){
	        if (new RegExp("(" + k + ")").test(fmt)) {
	            fmt = fmt.replace(RegExp.$1, (RegExp.$1.length == 1) ? (o[k]) : (("00" + o[k]).substr(("" + o[k]).length)));
	        }
	    }
	    return fmt;
	}
</script>
</html>