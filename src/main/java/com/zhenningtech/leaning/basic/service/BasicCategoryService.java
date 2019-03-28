package com.zhenningtech.leaning.basic.service;

import java.util.List;

import com.zhenningtech.leaning.basic.model.BasicCategory;
import com.zhenningtech.leaning.system.model.TreeNode;


public interface BasicCategoryService {
	
	List<TreeNode> selectCategoryTree(Integer pId);
	
	BasicCategory selectByPrimaryKey(Integer id);
	
	int insert(BasicCategory record);
	
	int updateByPrimaryKey(BasicCategory record);
	
	int deleteTree(Integer id);
	
	List<Integer> selectCategoryIds(Integer parentId);
}
