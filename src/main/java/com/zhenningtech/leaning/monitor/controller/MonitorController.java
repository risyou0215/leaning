package com.zhenningtech.leaning.monitor.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.zhenningtech.leaning.basic.model.BasicEquipment;
import com.zhenningtech.leaning.monitor.service.MonitorService;

@Controller
@RequestMapping("monitor")
public class MonitorController {
	
	@Autowired
	private MonitorService monitorService;
	
	@RequestMapping("preview")
	ModelAndView preview() {
		ModelAndView mv = new ModelAndView("monitor/preview/preview");
		return mv;
	}
	
	@RequestMapping("replay")
	ModelAndView replay() {
		ModelAndView mv = new ModelAndView("monitor/replay/replay");
		return mv;
	}

	@RequestMapping("list")
	@ResponseBody
	List<BasicEquipment> list() {
		return monitorService.getEquipmentList();
	}
}
