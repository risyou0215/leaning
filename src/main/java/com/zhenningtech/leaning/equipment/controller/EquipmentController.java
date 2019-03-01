package com.zhenningtech.leaning.equipment.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.zhenningtech.leaning.equipment.model.Equipment;
import com.zhenningtech.leaning.equipment.service.EquipmentService;


@Controller
@RequestMapping("equipment")
public class EquipmentController {

	@Autowired
	private EquipmentService equipmentService;
	
	@RequestMapping("customer")
	@ResponseBody
	public List<Equipment> getCustomerFlow() {
		return equipmentService.getCustomerFlow();
	}
	
	@RequestMapping("energy")
	@ResponseBody
	public List<Equipment> getEnergy() {
		return equipmentService.getEnergy();
	}
}
