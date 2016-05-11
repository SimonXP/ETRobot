//
//  VoipHelper.m
//  PIRO
//
//  Created by IHOME on 15/12/14.
//  Copyright (c) 2015年 IHOME. All rights reserved.
//

#import "VoipHelper.h"

@interface VoipHelper ()

@end

@implementation VoipHelper

@synthesize delegate = _delegate;
static VoipHelper *helper;

- (instancetype)init
{
    if (self = [super init]) {
        
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _ucsService = [[UCSService alloc]init];
            [_ucsService setDelegate:self];
            _overall = [OverallObject sharedLoginInfo];
        });
        
    }
    return self;
}

+ (VoipHelper *)sharedObject
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [[VoipHelper alloc] init];
    });
    return helper;
}


// 登录帐号
- (void)connectToClientNumber:(NSString *)clientNumber clientPwd:(NSString *)clientPwd
{
    [self.ucsService connect:@"05c2d70de8d84b9d5039e88ebaad9a85" withAccountToken:@"361109563878d8a8c7ccfffb25c2cbe7" withClientNumber:clientNumber withClientPwd:clientPwd];
}

// 退出云平台
- (void)disConnect
{
    [self.ucsService uninit];
}

//呼叫
- (void)call:(NSString *)account type:(NSInteger)type
{
    [self.ucsService dial:type andCalled:account andUserdata:@"voip网络电话"];
}


#pragma mark 初始化函数代理
/********************初始化回调********************/
//与云通讯平台连接成功
- (void)onConnectionSuccessful:(NSInteger)result
{
    NSLog(@"与云通讯平台连接成功");
    if ([_delegate respondsToSelector:@selector(onConnectionSuccessful:)]) {
        [_delegate onConnectionSuccessful:result];
    }
}

//与云通讯平台连接失败或连接断开
-(void)onConnectionFailed:(NSInteger)reason
{
    NSLog(@"与云通讯平台连接失败或连接断开");
    if ([_delegate respondsToSelector:@selector(onConnectionFailed:)]) {
        [_delegate onConnectionFailed:reason];
    }
}

//收到来电回调(支持昵称)
- (void)onIncomingCall:(NSString*)callid withcalltype:(UCSCallTypeEnum) callType withcallerinfo:(NSDictionary *)callinfo
{
    NSLog(@"收到来电回调(支持昵称):%@",callid);
    self.overall.pubAttr.currentCallId = callid;
    if ([_delegate respondsToSelector:@selector(onIncomingCall:withcalltype:withcallerinfo:)]) {
        [_delegate onIncomingCall:callid withcalltype:callType withcallerinfo:callinfo];
    }
    NSString *callTypeStr;
    
    if (callType == UCSCallType_VOIP) {
        callTypeStr = @"voice";
    }else if(callType == UCSCallType_VideoPhone) {
        callTypeStr = @"video";
    }
    NSDictionary *dict = @{@"callId":callid,@"callType":callTypeStr};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"voipCallIn" object:self userInfo:dict];
}

//当发起呼叫后对方振铃时回调此函数
- (void) onAlerting:(NSString*)callid
{
    NSLog(@"当发起呼叫后对方振铃时回调此函数");
    if ([_delegate respondsToSelector:@selector(onAlerting:)]) {
        [_delegate onAlerting:callid];
    }
}

//接听回调
-(void) onAnswer:(NSString*)callid
{
    NSLog(@"接听回调");
    self.overall.pubAttr.currentCallId = callid;
    [_delegate onAnswer:callid];
}

//呼叫失败(被叫拒接，被叫忙等原因)的代理函数，可参考错误码查找失败原因
- (void) onDialFailed:(NSString*)callid withReason:(UCSReason*)reason
{
    NSLog(@"呼叫失败");
    if ([_delegate respondsToSelector:@selector(onDialFailed:withReason:)]) {
        [_delegate onDialFailed:callid withReason:reason];
    }
}

//通话过程中，对方挂断电话
- (void) onHangUp:(NSString*)callid withReason:(UCSReason*)reason
{
    NSLog(@"通话过程中，对方挂断电话");
    [_delegate onHangUp:callid withReason:reason];
}

@end
