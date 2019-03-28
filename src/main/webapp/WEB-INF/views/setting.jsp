<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Leaning Platform</title>
<c:set var="path" value="${pageContext.request.contextPath}"></c:set>
<link rel="stylesheet" type="text/css" href="${path}/static/jquery-easyui/themes/default/easyui.css" />
<link rel="stylesheet" type="text/css" href="${path}/static/jquery-easyui/themes/icon.css" />
<script type="text/javascript" src="${path}/static/jquery-easyui/jquery.min.js"></script>
<script type="text/javascript" src="${path}/static/jquery-easyui/jquery.easyui.min.js"></script>
<script type="text/javascript" src="${path}/static/jquery-easyui/locale/easyui-lang-zh_CN.js"></script>
<script type="text/javascript" src="${path}/static/js/common.js"></script>
</head>
<body class="easyui-layout">
	<div data-options="region:'north',border:false" style="height:60px;background:#B3DFDA;padding:10px">
		<div style="text-align: right">
			<a href="#" class="easyui-menubutton" data-options="menu:'#userMenu',plain:true,iconCls:'icon-man'"><shiro:principal/></a>
			<div id="userMenu" class="easyui-menu">
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
    });
    
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
</script>
</html>