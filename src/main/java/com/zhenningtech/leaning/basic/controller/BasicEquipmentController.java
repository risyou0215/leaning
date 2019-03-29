package com.zhenningtech.leaning.basic.controller;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.commons.CommonsMultipartFile;
import org.springframework.web.servlet.ModelAndView;

import com.github.pagehelper.PageInfo;
import com.zhenningtech.leaning.basic.model.BasicEquipment;
import com.zhenningtech.leaning.basic.service.BasicEquipmentService;
import com.zhenningtech.leaning.system.model.SystemAttachment;

@Controller
@RequestMapping("basic/equipment")
public class BasicEquipmentController {
	@Autowired
	private BasicEquipmentService basicEquipmentService;
	
	@Autowired
	private HttpServletRequest request;	//浏览器请求Request
	
	@RequestMapping("list")
	public ModelAndView listEequipment() {
		ModelAndView mv = new ModelAndView("basic/equipment/equipment_list");
		return mv;
	}
	
	@RequestMapping("edit/{id}")
	public ModelAndView editEquipment(@PathVariable("id") Integer equipmentId){
		ModelAndView mv = new ModelAndView("basic/equipment/equipment_edit");
		//将设备信息传给页面
		BasicEquipment basicEquipment = basicEquipmentService.selectEquipment(equipmentId);
		mv.addObject("equipment", basicEquipment);	
		return mv;
	}
	
	@RequestMapping("add")
	public ModelAndView addEquipment() {
		ModelAndView mv = new ModelAndView("basic/equipment/equipment_edit");
		return mv;
	}
	
	@RequestMapping(value="page", method=RequestMethod.GET)
	@ResponseBody
	public ModelMap page(@RequestParam(value="page", defaultValue="1") Integer page, 
			@RequestParam(value="rows", defaultValue="10") Integer rows, 
			BasicEquipment basicEquipment) {
		ModelMap modelMap = new ModelMap();
		if (basicEquipment.getCategory() == null) {
			modelMap.put("total", 0);
			modelMap.put("rows", new ArrayList<BasicEquipment>());
		} else {  
			List<BasicEquipment> equipments = basicEquipmentService.selectEquipmentInPaging(page, rows, basicEquipment);
			PageInfo<BasicEquipment> pageInfo = new PageInfo<BasicEquipment>(equipments);	
			modelMap.put("total", pageInfo.getTotal());	
			modelMap.put("rows", equipments);					
		}
		return modelMap;
	}
	
	@RequestMapping("deletePictureTemp")
	@ResponseBody
	public ModelMap deletePictrueTemp() {
		ModelMap modelMap = new ModelMap();
		try {
			int result = basicEquipmentService.deletePictureTemp();
			modelMap.put("success", true);
			modelMap.put("count", result);
		} catch (Exception e) {
			modelMap.put("success", false);
			modelMap.put("message", e.getMessage());
		}	
		return modelMap;
	}
	
	@RequestMapping(value="save", method=RequestMethod.POST)
	@ResponseBody
	public ModelMap saveEquipment(BasicEquipment basicEquipment) {
		ModelMap modelMap = new ModelMap();
		try {
			int result = 0;
			if (basicEquipment.getId() == null) {  //没有设备ID的情况，新建设备
				result = basicEquipmentService.newEquipment(basicEquipment);
			} else {  //有设备ID的情况，更新设备
				result = basicEquipmentService.updateEquipment(basicEquipment);
			}
			
			if (result == 1) {
				modelMap.put("success", true);
				modelMap.put("id", basicEquipment.getId());
			} else {
				modelMap.put("success", false);
				modelMap.put("message", "保存设备失败!");
			}
		} catch (Exception e) {
			modelMap.put("success", false);
			modelMap.put("message", e.getMessage() != null ? e.getMessage() : "保存设备失败!");
		}
		return modelMap;
	}
	
	@RequestMapping(value="delete", method=RequestMethod.GET)
	@ResponseBody
	public ModelMap deleteEquipment(@RequestParam("equipmentIds") List<Integer> equipmentIds) {
		ModelMap modelMap = new ModelMap();
		try {
			int result = basicEquipmentService.deleteEquipment(equipmentIds);
			if (result > 0) {
				modelMap.put("success", true);
				modelMap.put("count", result);
			} else {
				modelMap.put("success", false);
				modelMap.put("message", "删除设备失败!");
			}
			
		} catch (Exception e) {
			modelMap.put("success", false);
			modelMap.put("message", e.getMessage() != null ? e.getMessage() : "删除设备失败!");
		}
		return modelMap;
	}
	
	@RequestMapping(value = "uploadPicture", method = RequestMethod.POST)
	@ResponseBody
	public ModelMap uploadPictrue(@RequestParam("file") CommonsMultipartFile file) {
		ModelMap modelMap = new ModelMap();
		try {
			String path = request.getSession().getServletContext().getRealPath("upload/equipment"); 	//取得服务器上实际存放图片文件的路径
			int result = basicEquipmentService.uploadPicture(file, path);
			if (result > 0) {
				modelMap.put("success", true);
				modelMap.put("count", result);
			} else {
				modelMap.put("success", false);
				modelMap.put("message", "上传图片失败!");
			}
		} catch (Exception e) {
			modelMap.put("success", false);
			modelMap.put("message", e.getMessage());
		}
		return modelMap;
	}
	
	@RequestMapping("selectPicture")
	@ResponseBody
	ModelMap selectPicture(@RequestParam("equipmentId") Integer equipmentId, 
			@RequestParam(value = "index", defaultValue="1") Integer index) {
		ModelMap modelMap = new ModelMap();
		try {
			List<SystemAttachment> systemAttachments = basicEquipmentService.selectPicture(equipmentId, index);
			PageInfo<SystemAttachment> pageInfo = new PageInfo<SystemAttachment>(systemAttachments);
			if (systemAttachments.size() > 0) {
				modelMap.put("success", true);
				SystemAttachment systemAttachment = systemAttachments.get(0);
				modelMap.put("pic", "upload/equipment/" + systemAttachment.getName());
				modelMap.put("attachmentId", systemAttachment.getId());
				modelMap.put("total", pageInfo.getTotal());
			} else {
				modelMap.put("success", true);
				modelMap.put("total", pageInfo.getTotal());
			}
		} catch (Exception e) {
			modelMap.put("success", false);
			modelMap.put("message", e.getMessage());
		}
		return modelMap;
	}
	
	@RequestMapping("deletePicture")
	@ResponseBody
	ModelMap deletePicture(@RequestParam("attachmentId") Integer attachmentId) {
		ModelMap modelMap = new ModelMap();
		try {
			int result = basicEquipmentService.deletePicture(attachmentId);
			if (result > 0) {
				modelMap.put("success", true);
				modelMap.put("count", result);
			} else {
				modelMap.put("success", false);
				modelMap.put("message", "删除图片失败!");
			}
		} catch (Exception e) {
			modelMap.put("success", false);
			modelMap.put("message", e.getMessage());
		}
		return modelMap;
	}
}
