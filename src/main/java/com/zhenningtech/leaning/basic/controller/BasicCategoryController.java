package com.zhenningtech.leaning.basic.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.zhenningtech.leaning.basic.model.BasicCategory;
import com.zhenningtech.leaning.basic.service.BasicCategoryService;
import com.zhenningtech.leaning.system.model.TreeNode;

@Controller
@RequestMapping("basic/category")
public class BasicCategoryController {
	@Autowired
	private BasicCategoryService basicCategoryService;
	
	@RequestMapping("edit")
	public ModelAndView edit() {
		ModelAndView mv = new ModelAndView("basic/category/category_edit");
		return mv;
	}
	
	@RequestMapping(value="{pId}", method=RequestMethod.GET)
	@ResponseBody
	public List<TreeNode> getCategoryTree(@PathVariable("pId") Integer pId) {
		return basicCategoryService.selectCategoryTree(pId);
	}
	
	@RequestMapping("select/{id}")
	@ResponseBody
	public BasicCategory getCategory(@PathVariable("id") Integer id) {
		return basicCategoryService.selectByPrimaryKey(id);
	}
	
	/**
	 * 保存指定的商品类目信息,如果没有该商品类目则新建商品类目
	 * @param category  商品类目信息
	 * @return 保存结果(成功:success=true,id=保存成功的商品类目ID 失败:success=false,message=错误信息)
	 */
	@RequestMapping(value="save", method=RequestMethod.POST)
	@ResponseBody
	public ModelMap save(BasicCategory category) {
		int result = 0;
		ModelMap modelMap = new ModelMap();
		try {
			if (category.getId() == null) {
				result = basicCategoryService.insert(category);
			} else {
				result = basicCategoryService.updateByPrimaryKey(category);
			}
			if (result == 1) {
				modelMap.put("success", true);
				modelMap.put("id", category.getId());
			} else {
				modelMap.put("success", false);
				modelMap.put("message", "保存商品类目失败!");
			}
		} catch (Exception e) {
			modelMap.put("success", false);
			modelMap.put("message", e.getMessage());
		}
		return modelMap;
	}
	
	/**
	 * 删除指定的商品类目及其子类目
	 * @param id 商品类目ID
	 * @return 保存结果(成功:success=true 失败:success=false,message=错误信息)
	 */
	@RequestMapping(value="delete/{id}", method=RequestMethod.GET)
	@ResponseBody
	public ModelMap delete(@PathVariable("id") Integer id) {
		ModelMap modelMap = new ModelMap();
		try {
			if (0 < basicCategoryService.deleteTree(id)) {
				modelMap.put("success", true);
			} else {
				modelMap.put("success", false);
				modelMap.put("message", "删除商品类目失败!");
			}
		} catch (Exception e) {
			modelMap.put("success", false);
			modelMap.put("message", e.getMessage());
		}
		return modelMap;
	}
}
