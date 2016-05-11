
//
//  VideoViewController.m
//  RecreationRobot
//
//  Created by IHOME on 16/4/18.
//  Copyright (c) 2016年 IHOME. All rights reserved.
//

#import "VideoViewController.h"

@interface InspectViewController ()<VoipHelperDelegate>

@property (nonatomic, assign) int hhInt;
@property (nonatomic, assign) int mmInt;
@property (nonatomic, assign) int ssInt;

@property (nonatomic, strong) UIView *localView;
@property (nonatomic, strong) UIView *userView;
@property (nonatomic, strong) UIImageView *localImageView;


@property (nonatomic, strong) UILabel *timeLbl;             //时间
@property (nonatomic, strong) UIButton *speakerBtn;         //免提
@property (nonatomic, strong) UIButton *relaseCallBtn;      //挂断
@property (nonatomic, strong) UIButton *operateBtn;         //控制机器人的方向

@property (nonatomic, strong) UIView *operateDirView;      //操作方向按钮
@property (nonatomic, strong) UIButton *upBtn;
@property (nonatomic, strong) UIButton *downBtn;
@property (nonatomic, strong) UIButton *leftBtn;
@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, strong) UIButton *operateTypeBtn;

@property (nonatomic, strong) FXLabel *endCallPromptLbl;//结束通话的提示

@property (nonatomic, strong) NSTimer *operateTimer;
@property (nonatomic, assign) NSInteger directionNum;

@property (nonatomic, assign) CGRect timeRect;

@property (nonatomic, strong) NSTimer *callTimer;

@property (nonatomic, strong) VoipHelper *voipHelper;
@property (nonatomic, strong) OverallObject *overall;
@property (nonatomic, assign) VoipRole currentRole;
@property (nonatomic, strong) XPAFNetworkingTool *netWorkingTool;
@property (strong, nonatomic) TCPHelper *tcpHelper;
@property (assign, nonatomic) BOOL tcpConnected;

@end

@implementation InspectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化工具类
    [self initToolClass];
    //设置调整UI
    [self setAdjustUI];
    //video处理
    [self initVoip];
    //timer
    [self setTimer];
}

- (void)viewWillAppear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarStyle:1];
    [self hiddenWithSpeakerBtn:NO operateBtn:NO];
}

#pragma mark 初始化工具类
- (void)initToolClass
{
    self.overall = [OverallObject sharedLoginInfo];
    self.netWorkingTool = [[XPAFNetworkingTool alloc]init];
    self.tcpHelper = [[TCPHelper alloc]init];
//    self.tcpConnected = [self.tcpHelper connectWithIP:@"192.168.1.28" Port:30000 IsHeartBeat:false];
}

#pragma mark 初始化VOIP
- (void)initVoip
{
    self.voipHelper = [VoipHelper sharedObject];
    [self.voipHelper setDelegate:self];
    //登陆云平台
    [self.voipHelper connectToClientNumber:@"73350043801662" clientPwd:@"c6c07e43"];
    
    //自定义视频编码参数
    UCSVideoEncAttr *vEncAttr = [[UCSVideoEncAttr alloc] init] ;
    
    vEncAttr.isUseCustomEnc = YES;
    vEncAttr.uWidth = 352;
    vEncAttr.uHeight = 288;
    //    vEncAttr.uWidth = 640;
    //    vEncAttr.uHeight = 480;:
    
    vEncAttr.uStartBitrate = 250;
    vEncAttr.uMaxFramerate = 15;
    //    vEncAttr.uMaxBitrate = 300; //注释 by pbf 2015.09.10
    //    vEncAttr.uMinbitrate = 80;
    //    [self.voipHelper.ucsService setVideoEncAttr:vEncAttr]; //注释 by pbf 2015.09.15
    
    //自定义视频解码参数
    UCSVideoDecAttr *vDecAttr = [[UCSVideoDecAttr alloc] init] ;
    
    vDecAttr.isUseCustomDec = YES;
    vDecAttr.uWidth = 352;
    vDecAttr.uHeight = 288;
    //    vEncAttr.uWidth = 640;
    //    vEncAttr.uHeight = 480;
    
    //    vDecAttr.uMaxFramerate = 15; //注释 by pbf 2015.09.10
    //    [self.voipHelper.ucsService setVideoDecAttr:vDecAttr]; //注释 by pbf 2015.09.15
    
    [self.voipHelper.ucsService setVideoAttr:vEncAttr andVideoDecAttr:vDecAttr];
    
    //设置视频来电时是否支持预览。
    [self.voipHelper.ucsService setCameraPreViewStatu:YES];
    
    //设置，打开摄像头，和显示的view
    [self.voipHelper.ucsService openCamera:1];
}

#pragma mark 接听
- (void)anwerBtnMethod:(UIButton *)button
{
    [self.voipHelper.ucsService answer:self.overall.pubAttr.currentCallId];
}

#pragma mark 挂断
- (void)hangBtnMethod:(UIButton *)button
{
    [self endCallMethod];
}

#pragma mark 设置调整UI
- (void)setAdjustUI
{
    CGRect rect = [UIScreen mainScreen].bounds;
    
    CGFloat width1;
    if ([self.overall.pubMethod getDeviceType:rect.size.height]>5) {
        width1 = 68;
    }else if ([self.overall.pubMethod getDeviceType:rect.size.height]==5){
        width1 = 52;
    }
    
    //对方图像
    self.userView = [VideoView allocAndInitWithFrame:CGRectMake(-width1, -40, rect.size.width+width1*2, rect.size.height+80)];
    [self.view addSubview:self.userView];
    
    //本地图像
    self.localView = [VideoView allocAndInitWithFrame:CGRectMake(0, 0, 0, 0)];
    [self.view addSubview:self.localView];
    
    self.localImageView = [[UIImageView alloc]initWithFrame:self.userView.frame];
    [self.localImageView setImageToBlur:[UIImage imageNamed:@"voice.jpg"] blurRadius:8 completionBlock:nil];
    [self.view addSubview:self.localImageView];
    
    int width = 62;
    int spacing = 15;
    
    //免提
    self.speakerBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 30, width, width)];
    [self.speakerBtn setTitle:@"免提" forState:UIControlStateNormal];
    [self.speakerBtn addTarget:self action:@selector(setSpeakerMethod:) forControlEvents:UIControlEventTouchUpInside];
    [self.speakerBtn.layer setCornerRadius:width/2];
    [self.speakerBtn.layer setMasksToBounds:YES];
    [self.speakerBtn.layer setBorderWidth:1.5];
    [self.speakerBtn.layer setBorderColor:[UIColor whiteColor].CGColor];
    [self.speakerBtn setTag:1];
    [self.speakerBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [self.view addSubview:self.speakerBtn];
    
    //操作机器人方向
    self.operateBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, width + self.speakerBtn.frame.origin.y+spacing, width, width)];
    [self.operateBtn.layer setCornerRadius:width/2];
    [self.operateBtn.layer setMasksToBounds:YES];
    [self.operateBtn.layer setBorderWidth:1.5];
    [self.operateBtn.layer setBorderColor:[UIColor whiteColor].CGColor];
    [self.operateBtn setTag:1];
    [self.operateBtn setTitle:@"控制" forState:UIControlStateNormal];
    [self.operateBtn addTarget:self action:@selector(operateBtnMethod:) forControlEvents:UIControlEventTouchUpInside];
    [self.operateBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [self.view addSubview:self.operateBtn];
    
    //挂断
    self.relaseCallBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 2*width + self.speakerBtn.frame.origin.y+2*spacing, width, width)];
    [self.relaseCallBtn.layer setCornerRadius:width/2];
    [self.relaseCallBtn.layer setMasksToBounds:YES];
    [self.relaseCallBtn.layer setBorderWidth:1.5];
    [self.relaseCallBtn.layer setBorderColor:[UIColor whiteColor].CGColor];
    [self.relaseCallBtn setTag:1];
    [self.relaseCallBtn setTitle:@"挂断" forState:UIControlStateNormal];
    [self.relaseCallBtn addTarget:self action:@selector(relaseCall:) forControlEvents:UIControlEventTouchUpInside];
    [self.relaseCallBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [self.view addSubview:self.relaseCallBtn];
    
    self.timeRect = CGRectMake(0, [UIScreen mainScreen].bounds.size.height-80, [UIScreen mainScreen].bounds.size.width, 30);
    
    //时间提示
    self.timeLbl = [[UILabel alloc]initWithFrame:self.timeRect];
    [self.timeLbl setTextAlignment:NSTextAlignmentCenter];
    [self.timeLbl setTextColor:[UIColor whiteColor]];
    [self.timeLbl setFont:[UIFont boldSystemFontOfSize:18]];
    [self.timeLbl setText:@"正在呼叫..."];
    [self.view addSubview:self.timeLbl];
    
    //操作view
    self.operateDirView = [[UIView alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, 120)];
    [self.operateDirView setBackgroundColor:[UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.5]];
    [self.view addSubview:self.operateDirView];
    
    self.operateTypeBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.operateDirView.frame.size.width, self.operateDirView.frame.size.height)];
    [self.operateTypeBtn setTitle:@"运动" forState:UIControlStateNormal];
    [self.operateTypeBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [self.operateDirView addSubview:self.operateTypeBtn];
    
    self.upBtn = [[UIButton alloc]initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width - 110)/2, 0, 110, 45)];
    [self.upBtn setImage:[UIImage imageNamed:@"dir_up_off"] forState:UIControlStateNormal];
    [self.upBtn setImage:[UIImage imageNamed:@"dir_up_on"] forState:UIControlStateHighlighted];
    [self.upBtn setTag:1];
    [self.upBtn addTarget:self action:@selector(cancelDirectionMethod:) forControlEvents:UIControlEventTouchUpInside];
    [self.upBtn addTarget:self action:@selector(directionMethod:) forControlEvents:UIControlEventTouchDown];
    [self.operateDirView addSubview:self.upBtn];
    
    self.downBtn = [[UIButton alloc]initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width - 110)/2, self.operateDirView.frame.size.height - 45, 110, 45)];
    [self.downBtn setImage:[UIImage imageNamed:@"dir_down_off"] forState:UIControlStateNormal];
    [self.downBtn setImage:[UIImage imageNamed:@"dir_down_on"] forState:UIControlStateHighlighted];
    [self.downBtn setTag:2];
    [self.downBtn addTarget:self action:@selector(cancelDirectionMethod:) forControlEvents:UIControlEventTouchUpInside];
    [self.downBtn addTarget:self action:@selector(directionMethod:) forControlEvents:UIControlEventTouchDown];
    [self.operateDirView addSubview:self.downBtn];
    
    self.leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(0 , (self.operateDirView.frame.size.height - 110)/2, 45, 110)];
    [self.leftBtn setImage:[UIImage imageNamed:@"dir_left_off"] forState:UIControlStateNormal];
    [self.leftBtn setImage:[UIImage imageNamed:@"dir_left_on"] forState:UIControlStateHighlighted];
    [self.leftBtn setTag:3];
    [self.leftBtn addTarget:self action:@selector(cancelDirectionMethod:) forControlEvents:UIControlEventTouchUpInside];
    [self.leftBtn addTarget:self action:@selector(directionMethod:) forControlEvents:UIControlEventTouchDown];
    [self.operateDirView addSubview:self.leftBtn];
    
    self.rightBtn = [[UIButton alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 45, (self.operateDirView.frame.size.height - 110)/2, 45, 110)];
    [self.rightBtn setImage:[UIImage imageNamed:@"dir_right_off"] forState:UIControlStateNormal];
    [self.rightBtn setImage:[UIImage imageNamed:@"dir_right_on"] forState:UIControlStateHighlighted];
    [self.rightBtn setTag:4];
    [self.rightBtn addTarget:self action:@selector(cancelDirectionMethod:) forControlEvents:UIControlEventTouchUpInside];
    [self.rightBtn addTarget:self action:@selector(directionMethod:) forControlEvents:UIControlEventTouchDown];
    [self.operateDirView addSubview:self.rightBtn];
    
    self.endCallPromptLbl = [[FXLabel alloc]initWithFrame:CGRectMake(0, rect.size.height/2, rect.size.width, 80)];
    [self.endCallPromptLbl setText:@"结束通话"];
    [self.endCallPromptLbl setTextAlignment:NSTextAlignmentCenter];
    [self.endCallPromptLbl setTextColor:[UIColor whiteColor]];
    [self.endCallPromptLbl setFont:[UIFont boldSystemFontOfSize:25]];
    self.endCallPromptLbl.shadowOffset = CGSizeMake(0.0f, 2.0f);
    self.endCallPromptLbl.shadowColor = [UIColor colorWithWhite:0.0f alpha:0.75f];
    self.endCallPromptLbl.shadowBlur = 5.0f;
    [self.view addSubview:self.endCallPromptLbl];
    [self.endCallPromptLbl setAlpha:0];
    
}

#pragma mark UI调整
- (void)hiddenWithSpeakerBtn:(BOOL)speaker operateBtn:(BOOL)operate
{
    [self.speakerBtn setEnabled:speaker];
    [self.operateBtn setEnabled:operate];
}
#pragma mark -主动方法
#pragma mark 挂断电话
- (void)relaseCall:(UIButton *)button
{
    [self endCallMethod];
}

#pragma mark 结束通话
- (void)endCallMethod
{
    [UIView animateWithDuration:0.8 animations:^{
        [self.endCallPromptLbl setAlpha:1];
    }];
    [self.voipHelper.ucsService hangUp:self.overall.pubAttr.currentCallId];
    [self performSelector:@selector(goBack) withObject:nil afterDelay:1];
}

#pragma mark 返回
- (void)goBack
{
    [self stopCallTimer];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark 设置免提
- (void)setSpeakerMethod:(UIButton *)button
{
    if (button.tag == 1) {
        [button setTag:2];
        [button setBackgroundColor:[UIColor whiteColor]];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.voipHelper.ucsService setSpeakerphone:YES];
    }else{
        [button setTag:1];
        [button setBackgroundColor:[UIColor clearColor]];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.voipHelper.ucsService setSpeakerphone:NO];
    }
}


#pragma mark 控制机器人方向
- (void)operateBtnMethod:(UIButton *)button
{
    if (button.tag == 1) {
        [button setTag:2];
        [button setBackgroundColor:[UIColor whiteColor]];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }else{
        [button setTag:1];
        [button setBackgroundColor:[UIColor clearColor]];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    if (self.operateDirView.frame.origin.y == [UIScreen mainScreen].bounds.size.height) {
        [UIView animateWithDuration:0.3 animations:^{
            [self.operateDirView setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-120, [UIScreen mainScreen].bounds.size.width, 120)];
            [self.timeLbl setFrame:CGRectMake(0, self.timeLbl.frame.origin.y-self.operateDirView.frame.size.height, [UIScreen mainScreen].bounds.size.width, 30)];
        }];
        
    }else{
        [UIView animateWithDuration:0.3 animations:^{
            [self.operateDirView setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, 120)];
            [self.timeLbl setFrame:CGRectMake(0, self.timeLbl.frame.origin.y+self.operateDirView.frame.size.height, [UIScreen mainScreen].bounds.size.width, 30)];
        }];
    }
}


#pragma mark 云之讯代理
//与云通讯平台连接成功
- (void)onConnectionSuccessful:(NSInteger)result
{
    //开始发送
    [self.voipHelper.ucsService sendDTMF:'8'];
    [self.voipHelper call:@"73350043801661" type:2];
}

//与云通讯平台连接失败或连接断开
-(void)onConnectionFailed:(NSInteger)reason
{
    
}

//收到来电回调(支持昵称)
- (void)onIncomingCall:(NSString*)callid withcalltype:(UCSCallTypeEnum) callType withcallerinfo:(NSDictionary *)callinfo
{
    
}

//呼叫振铃回调
-(void)onAlerting:(NSString*)called withVideoflag:(int)videoflag
{
    NSLog(@"呼叫振铃回调");
}

//接听回调
-(void)onAnswer:(NSString*)callid
{
    NSLog(@"接听回调");
    [self.voipHelper.ucsService initCameraConfig:self.localView withRemoteVideoView:self.userView];
    [self.localImageView setHidden:YES];
    [self hiddenWithSpeakerBtn:YES operateBtn:YES];
    [self startCallTimer];
}

//呼叫失败回调
- (void) onDialFailed:(NSString*)callid  withReason:(UCSReason*)reason
{
    NSLog(@"呼叫失败");
    [self.endCallPromptLbl setText:@"对方不在线"];
    [self endCallMethod];
}

//释放通话回调
- (void) onHangUp:(NSString*)callid withReason:(UCSReason*)reason
{
    NSLog(@"对方已挂断");
    [self endCallMethod];
}

#pragma mark 通话时间
- (void)updateRealtimeLabel
{
    NSString *timerStr = @"";
    self.ssInt +=1;
    if (self.ssInt >= 60) {
        self.mmInt += 1;
        self.ssInt -= 60;
        if (self.mmInt >=  60) {
            self.hhInt += 1;
            self.mmInt -= 60;
            if (self.hhInt >= 24) {
                self.hhInt = 0;
            }
        }
    }
    
    if (self.hhInt > 0) {
        timerStr = [NSString stringWithFormat:@"%02d:%02d:%02d",self.hhInt,self.mmInt,self.ssInt];
    }else{
        timerStr = [NSString stringWithFormat:@"%02d:%02d",self.mmInt,self.ssInt];
    }
    NSLog(@"%@",timerStr);
    [self.timeLbl setText:timerStr];
}

//设置定时器
- (void)setTimer
{
    self.callTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(updateRealtimeLabel) userInfo:nil repeats:YES];
    [self stopCallTimer];
    
    self.operateTimer = [NSTimer scheduledTimerWithTimeInterval:0.5f target:self selector:@selector(controlRobotMoveMethod) userInfo:nil repeats:YES];
    [self stopOperateTimer];
}

#pragma mark -运动控制

#pragma mark 取消方向操作
- (void)cancelDirectionMethod:(UIButton *)button
{
    //停止移动
    [self sendDirectionWithType:@"5"];
    [self stopOperateTimer];
}

#pragma mark 方向操作
- (void)directionMethod:(UIButton *)button
{
    self.directionNum = button.tag;
    [self startOperateTimer];
}

//发送方向数据
- (void)controlRobotMoveMethod
{
    if (self.directionNum == 1) {
        //前进
        [self sendDirectionWithType:@"1"];
        
    }else if (self.directionNum == 2){
        //后退
        [self sendDirectionWithType:@"2"];
        
    }else if (self.directionNum == 3){
        //左移
        [self sendDirectionWithType:@"3"];
        
    }else if (self.directionNum == 4){
        //右移
        [self sendDirectionWithType:@"4"];
    }
}

//发送数据到底盘
- (void)sendDirectionWithType:(NSString *)direcationValue
{
    NSLog(@"direcationValue：%@",direcationValue);
//    //开始发送
//    if (self.overall.pubAttr.tcpConnected) {
//        [self.overall.pubAttr.tcpHelper writeValue:direcationValue];
//    }
}


#pragma mark 定时器
- (void)stopCallTimer
{
    [self.callTimer setFireDate:[NSDate distantFuture]];
}
- (void)startCallTimer
{
    [self.callTimer setFireDate:[NSDate date]];
}

- (void)stopOperateTimer
{
    [self.operateTimer setFireDate:[NSDate distantFuture]];
}

- (void)startOperateTimer
{
    [self.operateTimer setFireDate:[NSDate date]];
}

@end
