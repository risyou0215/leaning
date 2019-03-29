package com.zhenningtech.leaning.basic.service;

import java.util.List;

public interface BasicEquipmentPictureService {
	int insert(Integer equipmentId, Integer attachmentId);
	
	int insertFromAttachment(Integer equipmentId);
	
	List<Integer> selectAttachmentIdsByEquipmentId(Integer equipmentId);
	
	int deleteByAttachmentId(Integer attachmentId);
}
