package com.zhenningtech.leaning.basic.mapper;

import com.zhenningtech.leaning.basic.model.BasicEquipmentPicture;
import java.util.List;

import org.apache.ibatis.annotations.Param;

public interface BasicEquipmentPictureMapper {
    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table basic_equipment_picture
     *
     * @mbg.generated Thu Mar 28 11:50:55 CST 2019
     */
    int deleteByPrimaryKey(Integer id);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table basic_equipment_picture
     *
     * @mbg.generated Thu Mar 28 11:50:55 CST 2019
     */
    int insert(BasicEquipmentPicture record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table basic_equipment_picture
     *
     * @mbg.generated Thu Mar 28 11:50:55 CST 2019
     */
    BasicEquipmentPicture selectByPrimaryKey(Integer id);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table basic_equipment_picture
     *
     * @mbg.generated Thu Mar 28 11:50:55 CST 2019
     */
    List<BasicEquipmentPicture> selectAll();

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table basic_equipment_picture
     *
     * @mbg.generated Thu Mar 28 11:50:55 CST 2019
     */
    int updateByPrimaryKey(BasicEquipmentPicture record);
    
    int insertGeneratorKey(@Param("equipmentId") Integer equipmentId, @Param("attachmentId") Integer attachmentId);
	
	List<Integer> selectAttachmentIdsByEquipmentId(@Param("equipmentId") Integer equipmentId);
	
	int deleteByAttachmentId(@Param("attachmentId") Integer attachmentId);
}