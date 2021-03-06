package com.zhenningtech.leaning.equipment.mapper;

import com.zhenningtech.leaning.equipment.model.Equipment;
import java.util.List;

public interface EquipmentMapper {
    /**
	 * This method was generated by MyBatis Generator. This method corresponds to the database table equipment
	 * @mbg.generated  Wed Mar 27 17:01:58 CST 2019
	 */
	int deleteByPrimaryKey(Integer id);

	/**
	 * This method was generated by MyBatis Generator. This method corresponds to the database table equipment
	 * @mbg.generated  Wed Mar 27 17:01:58 CST 2019
	 */
	int insert(Equipment record);

	/**
	 * This method was generated by MyBatis Generator. This method corresponds to the database table equipment
	 * @mbg.generated  Wed Mar 27 17:01:58 CST 2019
	 */
	Equipment selectByPrimaryKey(Integer id);

	/**
	 * This method was generated by MyBatis Generator. This method corresponds to the database table equipment
	 * @mbg.generated  Wed Mar 27 17:01:58 CST 2019
	 */
	List<Equipment> selectAll();

	/**
	 * This method was generated by MyBatis Generator. This method corresponds to the database table equipment
	 * @mbg.generated  Wed Mar 27 17:01:58 CST 2019
	 */
	int updateByPrimaryKey(Equipment record);

	List<Equipment> selectEquipmentByType(Integer type);
}