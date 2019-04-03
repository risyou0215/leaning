package com.zhenningtech.leaning.monitor.service.impl;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.sun.jna.NativeLong;
import com.sun.jna.Pointer;
import com.sun.jna.ptr.IntByReference;
import com.zhenningtech.leaning.basic.model.BasicEquipment;
import com.zhenningtech.leaning.basic.service.BasicEquipmentService;
import com.zhenningtech.leaning.monitor.service.MonitorService;
import com.zhenningtech.leaning.support.hikvision.HCNetSDK;

@Service
public class MonitorServiceImpl implements MonitorService {
	
	@Autowired
	private BasicEquipmentService basicEquipmentService;

	@Override
	public List<BasicEquipment> getEquipmentList() {
		List<BasicEquipment> equipments = basicEquipmentService.selectEquipmentByCategory(8);
		HCNetSDK hCNetSDK = HCNetSDK.INSTANCE;
		boolean ret = hCNetSDK.NET_DVR_Init();
		if (!ret) {return equipments;};
		for (BasicEquipment equipment : equipments) {
			HCNetSDK.NET_DVR_DEVICEINFO_V30 m_strDeviceInfo = new HCNetSDK.NET_DVR_DEVICEINFO_V30();
			NativeLong lUserId = hCNetSDK.NET_DVR_Login_V30(equipment.getAddress(), (short) 8000, equipment.getUsername(), equipment.getPassword(), m_strDeviceInfo);
			IntByReference ibrBytesReturned = new IntByReference(0);
			HCNetSDK.NET_DVR_IPPARACFG_V40  m_strIpparaCfg = new HCNetSDK.NET_DVR_IPPARACFG_V40();
			m_strIpparaCfg.write();
			Pointer lpIpParaConfig = m_strIpparaCfg.getPointer();
			hCNetSDK.NET_DVR_GetDVRConfig(lUserId, HCNetSDK.NET_DVR_GET_IPPARACFG_V40, new NativeLong(0), lpIpParaConfig, m_strIpparaCfg.size(), ibrBytesReturned);
		    m_strIpparaCfg.read();
		    List<BasicEquipment> children = new ArrayList<BasicEquipment>();
		    for(int i = 0; i < HCNetSDK.MAX_IP_CHANNEL; i ++) {
		    	if(m_strIpparaCfg.struStreamMode[i].byGetStreamType == 0) {
		    		m_strIpparaCfg.struStreamMode[i].uGetStream.setType(HCNetSDK.NET_DVR_IPCHANINFO_V40.class);
		    		m_strIpparaCfg.struStreamMode[i].uGetStream.read();
		    		if (m_strIpparaCfg.struStreamMode[i].uGetStream.struIPChan.byEnable == 1) {
		    			BasicEquipment monitor = new BasicEquipment();
		    			monitor.setAddress(equipment.getAddress());
		    			monitor.setUsername(equipment.getUsername());
		    			monitor.setPassword(equipment.getPassword());
		    			monitor.setName(String.format("摄像头%d", i));
		    			children.add(i, monitor);
		    		}
		    	}
		    }
		    equipment.setChildren(children);
			hCNetSDK.NET_DVR_Logout_V30(lUserId);
		}
		hCNetSDK.NET_DVR_Cleanup();
		return equipments;
	}

}
