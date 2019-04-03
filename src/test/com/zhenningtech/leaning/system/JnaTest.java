package com.zhenningtech.leaning.system;

import static org.junit.jupiter.api.Assertions.*;

import org.junit.jupiter.api.AfterAll;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.TestInstance;
import org.junit.jupiter.api.TestInstance.Lifecycle;

import com.sun.jna.NativeLong;
import com.sun.jna.Pointer;
import com.sun.jna.ptr.IntByReference;
import com.zhenningtech.leaning.support.hikvision.HCNetSDK;

@TestInstance(Lifecycle.PER_CLASS)
class JnaTest {
	private HCNetSDK hCNetSDK = HCNetSDK.INSTANCE;
	private NativeLong lUserId = new NativeLong(-1);
	
	@BeforeAll
	void before() {
		hCNetSDK.NET_DVR_Init();
	}
	
	@AfterAll
	void after() {
		hCNetSDK.NET_DVR_Cleanup();
	}
	
	void login() {
		HCNetSDK.NET_DVR_DEVICEINFO_V30 m_strDeviceInfo = new HCNetSDK.NET_DVR_DEVICEINFO_V30();
		lUserId = hCNetSDK.NET_DVR_Login_V30("192.168.50.130", (short) 8000, "admin", "QAZqaz123", m_strDeviceInfo);
		assertTrue(lUserId.longValue() > -1);
	}
	
	void logout() {
		boolean ret = hCNetSDK.NET_DVR_Logout_V30(lUserId);	
		assertTrue(ret);
	}
	
	void createDevice() {
		IntByReference ibrBytesReturned = new IntByReference(0);
		HCNetSDK.NET_DVR_IPPARACFG_V40  m_strIpparaCfg = new HCNetSDK.NET_DVR_IPPARACFG_V40();
		m_strIpparaCfg.write();
		Pointer lpIpParaConfig = m_strIpparaCfg.getPointer();
		boolean ret = hCNetSDK.NET_DVR_GetDVRConfig(lUserId, HCNetSDK.NET_DVR_GET_IPPARACFG_V40, new NativeLong(0), lpIpParaConfig, m_strIpparaCfg.size(), ibrBytesReturned);
		assertTrue(ret);
	    m_strIpparaCfg.read();
	    
	    for(int i = 0; i < HCNetSDK.MAX_IP_CHANNEL; i ++) {
	    	if(m_strIpparaCfg.struStreamMode[i].byGetStreamType == 0) {
	    		m_strIpparaCfg.struStreamMode[i].uGetStream.setType(HCNetSDK.NET_DVR_IPCHANINFO_V40.class);
	    		m_strIpparaCfg.struStreamMode[i].uGetStream.read();
	    		if (m_strIpparaCfg.struStreamMode[i].uGetStream.struIPChan.byEnable == 1) {
	    			
	    		}
	    	}
	    }
		
	}
	
	@Test
	void test() {
		login();
		createDevice();
		logout();
	}

}
