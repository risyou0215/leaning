package com.zhenningtech.leaning.basic.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.zhenningtech.leaning.basic.mapper.BasicEquipmentPictureMapper;
import com.zhenningtech.leaning.basic.service.BasicEquipmentPictureService;
import com.zhenningtech.leaning.system.model.SystemAttachment;
import com.zhenningtech.leaning.system.service.SystemAttachmentService;

@Service
@Transactional
public class BasicEquipmentPictureServiceImpl implements BasicEquipmentPictureService {

	@Autowired
	private BasicEquipmentPictureMapper basicEquipmentPictureMapper;
	
	@Autowired
	private SystemAttachmentService systemAttachmentService;

	@Override
	public int insert(Integer equipmentId, Integer attachmentId) {
		return basicEquipmentPictureMapper.insertGeneratorKey(equipmentId, attachmentId);
	}

	@Override
	public int insertFromAttachment(Integer equipmentId) {
		int result = 0;
		List<SystemAttachment> systemAttachments = systemAttachmentService.selectByIdsOrAttachmentType("EQUIPMENT", null);
		result += systemAttachmentService.updateAttachmentType("EQUIPMENT");
		for (SystemAttachment systemAttachment : systemAttachments) {
			result += basicEquipmentPictureMapper.insertGeneratorKey(equipmentId, systemAttachment.getId());
		}
		return result;
	}

	@Override
	public List<Integer> selectAttachmentIdsByEquipmentId(Integer equipmentId) {
		return basicEquipmentPictureMapper.selectAttachmentIdsByEquipmentId(equipmentId);
	}

	@Override
	public int deleteByAttachmentId(Integer attachmentId) {
		return basicEquipmentPictureMapper.deleteByAttachmentId(attachmentId);
	}

}
