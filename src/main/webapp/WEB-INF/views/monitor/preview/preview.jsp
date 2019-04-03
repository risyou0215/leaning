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
			<a href="#" class="easyui-linkbutton easyui-tooltip" title="查询" data-options="plain:true,iconCls:'icon-search',onClick:searchEquipment"></a>
		</div>
		<div id="divPlugin" class="plugin" style="width:1000px; height:600px;"></div>
	</div>
	<div id="pager_buttons" style="padding: 2px 5px">
		<a href="#" class="easyui-linkbutton easyui-tooltip" title="新增" data-options="plain:true,iconCls:'icon-add',onClick:addEquipment"></a> 
		<a href="#" class="easyui-linkbutton easyui-tooltip" title="删除" data-options="plain:true,iconCls:'icon-remove',onClick:deleteEquipmentMulti"></a>
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
		Login(node);
		
		
		//alert(JSON.stringify(node));
	}
	
	function Login(cfg) {
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
	        	startRealPlay(1);
	        },
	        error: function (status, xmlDoc) {
	        	alert('登录失败');
	        }
	    });

	    if (-1 == iRet) {
	        showOPInfo(szDeviceIdentify + " 已登录过！");
	    }
	}
	
	function startRealPlay(iStreamType) {
		WebVideoCtrl.I_StartRealPlay(g_szDeviceIdentify, {
            iChannelID: 1,
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
	
	/**
	 *	 @method 新建设备，打开一个新建设备的Tab
	*/
	function addEquipment() {
		var tabs = parent.$('#mainframe');
		addTab(tabs, 1, '新建设备', '${path}/basic/equipment/add');
	}
	
	/**
	 *	 @method 编辑设备，打开一个编辑设备的Tab
	*/
	function editEquipment(equipmentId) {
		//编辑按钮的tooltip会在打开新的Tab后，一直保持在显示状态，所以要人为关闭一下
		var btns = $('.operator-edit');
		for (var i = 0; i < btns.length; i ++) {
			$(btns[i]).tooltip('hide');
		}
		var tabs = parent.$('#mainframe');
		addTab(tabs, equipmentId, '编辑设备', '${path}/basic/equipment/edit/' + equipmentId);
	}
	
	/**
	 *	 @method 删除单个设备(在点击每行操作列的删除按钮时触发)
	 *	 @param equipmentId 设备ID  
	*/
	function deleteEquipmentSingle(equipmentId) {
		var ids = [];
		ids.push(equipmentId);
		deleteEquipment(ids);
	}
	
	/**
	 *	 @method 删除设备一览Grid里选中的设备(在点击Footer部的删除按钮时触发)
	*/
	function deleteEquipmentMulti() {
		var ids = [];
		var rows = $('#equipment_list').datagrid('getChecked');
		if (rows.length < 1) {
			$.messager.alert('错误','请选择想要删除的设备!','error');
			return;
		}
		for (var i =0; i < rows.length; i++){
			ids.push(rows[i].id);
		}
		deleteEquipment(ids)	;
	}
	
	/**
	 *	 @method 删除设备
	 *	 @param equipmentIds 需要删除的设备ID列表
	*/
	function deleteEquipment(equipmentIds) {
		$.messager.confirm('删除', '确认要删除设备吗?', function(r){
			if (r) {
				$.ajax({
					url:'${path}/basic/equipment/delete',
					type:'get',
					data:{
						equipmentIds:equipmentIds.join()
					},
					success:function(data){
						if (data.success == true) {
							$.messager.alert('成功','删除' + data.count + '件设备成功!','info');
							$('#equipment_list').datagrid('reload');
						} else {
							$.messager.alert('错误',data.message,'error');
						}
					}
				});
			}
		});
	}
	
	/**
	 *	 @method 格式化设备一览的操作列(编辑和删除按钮)
	 *	 @param value 数值
	 *	 @param value 行
	 *	 @return 格式化后的内容
	*/
	function formatOperator(value, row) {
		var content = '<a href="#" class="operator-edit" onclick="editEquipment(' + row.id + ');"></a>';
		content += '<a href="#" class="operator-delete" onclick="deleteEquipmentSingle(' + row.id + ');"></a>';
		return content;
	}
	
	/**
	 *	 @method 格式化设备一览的状态列
	 *	 @param value 数值
	 *	 @param value 行
	 *	 @return 格式化后的内容
	*/
	function formatStatus(value, row) {
		if (value == true) {
			return '使用';
		} else {
			return '停用';
		}
	}
	
	/**
	 *	 @method 查询条件部search按钮点击后重新查询设备信息
	*/
	function searchEquipment()
	{
		//取得左边设备类目当前选中的类目
		var categoryId = null;
		var panel = $('#category-accordion').accordion('getSelected');
		if (panel != null) {
			var equipmentCategoryId = panel.panel('options').id
			var selected = $('#tree' + equipmentCategoryId).tree('getSelected');
			if (selected != null) {
				categoryId = selected.id;
			}
		}
		//类目没有选择的情况，报错
		if (categoryId == null) {
			$.messager.alert('错误', '请选择设备类目!', 'error');
			return;
		}
		//取得查询条件
		var equipmentName = $('#equipmentname-textbox').val();
		var equipmentStatus = $('#equipmentstatus-combobox').val();
		if (equipmentStatus != 1 && equipmentStatus != 0){
			equipmentStatus = null;
		}
		//重新取得设备信息一览
		$('#equipment_list').datagrid('load',{
			name:equipmentName,
			category:categoryId,
			status:equipmentStatus
		});
	}
	
	function equipmentTreeFormatter(node) {
		return node.name;
	}
	
	
</script>
</html>