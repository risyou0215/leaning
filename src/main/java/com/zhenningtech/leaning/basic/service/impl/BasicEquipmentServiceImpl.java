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
	private BasicEquipmentMapper basicProductMapper;   

	@Autowired
	private SystemAttachmentService systemAttachmentService;  //附件Service
	
	@Autowired
	private BasicCategoryService basicCategoryService;    //商品类目Service
	
	@Autowired
	private BasicEquipmentPictureService basicEquipmentPictureService;
	
	@Override
	public int newProduct(BasicEquipment record) {
		int result = basicProductMapper.insertGeneratorKey(record);	
		basicEquipmentPictureService.insertFromAttachment(record.getId());
		return result;
	}
	
	@Override
	public List<BasicEquipment> selectProductInPaging(Integer page, Integer rows, BasicEquipment basicProduct) {
		List<Integer> ids = basicCategoryService.selectCategoryIds(basicProduct.getCategory());
		PageHelper.startPage(page, rows);
		return basicProductMapper.selectProduct(ids, basicProduct);
	}

	@Override
	public int deleteProduct(List<Integer> equipmentId) {
		return basicProductMapper.deleteByPrimaryKeysLogic(equipmentId);
	}

	@Override
	public BasicEquipment selectProduct(Integer productId) {
		return basicProductMapper.selectProductByPrimaryKey(productId);
	}

	@Override
	public int updateProduct(BasicEquipment record) {
		int result = basicProductMapper.updateByPrimaryKeyWithoutDeleted(record);
		basicEquipmentPictureService.insertFromAttachment(record.getId());
		return result;
	}
	
	@Override
	public int uploadPicture(CommonsMultipartFile file, String path) throws Exception {
		SystemAttachment systemAttachment = new SystemAttachment();
		systemAttachment.setTypeName("PRODUCT");
		return systemAttachmentService.UploadAttachment(file, path, systemAttachment);
	}

	@Override
	public List<SystemAttachment> selectPicture(Integer equipmentId, Integer index) {
		List<Integer> attachmentIds = null;
		if (equipmentId != null) {
			attachmentIds = basicEquipmentPictureService.selectAttachmentIdsByEquipmentId(equipmentId);
		}
		PageHelper.startPage(index, 1);
		return systemAttachmentService.selectByIdsOrAttachmentType("PRODUCT", attachmentIds);
	}
	
	@Override
	public int deletePicture(Integer attachmentId) {
		basicEquipmentPictureService.deleteByAttachmentId(attachmentId);
		return systemAttachmentService.deleteByPrimaryKey(attachmentId);
	}
	
	@Override
	public int deletePictureTemp() {
		return systemAttachmentService.deleteByAttachmentType("PRODUCT");
	}
}
