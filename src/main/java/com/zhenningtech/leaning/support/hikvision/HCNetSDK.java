package com.zhenningtech.leaning.support.hikvision;

import java.util.Arrays;
import java.util.List;

import com.sun.jna.Library;
import com.sun.jna.Native;
import com.sun.jna.NativeLong;
import com.sun.jna.Pointer;
import com.sun.jna.Structure;
import com.sun.jna.Union;
import com.sun.jna.ptr.IntByReference;

public interface HCNetSDK extends Library {
	HCNetSDK INSTANCE = (HCNetSDK)Native.loadLibrary("C:\\hikvision64\\HCNetSDK.dll", HCNetSDK.class); 
	
	public static final int SERIALNO_LEN = 48;
	public static final int MAX_ANALOG_CHANNUM = 32;
	public static final int MAX_IP_CHANNEL = 32;
	public static final int MAX_CHANNUM_V30 = (MAX_ANALOG_CHANNUM + MAX_IP_CHANNEL);
	public static final int NAME_LEN = 32;
	public static final int PASSWD_LEN = 16;
	public static final int MAX_DOMAIN_NAME = 64;
	public static final int MAX_IP_DEVICE_V40 = 64;
	
	public static final int NET_DVR_GET_IPPARACFG_V40 = 1062;
	
	boolean  NET_DVR_Init();
	boolean  NET_DVR_Cleanup();
	NativeLong  NET_DVR_Login_V30(String sDVRIP, short wDVRPort, String sUserName, String sPassword, NET_DVR_DEVICEINFO_V30 lpDeviceInfo);
	boolean  NET_DVR_Logout_V30(NativeLong lUserID);
	boolean  NET_DVR_GetDVRConfig(NativeLong lUserID, int dwCommand,NativeLong lChannel, Pointer lpOutBuffer, int dwOutBufferSize, IntByReference lpBytesReturned);
	
	public static class NET_DVR_DEVICEINFO_V30 extends Structure
	{
	   public  byte[] sSerialNumber = new byte[SERIALNO_LEN];
	   public  byte byAlarmInPortNum;
	   public  byte byAlarmOutPortNum;
	   public  byte byDiskNum;
	   public  byte byDVRType;
	   public  byte byChanNum;
	   public  byte byStartChan;
	   public  byte byAudioChanNum;
	   public  byte byIPChanNum;
	   public  byte[] byRes1 = new byte[24];
	}
	
	public static class NET_DVR_IPPARACFG_V40 extends Structure {
	       public  int  dwSize;
	       public  int  dwGroupNum;
	       public  int  dwAChanNum;
	       public  int  dwDChanNum;
	       public  int  dwStartDChan;
	       public  byte[]  byAnalogChanEnable = new byte[MAX_CHANNUM_V30];
	       public NET_DVR_IPDEVINFO_V31[] struIPDevInfo = new NET_DVR_IPDEVINFO_V31[MAX_IP_DEVICE_V40];
	       public NET_DVR_STREAM_MODE[]  struStreamMode =new NET_DVR_STREAM_MODE[MAX_CHANNUM_V30];
	       public byte[] byRes2=new byte[20];
	}
	
	public class NET_DVR_IPDEVINFO_V31 extends Structure {

		public byte byEnable;/* 该通道是否启用 */
		public byte byProType;//协议类型(默认为私有协议)，0- 私有协议，1- 松下协议，2- 索尼，更多协议通过NET_DVR_GetIPCProtoList获取。
		public byte byEnableQuickAdd;//0-不支持快速添加；1-使用快速添加
		public byte byRes1;//保留，置为0
		public byte[] sUserName =new byte[HCNetSDK.NAME_LEN];//用户名
		public byte[] sPassword = new byte[HCNetSDK.PASSWD_LEN];//密码
		public byte[] byDomain=new byte[HCNetSDK.MAX_DOMAIN_NAME];//设备域名
		public NET_DVR_IPADDR struIP;//IP地址
		public short wDVRPort;//端口号
		public byte[] szDeviceID= new byte[32];
		public byte[] byRes2 = new byte[2];//保留，置为0

		public NET_DVR_IPDEVINFO_V31() {
			super();
		}

		protected List<?> getFieldOrder() {
			return Arrays.asList("byEnable","byProType","byEnableQuickAdd","byRes1","sUserName","sPassword","byDomain","struIP","wDVRPort","szDeviceID","byRes2");
		}


		public static class ByReference extends NET_DVR_IPDEVINFO_V31 implements
				Structure.ByReference {

		};

		public static class ByValue extends NET_DVR_IPDEVINFO_V31 implements
				Structure.ByValue {

		};
	}
	
	public static class NET_DVR_IPADDR extends Structure {
        public byte[] sIpV4 = new byte[16];
        public byte[] byRes = new byte[128];

        public String toString() {
            return "NET_DVR_IPADDR.sIpV4: " + new String(sIpV4) + "\n" + "NET_DVR_IPADDR.byRes: " + new String(byRes) + "\n";
        }
    }



	public static class NET_DVR_ETHERNET_V30 extends Structure {
		public NET_DVR_IPADDR struDVRIP;
		public NET_DVR_IPADDR struDVRIPMask;
		public int dwNetInterface;
		public short wDVRPort;
		public short wMTU;
		public byte[] byMACAddr = new byte[6];

		public String toString() {
			return "NET_DVR_ETHERNET_V30.struDVRIP: \n" + struDVRIP + "\n" + "NET_DVR_ETHERNET_V30.struDVRIPMask: \n"
					+ struDVRIPMask + "\n" + "NET_DVR_ETHERNET_V30.dwNetInterface: " + dwNetInterface + "\n"
					+ "NET_DVR_ETHERNET_V30.wDVRPort: " + wDVRPort + "\n" + "NET_DVR_ETHERNET_V30.wMTU: " + wMTU + "\n"
					+ "NET_DVR_ETHERNET_V30.byMACAddr: " + new String(byMACAddr) + "\n";
		}
	}
	
	public class NET_DVR_STREAM_MODE extends Structure {

	     public byte  byGetStreamType;//取流方式：0- 直接从设备取流；1- 从流媒体取流；2- 通过IPServer获得IP地址后取流；
	     //3- 通过IPServer找到设备，再通过流媒体取设备的流； 4- 通过流媒体由URL去取流；5- 通过hiDDNS域名连接设备然后从设备取流
	     public byte[] byRes= new byte[3];//保留，置为0
	     public NET_DVR_GET_STREAM_UNION  uGetStream =new NET_DVR_GET_STREAM_UNION();//不同取流方式联合体

	     public NET_DVR_STREAM_MODE() {
			super();
	     }

	     protected List<?> getFieldOrder() {
			return Arrays.asList("byGetStreamType", "byRes","uGetStream");
	     }
	}
	
	public static class NET_DVR_GET_STREAM_UNION extends Union
	{
	    public NET_DVR_IPCHANINFO      struChanInfo = new NET_DVR_IPCHANINFO(); 
	    public NET_DVR_PU_STREAM_CFG   struPUStream = new NET_DVR_PU_STREAM_CFG(); 
	    public NET_DVR_IPSERVER_STREAM struIPServerStream = new NET_DVR_IPSERVER_STREAM();  
	    public NET_DVR_DDNS_STREAM_CFG struDDNSStream = new NET_DVR_DDNS_STREAM_CFG();
	    public NET_DVR_PU_STREAM_URL   struStreamUrl = new NET_DVR_PU_STREAM_URL();
	    public NET_DVR_HKDDNS_STREAM      struHkDDNSStream = new NET_DVR_HKDDNS_STREAM();
	    public NET_DVR_IPCHANINFO_V40 struIPChan = new NET_DVR_IPCHANINFO_V40();
	}
	
	public static class NET_DVR_IPCHANINFO extends Structure {/* IP通道匹配参数 */
	       public  byte byEnable;					/* 该通道是否启用 */
	       public  byte byIPID;					/* IP设备ID 取值1- MAX_IP_DEVICE */
	       public  byte byChannel;					/* 通道号 */
	       public  byte[] byres = new byte[33];					/* 保留 */
	}
	
	public class NET_DVR_PU_STREAM_CFG extends Structure{
	    public  int  dwSize;//结构体大小
	    public NET_DVR_STREAM_MEDIA_SERVER_CFG struStreamMediaSvrCfg=new NET_DVR_STREAM_MEDIA_SERVER_CFG();
	    public NET_DVR_DEV_CHAN_INFO struDevChanInfo=new NET_DVR_DEV_CHAN_INFO();
	}
	
	public class NET_DVR_IPSERVER_STREAM extends Structure{
		  public byte  byEnable;
		  public byte[] byRes=new byte[3];
		  public NET_DVR_IPADDR struIPServer=new NET_DVR_IPADDR();
		  public short wPort;
		  public short wDvrNameLen;
		  public byte[] byDVRName=new byte[HCNetSDK.NAME_LEN];
		  public short  wDVRSerialLen;
		  public short[]  byRes1=new short[2];
		  public byte[]  byDVRSerialNumber=new byte[HCNetSDK.SERIALNO_LEN];
		  public byte[]  byUserName=new byte[HCNetSDK.NAME_LEN];
		  public byte[]  byPassWord=new byte[HCNetSDK.PASSWD_LEN];
		  public byte  byChannel;
		  public byte[] byRes2=new byte[11];
	}
	
	public class NET_DVR_DDNS_STREAM_CFG extends Structure{
		  public  byte byEnable;
		  public  byte[] byRes1=new byte[3];
		  public NET_DVR_IPADDR struStreamServer=new NET_DVR_IPADDR();
		  public  short  wStreamServerPort;
		  public  byte  byStreamServerTransmitType;
		  public  byte  byRes2;
		  public NET_DVR_IPADDR struIPServer=new NET_DVR_IPADDR();
		  public  short  wIPServerPort;
		  public  byte[]  byRes3=new byte[2];
		  public  byte[]  sDVRName=new byte[HCNetSDK.NAME_LEN];
		  public  short  wDVRNameLen;
		  public  short  wDVRSerialLen;
		  public  byte[] sDVRSerialNumber=new byte[HCNetSDK.SERIALNO_LEN];
		  public  byte[] sUserName=new byte[HCNetSDK.NAME_LEN];
		  public  byte[] sPassWord=new byte[HCNetSDK.PASSWD_LEN];
		  public  short  wDVRPort;
		  public  byte[]  byRes4=new byte[2];
		  public  byte  byChannel;
		  public  byte  byTransProtocol;
		  public  byte  byTransMode;
		  public  byte  byFactoryType;
	}
	
	public class NET_DVR_PU_STREAM_URL extends Structure{
		public byte byEnable;//是否启用：0- 禁用，1- 启用
		public byte[] strURL=new byte[240];//取流URL路径
		public byte byTransPortocol;//传输协议类型：0-TCP，1-UDP
		public short  wIPID;//设备ID号，wIPID = iDevInfoIndex + iGroupNO*64 +1
		public byte byChannel;//设备通道号
		public byte[] byRes=new byte[7];//保留，置为0 
	}
	
	public class NET_DVR_HKDDNS_STREAM extends Structure{
		 public byte  byEnable;//是否启用
		 public byte[] byRes=new byte[3];//保留
		 public byte[] byDDNSDomain=new byte[64];//hiDDNS服务器地址
		 public short wPort;//hiDDNS端口，默认：80
		 public short wAliasLen;//别名长度
		 public byte[]  byAlias=new byte[HCNetSDK.NAME_LEN];//别名
		 public short  wDVRSerialLen;//序列号长度
		 public byte[] byRes1=new byte[2];//保留
		 public byte[] byDVRSerialNumber=new byte[HCNetSDK.SERIALNO_LEN];//设备序列号
		 public byte[] byUserName=new byte[HCNetSDK.NAME_LEN];//设备登录用户名
		 public byte[] byPassWord=new byte[HCNetSDK.PASSWD_LEN];//设备登录密码
		 public byte   byChannel;//设备通道号
		 public byte[] byRes2=new byte[11];//保留
	}
	
	public class NET_DVR_IPCHANINFO_V40 extends Structure {

		public byte byEnable;//IP通道在线状态，是一个只读的属性；
							//0表示HDVR或者NVR设备的数字通道连接对应的IP设备失败，该通道不在线；1表示连接成功，该通道在线
		public byte byRes1;//保留，置为0
		public short wIPID;//IP设备ID
		public int dwChannel;//IP设备的通道号，例如设备A（HDVR或者NVR设备）的IP通道01，对应的是设备B（DVS）里的通道04，则byChannel=4，如果前端接的是IPC则byChannel=1。
		public byte byTransProtocol;//传输协议类型：0- TCP，1- UDP，2- 多播，0xff- auto(自动)
		public byte byTransMode;//传输码流模式：0- 主码流，1- 子码流
		public byte byFactoryType;//前端设备厂家类型
		public byte[] byRes = new byte[241];//保留，置为0
	}
	
	public class NET_DVR_STREAM_MEDIA_SERVER_CFG extends Structure{

		  public byte byValid;//是否启用流媒体服务器取流：0-不启用，非0-启用
		  public byte[] byRes1=new byte[3];//保留，置为0
		  public NET_DVR_IPADDR   struDevIP=new NET_DVR_IPADDR();//流媒体服务器的IP地址
		  public short wDevPort;//流媒体服务器端口
		  public byte byTransmitType;//传输协议类型：0-TCP，1-UDP
		  public byte[] byRes2=new byte[69];
	}
	
	public class NET_DVR_DEV_CHAN_INFO extends Structure{
		 public NET_DVR_IPADDR   struIP =new NET_DVR_IPADDR();//设备IP地址
		 public short  wDVRPort;//设备端口号
		 public byte byChannel;//通道号,目前设备的模拟通道号是从1开始的，对于9000等设备的IPC接入，数字通道号从33开始
		 public byte byTransProtocol;//传输协议类型：0-TCP，1-UDP，2-多播方式，3-RTP
		 public byte byTransMode;//传输码流模式：0－主码流，1－子码流
		 public byte byFactoryType;//前端设备厂家类型， 通过接口NET_DVR_GetIPCProtoList获取
		 public byte byDeviceType;//设备类型(视频综合平台使用)：1- IPC，2- ENCODER
		 public byte byDispChan;//	显示通道号（智能配置使用），根据能力集决定使用解码通道还是显示通道
		 public byte bySubDispChan;//显示通道子通道号（智能配置时使用）
		 public byte byResolution;//分辨率：1- CIF，2- 4CIF，3- 720P，4- 1080P，5- 500W，用于多屏控制器，多屏控制器会根据该参数分配解码资源
		 public byte[] byRes=new byte[2];//保留，置为0
		 public byte[] byDomain =new byte[HCNetSDK.MAX_DOMAIN_NAME];//设备域名
		 public byte[] sUserName=new byte[HCNetSDK.NAME_LEN];//设备登陆帐号
		 public byte[] sPassword=new byte[HCNetSDK.PASSWD_LEN];//设备密码
	}
}


