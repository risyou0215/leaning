package com.zhenningtech.leaning.system.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.zhenningtech.leaning.system.mapper.SystemMenuMapper;
import com.zhenningtech.leaning.system.model.SystemMenu;
import com.zhenningtech.leaning.system.model.TreeNode;
import com.zhenningtech.leaning.system.service.SystemMenuService;

@Service
@Transactional
public class SystemMenuServiceImpl implements SystemMenuService {
	@Autowired
	private SystemMenuMapper systemMenuMapper;
	
	
	@Override
	public List<TreeNode> buildTree(Integer pId) {
		List<SystemMenu> menuList = systemMenuMapper.selectAll();
		return buildTree(menuList, pId);
	}

	private List<TreeNode> buildTree(List<SystemMenu> menuList, Integer pId)
	{
		List<TreeNode> treeMenu = new ArrayList<TreeNode>();
		for (SystemMenu menu : menuList) {
			if (menu.getpId() == pId) {
				TreeNode node = new TreeNode();
				Map<String, Object> attributes = new HashMap<String, Object>();
				node.setId(menu.getId());
				node.setpId(menu.getpId());
				node.setText(menu.getName());
				attributes.put("action", menu.getAction());
				node.setAttributes(attributes);
				node.setChildren(buildTree(menuList, menu.getId()));
				treeMenu.add(node);
			}
		}
		return treeMenu;
	}
}
