//
//  UCSCallService.h
//  yzxapisdk
//
//  Created by tongkucky on 14-4-2.
//  Copyright (c) 2014年 yzx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UCSCommonClass.h"
#import "UCSEvent.h"
@class VideoView;
@interface UCSService : NSObject
 

#pragma mark - 初始化函数
//初始化实例
- (UCSService *)initWithDelegate:(id<UCSEventDelegate>)delegate;
//设置代理方法
-(void)setDelegate:(id< UCSEventDelegate>)delegate;

//连接服务器（明文）
-(NSInteger)connect:(NSString *)accountSid withAccountToken:(NSString *)accountToken withClientNumber:(NSString *)clientNumber withClientPwd:(NSString *)clientPwd;

//连接服务器（密文）
-(NSInteger)connect:(NSString *)token;

//连接服务器（明文,指定IP，Port）
-(NSInteger)connect:(NSString*)host_addr withPort:(NSString*)host_port withwithAccountSid:(NSString *)accountSid withAccountToken:(NSString *)accountToken withClientNumber:(NSString *)clientNumber withClientPwd:(NSString *)clientPwd;

//连接服务器（密文,指定IP，Port）
-(NSInteger)connect:(NSString*)host_addr withPort:(NSString*)host_port withToken:(NSString *)token;

 


//查询帐号与服务器连接状态
- (BOOL)isConnected;

//断开云平台连接
- (void)uninit;

#pragma mark - 呼叫控制函数
/**
 * 拨打电话
 * @param callType 电话类型 0:语音Voip电话 1:落地电话 2:视频电话 4:智能呼叫
 * @param called 电话号(加国际码)或者VoIP号码
 * @return
 */
- (void)dial:(NSInteger)callType andCalled:(NSString *)calledNumber andUserdata:(NSString *)callerData;


/**
 * 挂断电话
 * @param callid 电话id
 *
 */
- (void) hangUp: (NSString*)callid;


/**
 * 接听电话
 * @param callid 电话id
 *
 */
- (void) answer: (NSString*)callid;


/**
 * 拒绝呼叫(挂断一样,当被呼叫的时候被呼叫方的挂断状态)
 * @param callid 电话id
 * 
 */
- (void)reject: (NSString*)callid;


/**
 * 回拨电话
 *
 * @param phoneNumber 被叫的电话（若呼叫国外需加国际码）
 *
 *
 */
- (void)callBack:(NSString *)phoneNumber;


/**
 * 回拨电话
 *
 * @param phoneNumber 被叫的电话（若呼叫国外需加国际码）
 * @param fromNum     显示主叫号码（此为可选参数）
 * @param toNum       显示被叫号码 （此为可选参数）
 *
 */
- (void)callBack:(NSString *)phoneNumber showFromNum:(NSString*)fromNum showToNum:(NSString*)toNum;


/**
 * 取消回拨电话
 *
 * @param phoneNumber 被叫的电话（若呼叫国外需加国际码）
 *
 *
 */
- (void)cancelCallBack:(NSString *)phoneNumber;


#pragma mark - DTMF函数
/**
 * 发送DTMF
 * @param callid 电话id
 * @param dtmf 键值
 */
- (BOOL)sendDTMF: (char)dtmf;


#pragma mark - 本地功能函数
/**
 * 免提设置
 * @param enable NO:关闭 YES:打开
 */
- (void) setSpeakerphone:(BOOL)enable;


/**
 * 获取当前免提状态
 * @return NO:关闭 YES:打开
 */
- (BOOL) isSpeakerphoneOn;


/**
 * 静音设置
 * @param on NO:正常 YES:静音
 */
- (void)setMicMute:(BOOL)on;


/**
 * 获取当前静音状态
 * @return NO:正常 YES:静音
 */
- (BOOL)isMicMute;


#pragma mark IM能力函数
/**
 * 发送IM消息
 *
 */
- (NSString*) sendUcsMessage:(NSString*) receiver andText:(NSString*) text   andFilePath:(NSString*) filePath andExpandData:(NSInteger)msgType;


/**
 * 开始录制音频
 *
 */
- (NSString*) startVoiceRecord:(NSString*)filePath;


/**
 * 停止录制语音
 *
 */
-(void) stopVoiceRecord;


/**
 * 播放语音
 *
 */
-(void) playVoice :(NSString*) filePath;


/**
 * 停止播放语音
 *
 */
-(void) stopVoice;


/**
 * 获取语音时长
 *
 */
-(long) getVoiceDuration:(NSString*) filePath;


/**
 * 下载附件API
 *
 */
- (void) downloadAttached:(NSString*) fileUrl andFilePath:(NSString*) filePath andMsgID:(NSString*)MsgID;


#pragma mark 辅助能力函数
/**
 * 获取SDK版本信息
 *
 */
- (NSString*) getUCSSDKVersion;


/**
 * 获取流量分类统计信息
 *
 */
-(NSDictionary*) getNetWorkFlow;


/**
 * 获取clientNumber和phoneNumber（绑定的手机号）
 *
 */
-(NSDictionary*) getUserInfo;


 /**
 * 获取当前应用下的路径
 *
 */
- (NSString *) getIMMediaDir:(NSString *) strPhoneNumber;


#pragma mark 视频能力函数

/**
 * 设置视频显示参数
 *
 *参数 localVideoView 设置本地视频显示控件
 *参数 remoteView     设置对方视频显示控件
 *参数 width          设置发给对方视频的分辨率：宽
 *参数 height         设置发给对方视频的分辨率：高
 *
 *@return NO:  YES:
 */

- (BOOL)setVideoConfig:(UIView*)localVideoView withRemoteVideoView:(UIView*)remoteView showtoRemoteVideoWidth:(int)width showtoRemoteVideoHeight:(int) height;//注：此接口将被弃用,建议查阅官网接口，使用新接口。


/**
 * 设置视频显示参数
 *
 *参数 localVideoView 设置本地视频显示控件
 *参数 remoteView     设置对方视频显示控件
 *
 *@return NO:  YES:
 */
-(BOOL)initCameraConfig:(UIView*)localVideoView withRemoteVideoView:(UIView*)remoteView;


/**
 * 通过UCSVideoEncAttr设置视频编码 分辨率、开始码率、最大码率、最小码率、帧率参数（在设置视频显示参数前调用）
 *
 *  参数 ucsVideoEncAttr  参数实体
 *  视频编码分辨率建议 低分辨率：352*288 高分辨率：640*480
 *@return NO:  YES:
 */
- (BOOL)setVideoEncAttr:(UCSVideoEncAttr*)ucsVideoEncAttr;//注：此接口将被弃用,建议查阅官网接口，使用新接口。


/**
 * 通过UCSVideoDecAttr设置视频解码 分辨率、帧率参数（在设置视频显示参数前调用）
 *
 * 参数 ucsVideoDecAttr  参数实体
 * 视频解码码分辨率建议 低分辨率：352*288 高分辨率：640*480
 *@return NO:  YES:
 */
- (BOOL)setVideoDecAttr:(UCSVideoDecAttr*)ucsVideoDecAttr;//注：此接口将被弃用,建议查阅官网接口，使用新接口。


/**
 *  自定义视频编码和解码参数
 *
 *  @param ucsVideoEncAttr 编码参数
 *  @param ucsVideoDecAttr 解码参数
 */
- (void)setVideoAttr:(UCSVideoEncAttr*)ucsVideoEncAttr andVideoDecAttr:(UCSVideoDecAttr*)ucsVideoDecAttr;


/**
 * 旋转显示图像角度
 *
 * 参数 sendRotation      本地显示图像角度  数值为0 90 180 270
 * 参数 reciviedRotation  对端显示图像角度  数值为0 90 180 270
 *@return NO:  YES:
 */
- (BOOL)setRotationVideo:(unsigned int)sendRotation withReciviedRotation:(unsigned int)reciviedRotation;


/**
 * 设置视频显示参数
 *获取摄像头个数
 */
- (int) getCameraNum;


/**
 * 摄像头切换 后置摄像头：0 前置摄像头：1
 *return YES 成功 NO 失败
 */
- (BOOL) switchCameraDevice:(int)CameraIndex;


/**
 * 开启视频预览 后置摄像头：0 前置摄像头：1
 *return YES 成功 NO 失败
 */
- (BOOL) openCamera:(int)CameraIndex;//注：此接口将被弃用,建议查阅官网接口，使用新接口。


/**
 * 关闭视频预览 后置摄像头：0 前置摄像头：1
 * return YES 成功 NO 失败
 */
- (BOOL)closeCamera:(int)CameraIndex;//注：此接口将被弃用,建议查阅官网接口，使用新接口。


/**
 *  切换视频模式：发送、接收、正常模式
 *
 *  @param type         CAMERA_RECEIVE : 只接收视频数据（只能接收到对方的视频）
                        CAMERA_SEND : 只发送视频数据（只让对方看到我的视频）
                        CAMERA_NORMAL : send receive preview
 *
 *  @return YES 成功 NO 失败
 */
- (BOOL) switchVideoMode:(UCSCameraType)type;


/**
 * 视频截图
 * @param islocal: 0 是远端截图 1 是本地截图。
 * @param filename: 截图名称。
 * @param savePath: 存放路径。
 *
 */
- (void)cameraCapture:(int)islocal withFileName:(NSString*)filename withSavePath:(NSString*)savePath;


/**
 * 视频来电时是否支持预览
 * isPreView: YES 支持预览 NO 不支持预览。
 * return YES 成功 NO 失败
 */
- (BOOL)setCameraPreViewStatu:(BOOL)isPreView;


/**
 *  获取视频来电时是否支持预览
 *
 *  @return YES 支持预览 NO 不支持预览
 */
- (BOOL)isCameraPreviewStatu;


/**
 * 查询多个client/phone的状态
 *
 */
- (void) queryUserState:(UCSClientType)numType withClients:(NSMutableArray*)clients;


/**
 * 查询单个client/phone的状态
 *
 */
- (void) queryUserState:(UCSClientType)numType withClient:(NSString*)client;


/**
 * 获取云验证码
 */
-(void)getVerificationCode:(NSString *)sid withAppid:(NSString *)appid withAppName:(NSString *)appName withCodetype:(int)codetype withPhone:(NSString *)phone withSeconds:(int)seconds withBusiness:(int)business;


/**
  * 验证码验证
 */
-(void)doVerificationCode:(NSString *)sid withAppid:(NSString *)appid withPhone:(NSString *)phone withVerifycode:(NSString *)verifycode;


/**
 * 离线来电推送
 *
 */
- (void) callIncomingPushRsp:(NSString*)callid  withVps:(NSInteger)vpsid withReason:(UCSReason*)reason;

@end
