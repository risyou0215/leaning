package com.zhenningtech.leaning.system.mapper;

import com.zhenningtech.leaning.system.model.SystemAttachment;
import java.util.List;

import org.apache.ibatis.annotations.Param;

public interface SystemAttachmentMapper {
    /**
	 * This method was generated by MyBatis Generator. This method corresponds to the database table system_attachment
	 * @mbg.generated  Wed Apr 03 09:31:47 CST 2019
	 */
	int deleteByPrimaryKey(Integer id);

	/**
	 * This method was generated by MyBatis Generator. This method corresponds to the database table system_attachment
	 * @mbg.generated  Wed Apr 03 09:31:47 CST 2019
	 */
	int insert(SystemAttachment record);

	/**
	 * This method was generated by MyBatis Generator. This method corresponds to the database table system_attachment
	 * @mbg.generated  Wed Apr 03 09:31:47 CST 2019
	 */
	SystemAttachment selectByPrimaryKey(Integer id);

	/**
	 * This method was generated by MyBatis Generator. This method corresponds to the database table system_attachment
	 * @mbg.generated  Wed Apr 03 09:31:47 CST 2019
	 */
	List<SystemAttachment> selectAll();

	/**
	 * This method was generated by MyBatis Generator. This method corresponds to the database table system_attachment
	 * @mbg.generated  Wed Apr 03 09:31:47 CST 2019
	 */
	int updateByPrimaryKey(SystemAttachment record);

	int insertGeneratorKey(SystemAttachment record);
	
	List<SystemAttachment> selectByAttachmentType(@Param("attachmentType")  String attachmentType);
	
	List<SystemAttachment> selectByIdsOrAttachmentType(@Param("attachmentType") String attachmentType, @Param("attachmentIds") List<Integer> attachmentIds);
	
	int updateAttachmentType(String attachmentType);
	
	int deleteByAttachmentType(String attachmentType);
}