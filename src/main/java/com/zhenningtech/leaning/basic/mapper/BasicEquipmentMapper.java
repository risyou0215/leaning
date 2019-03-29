package com.zhenningtech.leaning.basic.mapper;

import com.zhenningtech.leaning.basic.model.BasicEquipment;

import java.util.List;

import org.apache.ibatis.annotations.Param;

public interface BasicEquipmentMapper {
    /**
	 * This method was generated by MyBatis Generator. This method corresponds to the database table basic_equipment
	 * @mbg.generated  Thu Mar 28 11:50:55 CST 2019
	 */
	int deleteByPrimaryKey(Integer id);


	/**
	 * This method was generated by MyBatis Generator. This method corresponds to the database table basic_equipment
	 * @mbg.generated  Thu Mar 28 11:50:55 CST 2019
	 */
	int insert(BasicEquipment record);


	/**
	 * This method was generated by MyBatis Generator. This method corresponds to the database table basic_equipment
	 * @mbg.generated  Thu Mar 28 11:50:55 CST 2019
	 */
	BasicEquipment selectByPrimaryKey(Integer id);


	/**
	 * This method was generated by MyBatis Generator. This method corresponds to the database table basic_equipment
	 * @mbg.generated  Thu Mar 28 11:50:55 CST 2019
	 */
	List<BasicEquipment> selectAll();


	/**
	 * This method was generated by MyBatis Generator. This method corresponds to the database table basic_equipment
	 * @mbg.generated  Thu Mar 28 11:50:55 CST 2019
	 */
	int updateByPrimaryKey(BasicEquipment record);


	int insertGeneratorKey(BasicEquipment record);
	
	
	List<BasicEquipment> selectEquipment(@Param("categoryIds") List<Integer> categoryIds, @Param("equipment") BasicEquipment basicEquipment);
	
	int deleteByPrimaryKeysLogic(List<Integer> equipmentIds);
	
	BasicEquipment selectEquipmentByPrimaryKey(Integer equipmentId);
	
	int updateByPrimaryKeyWithoutDeleted(BasicEquipment record);
}