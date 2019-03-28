package com.zhenningtech.leaning.system.service;

import java.util.List;

import org.springframework.web.multipart.commons.CommonsMultipartFile;

import com.zhenningtech.leaning.system.model.SystemAttachment;


public interface SystemAttachmentService {
	int UploadAttachment(CommonsMultipartFile file, String path, SystemAttachment systemAttachment) throws Exception;
	
	//List<SystemAttachment> selectByAttachmentType(String attachmentType);
	
	List<SystemAttachment> selectByIdsOrAttachmentType(String attachmentType, List<Integer> attachmentIds);
	
	int updateAttachmentType(String attachmentType);
	
	int deleteByAttachmentType(String attachmentType);
	
	int deleteByPrimaryKey(Integer id);
}
