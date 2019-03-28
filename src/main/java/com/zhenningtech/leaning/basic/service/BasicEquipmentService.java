package com.zhenningtech.leaning.basic.service;

import java.util.List;

import org.springframework.web.multipart.commons.CommonsMultipartFile;

import com.zhenningtech.leaning.basic.model.BasicEquipment;
import com.zhenningtech.leaning.system.model.SystemAttachment;

public interface BasicEquipmentService {
	/**
	 * 新建商品信息
	 * @param record 商品信息
	 * @return 新建商品信息条数
	 */
	int newProduct(BasicEquipment record);
	
	/**
	 * 按分页获取商品信息列表
	 * @param page  当前页数
	 * @param rows  每页的记录条数
	 * @param basicProduct 商品信息(做为查询条件)
	 * @return 商品信息一览
	 */
	List<BasicEquipment> selectProductInPaging(Integer page, Integer rows, BasicEquipment basicProduct);
	
	/**
	 * 删除商品
	 * @param productIds 商品ID
	 * @return 删除商品条数
	 */
	int deleteProduct(List<Integer> productIds);
	
	/**
	 * 根据商品ID取得商品信息
	 * @param productId 商品ID
	 * @return 商品信息
	 */
	BasicEquipment selectProduct(Integer productId);
	
	/**
	 * 更新商品信息
	 * @param record 商品信息
	 * @return 更新商品信息条数
	 */
	int updateProduct(BasicEquipment record);
	
	/**
	 * 上传图片
	 * @param file 文件信息
	 * @param path 保存路径
	 * @return 上传文件条数
	 * @throws Exception
	 */
	int uploadPicture(CommonsMultipartFile file, String path) throws Exception;
	
	/**
	 * 取得商品对应的图片
	 * @param productId 商品ID
	 * @param index 图片Index
	 * @return 图片附件信息
	 */
	List<SystemAttachment> selectPicture(Integer productId, Integer index);
	
	/**
	 * 删除商品对应的图片
	 * @param attachmentId 图片附件ID
	 * @return 删除图片条数
	 */
	int deletePicture(Integer attachmentId);
	
	/**
	 * 删除临时图片(清除数据库里残留的垃圾数据)
	 * @return 删除图片条数
	 */
	int deletePictureTemp();
}
