package com.zhenningtech.leaning.system.service;

import java.util.List;

import com.zhenningtech.leaning.system.model.TreeNode;

public interface SystemMenuService {
	List<TreeNode> buildTree(Integer pId);
}
