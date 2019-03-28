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
	private BasicEquipmentService basicEquipmentService;	//商品Service
	
	@Autowired
	private HttpServletRequest request;	//浏览器请求Request
	
	/**
	 * 跳转到商品一览页面(product_list.jsp)
	 * @return 重定向view
	 */
	@RequestMapping("list")
	public ModelAndView listProduct() {
		ModelAndView mv = new ModelAndView("basic/equipment/equipment_list");
		return mv;
	}
	
	/**
	 * 跳转到商品编辑页面(product_edit.jsp)
	 * @param productId 需要编辑商品的ID
	 * @return 重定向view
	 */
	@RequestMapping("edit/{id}")
	public ModelAndView editProduct(@PathVariable("id") Integer productId){
		ModelAndView mv = new ModelAndView("basic/equipment/equipment_edit");
		//将商品信息传给页面
		BasicEquipment basicProduct = basicEquipmentService.selectProduct(productId);
		mv.addObject("product", basicProduct);	
		return mv;
	}
	
	/**
	 * 跳转到商品新建页面(product_edit.jsp)
	 * @return 重定向view
	 */
	@RequestMapping("add")
	public ModelAndView addProduct() {
		ModelAndView mv = new ModelAndView("basic/equipment/equipment_edit");
		return mv;
	}
	
	/**
	 * 按查询条件获得商品信息列表(有分页功能)
	 * @param page 指定当前分页数
	 * @param rows 指定每页的商品信息条数
	 * @param basicProduct 商品信息(做为查询条件)
	 * @return 指定页的商品信息列表
	 */
	@RequestMapping(value="page", method=RequestMethod.GET)
	@ResponseBody
	public ModelMap page(@RequestParam(value="page", defaultValue="1") Integer page, 
			@RequestParam(value="rows", defaultValue="10") Integer rows, 
			BasicEquipment basicProduct) {
		ModelMap modelMap = new ModelMap();
		if (basicProduct.getCategory() == null) {	//如果没有指定商品类目的情况下，不做查询，返回空。(出于查询性能上的考虑，必须先指定商品类目)
			modelMap.put("total", 0);
			modelMap.put("rows", new ArrayList<BasicEquipment>());
		} else {  //指定了商品类目的情况，查询该类目下的商品
			List<BasicEquipment> products = basicEquipmentService.selectProductInPaging(page, rows, basicProduct);
			PageInfo<BasicEquipment> pageInfo = new PageInfo<BasicEquipment>(products);	//分页信息
			modelMap.put("total", pageInfo.getTotal());	//总的商品信息条数
			modelMap.put("rows", products);					//当页的商品信息列表
		}
		return modelMap;
	}
	
	/**
	 * 删除临时图片(清除数据库里残留的垃圾数据)
	 * @return 删除结果(成功:success=true,count=成功删除记录条数 失败:success=false,message=错误信息)
	 */
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
	
	/**
	 * 保存指定的商品信息,如果没有该商品则新建
	 * @param basicProduct 要保存的商品信息
	 * @return 保存结果(成功:success=true,id=成功保存商品的ID 失败:success=false,message=错误信息)
	 */
	@RequestMapping(value="save", method=RequestMethod.POST)
	@ResponseBody
	public ModelMap saveProduct(BasicEquipment basicProduct) {
		ModelMap modelMap = new ModelMap();
		try {
			int result = 0;
			if (basicProduct.getId() == null) {  //没有商品ID的情况，新建商品
				result = basicEquipmentService.newProduct(basicProduct);
			} else {  //有商品ID的情况，更新商品
				result = basicEquipmentService.updateProduct(basicProduct);
			}
			
			if (result == 1) {
				modelMap.put("success", true);
				modelMap.put("id", basicProduct.getId());
			} else {
				modelMap.put("success", false);
				modelMap.put("message", "保存商品失败!");
			}
		} catch (Exception e) {
			modelMap.put("success", false);
			modelMap.put("message", e.getMessage() != null ? e.getMessage() : "保存商品失败!");
		}
		return modelMap;
	}
	
	/**
	 * 删除指定的商品
	 * @param productIds 需删除商品的ID
	 * @return 删除结果(成功:success=true,count=成功删除商品条数 失败:success=false,message=错误信息)
	 */
	@RequestMapping(value="delete", method=RequestMethod.GET)
	@ResponseBody
	public ModelMap deleteProduct(@RequestParam("productIds") List<Integer> productIds) {
		ModelMap modelMap = new ModelMap();
		try {
			int result = basicEquipmentService.deleteProduct(productIds);
			if (result > 0) {
				modelMap.put("success", true);
				modelMap.put("count", result);
			} else {
				modelMap.put("success", false);
				modelMap.put("message", "删除商品失败!");
			}
			
		} catch (Exception e) {
			modelMap.put("success", false);
			modelMap.put("message", e.getMessage() != null ? e.getMessage() : "删除商品失败!");
		}
		return modelMap;
	}
	
	/**
	 * 上传商品对应的图片
	 * @param file 上传文件的信息
	 * @return 上传结果(成功:success=true,count=成功上传图片条数 失败:success=false,message=错误信息)
	 */
	@RequestMapping(value = "uploadPicture", method = RequestMethod.POST)
	@ResponseBody
	public ModelMap uploadPictrue(@RequestParam("file") CommonsMultipartFile file) {
		ModelMap modelMap = new ModelMap();
		try {
			String path = request.getSession().getServletContext().getRealPath("upload/product"); 	//取得服务器上实际存放图片文件的路径
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
	
	/**
	 * 获取商品对应的图片
	 * @param productId 商品ID
	 * @param index 图片的Index
	 * @return 查询结果(成功:success=true,pic=图片的相对路径,attachmentId=图片在附件(system_attachment)表里的ID,total=图片总数 
	 *                             失败:success=false,message=错误信息)
	 */
	@RequestMapping("selectPicture")
	@ResponseBody
	ModelMap selectPicture(@RequestParam("productId") Integer productId, 
			@RequestParam(value = "index", defaultValue="1") Integer index) {
		ModelMap modelMap = new ModelMap();
		try {
			List<SystemAttachment> systemAttachments = basicEquipmentService.selectPicture(productId, index);
			PageInfo<SystemAttachment> pageInfo = new PageInfo<SystemAttachment>(systemAttachments);
			if (systemAttachments.size() > 0) {
				modelMap.put("success", true);
				SystemAttachment systemAttachment = systemAttachments.get(0);
				modelMap.put("pic", "upload/product/" + systemAttachment.getName());
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
	
	/**
	 * 删除商品对应的图片
	 * @param attachmentId  图片在附件表(system_attachment)里的ID
	 * @return 删除结果(成功:success=true,count=成功删除图片条数 失败:success=false,message=错误信息)
	 */
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
	
	@RequestMapping("dialog")
	public ModelAndView dialog() {
		ModelAndView mv = new ModelAndView("basic/product/product_select");
		return mv;
	}
	
	/*@RequestMapping(value = "colors/{productId}", method = RequestMethod.GET)
	@ResponseBody
	public List<SystemColor> getProductColors(@PathVariable("productId") Integer productId) {
		return basicEquipmentService.getProductColors(productId);
	}
	
	@RequestMapping(value = "sizes/{productId}", method = RequestMethod.GET)
	@ResponseBody
	public List<SystemCode> getProductSizes(@PathVariable("productId") Integer productId) {
		List <SystemCode> sizes = basicEquipmentService.getProdcutSizes(productId);
		return sizes;
	}*/
}
