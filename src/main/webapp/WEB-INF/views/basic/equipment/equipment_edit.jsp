<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>设备编辑</title>
<c:set var="path" value="${pageContext.request.contextPath}"></c:set>
<link rel="stylesheet" type="text/css" href="${path}/static/jquery-easyui/themes/default/easyui.css" />
<link rel="stylesheet" type="text/css" href="${path}/static/jquery-easyui/themes/icon.css" />
<link rel="stylesheet" type="text/css" href="${path}/static/css/common.css" />
<script type="text/javascript" src="${path}/static/jquery-easyui/jquery.min.js"></script>
<script type="text/javascript" src="${path}/static/jquery-easyui/jquery.easyui.min.js"></script>
<script type="text/javascript" src="${path}/static/jquery-plugins/jquery.jqprint-0.3.js"></script>
<script type="text/javascript" src="${path}/static/jquery-plugins/jquery-migrate-1.4.1.min.js"></script>
<script type="text/javascript" src="${path}/static/jquery-easyui/locale/easyui-lang-zh_CN.js"></script>
<script type="text/javascript" src="${path}/static/jquery-plugins/jquery.form.js"></script>
<script type="text/javascript" src="${path}/static/js/common.js"></script>
</head>
<body>
    <div class="easyui-panel" title="商品信息" data-options="fit:true,border:false">
    	<form id="product_form" class="easyui-form" method="post" data-options="iframe:false">
    			<div id="pic-tool">
					<a href="#" class="icon-add easyui-tooltip" title="添加图片" onclick="addPicture()"></a>
					<a href="#" class="icon-remove easyui-tooltip" title="移除图片" onclick="deletePicture()"></a>
				</div>
				<div style="padding: 10px;width:400px;float:right">
					<div class="easyui-panel" style="padding: 10px" title="图片" data-options="width:400,tools:'#pic-tool'">
						<div style="text-align: center">
							<div style="height: 350px">
								<div style="margin:0 auto; width:300px;height:300px">
									<img id="picture-img" style="width:auto;height:auto;max-width:100%; max-height:100%"/>
								</div>
							</div>
							<div style="text-align:center">
								<div style="margin:0 auto; width: 30%">
									<div class="easyui-pagination" id="picture-pagination" data-options="layout:['first','prev','next','last']"></div>
								</div>
							</div>
						</div>
					</div>
				</div>
				<div style="margin-right: 400px">
					<div style="width: 100%">
						<input type="hidden" name="id" value="${product.id}" />
						<div style="padding:10px">
							<input id="product-no-textbox" name="no" labelPosition="left" class="easyui-textbox" style="width:95%" data-options="required:true,label:'设备编号:',icons:[{iconCls:'icon-barcode',handler:openBarcodeDlg}]" value="${product.no}" />
						</div>    
						<div style="padding: 10px">
							<input name="name" class="easyui-textbox" labelPosition="left" style="width: 95%"  data-options="required:true,label:'设备名称:'"  value="${product.name}"/>
						</div>
						<div div style="padding: 10px">
							<input class="easyui-combotree" id="category_combotree" name="category" labelPosition="left" style="width: 95%" data-options="required:true,label:'设备类型:'"  value="${product.category}"/>
						</div>
						<div div style="padding: 10px">
							<input name="address" class="easyui-textbox" labelPosition="left" style="width: 95%" data-options="label:'设备地址:'" value="${product.address}"/>
						</div>
						<div div style="padding: 10px">
							<label for="status">是否在用:</label>
							<td>
								<input id="status-switch" name="status" class="easyui-switchbutton" checked data-options="onText:'使用',offText:'停用'">
							</td>
						</div>
					</div>
				</div>
				<div style="text-align: right; padding: 10px 20px">
					<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-save',onClick:saveEquipment" style="width: 80px">保存</a>
					<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-cancel',onClick:cancelEdit" style="width: 80px">取消</a>
				</div>
			</form>   
    </div>
    <div id="barcode-dialog" class="easyui-dialog" title="商品二维码" style="width:500px;height:362px" 
    	data-options="closed:true,modal:true,toolbar: [{
					text:'打印标签',
					iconCls:'icon-print',
					handler:printBarcodeMark}]">
		<div div="barcodeMark">
			<img id="picture-barcode" style="width:300;height:300"></img>
		</div>
    </div>
</body>
<script type="text/javascript">
	/**
 	 *	 @method 页面载入
	*/
	$(function() {
		//获取商品类目树
		$.ajax({
			url : '${path}/basic/category/0',
			type : 'get',
			success : function(data) {
				$('#category_combotree').combotree('loadData', data);
			}
		});
		
		//删除临时的图片
		$.ajax({
			url:'${path}/basic/equipment/deletePictureTemp',
			type:'get',
			success:function(){}
		});

		
		
		
		
		
		
		
		
		
		
		//设置商品的状态(在售/停售)
		if ('${product.id}' == null || '${product.id}' == '') { //新建的情况，初始化始终为在售
			$('#status-switch').switchbutton({checked:true});
			$.ajax({
	            url:'${path}/common/generateCode',
	            type:'GET',
	            data:{
	            	tablename:'basic_product',
	            	codeColumn:'no',
	            },
	            success:function(data){
	            	$('#product-no-textbox').textbox('setValue', data);
	            }
	        });
		} else {  //编辑的情况
			if ('${product.status}' == 'true'){
				$('#status-switch').switchbutton({checked:true});
			} else {
				$('#status-switch').switchbutton({checked:false});
			}
		}
		
		//图片选择按钮初始化
		$('#picture-pagination').pagination({
			pageSize:1,
			pageNumber:1,
			onSelectPage:onSelectPicturePage
		});
		selectPicture('${product.id}', 1);

		//form提交函数设置,替换默认的操作
		$('#product_form').submit(productFormSubmit);
	});
	
	/**
	 *	 @method 商品信息form提交
	 *   @param e 事件对象
	*/
	function productFormSubmit(e) {
		var form = e.currentTarget;
		$(form).ajaxSubmit({        
			url:'${path}/basic/equipment/save',
			type:'post',
			async:false,
			beforeSubmit:function() {
				return $(form).form('validate');
			},
			success:function(data) {
				if (data.success == true) {
					$.messager.alert({
						title:'成功',
						msg:'保存商品成功!',
						icon:'info',
						fn:function(){
							parent.reflushSubFrame('商品管理');
							cancelEdit();
						}
					});
				} else {
					$.messager.alert('错误',data.message,'error');
				}
			}
		});
		e.preventDefault();
		return false;
	}
	
	/**
	 *	 @method 保存商品按钮事件(提交)
	*/
	function saveEquipment() {
		$('#product_form').submit();
	}

	/**
	 *	 @method 颜色选择下拉框的格式，在下拉框的每一行添加一个表示颜色的色块
	 *	 @return 格式化后的内容
	*/
	function formatColorList(row) {
		return '<div style="width:20px;height:20px;float:left;margin-right:10px;background:' + row.code + '"></div>' + row.name;
	}

	/**
	 *	 @method 颜色选择下拉框选中后，在框里显示的tag的颜色设置
	 *	 @return 格式化后的内容
	*/
	function colorTagStyler(value, row) {
		if (typeof(row) != 'undefined') {
			return 'background:' + row.code;
		} else {
			return value;
		}
	}
	
	/**
	 *	 @method 添加图片
	*/
	function addPicture() {
		selectFiles('${product.id}', '${path}/basic/equipment/uploadPicture', refreshPicture);
	}
	
	/**
	 *	 @method 删除图片
	*/
	function deletePicture() {
		if ($('#picture-pagination').pagination('options').total == 0) {
			$.messager.alert('错误','图片已全部删除！','error');
			return;
		}
		$.messager.confirm('删除', '确认要删除图片吗?', function(r){
			if (r) {
				var attachmentId = $('#picture-pagination').pagination('options').id;
				$.ajax({
					url:'${path}/basic/equipment/deletePicture',
					type:'get',
					data:{
						attachmentId:attachmentId
					},
					success:function(data){
						if (data.success == true) {
							var pagination = $('#picture-pagination');
							var total = pagination.pagination('options').total - 1;
							pagination.pagination({
								total:total
							});
							pagination.pagination('select');
						} else {
							$.messager.alert('错误',data.message,'error');
						}
					}
				});
			}
		});
	}
	
	/**
	 *	 @method 选择图片
	 *	 @param productId 商品ID
	 *	 @param index 图片index
	*/
	function selectPicture(productId, index) {
		$.ajax({
			url:'${path}/basic/equipment/selectPicture',
			type:'post',
			data:{
				productId:productId,
				index:index
			},
			success:function(data) {
				if (data.success == true) {
					$('#picture-pagination').pagination({
						total:data.total,
						id:data.attachmentId
					});
					if (data.pic != null && data.pic != '' && data.pic != 'undefined') {
						$('#picture-img').attr('src', '${path}/' + data.pic);
					} else {
						$('#picture-img').attr('src', '');
					}
				} 
			}
		});
	}
	
	/**
	 *	 @method 添加图片后刷新图片显示
	*/
	function refreshPicture() {
		var pagination = $('#picture-pagination');
		var total = pagination.pagination('options').total + 1;
		pagination.pagination({
			total:total
		});
		pagination.pagination('select', total);
	}
	
	/**
	 *	 @method 图片选择按钮点击时触发
	*/
	function onSelectPicturePage(pageNumber, pageSize) {
		selectPicture('${product.id}', pageNumber);
	}
	
	function openBarcodeDlg() {
		var no = $('#product-no-textbox').textbox('getValue');
		$('#barcode-dialog').dialog('open');
		$('#picture-barcode').attr('src', '${path}/common/generateBarcode/' + no);
	}
	
	function printBarcodeMark() {
		$('#printBarcodeMark').jqprint();
	}
</script>
</html>