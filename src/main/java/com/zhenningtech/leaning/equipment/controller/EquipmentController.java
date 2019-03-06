package com.zhenningtech.leaning.equipment.controller;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.zhenningtech.leaning.equipment.service.EquipmentService;


@Controller
@RequestMapping("equipment")
public class EquipmentController {

	@Autowired
	private EquipmentService equipmentService;
	
	@RequestMapping("customer")
	@ResponseBody
	public ModelMap getCustomerFlow() {
		ModelMap mp = new ModelMap();
		List<ModelMap> details = new ArrayList<ModelMap>();
		details.add(getCustomerDetail("一", 45, 1220));
		details.add(getCustomerDetail("二", 20, 1000));
		details.add(getCustomerDetail("三", 20, 1100));
		details.add(getCustomerDetail("四", 80, 1200));
		details.add(getCustomerDetail("五", 60, 1330));
		details.add(getCustomerDetail("六", 50, 900));
		details.add(getCustomerDetail("七", 50, 1150));
		details.add(getCustomerDetail("八", 55, 1100));
		mp.addAttribute("data", details);
		return mp; 
	}
	
	@RequestMapping("warning")
	@ResponseBody
	public ModelMap getEnergy() {
		ModelMap mp = new ModelMap();
		List<ModelMap> details = new ArrayList<ModelMap>();
		details.add(getWarningDetail(0, 1.5, 6.5));
		details.add(getWarningDetail(0, 1.3, 3));
		details.add(getWarningDetail(0, 2.5, 5.2));
		details.add(getWarningDetail(0, 5.9, 6.8));
		details.add(getWarningDetail(0, 6.0, 3.8));
		details.add(getWarningDetail(0, 7.8, 1.6));
		details.add(getWarningDetail(0, 8.7, 8.0));
		details.add(getWarningDetail(0, 8.8, 6.0));
		details.add(getWarningDetail(0, 10.8, 8.8));
		details.add(getWarningDetail(0, 11.6, 2.4));
		details.add(getWarningDetail(0, 12.3, 5.0));
		details.add(getWarningDetail(0, 12.7, 3.7));
		details.add(getWarningDetail(0, 14.0, 5.1));
		details.add(getWarningDetail(1, 4.2, 7.5));
		details.add(getWarningDetail(1, 7.2, 5.2));
		details.add(getWarningDetail(1, 11.2, 6.2));
		mp.addAttribute("data", details);
		return mp; 
	}
	
	private  ModelMap getCustomerDetail(String area, int renliu, int nenghao) {
		ModelMap detail = new ModelMap();
		detail.addAttribute("arrea", area);
		detail.addAttribute("renliu", renliu);
		detail.addAttribute("nenghao", nenghao);
		return detail;
	}
	
	private  ModelMap getWarningDetail(int type, double x, double y) {
		ModelMap detail = new ModelMap();
		detail.addAttribute("type", type);
		detail.addAttribute("x", x);
		detail.addAttribute("y", y);
		return detail;
	}
}
