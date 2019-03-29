<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>设备一览</title>
<c:set var="path" value="${pageContext.request.contextPath}"></c:set>
<link rel="stylesheet" type="text/css" href="${path}/static/jquery-easyui/themes/default/easyui.css" />
<link rel="stylesheet" type="text/css" href="${path}/static/jquery-easyui/themes/icon.css" />
<script type="text/javascript" src="${path}/static/jquery-easyui/jquery.min.js"></script>
<script type="text/javascript" src="${path}/static/jquery-easyui/jquery.easyui.min.js"></script>
<script type="text/javascript" src="${path}/static/jquery-easyui/locale/easyui-lang-zh_CN.js"></script>
<script type="text/javascript" src="${path}/static/js/common.js"></script>
</head>
<body class="easyui-layout">
	<div id="p" data-options="region:'west',split:true" title="设备类型" style="width: 300px;">
		<div id="category-accordion" class="easyui-accordion" data-options="fit:true, border:false">
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
		<table id="equipment_list" class="easyui-datagrid"
			data-options="border:false, fit:true, pagination:true, toolbar:'#toolbar',onClickRow:onClickDataGridRow">
			<thead>
				<tr>
					<th data-options="field:'check',checkbox:true"></th>
					<th data-options="field:'no',width:200">设备编号</th>
					<th data-options="field:'name',width:200">设备名称</th>
					<th data-options="field:'categoryName', width:100">设备类型</th>
					<th data-options="field:'address', width:100">设备地址</th>
					<th data-options="field:'status',width:40, align:'center',formatter:formatStatus">状态</th>
					<th data-options="field:'operator', width:100, align:'center', formatter:formatOperator">操作</th>
				</tr>
			</thead>
		</table>
	</div>
	<div id="pager_buttons" style="padding: 2px 5px">
		<a href="#" class="easyui-linkbutton easyui-tooltip" title="新增" data-options="plain:true,iconCls:'icon-add',onClick:addEquipment"></a> 
		<a href="#" class="easyui-linkbutton easyui-tooltip" title="删除" data-options="plain:true,iconCls:'icon-remove',onClick:deleteEquipmentMulti"></a>
	</div>
</body>
<script type="text/javascript">
	/**
	  *	 @method 页面载入
	*/
	$(function() {
		//获得设备类目树(根类添加panel，子类以树形结构展示)
		var categoryAccordion = $('#category-accordion');
		$.ajax({
			url:'${path}/basic/category/0',
			type:'get',
			data:{},
			cache:false,
			success:function(data){
				for(category in data) {
					addCategoryPanel(data[category].id, data[category].text, data[category].children, category == 0 ? true : false);
				}
			}
		});
		
		//设置设备一览Grid的url，并在并设置操作列里按钮的样式
		$('#equipment_list').datagrid({
			url:'${path}/basic/equipment/page',
			method:'get',
			cache:false,
			onLoadSuccess:function(data) {
				$('.operator-edit').linkbutton({
					plain:true,
					iconCls:'icon-edit'
				});
				$('.operator-edit').tooltip({
					content:'编辑'
				});
				$('.operator-delete').linkbutton({
					plain:true,
					iconCls:'icon-remove'
				});
				$('.operator-delete').tooltip({
					content:'删除'
				});
			}
		});
		
		//翻页栏上添加功能按钮(新增,删除)
		var pager = $('#equipment_list').datagrid().datagrid('getPager');
		pager.pagination({
		    buttons : '#pager_buttons'
		});
	});
	
	/**
	 *	 @method 在页面左边的accordion里增加一个设备类目的panel
	 *   @param id 设备类目ID
	 *   @param title 设备类目title
	 *   @param data 该设备类目的子目录树JSON数据
	 *   @param selected 该设备类目panel是否设置为被选中
	*/
	function addCategoryPanel(id, title, data, selected) {
		$('#category-accordion').accordion('add', {
            id:id,
            title:title,
            content: '<div id="tree' + id + '" class="easyui-tree" data-options="fit:true, border:false,onSelect:onCategorySelect"></div>',
            selected:selected
        });
        $('#tree' + id).tree('loadData', data);
	}
	
	/**
	 *	 @method 设备类目选中时，取得该类目下的设备一览
	 *  @param node 选中节点的内容
	*/
	function onCategorySelect(node) {
		var equipmentName = $('#equipmentname-textbox').val();   //选择条件部的设备名称的值
		var equipmentStatus = $('#equipmentstatus-combobox').val();   //选择条件部的设备状态的值
		if (equipmentStatus != 1 && equipmentStatus != 0){
			equipmentStatus = null;
		}
		//重新load设备一览的Grid
		$('#equipment_list').datagrid('load',{
			category:node.id,
			name:equipmentName,
			status:equipmentStatus
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
	
	/**
	 *	 @method 刷新本页的设备一览Grid(mainFrame在需要时会调用这个函数刷新本页面的数据)
	*/
	function reflushMe(){
		$('#equipment_list').datagrid('reload');
	}
</script>
</html>