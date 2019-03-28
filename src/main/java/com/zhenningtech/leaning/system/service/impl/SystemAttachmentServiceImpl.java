package com.zhenningtech.leaning.system.service.impl;

import java.io.File;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.commons.CommonsMultipartFile;

import com.zhenningtech.leaning.system.mapper.SystemAttachmentMapper;
import com.zhenningtech.leaning.system.model.SystemAttachment;
import com.zhenningtech.leaning.system.service.SystemAttachmentService;

@Service
@Transactional
public class SystemAttachmentServiceImpl implements SystemAttachmentService {

	@Autowired
	private SystemAttachmentMapper systemAttachmentMapper;
	
	@Override
	public int UploadAttachment(CommonsMultipartFile file, String path, SystemAttachment systemAttachment) throws Exception {
		File filePath = new File(path);
		if (!filePath.exists()) {
			filePath.mkdirs();
		}
		String originalFilename = file.getOriginalFilename();
		String filename = generateFilename(originalFilename);
		File newFile = new File(path + "/" + filename);
		
		systemAttachment.setName(filename);
		systemAttachment.setRealPath(path + "/" + filename);
		systemAttachment.setOriginalName(originalFilename);
		int result = systemAttachmentMapper.insertGeneratorKey(systemAttachment);
		file.transferTo(newFile);
		
		return result;
	}

	@Override
	public List<SystemAttachment> selectByIdsOrAttachmentType(String attachmentType, List<Integer> attachmentIds) {
		return systemAttachmentMapper.selectByIdsOrAttachmentType(attachmentType, attachmentIds);
	}
	
	public int updateAttachmentType(String attachmentType) {
		return systemAttachmentMapper.updateAttachmentType(attachmentType);
	}

	@Override
	public int deleteByAttachmentType(String attachmentType) {
		List<SystemAttachment> systemAttachments = selectByIdsOrAttachmentType(attachmentType, null);
		for (SystemAttachment systemAttachment : systemAttachments) {
			String filename = systemAttachment.getRealPath();
			File file = new File(filename);
			if (file.exists() && file.isFile()) {
				file.delete();
			}
		}
		return systemAttachmentMapper.deleteByAttachmentType(attachmentType);
	}

	@Override
	public int deleteByPrimaryKey(Integer id) {
		SystemAttachment systemAttachment = systemAttachmentMapper.selectByPrimaryKey(id);
		String filename = systemAttachment.getRealPath();
		File file = new File(filename);
		if (file.exists() && file.isFile()) {
			file.delete();
		}
		return systemAttachmentMapper.deleteByPrimaryKey(id);
	}

	private String generateFilename(String originFilename) {
		SimpleDateFormat format = new SimpleDateFormat("yyyyMMddHHmmss");
		Calendar calendar = Calendar.getInstance();
		String filename = format.format(calendar.getTime());
		String extension = originFilename.substring(originFilename.lastIndexOf("."));
		filename += extension;
		return filename;
	}

}
