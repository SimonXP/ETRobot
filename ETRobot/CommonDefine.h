//
//  CommonDefine.h
//  XiangJiaBao
//
//  Created by admin on 15-6-11.
//  Copyright (c) 2015年 青芒科技. All rights reserved.
//

#ifndef XiangJiaBao_CommonDefine_h
#define XiangJiaBao_CommonDefine_h

//联系人列表更新间隔
#define INTERNAL_OF_UPDATE_CONTACT_LIST 20

//自动接听等待时间
#define INTERNAL_OF_AUTO_ANSWER_CALL 6

//自动挂断等待时间
#define INTERNAL_OF_AUTO_HANGUP_CALL 20

//获取自身在线状态间隔
#define INTERNAL_OF_CHECK_ONLINE_STATUS 20

//视频留言最大时长
#define VideoMESSAGE_MAX_SECONDS 120

//webrtc接通等待时间
#define WEBRTC_CONNECT_MAX_WAIT_SECONDS 30

//控制对方底座转动时手指在屏幕上的最小滑动距离，否则无效
#define MIN_FLING_DISTANCEX 100.0f
#define MIN_FLING_DISTANCEY 100.0f

//master服务器IP
//"121.40.127.72"--内测服务器
//"121.40.50.219"--商用服务器
#define MASTERSERVER_IP @"121.40.106.95"
//master服务器TCP端口
#define MASTERSERVER_TCP_PORT 10000

//TCP连接超时
#define TCP_CONNECT_TIMEOUT 10
//TCP读超时
#define TCP_READ_TIMEOUT 10

//TCP线程消息
#define TCP_CONNECT_FAILED 101
#define TCP_WRITE_FAILED 102
#define TCP_READ_FAILED 103
#define TCP_TRANSFER_ERROR 104
#define ENCRYPT_FAILED 105
#define DECRYPT_FAILED 106

#define SEND_PHOTO_OR_VIDEO_PACKET_SIZE 1000

#endif
