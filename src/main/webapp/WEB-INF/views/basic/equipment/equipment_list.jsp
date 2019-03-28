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
	<div data-options="region:'center'" title="商品一览">
		<div id="toolbar" style="padding: 2px 5px">
			设备名称: 
			<input id="productname-textbox" class="easyui-textbox" style="width: 200px" /> 
			设备状态: 
			<select id="productstatus-combobox" class="easyui-combobox" panelHeight="auto" style="width: 100px">
				<option value="1">使用</option>
				<option value="0">停用</option>
			</select> 
			<a href="#" class="easyui-linkbutton easyui-tooltip" title="查询" data-options="plain:true,iconCls:'icon-search',onClick:searchProduct"></a>
		</div>
		<table id="product_list" class="easyui-datagrid"
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
		<a href="#" class="easyui-linkbutton easyui-tooltip" title="新增" data-options="plain:true,iconCls:'icon-add',onClick:addProduct"></a> 
		<a href="#" class="easyui-linkbutton easyui-tooltip" title="删除" data-options="plain:true,iconCls:'icon-remove',onClick:deleteProductMulti"></a>
	</div>
</body>
<script type="text/javascript">
	/**
	  *	 @method 页面载入
	*/
	$(function() {
		//获得商品类目树(根类添加panel，子类以树形结构展示)
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
		
		//设置商品一览Grid的url，并在并设置操作列里按钮的样式
		$('#product_list').datagrid({
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
		var pager = $('#product_list').datagrid().datagrid('getPager');
		pager.pagination({
		    buttons : '#pager_buttons'
		});
	});
	
	/**
	 *	 @method 在页面左边的accordion里增加一个商品类目的panel
	 *   @param id 商品类目ID
	 *   @param title 商品类目title
	 *   @param data 该商品类目的子目录树JSON数据
	 *   @param selected 该商品类目panel是否设置为被选中
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
	 *	 @method 商品类目选中时，取得该类目下的商品一览
	 *  @param node 选中节点的内容
	*/
	function onCategorySelect(node) {
		var productName = $('#productname-textbox').val();   //选择条件部的商品名称的值
		var productStatus = $('#productstatus-combobox').val();   //选择条件部的商品状态的值
		if (productStatus != 1 && productStatus != 0){
			productStatus = null;
		}
		//重新load商品一览的Grid
		$('#product_list').datagrid('load',{
			category:node.id,
			name:productName,
			status:productStatus
		});
	}
	
	/**
	 *	 @method 新建商品，打开一个新建商品的Tab
	*/
	function addProduct() {
		var tabs = parent.$('#mainframe');
		addTab(tabs, 1, '新建设备', '${path}/basic/equipment/add');
	}
	
	/**
	 *	 @method 编辑商品，打开一个编辑商品的Tab
	*/
	function editProduct(productId) {
		//编辑按钮的tooltip会在打开新的Tab后，一直保持在显示状态，所以要人为关闭一下
		var btns = $('.operator-edit');
		for (var i = 0; i < btns.length; i ++) {
			$(btns[i]).tooltip('hide');
		}
		var tabs = parent.$('#mainframe');
		addTab(tabs, productId, '编辑设备', '${path}/basic/equipment/edit/' + productId);
	}
	
	/**
	 *	 @method 删除单个商品(在点击每行操作列的删除按钮时触发)
	 *	 @param productId 商品ID  
	*/
	function deleteProductSingle(productId) {
		var ids = [];
		ids.push(productId);
		deleteProduct(ids);
	}
	
	/**
	 *	 @method 删除商品一览Grid里选中的商品(在点击Footer部的删除按钮时触发)
	*/
	function deleteProductMulti() {
		var ids = [];
		var rows = $('#product_list').datagrid('getChecked');
		if (rows.length < 1) {
			$.messager.alert('错误','请选择想要删除的商品!','error');
			return;
		}
		for (var i =0; i < rows.length; i++){
			ids.push(rows[i].id);
		}
		deleteProduct(ids)	;
	}
	
	/**
	 *	 @method 删除商品
	 *	 @param productIds 需要删除的商品ID列表
	*/
	function deleteProduct(productIds) {
		$.messager.confirm('删除', '确认要删除商品吗?', function(r){
			if (r) {
				$.ajax({
					url:'${path}/basic/equipment/delete',
					type:'get',
					data:{
						productIds:productIds.join()
					},
					success:function(data){
						if (data.success == true) {
							$.messager.alert('成功','删除' + data.count + '件商品成功!','info');
							$('#product_list').datagrid('reload');
						} else {
							$.messager.alert('错误',data.message,'error');
						}
					}
				});
			}
		});
	}
	
	/**
	 *	 @method 格式化商品一览的操作列(编辑和删除按钮)
	 *	 @param value 数值
	 *	 @param value 行
	 *	 @return 格式化后的内容
	*/
	function formatOperator(value, row) {
		var content = '<a href="#" class="operator-edit" onclick="editProduct(' + row.id + ');"></a>';
		content += '<a href="#" class="operator-delete" onclick="deleteProductSingle(' + row.id + ');"></a>';
		return content;
	}
	
	/**
	 *	 @method 格式化商品一览的状态列
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
	 *	 @method 查询条件部search按钮点击后重新查询商品信息
	*/
	function searchProduct()
	{
		//取得左边商品类目当前选中的类目
		var categoryId = null;
		var panel = $('#category-accordion').accordion('getSelected');
		if (panel != null) {
			var productCategoryId = panel.panel('options').id
			var selected = $('#tree' + productCategoryId).tree('getSelected');
			if (selected != null) {
				categoryId = selected.id;
			}
		}
		//类目没有选择的情况，报错
		if (categoryId == null) {
			$.messager.alert('错误', '请选择商品类目!', 'error');
			return;
		}
		//取得查询条件
		var productName = $('#productname-textbox').val();
		var productStatus = $('#productstatus-combobox').val();
		if (productStatus != 1 && productStatus != 0){
			productStatus = null;
		}
		//重新取得商品信息一览
		$('#product_list').datagrid('load',{
			name:productName,
			category:categoryId,
			status:productStatus
		});
	}
	
	/**
	 *	 @method 刷新本页的商品一览Grid(mainFrame在需要时会调用这个函数刷新本页面的数据)
	*/
	function reflushMe(){
		$('#product_list').datagrid('reload');
	}
</script>
</html>