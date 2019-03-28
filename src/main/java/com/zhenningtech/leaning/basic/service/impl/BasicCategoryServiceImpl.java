package com.zhenningtech.leaning.basic.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.zhenningtech.leaning.basic.mapper.BasicCategoryMapper;
import com.zhenningtech.leaning.basic.model.BasicCategory;
import com.zhenningtech.leaning.basic.service.BasicCategoryService;
import com.zhenningtech.leaning.system.model.TreeNode;

@Service
@Transactional
public class BasicCategoryServiceImpl implements BasicCategoryService {
	
	@Autowired
	private BasicCategoryMapper basicCategoryMapper;

	@Override
	public List<TreeNode> selectCategoryTree(Integer pId) {
		List<BasicCategory> categoryList = basicCategoryMapper.selectWithoutDeleted();
		return selectCategoryTree(categoryList, pId);
	}
	
	@Override
	public BasicCategory selectByPrimaryKey(Integer id) {
		return basicCategoryMapper.selectByPrimaryKey(id);
	}
	
	@Override
	public int insert(BasicCategory record) {
		return basicCategoryMapper.insertGeneratorKey(record);
	}

	@Override
	public int updateByPrimaryKey(BasicCategory record) {
		return basicCategoryMapper.updateByPrimaryKeyWithoutDeleted(record);
	}

	@Override
	public int deleteTree(Integer pId) {
		int result = 0;
		result = basicCategoryMapper.deleteByPrimaryKeyLogic(pId);
		List<BasicCategory> categoryList = basicCategoryMapper.selectWithoutDeleted();
		return result + deleteTree(categoryList, pId);
	}

	@Override
	public List<Integer> selectCategoryIds(Integer parentId) {
		List<Integer> ids = new ArrayList<Integer>();
		ids.add(parentId);
		List<BasicCategory> categorys = basicCategoryMapper.selectAll();
		ids.addAll(selectCategoryIds(categorys, parentId));
		return ids;
	}

	/**
	 * 创建指定父商品类目下的子商品类目树
	 * @param categoryList 所有的商品类目信息列表
	 * @param pId 指定父商品类目ID
	 * @return 子商品类目树
	 */
	private List<TreeNode> selectCategoryTree(List<BasicCategory> categoryList, Integer pId)
	{
		List<TreeNode> treeCategory = new ArrayList<TreeNode>();
		for (BasicCategory category : categoryList) {
			if (category.getParentId() == pId) {
				TreeNode node = new TreeNode();
				node.setId(category.getId());
				node.setpId(category.getParentId());
				node.setText(category.getName());
				Map<String, Object> attributes = new HashMap<String, Object>();
				attributes.put("code", category.getCode());
				node.setAttributes(attributes);
				node.setChildren(selectCategoryTree(categoryList, category.getId())); 	//递归添加子商品类目
				treeCategory.add(node);
			}
		}
		return treeCategory;
	}
	
	/**
	 * 删除指定父商品类目的子类目(逻辑删除)
	 * @param categoryList 所有的商品类目信息列表
	 * @param pId 指定父商品类目ID
	 * @return 成功删除商品类目数量
	 */
	private int deleteTree(List<BasicCategory> categorys, Integer pId) {
		int result = 0;
		for (BasicCategory category : categorys) {
			if (category.getParentId() == pId) {
				result += basicCategoryMapper.deleteByPrimaryKeyLogic(category.getId()); 
				result += deleteTree(categorys, category.getId());  //递归删除子商品类目
			}
		}
		return result;
	}
	
	/**
	 * 获取指定父商品类目下所有的子商品类目的ID
	 * @param categorys 所有商品类目信息列表
	 * @param pId 父商品类目ID
	 * @return 子商品类目ID列表
	 */
	private List<Integer> selectCategoryIds(List<BasicCategory> categorys, Integer pId) {
		List<Integer> ids = new ArrayList<Integer>();
		for (BasicCategory category : categorys) {
			if (category.getParentId() == pId) {
				ids.add(category.getId());
				ids.addAll(selectCategoryIds(categorys, category.getId()));
			}
		}
		return ids;
	}
}
