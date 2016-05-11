//
//  message.h
//  XiangJiaBao
//
//  Created by admin on 15-6-11.
//  Copyright (c) 2015年 青芒科技. All rights reserved.
//

#ifndef XiangJiaBao_message_h
#define XiangJiaBao_message_h

/***********************
 *   宏定义
 ***********************/
//所有赋值的操作之前要求必须先清零buf.
//考虑到字符串长度存储最后要有一个空字节，所以宏中最大长度应至少比字符型数据真实最大长度多1
//例如序列号的最大长度为12，则指定长度至少为13。
//下面的长度可以适当放大
#define MAX_MSG_BODY_LEN 4096
#define MAX_DEV_NAME_LEN 48	//实际中文最好不超过20个字，考虑双字节与mysql中转义存储要占用的空间。
#define MAX_ALIAS_NAME_LEN 48
#define MAX_PASSWD_LEN 48
#define MAX_SERIAL_NUM_LEN 16//改为13以便传输更高效率和加密少16位
#define MAX_PHONE_NUM_LEN 16
#define MAX_IDENTITY_LEN 20 //no less than max len of PHONE and SERIAL
#define MAX_CHECK_NUM_LEN 12
#define MAX_IP_ADDR_LEN 40
#define MAX_TRACK_MSG_ID_LEN 20	 //12+6 long enough
#define MAX_TRACK_MSG_CONTENT_LEN 1024
#define MAX_LOGIN_TRACK_STRING_LEN 20
#define MAX_VERSION_LEN 40
#define MAX_VCODE_LEN 15
#define MAX_SMS_CONTENT_LEN 200	//互亿无线给出的是300,但考虑到短信中将有其它附加文字，限制成更小的长度


//下面有关长度，需要是准确的为数据长度
#define AES_KEY_LEN 32 //32bytes, (算法中256 bits)
#define AES_IV_LEN  16 //16bytes, (算法中128 bits)
#define RSA_KEY_BYTE_LEN 128 //算法中采用1024 bits
#define HASH_BYTE_LEN 16 //md5sum
#define HASH_AES_ENCRYPT_BYTE_LEN 32 //md5sum,AES有几种扩展算法，其中ecb和cbc需要填充，即加密后长度可能会不一样，cfb和ofb不需要填充，密文长度与明文长度一样 ；
#define PASSWD_ENCRYPT_BYTE_LEN 20//sha1
#define SERIAL_ENCRYPT_BYTE_LEN 32

//下面为有关常数
#define HEART_BEAT_INTERVALS 15		//暂定15秒发一次心跳

//
//NOTE: 	All enum types are stored as UINT32 in the buffer.
//		All count numbers are stored as UINT32 in the buffer.
#define ENUM_SIZE 4 //use 4 bytes to store the enum type variable
#define LENGTH_SIZE 4 //use 4 bytes to store the length variable of the msg_length
#define COUNT_SIZE 4//use 4 bytes to store count number, e.g. number of devices
#define ENCRYPT_KEY_VERSION_SIZE 4//use 4 bytes to store count number, e.g. number of devices


/***********************************
 * 消息相关的枚举类型
 ***********************************/
//由客户端发起的消息，服务器总会有一个对应回复。
//由服务器发的消息，服务器可能会等待用户回复(即客户端需回复，如ICE情形)，也可能不等待(即客户端无需回复，如下线通知等简单推送消息)
//IDENTITY代表CELL_NUM或SERIAL_NUM的统称
typedef enum
{
    //100-200  SERVER TO APP，偶数为客户端发给服务器，奇数为服务器发给客户端，
    
    C_S_SESSION_REQUEST=0,		//当一个客户端开即与服务器连接时，先发送这个，协商加密密钥
    S_C_SESSION_REQUEST,
    
    C_S_SESSION_EXIT,		//当一个客户端关闭连接前，向服务器发送此退出消息，
    S_C_SESSION_EXIT,		//如master服务器完成request_server后或slave服务器退出时
    
    C_S_IS_SERIAL_REGISTERED,
    S_C_IS_SERIAL_REGISTERED,	//检测设备是否已经注册
    
    C_S_REGISTER_BY_CELL_NUM,		//注册提交
    S_C_REGISTER_BY_CELL_NUM,
    
    C_S_CHECK_NUM_REQUEST,		//注册时短信认证申请
    S_C_CHECK_NUM_REQUEST,
    
    C_S_CHECK_NUM_VERIFY,		//短信认证登录,第一次登录验证,接在CHECK_NUM_REQUEST成功之后
    S_C_CHECK_NUM_VERIFY,		//因为设备要以序列号自动登录，身份不同于APP，所以只做验证，不算成登录
    
    C_S_BIND_DEVICE_WITH_PHONE,	//设备绑定手机
    S_C_BIND_DEVICE_WITH_PHONE,	//
    
    C_S_LOGIN_BY_CELL_NUM,		//手机号+密码登录;
    S_C_LOGIN_BY_CELL_NUM,
    
    C_S_LOGIN_BY_SERIAL,	//已绑定手机的设备用序列号自动登录
    S_C_LOGIN_BY_SERIAL,
    
    C_S_LOGOUT,				//用户登出
    S_C_LOGOUT,
    
    C_S_GET_DEVICE_BY_SERIAL,	//根据序列号，获取手机号，设备别名，仅仅针对底座
    S_C_GET_DEVICE_BY_SERIAL,
    
    C_S_GET_DEVICE_BY_OWNER_CELL_NUM,		//根据号码，获取名下设备
    S_C_GET_DEVICE_BY_OWNER_CELL_NUM,
    
    C_S_MODIFY_DEVICE_NAME,		//修改平板名称
    S_C_MODIFY_DEVICE_NAME,
    
    C_S_DEL_DEVICE,			//接绑定手机，在数据库中删除摄像头信息
    S_C_DEL_DEVICE,
    
    C_S_MODIFY_PASSWD,		//修改密码
    S_C_MODIFY_PASSWD,
    
    C_S_HEART_BEAT_INIT,	//客户端向服务器汇报的第一次心跳，服务器给回复，
    S_C_HEART_BEAT_INIT,	//确保双向连接建立，便于客户在能接收推送消息的条件下再登录
    
    C_S_HEART_BEAT,		//客户端向服务器汇报后续心跳，服务器不回复
    S_C_HEART_BEAT,
    
    C_S_PUSH_MESSAGE_NOTIFY,		//纯粹的服务器推送消息，客户端弹窗显示。
    S_C_PUSH_MESSAGE_NOTIFY, 	//由服务器发起
    
    C_S_NOTIFY_REPEAT_LOGIN,	//由服务器发超的消息对话，APP在其它地方登录了
    S_C_NOTIFY_REPEAT_LOGIN,	//客户端暂时认为不必回复
    
    C_S_GET_ONLINE_STATUS,		//获取对应IDENTITY(手机或序列号)是否在线的状态信息
    S_C_GET_ONLINE_STATUS,
    
    //以下两个消息计划迭代合并掉
    C_S_FORGET_PASSWD_REQUEST,	//用户忘记密码，请求服务器发送新密码(登录确认才正式有效)
    S_C_FORGET_PASSWD_REQUEST,	//这个应该只针对APP，
    
    C_S_CHECK_NUM_FORGET_PASSWD,//接在FORGET_PASSWD_REQUEST成功之后,登录确认
    S_C_CHECK_NUM_FORGET_PASSWD,
    
    C_S_FORWARD_DATA,				//服务器数据转发
    S_C_FORWARD_DATA,
    
    C_S_FORWARD_DATA_PUSH,			//服务器向客户端主动发送转发的数据
    S_C_FORWARD_DATA_PUSH,			//这个消息对话由服务器主动发起
    
    C_S_FORWARD_DATA_FEEDBACK,			//服务器向客户端回复client2的关于数据转发的回复；
    S_C_FORWARD_DATA_FEEDBACK,			//这个消息对话由服务器主动发起
    
    C_S_REQUEST_FRIEND,		// 添加好友,不区分手机/底座,支持离线添加
    S_C_REQUEST_FRIEND,
    
    C_S_REQUEST_FRIEND_NOTIFY,	// 服务器向用户B  发送用户A  添加B 为 好友的请求
    S_C_REQUEST_FRIEND_NOTIFY,  // 该消息由服务器主动发起
    
    C_S_REQUEST_FRIEND_FEEDBACK,	// 服务器向用户发送成功添加好友的消息
    S_C_REQUEST_FRIEND_FEEDBACK,	// 该消息由服务器主动发起
    
    C_S_GET_FRIEND_LIST,	// 获取好友列表,不区分手机/底座
    S_C_GET_FRIEND_LIST,
    
    C_S_GET_FRIEND_ALIAS,	//获取好友的备注名
    S_C_GET_FRIEND_ALIAS,
    
    C_S_DEL_FRIEND,		// 删除好友,使用手机号或者序列号登陆后该命令有效,不区分手机/底座,不提示对方
    S_C_DEL_FRIEND,
    
    C_S_MODIFY_FRIEND_ALIAS, //修改好友备注名
    S_C_MODIFY_FRIEND_ALIAS,
    
    C_S_GET_SERVER_VERSION,	//获取服务器的版本信息
    S_C_GET_SERVER_VERSION,
    
    C_MA_REQUEST_SERVER,		//客户端向Master服务器请求slave服务器地址
    MA_C_REQUEST_SERVER,
    
    S_M_REQUEST_SESSION,	//slave server向master server或server_monitor请求session id，因为rsa加密与client不同，不与C_S_SESSION_REQUEST共用
    M_S_REQUEST_SESSION,	//与客户端无关
    
    S_M_REPORT_SERVER_STATUS,//slave server向master server或server_monitor报告状态
    M_S_REPORT_SERVER_STATUS,//与客户端无关
    
    C_S_GET_VIP_INFO,	//获取底座的VIP信息:剩余VIP时间等
    S_C_GET_VIP_INFO,
    
    C_S_ACTIVATE_VCODE,	//用户提交V码激活来进行VIP充值
    S_C_ACTIVATE_VCODE,
    
    C_S_REQUEST_SEND_SMS,	//客户端请求向特定手机号发送短信
    S_C_REQUEST_SEND_SMS,
    
    C_S_APP_REPORT_STATUS,  //APP在给定情况下向服务器汇报相关状态，如是否在视频通话
    S_C_APP_REPORT_STATUS,
    //200-400 APP TO APP
} enum_message_t;

//二级子消息，暂无用
typedef enum
{
    REGISTER,
    FORGET_PASSWORD
} check_num_type_t;


typedef enum
{
    FEEDBACK_OK = 0,				//正常完成
    SERVER_BUSY_ERR,				//服务器忙，由于服务器原因不能成功完成操作
    INVALID_SERIAL_NUM_ERR,		//非法 底座
    INVALID_CELLPHONE_NUM_ERR,	//手机号非法，为了兼容国外手机，不做太多检查
    INVALID_IDENTITY_ERR,			//要求是手机号或序列号，但不是
    INVALID_PASSWD_ERR,			//密码不合法
    INVALID_MESSAGE_HEAD_ERR,	//如果server认为收到了未知msg_head类型
    INVALID_MESSAGE_PACKET_ERR,	//服务器收到包不合法，比如数据长度小于该消息类型应发送的长度或加密认证不对
    INVALID_TRACK_MSG_ID_ERR,	//10回复的msg_id不对
    INVALID_SESSION_ERR,			//SESSION_ID不合法
    
    WRONG_CHECK_NUM_ERR,		//验证码错误
    WRONG_PASSWD_ERR,			//密码错误
    EXPIRED_MSG_ID_ERR,			//MSG_ID已过了有效时间
    PERMISSION_DENY_ERR,			//用户做了越权的操作
    NOT_EXIST_ERR,					//相应条目不存在:用户未注册或者设备不存在，或者授权不存在
    ALREADY_EXIST_ERR,			//相应条目已经存在:用户重复注册 或者设备重复或者授权重复
    PEER_CLIENT_NOT_AVALIABLE_ERR, 	//对端无法连接
    MESSAGE_TOO_LONG_ERR,		//20针对客户端发了超过MAX_MSG_BODY_LEN的包
    DEVICE_BINDED_ERR, 			//设备已经绑定手机号码了
    ALIAS_NAME_EXIST_ERR,			//将要绑定的手机号码名下有相同名字的设备，同一个手机号不能有同名的设备
    SMS_REQUEST_TOO_MUCH_ERR,	//客户端当天短信请求过多，无法成功发送。
    SERVER_MSG_ERR,				//用于服务器主动发起的消息，客户端认为服务器消息有错误
    CLIENT_ERR,						//用于服务器主动发起的消息，客户端原因导致操作不能成功
    CONCURRENT_CONFLICT_ERR, 	//并发冲突，极少发生。如两个用户同时激活同一个V码等
    DECRYPT_FAILURE_ERR,			//服务器无法正确解密，很少发生；两端都可能导致这个发生，但通常是APP原因。
    INVALID_VCODE_ERR,			//V码不是合法的青芒V码
    VCODE_USED_ERR,				//V码是青芒V码，但已被使用过
    SMS_INTERVAL_TOO_SHORT_ERR,	//客户端请求短信间隔太短
    INVALID_VERSION_ERR,
}enum_return_result_t;


/**********************************************************
 App与App交互的消息定义
 *********************************************************/
typedef enum
{
    REQUEST_VIDEO_CALL = 1,
    ACCEPT_REQUEST_VIDEO_CALL,
    REJECT_REQUEST_VIDEO_CALL,
    HANG_UP_MYSELF,
    SEND_VIDEO_MESSAGE,
    SEND_PHOTO_FILE
}enum_message_app2app_t;

/**********************************************************
 *         消息所使用的 相关结构体
 **********************************************************/
typedef struct
{
    uint32_t msg_head;
    uint32_t msg_length;				//msg_body在socket数据中的大小
    uint8_t msg_body[MAX_MSG_BODY_LEN];
}str_cs_msg_t;

typedef struct
{
    uint32_t version_number;
    
}str_request_server_info_t;

typedef struct
{
    char master_server1_ip[MAX_IP_ADDR_LEN];
    uint32_t master_server1_port;
    char master_server2_ip[MAX_IP_ADDR_LEN];
    uint32_t master_server2_port;
    char slave_server_ip[MAX_IP_ADDR_LEN];
    uint32_t slave_server_port;
    char webrtc_server_ip[MAX_IP_ADDR_LEN];
    uint32_t webrtc_server_port;
    uint32_t update_indicator;//0: NO; 1:YES
    //[update link string]   		//if indicator is yes
} str_request_server_reply_info_t;

typedef struct
{
    uint8_t aes_key[AES_KEY_LEN]; //AES加密所用key
    uint8_t aes_iv[AES_IV_LEN];//AES加密所用iv
}str_aes_info_t;


typedef struct
{
    char serial_num[MAX_SERIAL_NUM_LEN];		//底座序列号，手机为全0
    char owner_num[MAX_PHONE_NUM_LEN];		//手机号
    uint8_t name[MAX_DEV_NAME_LEN];			//设备名，UINT8因为中文名
}str_device_info_t;

typedef struct
{
    char cell_num[MAX_PHONE_NUM_LEN];		//手机号注册
    char passwd[MAX_PASSWD_LEN];
    //email or other info...
}str_user_info_t;//以后可能拓展结构

typedef struct
{
    char cell_num[MAX_PHONE_NUM_LEN];
    char passwd[MAX_PASSWD_LEN];			//密码就是注册时候发送过来的验证码
    char serial_num[MAX_SERIAL_NUM_LEN];		//底座要填写serial_num，APP要为空，如果APP重复登录，则踢掉老用户，不同设备则允许用同一个用户登录。
}str_login_info_t;

typedef struct
{
    char session_id[MAX_TRACK_MSG_ID_LEN];	//会话标识
    //char session_id[MAX_IDENTITY_LEN];		//底座序列号或手机号
}str_heart_beat_info_t;


typedef struct
{
    char from_identity[MAX_IDENTITY_LEN]; // 自己的序列号或者手机
    char to_identity[MAX_IDENTITY_LEN];// 对方的列号或者手机号
    //两者不能同时为手机号
    char alias_name[MAX_ALIAS_NAME_LEN];//为对方取的昵称
} str_request_friend_info_t;

typedef struct
{
    char from_identity[MAX_IDENTITY_LEN];		 // 自己的序列号或者手机
    char to_identity[MAX_IDENTITY_LEN];		// 对方的列号或者手机号
    //如果请求者是底座会填写下列有效数据
    char owner_num[MAX_PHONE_NUM_LEN];		//拥有者手机
    uint8_t device_name[MAX_DEV_NAME_LEN];	//设备名，UINT8因为中文名
} str_request_friend_notify_info_t;

typedef struct
{
    uint32_t  reply; //对于好友申请的回复, 0:同意；1:拒绝...
    char alias_name[MAX_ALIAS_NAME_LEN];//为对方取的昵称
} str_request_friend_reply_info_t;

typedef struct
{
    uint32_t  reply; //对于好友申请的回复, 0:同意；1:拒绝...
    char identity[MAX_IDENTITY_LEN];		// 对方的列号或者手机号
    //如果响应好友请求者是底座会填写下列有效数据
    char owner_num[MAX_PHONE_NUM_LEN];		//拥有者手机
    uint8_t device_name[MAX_DEV_NAME_LEN];	//设备名，UINT8因为中文名
} str_request_friend_feedback_info_t;

typedef struct
{
    char identity[MAX_IDENTITY_LEN];	//好友用户标识，底座序列号或手机
    uint8_t alias_name[MAX_ALIAS_NAME_LEN];	//好友备注
    uint32_t status;							//好友在线状态
    //如果好友是底座会填写下列有效数据
    char owner_num[MAX_PHONE_NUM_LEN];		//
    uint8_t device_name[MAX_DEV_NAME_LEN];			//设备名，UINT8因为中文名
} str_friend_list_unit_info_t;


typedef struct
{
    char identity[MAX_IDENTITY_LEN];//对方手机号或序列号
    //forward data;					//要转发给对方的内容,逻辑上的成员，长度可变，单独重新定义个栈变量处理
} str_forward_info_t;

typedef struct
{
    char identity[MAX_IDENTITY_LEN];
    //forward data;
} str_forward_push_info_t;

typedef struct
{
    char slave_server_version[MAX_VERSION_LEN];//目前应该就这个会填有效值
    char slave_config_version[MAX_VERSION_LEN];
    char webrtc_server_version[MAX_VERSION_LEN];
    char webrtc_config_version[MAX_VERSION_LEN];
} str_server_version_info_t;

typedef struct
{
    char serial_num[MAX_SERIAL_NUM_LEN];
    uint32_t vip_time;//剩余的VIP时间，单位为秒，APP显示时可能要转换下，只显示天数即可；如果希望更改格式，可提出
} str_vip_info_t;

typedef struct
{
    char serial_num[MAX_SERIAL_NUM_LEN];
    char vip_code[MAX_VCODE_LEN];
} str_vcode_activate_info_t;

typedef struct
{
    char sms_recipient[MAX_PHONE_NUM_LEN];
    uint8_t sms_content[MAX_SMS_CONTENT_LEN];
} str_request_send_sms_info_t;

typedef struct
{
    uint32_t info_length;			//给出后接info content的长度
    uint32_t continue_indicator;//0:over; 1:continue receive remaining part
    //info content				//长度可变的部分
} str_information_content_t;

typedef struct
{
    uint32_t video_on_status;	//1:视频通话中，
} str_app_status_info_t;

typedef struct
{
    char identity[MAX_IDENTITY_LEN];//手机号或序列号
    uint32_t status;//在线状态
}str_identity_status_t;


/**************************************************************
 * 各消息使用说明如下：
 **************************************************************/
//原数据: data
//加密数据操作: enc(data)
//加密部分通用结构encrypt_data_block(data): enc(hash(enc(data))) + enc(data)
//回复消息msg_body通用结构:enum_return_result_t + encrypt_data_block
//加密算法不特别说明，为AES对称加密算法

//session_id, return_resut_t不加密
//因为session_id要用来查找会话密钥
//而对于找不到会话密钥的错误情况，其回复结果是没法加密回复的。

//!!!
//!!!所有的msg_body最初都加上UINT32型的server_encryption_key_version_number,当前值为1；暂未对下列文档做修改
//!!!


// C_S_SESSION_REQUEST 	//客户连接服务器，首先发送此消息协商此次会话中的对称密钥
// msg_body = encrypt_data_block(str_aes_info_t)
//		其中data用RSA基于server_public_key加密,hash用RSA基于client_private_key加密

//S_C_SESSION_REQUEST
//msg_body = enum_return_result_t + encrypt_data_block(session_id)
//		其中data用RSA基于client_public_key加密,hash用RSA基于server_private_key加密
//enum_return_result_t可能的情况:
//		FEEDBACK_OK: 只有此时enum_return_result_t后才接有效数据。
//		INVALID_MESSAGE_HEAD_ERR: server认为收到了未知msg_head类型
//		INVALID_MESSAGE_PACKET_ERR:  server认为收到包不合法，比如数据长度小于该消息类型应发送的长度或加密认证不对称(如session_id不对)
//		MESSAGE_TOO_LONG_ERR: server认为针对客户端发了超过MAX_MSG_BODY_LEN的包
//		DECRYPT_FAILURE_ERR: 服务器无法正确解密，很少发生；两端都可能导致这个发生，但通常是APP原因。
//		SERVER_BUSY_ERR: Server端原因，无法成功操作。

//C_S_SESSION_EXIT,		//当一个客户端关闭前，向服务器发送此退出消息
// msg_body = session_id + encrypt_data_block(session_id)   //一定程度只要有前一个session_id就行了，但冗余的加密数据起来进一步认证的作用，以防他人复制session_id)

//S_C_SESSION_EXIT,		//暂定回复，也可以考虑不回复
//msg_body = enum_return_result_t
//enum_return_result_t可能的情况:
//		FEEDBACK_OK, 成功退出
//		NOT_EXIST_ERR,session不存在;
//		INVALID_SESSION_ERR, 手机或序列号不合法
//		INVALID_MESSAGE_HEAD_ERR: server认为收到了未知msg_head类型
//		INVALID_MESSAGE_PACKET_ERR:  server认为收到包不合法，比如数据长度小于该消息类型应发送的长度或加密认证不对称(如session_id不对)
//		MESSAGE_TOO_LONG_ERR: server认为针对客户端发了超过MAX_MSG_BODY_LEN的包
//		DECRYPT_FAILURE_ERR: 服务器无法正确解密，很少发生；两端都可能导致这个发生，但通常是APP原因。
//		SERVER_BUSY_ERR: Server端原因，无法成功操作.



// C_S_IS_SERIAL_REGISTERED		//检测设备是否已经注册
// msg_body = session_id + encrypt_data_block(serial_num[MAX_SERIAL_NUM_LEN])

//S_C_IS_SERIAL_REGISTERED
//msg_body = enum_return_result_t
//enum_return_result_t可能的情况:
//		FEEDBACK_OK: 底座已注册;
//		NOT_EXIST_ERR: 底座未注册;
//		INVALID_SERIAL_NUM_ERR: 非法 底座
//		INVALID_MESSAGE_HEAD_ERR: server认为收到了未知msg_head类型
//		INVALID_MESSAGE_PACKET_ERR:  server认为收到包不合法，比如数据长度小于该消息类型应发送的长度或加密认证不对称(如session_id不对)
//		MESSAGE_TOO_LONG_ERR: server认为针对客户端发了超过MAX_MSG_BODY_LEN的包
//		DECRYPT_FAILURE_ERR: 服务器无法正确解密，很少发生；两端都可能导致这个发生，但通常是APP原因。
//		SERVER_BUSY_ERR: Server端原因，无法成功操作。

// C_S_LOGOUT			//手机号+密码登录
// msg_body = session_id + encrypt_data_block(identity[MAX_IDENTITY_LEN])   //一定程度只要有session_id就行了，但冗余的加密数据起来进一步认证的作用，以防他人复制session_id)

// S_C_LOGOUT,
//msg_body = enum_return_result_t
//enum_return_result_t可能的情况:
//		FEEDBACK_OK, 成功登出
//		NOT_EXIST_ERR,用户不存在;
//		INVALID_IDENTITY_ERR, 手机或序列号不合法
//		PERMISSION_DENY_ERR, 用户做了越权的操作
//		INVALID_MESSAGE_HEAD_ERR: server认为收到了未知msg_head类型
//		INVALID_MESSAGE_PACKET_ERR:  server认为收到包不合法，比如数据长度小于该消息类型应发送的长度或加密认证不对称(如session_id不对)
//		MESSAGE_TOO_LONG_ERR: server认为针对客户端发了超过MAX_MSG_BODY_LEN的包
//		DECRYPT_FAILURE_ERR: 服务器无法正确解密，很少发生；两端都可能导致这个发生，但通常是APP原因。
//		SERVER_BUSY_ERR: Server端原因，无法成功操作。


// C_S_REGISTER_BY_CELL_NUM,			//注册提交
// msg_body = session_id + encrypt_data_block(str_user_info_t)

//S_C_REGISTER_BY_CELL_NUM
//msg_body = enum_return_result_t
//enum_return_result_t可能的情况:
//		FEEDBACK_OK,可以正常注册
//		ALREADY_EXIST_ERR,用户已存在，重复注册;
//		INVALID_CELLPHONE_NUM_ERR,	手机号非法
//		INVALID_MESSAGE_HEAD_ERR: server认为收到了未知msg_head类型
//		INVALID_MESSAGE_PACKET_ERR:  server认为收到包不合法，比如数据长度小于该消息类型应发送的长度或加密认证不对称(如session_id不对)
//		MESSAGE_TOO_LONG_ERR: server认为针对客户端发了超过MAX_MSG_BODY_LEN的包
//		DECRYPT_FAILURE_ERR: 服务器无法正确解密，很少发生；两端都可能导致这个发生，但通常是APP原因。
//		SERVER_BUSY_ERR: Server端原因，无法成功操作。

//C_S_CHECK_NUM_REQUEST,		//短信认证申请
// msg_body = session_id + encrypt_data_block(cell_num)
//		其中cell_num为MAX_PHONE_NUM_LEN的手机号

//S_C_CHECK_NUM_REQUEST,
//msg_body = enum_return_result_t + encrypt_data_block(msg_id[MAX_TRACK_MSG_ID_LEN])
//enum_return_result_t可能的情况:
//		FEEDBACK_OK, 请求成功，已向用户手机发送验证码；后面存放相应msg_id[MAX_TRACK_MSG_ID_LEN].
//		INVALID_CELLPHONE_NUM_ERR,	手机号非法
//		SMS_REQUEST_TOO_MUCH_ERR, 该手机号请求短信过多。
//		SMS_INTERVAL_TOO_SHORT_ERR, 客户端请求短信间隔太短
//		ALREADY_EXIST_ERR, 该手机号已经注册
//		INVALID_MESSAGE_HEAD_ERR: server认为收到了未知msg_head类型
//		INVALID_MESSAGE_PACKET_ERR:  server认为收到包不合法，比如数据长度小于该消息类型应发送的长度或加密认证不对称(如session_id不对)
//		MESSAGE_TOO_LONG_ERR: server认为针对客户端发了超过MAX_MSG_BODY_LEN的包
//		DECRYPT_FAILURE_ERR: 服务器无法正确解密，很少发生；两端都可能导致这个发生，但通常是APP原因。
//		SERVER_BUSY_ERR: Server端原因，无法成功操作。

//C_S_CHECK_NUM_VERIFY,			//短信认证,接在CHECK_NUM_REQUEST成功之后
//msg_body = session_id + encrypt_data_block(msg_id+str_login_info_t)

//S_C_CHECK_NUM_VERIFY,
//msg_body = enum_return_result_t
//enum_return_result_t可能的情况:
//		FEEDBACK_OK, 成功验证
//		WRONG_CHECK_NUM_ERR, 验证码（密码）错误;
//		INVALID_TRACK_MSG_ID_ERR, 回复的msg_id不对
//		EXPIRED_MSG_ID_ERR, MSG_ID已过了有效时间
//		NOT_EXIST_ERR, MSG_ID不存在
//		INVALID_MESSAGE_HEAD_ERR: server认为收到了未知msg_head类型
//		INVALID_MESSAGE_PACKET_ERR:  server认为收到包不合法，比如数据长度小于该消息类型应发送的长度或加密认证不对称(如session_id不对)
//		MESSAGE_TOO_LONG_ERR: server认为针对客户端发了超过MAX_MSG_BODY_LEN的包
//		DECRYPT_FAILURE_ERR: 服务器无法正确解密，很少发生；两端都可能导致这个发生，但通常是APP原因。
//		SERVER_BUSY_ERR: Server端原因，无法成功操作。

//C_S_BIND_DEVICE_WITH_PHONE,		//设备绑定手机
// msg_body = session_id + encrypt_data_block(str_device_info_t)

//S_C_BIND_DEVICE_WITH_PHONE,
//msg_body = enum_return_result_t
//enum_return_result_t可能的情况:
//		FEEDBACK_OK,成功绑定
//		NOT_EXIST_ERR,想绑定的用户不存在;
//		INVALID_SERIAL_NUM_ERR, 非法 底座
//		INVALID_CELLPHONE_NUM_ERR,	手机号非法
//		PERMISSION_DENY_ERR, 用户做了越权的操作
//		INVALID_MESSAGE_HEAD_ERR: server认为收到了未知msg_head类型
//		INVALID_MESSAGE_PACKET_ERR:  server认为收到包不合法，比如数据长度小于该消息类型应发送的长度或加密认证不对称(如session_id不对)
//		MESSAGE_TOO_LONG_ERR: server认为针对客户端发了超过MAX_MSG_BODY_LEN的包
//		DECRYPT_FAILURE_ERR: 服务器无法正确解密，很少发生；两端都可能导致这个发生，但通常是APP原因。
//		SERVER_BUSY_ERR: Server端原因，无法成功操作。

// C_S_LOGIN_BY_CELL_NUM,			//手机号+密码登录
// msg_body = session_id + encrypt_data_block(str_login_info_t)

// S_C_LOGIN_BY_CELL_NUM,
//msg_body = enum_return_result_t
//enum_return_result_t可能的情况:
//		FEEDBACK_OK,成功登录
//		NOT_EXIST_ERR,用户不存在;
//		WRONG_PASSWD_ERR，密码错误
//		INVALID_CELLPHONE_NUM_ERR,	手机号非法，为了兼容国外手机，不做太多检查
//		INVALID_MESSAGE_HEAD_ERR: server认为收到了未知msg_head类型
//		INVALID_MESSAGE_PACKET_ERR:  server认为收到包不合法，比如数据长度小于该消息类型应发送的长度或加密认证不对称(如session_id不对)
//		MESSAGE_TOO_LONG_ERR: server认为针对客户端发了超过MAX_MSG_BODY_LEN的包
//		DECRYPT_FAILURE_ERR: 服务器无法正确解密，很少发生；两端都可能导致这个发生，但通常是APP原因。
//		SERVER_BUSY_ERR: Server端原因，无法成功操作。

// C_S_LOGIN_BY_SERIAL			//序列号自动登录
// msg_body = session_id + encrypt_data_block(serial_num)

// S_C_LOGIN_BY_SERIAL,
//msg_body = enum_return_result_t
//enum_return_result_t可能的情况:
//		FEEDBACK_OK,成功登录
//		NOT_EXIST_ERR,序列号未注册;
//		INVALID_SERIAL_NUM_ERR,	 序列号非法
//		INVALID_MESSAGE_HEAD_ERR: server认为收到了未知msg_head类型
//		INVALID_MESSAGE_PACKET_ERR:  server认为收到包不合法，比如数据长度小于该消息类型应发送的长度或加密认证不对称(如session_id不对)
//		MESSAGE_TOO_LONG_ERR: server认为针对客户端发了超过MAX_MSG_BODY_LEN的包
//		DECRYPT_FAILURE_ERR: 服务器无法正确解密，很少发生；两端都可能导致这个发生，但通常是APP原因。
//		SERVER_BUSY_ERR: Server端原因，无法成功操作。

// C_S_GET_DEVICE_BY_SERIAL,		//根据序列号，获取手机号，设备别名
// msg_body = session_id + encrypt_data_block(serial_num)

// S_C_GET_DEVICE_BY_SERIAL,
//msg_body = enum_return_result_t + encrypt_data_block(str_device_info_t)
//enum_return_result_t可能的情况:
//		FEEDBACK_OK: 只有此时enum_return_result_t后才接有效数据。
//		NOT_EXIST_ERR: 底座未注册;
//		INVALID_SERIAL_NUM_ERR: 非法 底座
//		INVALID_MESSAGE_HEAD_ERR: server认为收到了未知msg_head类型
//		INVALID_MESSAGE_PACKET_ERR:  server认为收到包不合法，比如数据长度小于该消息类型应发送的长度或加密认证不对称(如session_id不对)
//		MESSAGE_TOO_LONG_ERR: server认为针对客户端发了超过MAX_MSG_BODY_LEN的包
//		DECRYPT_FAILURE_ERR: 服务器无法正确解密，很少发生；两端都可能导致这个发生，但通常是APP原因。
//		SERVER_BUSY_ERR: Server端原因，无法成功操作。


// C_S_GET_DEVICE_BY_OWNER_CELL_NUM,		//根据号码，获取名下设备
//msg_body = session_id + encrypt_data_block(cell_num)	//cell_num还是不省略，考虑到加好友等情况可能用到

// S_C_GET_DEVICE_BY_OWNER_CELL_NUM,
//msg_body = enum_return_result_t + encrypt_data_block(num_count + num_remain + num_count x str_device_info_t ), 最大不超过10个。
//enum_return_result_t可能的情况:
//		FEEDBACK_OK, 成功获取名下设备，其后存放着此次传送设备个数num_count, 还剩的未传送的个数num_remain(0表示已传完，通常为0，如果>0，客户要继续接收)及具体num_count个str_device_info_t结构体。
//		NOT_EXIST_ERR, 用户不存在或用户并不拥有设备；
//		INVALID_CELLPHONE_NUM_ERR,	手机号非法，为了兼容国外手机，不做太多检查
//		INVALID_MESSAGE_HEAD_ERR: server认为收到了未知msg_head类型
//		INVALID_MESSAGE_PACKET_ERR:  server认为收到包不合法，比如数据长度小于该消息类型应发送的长度或加密认证不对称(如session_id不对)
//		MESSAGE_TOO_LONG_ERR: server认为针对客户端发了超过MAX_MSG_BODY_LEN的包
//		DECRYPT_FAILURE_ERR: 服务器无法正确解密，很少发生；两端都可能导致这个发生，但通常是APP原因。
//		SERVER_BUSY_ERR: Server端原因，无法成功操作。


//C_S_MODIFY_DEVICE_NAME,			//修改平板名称
//msg_body = session_id + encrypt_data_block(str_device_info_t)
//		其中，str_device_info_t的name成员是新命名的

//S_C_MODIFY_DEVICE_NAME,
//msg_body = enum_return_result_t
//enum_return_result_t可能的情况:
//		FEEDBACK_OK,成功修改设备名
//		NOT_EXIST_ERR,设备不存在;
//		INVALID_SERIAL_NUM_ERR, 非法 底座
//		PERMISSION_DENY_ERR,  用户做了越权的操作
//		INVALID_MESSAGE_HEAD_ERR: server认为收到了未知msg_head类型
//		INVALID_MESSAGE_PACKET_ERR:  server认为收到包不合法，比如数据长度小于该消息类型应发送的长度或加密认证不对称(如session_id不对)
//		MESSAGE_TOO_LONG_ERR: server认为针对客户端发了超过MAX_MSG_BODY_LEN的包
//		DECRYPT_FAILURE_ERR: 服务器无法正确解密，很少发生；两端都可能导致这个发生，但通常是APP原因。
//		SERVER_BUSY_ERR: Server端原因，无法成功操作。


//C_S_DEL_DEVICE,			//解绑定手机，在数据库中删除摄像头信息
//msg_body = session_id + encrypt_data_block(serial_num)

//S_C_DEL_DEVICE,
//msg_body = enum_return_result_t
//enum_return_result_t可能的情况:
//		FEEDBACK_OK,成功删除设备名
//		NOT_EXIST_ERR,设备不存在;
//		INVALID_SERIAL_NUM_ERR, 非法 底座
//		PERMISSION_DENY_ERR,  用户做了越权的操作
//		INVALID_MESSAGE_HEAD_ERR: server认为收到了未知msg_head类型
//		INVALID_MESSAGE_PACKET_ERR:  server认为收到包不合法，比如数据长度小于该消息类型应发送的长度或加密认证不对称(如session_id不对)
//		MESSAGE_TOO_LONG_ERR: server认为针对客户端发了超过MAX_MSG_BODY_LEN的包
//		DECRYPT_FAILURE_ERR: 服务器无法正确解密，很少发生；两端都可能导致这个发生，但通常是APP原因。
//		SERVER_BUSY_ERR: Server端原因，无法成功操作。

//C_S_MODIFY_PASSWD,			//修改密码
//msg_body = session_id + encrypt_data_block(str_user_info_t)
//		其中，str_user_info_t的passwd成员是新密码的

//S_C_MODIFY_PASSWD,
//msg_body = enum_return_result_t
//enum_return_result_t可能的情况:
//		FEEDBACK_OK,成功接收修改密码请求，后接msg_id，客户端应回带此msg_id进行原密码再发送C_S_VERIFY_PASSWD消息
//		NOT_EXIST_ERR,用户不存在;
//		INVALID_CELLPHONE_NUM_ERR, 非法 手机号
//		PERMISSION_DENY_ERR,  用户做了越权的操作
//		INVALID_MESSAGE_HEAD_ERR: server认为收到了未知msg_head类型
//		INVALID_MESSAGE_PACKET_ERR:  server认为收到包不合法，比如数据长度小于该消息类型应发送的长度或加密认证不对称(如session_id不对)
//		MESSAGE_TOO_LONG_ERR: server认为针对客户端发了超过MAX_MSG_BODY_LEN的包
//		DECRYPT_FAILURE_ERR: 服务器无法正确解密，很少发生；两端都可能导致这个发生，但通常是APP原因。
//		SERVER_BUSY_ERR: Server端原因，无法成功操作。

//C_S_VERIFY_PASSWD,			//认证密码
//msg_body = session_id + encrypt_data_block(msg_id + str_login_info_t)
//		在修改密码时，此处passwd成员为原密码

//S_C_VERIFY_PASSWD,
//msg_body = enum_return_result_t
//enum_return_result_t可能的情况:
//		FEEDBACK_OK, 验证成功，操作完成
//		WRONG_PASSWD_ERR, 密码错误
//		NOT_EXIST_ERR, msg_id 或用户不存在;
//		INVALID_TRACK_MSG_ID_ERR, msg_id不合法
//		EXPIRED_MSG_ID_ERR, MSG_ID已过了有效时间
//		INVALID_CELLPHONE_NUM_ERR, 非法 手机号
//		PERMISSION_DENY_ERR,  用户做了越权的操作
//		INVALID_MESSAGE_HEAD_ERR: server认为收到了未知msg_head类型
//		INVALID_MESSAGE_PACKET_ERR:  server认为收到包不合法，比如数据长度小于该消息类型应发送的长度或加密认证不对称(如session_id不对)
//		MESSAGE_TOO_LONG_ERR: server认为针对客户端发了超过MAX_MSG_BODY_LEN的包
//		DECRYPT_FAILURE_ERR: 服务器无法正确解密，很少发生；两端都可能导致这个发生，但通常是APP原因。
//		SERVER_BUSY_ERR: Server端原因，无法成功操作。


//C_S_HEART_BEAT_INIT,	//客户端向服务器汇报的第一次心跳，服务器给回复，确保listen正常了
//msg_body = session_id + encrypt_data_block(str_heart_beat_info_t)

//S_C_HEART_BEAT_INIT,
//msg_body = enum_return_result_t
//enum_return_result_t可能的情况:
//		FEEDBACK_OK, 操作完成
//		INVALID_MESSAGE_HEAD_ERR: server认为收到了未知msg_head类型
//		INVALID_MESSAGE_PACKET_ERR:  server认为收到包不合法，比如数据长度小于该消息类型应发送的长度或加密认证不对称(如session_id不对)
//		MESSAGE_TOO_LONG_ERR: server认为针对客户端发了超过MAX_MSG_BODY_LEN的包
//		DECRYPT_FAILURE_ERR: 服务器无法正确解密，很少发生；两端都可能导致这个发生，但通常是APP原因。
//		SERVER_BUSY_ERR: Server端原因，无法成功操作。



//C_S_HEART_BEAT
//msg_body = session_id + encrypt_data_block(str_heart_beat_info_t)

//S_C_HEART_BEAT
//现回复，C_S_HEART_BEAT_INIT应该多余了//该消息为预留，服务器为减轻负担，不回复
//		FEEDBACK_OK, 心跳接收OK
//		INVALID_MESSAGE_HEAD_ERR: server认为收到了未知msg_head类型
//		INVALID_MESSAGE_PACKET_ERR:  server认为收到包不合法，比如数据长度小于该消息类型应发送的长度或加密认证不对称(如session_id不对)
//		MESSAGE_TOO_LONG_ERR: server认为针对客户端发了超过MAX_MSG_BODY_LEN的包
//		DECRYPT_FAILURE_ERR: 服务器无法正确解密，很少发生；两端都可能导致这个发生，但通常是APP原因。
//		SERVER_BUSY_ERR: Server端原因，无法成功操作。


//这个消息对话由服务器主动发起
//C_S_REPEAT_LOGIN_NOTIFY //不必回复

//S_C_REPEAT_LOGIN_NOTIFY//服务器提示另外登录了
//msg_body = encrypt_data_block(identity)//identity是冗余的，主要起加密校验作用。


//C_S_GET_ONLINE_STATUS,//获取相应IDENTITY(serial or cell_num)的在线状态信息
//msg_body = session_id + data_encrypt_block(identity)

//S_C_GET_ONLINE_STATUS,
//msg_body = enum_return_result_t
//enum_return_result_t可能的情况:
//		FEEDBACK_OK, IDENTITY在线
//		NOT_EXIST_ERR,查询的用户不在线;
//		INVALID_IDENTITY_ERR, 非法IDENTITY;
//		INVALID_MESSAGE_HEAD_ERR: server认为收到了未知msg_head类型
//		INVALID_MESSAGE_PACKET_ERR:  server认为收到包不合法，比如数据长度小于该消息类型应发送的长度或加密认证不对称(如session_id不对)
//		MESSAGE_TOO_LONG_ERR: server认为针对客户端发了超过MAX_MSG_BODY_LEN的包
//		DECRYPT_FAILURE_ERR: 服务器无法正确解密，很少发生；两端都可能导致这个发生，但通常是APP原因。
//		SERVER_BUSY_ERR: Server端原因，无法成功操作。

//C_S_FORGET_PASSWD_REQUEST,	//用户忘记密码，请求服务器发送新密码(登录确认才正式有效)
// msg_body = session_id + encrypt_data_block(cell_num)
//		其中cell_num为MAX_PHONE_NUM_LEN的手机号

//S_C_FORGET_PASSWD_REQUEST,	//这个应该只针对APP
//msg_body = enum_return_result_t + encrypt_data_block(msg_id[MAX_TRACK_MSG_ID_LEN])
//enum_return_result_t可能的情况:
//		FEEDBACK_OK, 请求成功，已向用户手机发送验证码(新密码)；后面存放相应msg_id[MAX_TRACK_MSG_ID_LEN].
//		INVALID_CELLPHONE_NUM_ERR,	手机号非法
//		SMS_REQUEST_TOO_MUCH_ERR, 该手机号请求短信过多。
//		SMS_INTERVAL_TOO_SHORT_ERR, 客户端请求短信间隔太短
//		INVALID_MESSAGE_HEAD_ERR: server认为收到了未知msg_head类型
//		INVALID_MESSAGE_PACKET_ERR:  server认为收到包不合法，比如数据长度小于该消息类型应发送的长度或加密认证不对称(如session_id不对)
//		MESSAGE_TOO_LONG_ERR: server认为针对客户端发了超过MAX_MSG_BODY_LEN的包
//		DECRYPT_FAILURE_ERR: 服务器无法正确解密，很少发生；两端都可能导致这个发生，但通常是APP原因。
//		SERVER_BUSY_ERR: Server端原因，无法成功操作。


//C_S_CHECK_NUM_FORGET_PASSWD,			//接在FORGET_PASSWD_REQUEST成功之后
//msg_body = session_id + encrypt_data_block(msg_id+str_login_info_t)

//S_C_CHECK_NUM_FORGET_PASSWD,
//msg_body = enum_return_result_t
//enum_return_result_t可能的情况:
//		FEEDBACK_OK, 成功验证
//		WRONG_CHECK_NUM_ERR, 验证码（密码）错误;
//		INVALID_TRACK_MSG_ID_ERR, 回复的msg_id不对
//		EXPIRED_MSG_ID_ERR, MSG_ID已过了有效时间
//		NOT_EXIST_ERR, MSG_ID不存在
//		INVALID_MESSAGE_HEAD_ERR: server认为收到了未知msg_head类型
//		INVALID_MESSAGE_PACKET_ERR:  server认为收到包不合法，比如数据长度小于该消息类型应发送的长度或加密认证不对称(如session_id不对)
//		MESSAGE_TOO_LONG_ERR: server认为针对客户端发了超过MAX_MSG_BODY_LEN的包
//		DECRYPT_FAILURE_ERR: 服务器无法正确解密，很少发生；两端都可能导致这个发生，但通常是APP原因。
//		SERVER_BUSY_ERR: Server端原因，无法成功操作。


//C_S_FORWARD_DATA,		//服务器数据转发
//msg_body = session_id + encrypt_data_block(str_forward_info_t + data)
//		其中，data为任意要转发的数据

//S_C_FORWARD_DATA,
//msg_body = enum_return_result_t
//enum_return_result_t可能的情况:
//		FEEDBACK_OK, 服务器成功收到请求并已向client2发送相应请求。
//		NAT_CLIENT_NOT_AVAILABLE_ERR, client2不在线;
//		PERMISSION_DENY_ERR,  用户做了越权的操作
//		INVALID_MESSAGE_HEAD_ERR: server认为收到了未知msg_head类型
//		INVALID_MESSAGE_PACKET_ERR:  server认为收到包不合法，比如数据长度小于该消息类型应发送的长度或加密认证不对称(如session_id不对)
//		MESSAGE_TOO_LONG_ERR: server认为针对客户端发了超过MAX_MSG_BODY_LEN的包
//		DECRYPT_FAILURE_ERR: 服务器无法正确解密，很少发生；两端都可能导致这个发生，但通常是APP原因。
//		SERVER_BUSY_ERR: Server端原因，无法成功操作。

//这个消息对话由服务器主动发起
//C_S_FORWARD_DATA_PUSH,
//msg_body = session_id + encrypt_data_block(enum_return_result_t + msg_id [+ optional_feedback_data_to_client1])
//enum_return_result_t可能的情况:
//		FEEDBACK_OK, 此情况下，后可选择择性加上想回带给client1的信息
//		SERVER_MSG_ERR: 客户端认为服务器数据有错。
//		CLIENT_EER: 由于客户端原因不能正常完成操作.

//S_C_FORWARD_DATA_PUSH, //服务器向客户端发送转发的数据
//msg_body = encrypt_data_block(msg_id + str_forward_push_info_t + data)
//		其中，data为转发的数据，来自client1

//这个消息对话由服务器主动发起
//C_S_FORWARD_DATA_FEEDBACK, 	//暂定不必回复
//msg_body = session_id + data_encrypt_block(enum_return_result_t)
//enum_return_result_t可能的情况:
//		FEEDBACK_OK, 成功收到client2的数据转发回复;
//		SERVER_MSG_ERR: 客户端认为服务器数据有错。

//S_C_FORWARD_DATA_FEEDBACK, //服务器向客户端回复client2的关于数据转发的回复；
//msg_body = encrypt_data_block(client2_optional_data)//client2_optional_data 可能为0 byte



//C_S_REQUEST_FRIEND	// 添加好友请求,不区分手机/底座,支持离线添加
//msg_body = session_id + encrypt_data_block(str_request_friend_info_t)

//S_C_REQUEST_FRIEND
//msg_body = enum_return_result_t
//enum_return_result_t可能的情况:
//		FEEDBACK_OK,服务器正确收到了请求,请等待对方的回复
//		ALREADY_EXIST_ERR,你们已经是好友;
//		INVALID_SERIAL_NUM_ERR, 非法 底座
//		INVALID_IDENTITY_ERR, 要求是手机号或序列号，但不是
//		PERMISSION_DENY_ERR,  用户做了越权的操作
//		INVALID_MESSAGE_HEAD_ERR: server认为收到了未知msg_head类型
//		INVALID_MESSAGE_PACKET_ERR:  server认为收到包不合法，比如数据长度小于该消息类型应发送的长度或加密认证不对称(如session_id不对)
//		MESSAGE_TOO_LONG_ERR: server认为针对客户端发了超过MAX_MSG_BODY_LEN的包
//		DECRYPT_FAILURE_ERR: 服务器无法正确解密，很少发生；两端都可能导致这个发生，但通常是APP原因。
//		SERVER_BUSY_ERR: Server端原因，无法成功操作。


//C_S_REQUEST_FRIEND_NOTIFY		// 客户端回复服务器是否同意添加好友
//msg_body = session_id +encrypt_data_block(enum_return_result_t +  msg_id + str_request_friend_reply_info)
//enum_return_result_t可能的情况:
//		FEEDBACK_OK, 此情况下，后可选择择性加上想回带给client1的信息
//		SERVER_MSG_ERR: 客户端认为服务器数据有错。
//		CLIENT_EER: 由于客户端原因不能正常完成操作.

//S_C_REQUEST_FRIEND_NOTIFY		// 服务器向用户B发送用户A添加B为好友的请求
//msg_body = encrypt_data_block(msg_id + str_request_friend_notify_info_t)
//		其中，str_request_friend_notify_info包含对方请求加自己为好友的相关信息


//C_S_REQUEST_FRIEND_FEEDBACK		// 客户端需回复
//msg_body = session_id + encrypt_data_block(enum_return_result_t + msg_id)

//S_C_REQUEST_FRIEND_FEEDBACK		// 服务器向用户发送成功添加好友的消息,消息由服务器主动发起
//msg_body = encrypt_data_block(msg_id + str_request_friend_feedback_info_t)
//enum_return_result_t可能的情况:
//		FEEDBACK_OK, 此情况下，后可选择择性加上想回带给client1的信息
//		SERVER_MSG_ERR: 客户端认为服务器数据有错。
//		CLIENT_EER: 由于客户端原因不能正常完成操作.


//C_S_GET_FRIEND_LIST		// 获取好友列表,不区分手机/底座
//msg_body = session_id + encrypt_data_block(identity)
//		//identity为自已的。

//S_C_GET_FRIEND_LIST
//msg_body = enum_return_result_t + encrypt_data_block(num_count + num_remain+ n x (str_friend_list_unit_info_t))。
//enum_return_result_t可能的情况:
//		FEEDBACK_OK, 成功获取好友，其后存放好友个数num_count, 还剩的未传送的个数num_remain(0表示已传完，通常为0，如果>0，客户要继续接收)及具体num_count个str_friend_list_unit_info_t结构体
//		NOT_EXIST_ERR, 好友不存在或对方不是你的好友；
//		INVALID_SERIAL_NUM_ERR, 非法 底座
//		PERMISSION_DENY_ERR,  用户做了越权的操作
//		INVALID_MESSAGE_HEAD_ERR: server认为收到了未知msg_head类型
//		INVALID_MESSAGE_PACKET_ERR:  server认为收到包不合法，比如数据长度小于该消息类型应发送的长度或加密认证不对称(如session_id不对)
//		MESSAGE_TOO_LONG_ERR: server认为针对客户端发了超过MAX_MSG_BODY_LEN的包
//		DECRYPT_FAILURE_ERR: 服务器无法正确解密，很少发生；两端都可能导致这个发生，但通常是APP原因。
//		SERVER_BUSY_ERR: Server端原因，无法成功操作。


//C_S_GET_FRIEND_ALIAS,			//修改好友备注名
//msg_body = session_id + encrypt_data_block(str_request_friend_info_t)

//S_C_GET_FRIEND_ALIAS,
//msg_body = enum_return_result_t + encrypt_data_block(str_request_friend_info_t)
//enum_return_result_t可能的情况:
//		FEEDBACK_OK,成功获取好友备注名
//		NOT_EXIST_ERR,好友不存在;
//		INVALID_IDENTITY_ERR, 用户标识
//		PERMISSION_DENY_ERR,  用户做了越权的操作
//		INVALID_MESSAGE_HEAD_ERR: server认为收到了未知msg_head类型
//		INVALID_MESSAGE_PACKET_ERR:  server认为收到包不合法，比如数据长度小于该消息类型应发送的长度或加密认证不对称(如session_id不对)
//		MESSAGE_TOO_LONG_ERR: server认为针对客户端发了超过MAX_MSG_BODY_LEN的包
//		DECRYPT_FAILURE_ERR: 服务器无法正确解密，很少发生；两端都可能导致这个发生，但通常是APP原因。
//		SERVER_BUSY_ERR: Server端原因，无法成功操作。


//C_S_DEL_FRIEND		// 删除好友,使用手机号或者序列号登陆后该命令有效,不区分手机/底座,不提示对方
//msg_body = session_id + encrypt_data_block(str_request_friend_info_t)

//S_C_DEL_FRIEND
//msg_body = enum_return_result_t
//enum_return_result_t可能的情况:
//		FEEDBACK_OK,成功删除好友
//		NOT_EXIST_ERR,对方不是你的好友
//		INVALID_SERIAL_NUM_ERR, 非法 底座
//		INVALID_IDENTITY_ERR,对方身份证有误(不是合法的序列号或者手机号)
//		PERMISSION_DENY_ERR,  用户做了越权的操作
//		INVALID_MESSAGE_HEAD_ERR: server认为收到了未知msg_head类型
//		INVALID_MESSAGE_PACKET_ERR:  server认为收到包不合法，比如数据长度小于该消息类型应发送的长度或加密认证不对称(如session_id不对)
//		MESSAGE_TOO_LONG_ERR: server认为针对客户端发了超过MAX_MSG_BODY_LEN的包
//		DECRYPT_FAILURE_ERR: 服务器无法正确解密，很少发生；两端都可能导致这个发生，但通常是APP原因。
//		SERVER_BUSY_ERR: Server端原因，无法成功操作。


//C_S_MOIDFY_FRIEND_ALIAS,			//修改好友备注名
//msg_body = session_id + encrypt_data_block(str_request_friend_info_t)
//		其中，str_request_friend_info_t的alias_name成员是新命名的

//S_C_MODIFY_FRIEND_ALIAS,
//msg_body = enum_return_result_t
//enum_return_result_t可能的情况:
//		FEEDBACK_OK,成功修改好友备注名
//		NOT_EXIST_ERR,好友不存在;
//		INVALID_IDENTITY_ERR, 用户标识
//		PERMISSION_DENY_ERR,  用户做了越权的操作
//		INVALID_MESSAGE_HEAD_ERR: server认为收到了未知msg_head类型
//		INVALID_MESSAGE_PACKET_ERR:  server认为收到包不合法，比如数据长度小于该消息类型应发送的长度或加密认证不对称(如session_id不对)
//		MESSAGE_TOO_LONG_ERR: server认为针对客户端发了超过MAX_MSG_BODY_LEN的包
//		DECRYPT_FAILURE_ERR: 服务器无法正确解密，很少发生；两端都可能导致这个发生，但通常是APP原因。
//		SERVER_BUSY_ERR: Server端原因，无法成功操作。


//C_S_GET_SERVER_VERSION,	//
//msg_body = session_id + encrypt_data_block(session_id)

//S_C_GET_SERVER_VERSION
//msg_body = enum_return_result_t + encrypt_data_block(str_server_version_info_t)
//enum_return_result_t可能的情况:
//		FEEDBACK_OK: 只有此时enum_return_result_t后才接有效数据。
//		INVALID_MESSAGE_HEAD_ERR: server认为收到了未知msg_head类型
//		INVALID_MESSAGE_PACKET_ERR:  server认为收到包不合法，比如数据长度小于该消息类型应发送的长度或加密认证不对称(如session_id不对)
//		MESSAGE_TOO_LONG_ERR: server认为针对客户端发了超过MAX_MSG_BODY_LEN的包
//		DECRYPT_FAILURE_ERR: 服务器无法正确解密，很少发生；两端都可能导致这个发生，但通常是APP原因。
//		SERVER_BUSY_ERR: Server端原因，无法成功操作。


//C_S_GET_VIP_INFO,	//获取用户的VIP信息:剩余VIP时间等
// msg_body = session_id + encrypt_data_block(serial_num)

//S_C_GET_VIP_INFO,
//msg_body = enum_return_result_t + encrypt_data_block(str_vip_info_t)
//enum_return_result_t可能的情况:
//		FEEDBACK_OK: 只有此时enum_return_result_t后才接有效数据。
//		NOT_EXIST_ERR: 底座未注册;
//		INVALID_SERIAL_NUM_ERR: 非法 底座
//		INVALID_MESSAGE_HEAD_ERR: server认为收到了未知msg_head类型
//		INVALID_MESSAGE_PACKET_ERR:  server认为收到包不合法，比如数据长度小于该消息类型应发送的长度或加密认证不对称(如session_id不对)
//		MESSAGE_TOO_LONG_ERR: server认为针对客户端发了超过MAX_MSG_BODY_LEN的包
//		DECRYPT_FAILURE_ERR: 服务器无法正确解密，很少发生；两端都可能导致这个发生，但通常是APP原因。
//		SERVER_BUSY_ERR: Server端原因，无法成功操作。


//C_S_ACTIVATE_VCODE,	//用户提交V码激活来进行VIP充值
//msg_body = session_id + encrypt_data_block(str_vcode_activate_info_t)

//S_C_ACTIVATE_VCODE,
//msg_body = enum_return_result_t [+ encrypt_data_block(str_information_content_t)];
//enum_return_result_t可能的情况:
//		FEEDBACK_OK, V码成功激活。
//		INVALID_SERIAL_NUM_ERR, 非法 底座
//		INVALID_VCODE_ERR, 无效V码,本身不是青芒V码
//		VCODE_USED_ERR, V码已激活过了,此时后接str_information_content_t给出激活的时间(字符串)
//		PERMISSION_DENY_ERR,  用户做了越权的操作
//		CONCURRENT_CONFLICT_ERR, 并发冲突，极少发生。如两个用户同时激活同一个V码等
//		INVALID_MESSAGE_HEAD_ERR: server认为收到了未知msg_head类型
//		INVALID_MESSAGE_PACKET_ERR:  server认为收到包不合法，比如数据长度小于该消息类型应发送的长度或加密认证不对称(如session_id不对)
//		MESSAGE_TOO_LONG_ERR: server认为针对客户端发了超过MAX_MSG_BODY_LEN的包
//		DECRYPT_FAILURE_ERR: 服务器无法正确解密，很少发生；两端都可能导致这个发生，但通常是APP原因。
//		SERVER_BUSY_ERR: Server端原因，无法成功操作。


//C_S_REQUEST_SEND_SMS,	//客户端请求向特定手机号发送短信
//msg_body = session_id + encrypt_data_block(str_request_send_sms_info)

//S_C_REQUEST_SEND_SMS,
//msg_body = enum_return_result_t;
//		FEEDBACK_OK, 请求成功，已向相关用户手机发送短信内容
//		INVALID_CELLPHONE_NUM_ERR,	手机号非法
//		SMS_REQUEST_TOO_MUCH_ERR, 该手机号请求短信过多。
//		SMS_INTERVAL_TOO_SHORT_ERR, 客户端请求短信间隔太短
//		INVALID_MESSAGE_HEAD_ERR: server认为收到了未知msg_head类型
//		INVALID_MESSAGE_PACKET_ERR:  server认为收到包不合法，比如数据长度小于该消息类型应发送的长度或加密认证不对称(如session_id不对)
//		MESSAGE_TOO_LONG_ERR: server认为针对客户端发了超过MAX_MSG_BODY_LEN的包
//		DECRYPT_FAILURE_ERR: 服务器无法正确解密，很少发生；两端都可能导致这个发生，但通常是APP原因。
//		SERVER_BUSY_ERR: Server端原因，无法成功操作。

//C_S_APP_REPORT_STATUS,	//APP在给定情况下向服务器汇报相关状态，如是否在视频通话
//msg_body = session_id + encrypt_data_block(str_app_status_info)

//S_C_APP_REPORT_STATUS,
//msg_body = enum_return_result_t;
//		FEEDBACK_OK, 汇报成功
//		NOT_EXIST_ERR, 汇报的用户不在表中，即用户未登录
//		INVALID_MESSAGE_HEAD_ERR: server认为收到了未知msg_head类型
//		INVALID_MESSAGE_PACKET_ERR:  server认为收到包不合法，比如数据长度小于该消息类型应发送的长度或加密认证不对称(如session_id不对)
//		MESSAGE_TOO_LONG_ERR: server认为针对客户端发了超过MAX_MSG_BODY_LEN的包
//		DECRYPT_FAILURE_ERR: 服务器无法正确解密，很少发生；两端都可能导致这个发生，但通常是APP原因。
//		SERVER_BUSY_ERR: Server端原因，无法成功操作。



//C_MA_REQUEST_SERVER
// msg_body = encrypt_data_block(str_request_server_info_t)

//MA_C_REQUEST_SERVER
//msg_body = enum_return_result_t + encrypt_data_block(str_request_server_reply_info_t+[update_link])
//enum_return_result_t可能的情况:
//		FEEDBACK_OK: 只有此时enum_return_result_t后才接有效数据。update = 0,无更新；update =1, 有更新，接更新下载地址。
//		INVALID_MESSAGE_HEAD_ERR: server认为收到了未知msg_head类型
//		INVALID_MESSAGE_PACKET_ERR:  server认为收到包不合法，比如数据长度小于该消息类型应发送的长度或加密认证不对称(如session_id不对)
//		MESSAGE_TOO_LONG_ERR: server认为针对客户端发了超过MAX_MSG_BODY_LEN的包	
//		DECRYPT_FAILURE_ERR: 服务器无法正确解密，很少发生；两端都可能导致这个发生，但通常是APP原因。
//		SERVER_BUSY_ERR: Server端原因，无法成功操作。

#endif
