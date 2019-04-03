package com.zhenningtech.leaning.basic.service;

import java.util.List;

import org.springframework.web.multipart.commons.CommonsMultipartFile;

import com.zhenningtech.leaning.basic.model.BasicEquipment;
import com.zhenningtech.leaning.system.model.SystemAttachment;

public interface BasicEquipmentService {
	
	int newEquipment(BasicEquipment record);
	
	List<BasicEquipment> selectEquipmentInPaging(Integer page, Integer rows, BasicEquipment basicEquipment);
	
	List<BasicEquipment> selectEquipmentByCategory(Integer categoryId);
	
	int deleteEquipment(List<Integer> equipmentIds);
	
	BasicEquipment selectEquipment(Integer equipmentId);
	
	int updateEquipment(BasicEquipment record);
	
	int uploadPicture(CommonsMultipartFile file, String path) throws Exception;
	
	List<SystemAttachment> selectPicture(Integer equipmentId, Integer index);
	
	int deletePicture(Integer attachmentId);
	
	int deletePictureTemp();
}
