<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>设备分类编辑</title>
<c:set var="path" value="${pageContext.request.contextPath}"></c:set>
<link rel="stylesheet" type="text/css" href="${path}/static/jquery-easyui/themes/default/easyui.css" />
<link rel="stylesheet" type="text/css" href="${path}/static/jquery-easyui/themes/icon.css" />
<script type="text/javascript" src="${path}/static/jquery-easyui/jquery.min.js"></script>
<script type="text/javascript" src="${path}/static/jquery-easyui/jquery.easyui.min.js"></script>
<script type="text/javascript" src="${path}/static/jquery-easyui/locale/easyui-lang-zh_CN.js"></script>
<script type="text/javascript" src="${path}/static/jquery-plugins/jquery.form.js"></script>
</head>
<body class="easyui-layout">
	<div id="p" data-options="region:'west',split:true" title="设备类目" style="width: 300px;border-top:0px; border-left:0px; border-bottom:0px">
		<div class="easyui-layout" data-options="fit:true,border:false">
			<div class="easyui-panel" style="padding: 2px 5px; border-top: 0px; border-left: 0px; border-right: 0px;" data-options="region:'north',border:false"> 
				<a href="#" class="easyui-linkbutton easyui-tooltip" title="编辑" data-options="plain:true,iconCls:'icon-edit',onClick:editCategory"></a>
				<a href="#" class="easyui-linkbutton easyui-tooltip" title="新增" data-options="plain:true,iconCls:'icon-add',onClick:newCategory"></a>
				<a href="#" class="easyui-linkbutton easyui-tooltip" title="删除" data-options="plain:true,iconCls:'icon-remove',onClick:deleteCategory"></a>
				<a href="#" class="easyui-linkbutton easyui-tooltip" title="取消选择" data-options="plain:true,iconCls:'icon-clear',onClick:cancelSelected"></a>
			</div>
			<div data-options="region:'center', border:false">
				<div id="category-accordion" class="easyui-accordion" data-options="fit:true, border:false">	
				</div>
			</div>
		</div>
	</div>
	<div data-options="region:'center'" title="设备类目详情" style="border-top:0px; border-right:0px; border-bottom:0px;padding:20px;">
		<div class="easyui-panel" style="padding: 10px;width:550px">
			<form id="category_form" class="easyui-form" method="post">
				<input id="id" name="id" type="hidden" /> 
				<input id="parentId" name="parentId" type="hidden">
				<div class="easyui-panel" style="padding: 5px; border: 0px;">
					<div style="padding: 10px;">
						<label for="code">设备类目编号:</label>
						<input id="code" class="easyui-textbox required" name="code" style="width: 400px">
					</div>
					<div style="padding: 10px;">
						<label for="name">设备类目名称:</label> 
						<input id="name" class="easyui-textbox required" name="name" style="width: 400px">
					</div>
					<div style="padding: 10px;">
						<label for="status">启用:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</label>
						<input id="status" class="easyui-switchbutton" name="status" checked>
					</div>
					<div style="padding: 10px;">
						<label for="description" style="vertical-align: top">设备类型描述:</label>
						<input id="description" class="easyui-textbox" name="description" multiline="true" style="width: 400px; height: 120px">
					</div>
					<div style="text-align: right; padding: 2px 5px">
						<a id="save" href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-save', onClick:saveCategory" style="width: 80px">保存</a> 
						<a id="clear" href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-cancel', onClick:clearCategory" style="width: 80px">清除</a>
					</div>
				</div>
			</form>
		</div>
	</div>
</body>
<script type="text/javascript">
	
 	/**
 	  *	 @method 页面载入
	*/
	$(function(){
		//获得设备类目树(根类添加panel，子类以树形结构展示)
		$.ajax({
			url:'${path}/basic/category/0',
			type:'get',
			data:{},
			cache:false,
			success:function(data){
				for(category in data) {
					addCategoryPanel(data[category].id, data[category].text, data[category].children, data[category].attributes.code, category == 0 ? true : false);
				}
			}
		});
		$('#category_form').submit(categoryFormSubmit);  //绑定设备类目form的submit函数
		setMode('view');  //设置为查看模式
	});
	
	/**
	 *	 @method 设备类目信息form提交
	 *   @param e 事件对象
	*/
	function categoryFormSubmit(e){
		var form = e.currentTarget;
		$(form).ajaxSubmit({
			url:'${path}/basic/category/save',
			type:'post',
			beforeSubmit:function(){
				//提交前先数据验证，数据验证失败是返回false，不提交form
				return $(form).form('validate');
			},
			success:function(data) {
				if (data.success == true) {  //成功
		    		$.messager.alert('成功','保存设备类目成功!','info');
				    //取得当前选中的设备类目节点
		    		var panel = $('#category-accordion').accordion('getSelected');
		        	var category_tree = $('#tree' + (panel.panel('options').id));
		        	var category = category_tree.tree('getSelected');
		        	//成功的情况下，更新页面上设备类目数的信息(不再向后台取数据)
		    		if($('#id').val() != null && $('#id').val() != '') {  //更新的情况
			        	category_tree.tree('update', {
			        		target:category.target,
			        		text:$('#name').val()
			        	});
			        }  else {  //新建的情况
			        	if (category == null) { //新建根目(没有指定父节点)
			        		category_tree.tree('append', {
				        		data:[{
				        			id:data.id,
					        		text:$('#name').val()
				        		}]	
				        	});
			        	} else {  //新建子目(指定了父节点)
			        		category_tree.tree('append', {
				        		parent:category.target,
				        		data:[{
				        			id:data.id,
					        		text:$('#name').val()
				        		}]	
				        	});
			        	}
			        }
		    		setMode('view');  //设置为查看模式
		    	} else {  //失败
		        	$.messager.alert('错误',data.message,'error');
		        }
			}
		});
	}
	
	/**
	 *	 @method 设置页面的模式(查看模式和编辑模式)
	 *   @param mode 指定模式(查看模式:'view' 编辑模式:'edit')
	*/
	function setMode(mode){
		if (mode == 'view') {
			$('#code').textbox({readonly:true, required:false});
			$('#name').textbox({readonly:true, required:false});
			$('#status').switchbutton({readonly:true});
			$('#description').textbox({readonly:true});
			$('#save').linkbutton({disabled:true});
			$('#clear').linkbutton({disabled:true});	
		} else if (mode == 'edit') {
			$('#code').textbox({readonly:false, required:true});
			$('#name').textbox({readonly:false, required:true});
			$('#status').switchbutton({readonly:false});
			$('#description').textbox({readonly:false});
			$('#save').linkbutton({disabled:false});
			$('#clear').linkbutton({disabled:false});
		}
	}
	
	/**
	 *	 @method 在页面左边的accordion里增加一个设备类目的panel
	 *   @param id 设备类目ID
	 *   @param title 设备类目title
	 *   @param data 该设备类目的子目录树JSON数据
	 *   @param selected 该设备类目panel是否设置为被选中
	*/
	function addCategoryPanel(id, title, data, code,selected) {
		$('#category-accordion').accordion('add', {
            id:id,
            title:title,
            content: '<div id="tree' + id + '" class="easyui-tree" data-options="fit:true, border:false,onSelect:onSelect"></div>',
            selected:selected,
            code:code
        });
        $('#tree' + id).tree('loadData', data);
	}
	
	/**
	 *	 @method 设置页面为编辑模式(编辑按钮点击是触发)
	*/
	function editCategory() {
		//取得当前选中的设备类目节点
		var panel = $('#category-accordion').accordion('getSelected');
		var category_tree = $('#tree' + (panel.panel('options').id));
		var category = category_tree.tree('getSelected');
		if (category == null) {	//如果没有任何节点被选中，则报错
			$.messager.alert('错误','请选择想要编辑的设备类目!','error');
			return;
		}
		setMode('edit');  //设置为编辑模式
	}
	
	/**
	 *	 @method 设置页面为新建模式(编辑新建点击是触发)
	*/
	function newCategory() {
		var code = $('#code').textbox('getValue');
		//清空from里设备类目信息
		$('#category_form').form('clear');
		$('#status').switchbutton('reset');
		//取得当前选中的设备类目节点
		var panel = $('#category-accordion').accordion('getSelected');
		var category_tree = $('#tree' + (panel.panel('options').id));
		var category = category_tree.tree('getSelected');
		if (category == null) {  //如果没有任何节点被选中，则将panel对应的设备类目作为父类目
			$('#parentId').val(panel.panel('options').id);
			code = panel.panel('options').code;
		} else {  ////如果有节点被选中，则将该节点的设备类目作为父类目
			$('#parentId').val(category.id);
		}
		$.ajax({
            url:'${path}/common/generateCode',
            type:'GET',
            data:{
            	tablename:'basic_category',
            	codeColumn:'code',
            	prefix:code,
            	length:3,
            	parentIdField:'parent_id',
            	parentId:$('#parentId').val()
            },
            success:function(data){
            	$('#code').textbox('setValue', data);
            }
        });
		setMode('edit');   //设置为编辑模式
	}
	
	/**
	 *	 @method 删除指定的设备类目及其子类目
	*/
	function deleteCategory() {
		//取得当前选中的设备类目节点
		var panel = $('#category-accordion').accordion('getSelected');
		var category_tree = $('#tree' + (panel.panel('options').id));
		var category = category_tree.tree('getSelected');
		if (category == null) {  //如果没有任何节点被选中，则报错
			$.messager.alert('错误','请选择想要删除的设备类目!','error');
			return;
		}
		//删除指定的设备类目及其子类目
		$.messager.confirm('删除', '确认要删除该设备类目吗?', function(r){
			if (r) {
				$.ajax({
					url:'${path}/basic/category/delete/' + category.id,
					type:'get',
					success:function(data) {
						if (data.success == true) {   //删除成功
							$.messager.alert('成功','删除设备类目成功!','info');
							category_tree.tree('remove', category.target);
							$('#category_form').form('clear');
							$('#status').switchbutton('reset');
							setMode('view');
						} else {  //删除失败
							$.messager.alert('错误',data.message,'error');
						}
					}
				});
			}
		});
		
	}
	
	/**
	 *	 @method 保存编辑的设备类目(提交设备类目form)
	*/
	function saveCategory() {
		$('#category_form').submit();	
	}
	
	/**
	 *	 @method 清空form里设备类目信息
	*/
	function clearCategory() {
		$('#category_form').form('clear');
		$('#status').switchbutton('reset');
	}
	
	/**
	 *	 @method 设备类目选中时，取得该类目的信息并显示
	*/
	function onSelect(node) {
		$.ajax({
			url:'${path}/basic/category/select/' + node.id,
			type:'get',
			cache:false,
			success:function(data){
				$('#id').val(data.id);
				$('#parentId').val(data.parentId);
				$('#code').textbox({value:data.code});
				$('#name').textbox({value:data.name});
				if (data.status == true) {
					$('#status').switchbutton('check');
				} else {
					$('#status').switchbutton('uncheck');
				}
				$('#description').textbox({value:data.description});
			}
		});
		setMode('view');   //设置成查看模式
    }
	
	/**
	 *	 @method 取消对设备类目树节点的选中
	*/
	function cancelSelected() {
		clearCategory();
		setMode('view');   //设置成查看模式
		var panel = $('#category-accordion').accordion('getSelected');
		var category_tree = $('#tree' + (panel.panel('options').id));
		var category = category_tree.tree('getSelected');
		if (category == null) {
			return;
		} else {
			$(category.target).removeClass('tree-node-selected');
		}
	}
</script>
</html>