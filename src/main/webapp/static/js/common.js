/**
 * @method 在Tabs对象中添加新Tab页，如果已经存在则将该Tab页设为选中
 * @param tabs Tabs对象，在此Tab对象中添加新的Tab页
 * @param title 新Tab页的title
 * @param url 新Tab页中显示内容的url
 */
function addTab(tabs, id, title, url) {
	//查找打开的Tab页里是否有title和id都一直的Tab页，如果找到则将该Tab页设为选中状态。
	var panels = tabs.tabs('tabs');
	if (panels != null) {
		for (var i = 0; i < panels.length; i ++) {
			if (panels[i].panel('options').id == id 
					&& panels[i].panel('options').title == title) {
				tabs.tabs('select', tabs.tabs('getTabIndex', panels[i]));
				return;
			}
		}
	}
	//没有查找到的话，则新建一个Tab页
	var content = '<iframe scrolling="auto" frameborder="0"  src="' + url + '" style="width:100%;height:100%;"></iframe>'
	tabs.tabs('add', {
		id:id,
		title : title,
		content : content,
		closable : true
	});
}

/**
 * @method 关闭Tabs对象当前Tab页
 * @param tabs Tabs对象
 */
function closeTab(tabs) {
	var tab = tabs.tabs('getSelected');
	var index = tabs.tabs('getTabIndex', tab);
	tabs.tabs('close', index);
}

/**
 * @method 获得当前项目的名称
 * @return 项目名称
 */
function getProjectName() {
	var projectName = window.document.location.pathname;
	projectName = projectName.substring(0, projectName.substr(1).indexOf('/') + 1);
	return projectName;
}

/**
 *  @method Grid点击行的事件中，取消了单击选中，再点击取消选中的功能
 *  @param index 点击行的index
 *  @param row 点击行的内容
*/
function onClickDataGridRow(index, row) {
	var rows = $(this).datagrid('getSelections');
	for (var i =0; i < rows.length; i ++) {
		if ($(this).datagrid('getRowIndex', rows[i]) == index) {
			$(this).datagrid('unselectRow', index);
			return;
		}
	}
	$(this).datagrid('selectRow', index);
}

/**
 * @method 关闭当前Tab页
 */
function cancelEdit() {
	var tabs = parent.$('#mainframe');
	closeTab(tabs);
}
/**
 *	 @method 格式化数值,保留两位小数
 *	 @param value 数值
 *	 @param value 行
 *	 @return 格式化后的数值
*/
function formatPrice(value, row) {
	if (value != null && value != 'undefined' && value != '') {
		return parseFloat(value).toFixed(2);
	}	
}

function editCell(grid, index, field) {
	var opts = grid.datagrid('options');
	if (opts.editIndex != undefined){
        if (grid.datagrid('validateRow', opts.editIndex)){
        	grid.datagrid('endEdit', opts.editIndex);
            opts.editIndex = undefined;
        } else {
            return;
        }
    }
	grid.datagrid('editCell', {
        index: index,
        field: field
    });
    opts.editIndex = index;
}

function setViewMode() {
	$('.easyui-textbox ').textbox({readonly:true});
	$('.easyui-combobox').combobox({readonly:true});
	$('.easyui-datebox').datebox({readonly:true});
	$('.easyui-combotree').combotree({readonly:true});
	$('.easyui-numberbox').numberbox({readonly:true});
	$('.easyui-menubutton').menubutton({disabled:true});
	var buttons = $('.easyui-linkbutton');
	 for (var i = 0; i < buttons.length; i ++) {
		 if ($(buttons[i]).linkbutton('options').text != '取消') {
			 $(buttons[i]).linkbutton({disabled:true});
		 }
	 }
}

function selectFiles(id, url, refreshFunction) {
	var dlg = $('#__selectfiles-dialog');
	var canceled = false;
	if(dlg.length == 0) {
		var dlgDiv = '<div id="__selectfiles-dialog" style="position:relative" />';
		$(dlgDiv).dialog({
			modal:true,
			width:500,
			height:150,
			title:'文件选择',
			href:getProjectName() + '/system/attachment/selectfiles',
			onLoad:function(){
				$(this).find('.easyui-form').form({
					iframe:false,
					url:url
				});
				$(this).find('.easyui-form').submit(uploadSubmit);
			},
			onClose:function(){
				if (refreshFunction != null && canceled == false) {
					refreshFunction();
				}
				$(this).dialog('destroy');
			},
			buttons:[{
				text:'保存',
				iconCls:'icon-save',
				handler:function() {
					uploadFiles();
				}
			},{
				text:'取消',
				iconCls:'icon-cancel',
				handler:function() {
					canceled = true;
					$('#__selectfiles-dialog').dialog('close');
				}
			}]
		});
	} else {
		dlg.dialog('open');
	}
}

function uploadSubmit(e) {
	var form = e.currentTarget;
	var url = $(form).form('options').url;
	$(form).form({url:null});
	$(form).ajaxSubmit({
		url:url,
		type:'post',
		beforeSubmit:function(){
			return $(form).form('validate');
		},
		success:function(data) {
			if (data.success == true) {
				$('#__selectfiles-dialog').dialog('close');
			} else {
				$.messager.alert('错误', data.message, 'error');
			}
		},
		error:function(XMLHttpRequest, textStatus, errorThrown) {
			$.messager.alert('严重错误','错误码:' + XMLHttpRequest.status,'error');
		}
	});
	e.preventDefault();
	return false;
}

function uploadFiles() {
	var uploadForm = $('#__selectfiles-dialog').find('.easyui-form');
	uploadForm.submit();
}

Date.prototype.Format = function(fmt) {
    var o = {
        "M+": this.getMonth() + 1, //月份
        "d+": this.getDate(), //日
        "h+": this.getHours(), //小时
        "m+": this.getMinutes(), //分
        "s+": this.getSeconds(), //秒
        "q+": Math.floor((this.getMonth() + 3) / 3), //季度
        "S": this.getMilliseconds() //毫秒
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