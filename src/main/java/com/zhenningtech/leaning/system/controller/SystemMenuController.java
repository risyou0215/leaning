package com.zhenningtech.leaning.system.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.zhenningtech.leaning.system.model.TreeNode;
import com.zhenningtech.leaning.system.service.SystemMenuService;

@Controller
@RequestMapping("system/menu")
public class SystemMenuController {
	@Autowired
	private SystemMenuService systemMenuService;
	
	@RequestMapping(value="{pId}", method=RequestMethod.GET)
	@ResponseBody
	public List<TreeNode> getMenu(@PathVariable("pId") Integer pId) {
		return systemMenuService.buildTree(pId);
	}
}
