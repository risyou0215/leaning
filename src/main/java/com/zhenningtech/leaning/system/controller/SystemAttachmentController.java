package com.zhenningtech.leaning.system.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

@Controller
@RequestMapping("system/attachment")
public class SystemAttachmentController {
	@RequestMapping("selectfiles")
	public ModelAndView selectFiles() {
		ModelAndView mv = new ModelAndView("system/attachment/files_select");
		return mv;
	}
}
