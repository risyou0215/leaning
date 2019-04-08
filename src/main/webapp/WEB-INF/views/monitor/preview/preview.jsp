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
		<div id="monitor-equipments" class="easyui-tree" data-options="fit:true, border:false,formatter:equipmentTreeFormatter,onSelect:onCategorySelect">
		</div>
	</div>
	<div data-options="region:'center'" title="设备一览">
		<div id="toolbar" style="padding: 2px 5px">
			设备名称: 
			<input id="equipmentname-textbox" class="easyui-textbox" style="width: 200px" /> 
			设备状态: 
			<select id="equipmentstatus-combobox" class="easyui-combobox" panelHeight="auto" style="width: 100px">
				<option value="1">使用</option>
				<option value="0">停用</option>
			</select> 
			<a href="#" class="easyui-linkbutton easyui-tooltip" title="查询" data-options="plain:true,iconCls:'icon-search'"></a>
		</div>
		<div id="divPlugin" class="plugin" style="width:1000px; height:600px;"></div>
	</div>
	<div id="pager_buttons" style="padding: 2px 5px">
		<a href="#" class="easyui-linkbutton easyui-tooltip" title="新增" data-options="plain:true,iconCls:'icon-add'"></a> 
		<a href="#" class="easyui-linkbutton easyui-tooltip" title="删除" data-options="plain:true,iconCls:'icon-remove'"></a>
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
	
	
	/**
	 *	 @method 设备类目选中时，取得该类目下的设备一览
	 *  @param node 选中节点的内容
	*/
	function onCategorySelect(node) {
		preview(node);
	}
	
	function preview(cfg) {
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
	        	startRealPlay(parseInt(cfg.no) + 1);
	        },
	        error: function (status, xmlDoc) {
	        	alert('登录失败');
	        }
	    });
	    
	    if (-1 == iRet) {
	    	startRealPlay(parseInt(cfg.no) + 1);
	    }
	}
	
	function startRealPlay(channel) {
		var oWndInfo = WebVideoCtrl.I_GetWindowStatus(g_iWndIndex);
		if (oWndInfo != null) {// 已经在播放了，先停止
	        WebVideoCtrl.I_Stop({
	            success: function () {
	            	WebVideoCtrl.I_StartRealPlay(g_szDeviceIdentify, {
	                    iChannelID: channel,
	                    success: function () {   
	                    },
	                    error: function (status, xmlDoc) {
	                        if (403 === status) {
	                        	 alert('设备不支持Websocket取流！');
	                        } else {
	                        	alert('开始预览失败！');
	                        }
	                    }
	                });
	            }
	        });
	    }  else {
	    	WebVideoCtrl.I_StartRealPlay(g_szDeviceIdentify, {
	            iChannelID: channel,
	            success: function () {   
	            },
	            error: function (status, xmlDoc) {
	                if (403 === status) {
	                	 alert('设备不支持Websocket取流！');
	                } else {
	                	alert('开始预览失败！');
	                }
	            }
	        });
	    }
		
	}
	
	function equipmentTreeFormatter(node) {
		return node.name;
	}
	
	
</script>
</html>