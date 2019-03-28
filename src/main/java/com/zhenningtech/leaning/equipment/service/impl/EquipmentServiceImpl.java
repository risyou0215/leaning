package com.zhenningtech.leaning.equipment.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.zhenningtech.leaning.equipment.mapper.EquipmentMapper;
import com.zhenningtech.leaning.equipment.model.Equipment;
import com.zhenningtech.leaning.equipment.service.EquipmentService;
@Service
@Transactional
public class EquipmentServiceImpl implements EquipmentService {

	@Autowired
	private EquipmentMapper equipmentMapper;
	
	@Override
	public List<Equipment> getCustomerFlow() {
		return equipmentMapper.selectEquipmentByType(1);
	}

	@Override
	public List<Equipment> getEnergy() {
		return equipmentMapper.selectEquipmentByType(2);
	}
}
