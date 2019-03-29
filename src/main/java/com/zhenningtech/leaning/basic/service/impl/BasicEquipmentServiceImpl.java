package com.zhenningtech.leaning.basic.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.commons.CommonsMultipartFile;

import com.github.pagehelper.PageHelper;

import com.zhenningtech.leaning.basic.mapper.BasicEquipmentMapper;
import com.zhenningtech.leaning.basic.model.BasicEquipment;
import com.zhenningtech.leaning.basic.service.BasicCategoryService;
import com.zhenningtech.leaning.basic.service.BasicEquipmentPictureService;
import com.zhenningtech.leaning.basic.service.BasicEquipmentService;
import com.zhenningtech.leaning.system.model.SystemAttachment;
import com.zhenningtech.leaning.system.service.SystemAttachmentService;

@Service
@Transactional
public class BasicEquipmentServiceImpl implements BasicEquipmentService {

	@Autowired
	private BasicEquipmentMapper basicEquipmentMapper;   

	@Autowired
	private SystemAttachmentService systemAttachmentService;  //附件Service
	
	@Autowired
	private BasicCategoryService basicCategoryService;    //设备类目Service
	
	@Autowired
	private BasicEquipmentPictureService basicEquipmentPictureService;
	
	@Override
	public int newEquipment(BasicEquipment record) {
		int result = basicEquipmentMapper.insertGeneratorKey(record);	
		basicEquipmentPictureService.insertFromAttachment(record.getId());
		return result;
	}
	
	@Override
	public List<BasicEquipment> selectEquipmentInPaging(Integer page, Integer rows, BasicEquipment basicEquipment) {
		List<Integer> ids = basicCategoryService.selectCategoryIds(basicEquipment.getCategory());
		PageHelper.startPage(page, rows);
		return basicEquipmentMapper.selectEquipment(ids, basicEquipment);
	}

	@Override
	public int deleteEquipment(List<Integer> equipmentId) {
		return basicEquipmentMapper.deleteByPrimaryKeysLogic(equipmentId);
	}

	@Override
	public BasicEquipment selectEquipment(Integer equipmentId) {
		return basicEquipmentMapper.selectEquipmentByPrimaryKey(equipmentId);
	}

	@Override
	public int updateEquipment(BasicEquipment record) {
		int result = basicEquipmentMapper.updateByPrimaryKeyWithoutDeleted(record);
		basicEquipmentPictureService.insertFromAttachment(record.getId());
		return result;
	}
	
	@Override
	public int uploadPicture(CommonsMultipartFile file, String path) throws Exception {
		SystemAttachment systemAttachment = new SystemAttachment();
		systemAttachment.setTypeName("EQUIPMENT");
		return systemAttachmentService.UploadAttachment(file, path, systemAttachment);
	}

	@Override
	public List<SystemAttachment> selectPicture(Integer equipmentId, Integer index) {
		List<Integer> attachmentIds = null;
		if (equipmentId != null) {
			attachmentIds = basicEquipmentPictureService.selectAttachmentIdsByEquipmentId(equipmentId);
		}
		PageHelper.startPage(index, 1);
		return systemAttachmentService.selectByIdsOrAttachmentType("EQUIPMENT", attachmentIds);
	}
	
	@Override
	public int deletePicture(Integer attachmentId) {
		basicEquipmentPictureService.deleteByAttachmentId(attachmentId);
		return systemAttachmentService.deleteByPrimaryKey(attachmentId);
	}
	
	@Override
	public int deletePictureTemp() {
		return systemAttachmentService.deleteByAttachmentType("EQUIPMENT");
	}
}
