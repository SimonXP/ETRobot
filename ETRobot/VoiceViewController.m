
//
//  VoiceViewController.m
//  RecreationRobot
//
//  Created by IHOME on 16/4/18.
//  Copyright (c) 2016年 IHOME. All rights reserved.
//

#import "VoiceViewController.h"

@interface VoiceViewController ()<VoipHelperDelegate>

@property (nonatomic, assign) int hhInt;
@property (nonatomic, assign) int mmInt;
@property (nonatomic, assign) int ssInt;

@property (nonatomic, strong) VoipHelper *voipHelper;       //音视频工具类
@property (nonatomic, assign) VoipRole currentRole;        //主动呼叫，被呼叫
@property (nonatomic, strong) OverallObject *overall;       //单例
@property (nonatomic, strong) NSString *currentCallId;      //当前通话的ID

//主动拨打界面
@property (nonatomic, strong) UIButton *anwerBtn;             //接听
@property (nonatomic, strong) UIButton *relaseBtn;            //挂断

//被呼叫时的界面
@property (nonatomic, strong) UIImageView *robotIcon;   //图标
@property (nonatomic, strong) UILabel *robotNameLbl;    //名字
@property (nonatomic, strong) UIButton *hangBtn;        //挂断
@property (nonatomic, strong) UILabel *hangLbl;         //挂断提示
@property (nonatomic, strong) UILabel *speakerLbl;         //挂断提示
@property (nonatomic, strong) UILabel *muteLbl;         //挂断提示
@property (nonatomic, strong) UIButton *speakerBtn;     //扬声器
@property (nonatomic, strong) UIButton *muteBtn;        //静音,让对方听不到我的声音
@property (nonatomic, strong) UILabel *callTimeLbl;     //通话时间
@property (nonatomic, strong) FXLabel *endCallPromptLbl;//结束通话的提示

@property (nonatomic, strong) NSTimer *callTimer;

@end

@implementation VoiceViewController

- (instancetype)initWithCallRole:(NSInteger)role
{
    self = [super init];
    if (self) {
        self.currentRole = role;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化工具类
    [self initToolClass];
    //主动拨打界面
    [self setAdjustCallRoleCallersUI];
    //被呼叫时的界面
    [self setAdjustcallRoleCalledsUI];
    //设置定时器
    [self voipTimer];
}

- (void)viewWillAppear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarStyle:1];
    if (self.currentRole == VoipRoleCallers) {
        [self hiddenWithHangBtn:NO speakerBtn:YES muteBtn:YES prompt:YES relaseBtn:YES answerBtn:YES hangLbl:NO speakerLbl:YES muteLbl:YES];
    }else{
        [self hiddenWithHangBtn:YES speakerBtn:YES muteBtn:YES prompt:YES relaseBtn:NO answerBtn:NO hangLbl:YES speakerLbl:YES muteLbl:YES];
    }
}

- (void)hiddenWithHangBtn:(BOOL)hang speakerBtn:(BOOL)speaker muteBtn:(BOOL)mute prompt:(BOOL)prompt relaseBtn:(BOOL)relase answerBtn:(BOOL)answer hangLbl:(BOOL)hanglbl speakerLbl:(BOOL)speakerLbl muteLbl:(BOOL)muteLbl
{
    [self.hangBtn setHidden:hang];
    [self.speakerBtn setHidden:speaker];
    [self.muteBtn setHidden:mute];
    [self.relaseBtn setHidden:relase];
    [self.anwerBtn setHidden:answer];
    [self.hangLbl setHidden:hanglbl];
    [self.speakerLbl setHidden:speakerLbl];
    [self.muteLbl setHidden:muteLbl];
}


#pragma mark 初始化工具类
- (void)initToolClass
{
    self.voipHelper = [VoipHelper sharedObject];
    [self.voipHelper setDelegate:self];
    //登陆云平台
    [self.voipHelper connectToClientNumber:@"73350043801662" clientPwd:@"c6c07e43"];
    self.overall = [OverallObject sharedLoginInfo];
}

#pragma mark 初始化工具类
- (void)setAdjustcallRoleCalledsUI
{
    CGRect rect = [UIScreen mainScreen].bounds;
    CGFloat bWidth = 66;
    CGFloat spacing = 55;
    CGFloat titleWidth = rect.size.width/2;
    
    self.relaseBtn = [[UIButton alloc]initWithFrame:CGRectMake(rect.size.width-titleWidth + (titleWidth-bWidth)/2, rect.size.height-bWidth-spacing, bWidth, bWidth)];
    [self.relaseBtn setTitle:@"挂断" forState:UIControlStateNormal];
    [self.relaseBtn setBackgroundColor:[UIColor redColor]];
    [self.relaseBtn.titleLabel setFont:[UIFont systemFontOfSize:17]];
    [self.relaseBtn.layer setCornerRadius:self.hangBtn.frame.size.width/2];
    [self.relaseBtn.layer setMasksToBounds:YES];
    [self.relaseBtn addTarget:self action:@selector(hangBtnMethod:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.relaseBtn];
    
    self.anwerBtn = [[UIButton alloc]initWithFrame:CGRectMake((titleWidth-bWidth)/2, rect.size.height-bWidth-spacing, bWidth, bWidth)];
    [self.anwerBtn setTitle:@"接听" forState:UIControlStateNormal];
    [self.anwerBtn setBackgroundColor:[UIColor greenColor]];
    [self.anwerBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:17]];
    [self.anwerBtn.layer setCornerRadius:self.hangBtn.frame.size.width/2];
    [self.anwerBtn.layer setMasksToBounds:YES];
    [self.anwerBtn addTarget:self action:@selector(anwerBtnMethod:) forControlEvents:UIControlEventTouchUpInside];
    [self.anwerBtn setTag:1];
    [self.view addSubview:self.anwerBtn];
    
    [self.relaseBtn setHidden:YES];
    [self.anwerBtn setHidden:YES];
}

#pragma mark 初始化工具类
- (void)setAdjustCallRoleCallersUI
{
    CGRect rect = [UIScreen mainScreen].bounds;
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(-50, 0, rect.size.width+100, rect.size.height)];
    [imageView setImageToBlur:[UIImage imageNamed:@"voice.jpg"] blurRadius:15 completionBlock:nil];
    [self.view addSubview:imageView];
    
    CGFloat width = 120;
    self.robotIcon = [[UIImageView alloc]initWithFrame:CGRectMake((rect.size.width-width)/2, 60, width, width)];
    [self.robotIcon setImage:[UIImage imageNamed:@"voice.jpg"]];
    [self.robotIcon.layer setCornerRadius:self.robotIcon.frame.size.width/2];
    [self.robotIcon.layer setMasksToBounds:YES];
    [self.robotIcon.layer setBorderWidth:2];
    [self.robotIcon.layer setBorderColor:[UIColor whiteColor].CGColor];
    [self.view addSubview:self.robotIcon];

    self.robotNameLbl = [[UILabel alloc]initWithFrame:CGRectMake(0,  self.robotIcon.frame.origin.y+self.robotIcon.frame.size.height+10, rect.size.width, 40)];
    [self.robotNameLbl setTextColor:[UIColor whiteColor]];
    [self.robotNameLbl setFont:[UIFont boldSystemFontOfSize:20]];
    [self.robotNameLbl setText:@"小黄人"];
    [self.robotNameLbl setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:self.robotNameLbl];
    
    CGFloat bWidth = 64;
    CGFloat spacing = 55;
    CGFloat titleWidth = rect.size.width/3;
    
    self.hangBtn = [[UIButton alloc]initWithFrame:CGRectMake((rect.size.width-bWidth)/2, rect.size.height-bWidth-spacing, bWidth, bWidth)];
    [self.hangBtn setTitle:@"挂断" forState:UIControlStateNormal];
    [self.hangBtn setBackgroundColor:[UIColor redColor]];
    [self.hangBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [self.hangBtn.layer setCornerRadius:self.hangBtn.frame.size.width/2];
    [self.hangBtn.layer setMasksToBounds:YES];
    [self.hangBtn addTarget:self action:@selector(hangBtnMethod:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.hangBtn];

    self.speakerBtn = [[UIButton alloc]initWithFrame:CGRectMake(rect.size.width-titleWidth + (titleWidth-bWidth)/2, rect.size.height-bWidth-spacing, bWidth, bWidth)];
    [self.speakerBtn setTitle:@"免提" forState:UIControlStateNormal];
    [self.speakerBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
    [self.speakerBtn.layer setCornerRadius:self.hangBtn.frame.size.width/2];
    [self.speakerBtn.layer setMasksToBounds:YES];
    [self.speakerBtn.layer setBorderWidth:1.5];
    [self.speakerBtn.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [self.speakerBtn addTarget:self action:@selector(speakerBtnMethod:) forControlEvents:UIControlEventTouchUpInside];
    [self.speakerBtn setTag:1];
    [self.view addSubview:self.speakerBtn];
    
    self.muteBtn = [[UIButton alloc]initWithFrame:CGRectMake((titleWidth-bWidth)/2, rect.size.height-bWidth-spacing, bWidth, bWidth)];
    [self.muteBtn setTitle:@"静音" forState:UIControlStateNormal];
    [self.muteBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
    [self.muteBtn.layer setCornerRadius:self.hangBtn.frame.size.width/2];
    [self.muteBtn.layer setMasksToBounds:YES];
    [self.muteBtn.layer setBorderWidth:1.5];
    [self.muteBtn.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [self.muteBtn addTarget:self action:@selector(muteBtnMethod:) forControlEvents:UIControlEventTouchUpInside];
    [self.muteBtn setTag:1];
    [self.view addSubview:self.muteBtn];
    
    self.callTimeLbl = [[UILabel alloc]initWithFrame:CGRectMake(0, self.hangBtn.frame.origin.y-100, rect.size.width, 100)];
    [self.callTimeLbl setText:@"正在呼叫..."];
    [self.callTimeLbl setTextColor:[UIColor whiteColor]];
    [self.callTimeLbl setFont:[UIFont systemFontOfSize:18]];
    [self.callTimeLbl setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:self.callTimeLbl];
    
    self.endCallPromptLbl = [[FXLabel alloc]initWithFrame:CGRectMake(0, self.callTimeLbl.frame.origin.y-60, rect.size.width, 80)];
    [self.endCallPromptLbl setTextAlignment:NSTextAlignmentCenter];
    [self.endCallPromptLbl setTextColor:[UIColor whiteColor]];
    [self.endCallPromptLbl setFont:[UIFont boldSystemFontOfSize:25]];
    self.endCallPromptLbl.shadowOffset = CGSizeMake(0.0f, 2.0f);
    self.endCallPromptLbl.shadowColor = [UIColor colorWithWhite:0.0f alpha:0.75f];
    self.endCallPromptLbl.shadowBlur = 5.0f;
    [self.view addSubview:self.endCallPromptLbl];
    [self.endCallPromptLbl setAlpha:0];
    
    self.hangLbl = [[UILabel alloc]initWithFrame:CGRectMake(titleWidth, self.hangBtn.frame.origin.y+self.hangBtn.frame.size.height, titleWidth, 40)];
    [self.hangLbl setTextColor:[UIColor whiteColor]];
    [self.hangLbl setFont:[UIFont systemFontOfSize:12]];
    [self.hangLbl setTextAlignment:NSTextAlignmentCenter];
    [self.hangLbl setText:@"挂断"];
    [self.view addSubview:self.hangLbl];
    
    self.speakerLbl = [[UILabel alloc]initWithFrame:CGRectMake(0, self.hangBtn.frame.origin.y+self.hangBtn.frame.size.height, titleWidth, 40)];
    [self.speakerLbl setTextColor:[UIColor whiteColor]];
    [self.speakerLbl setFont:[UIFont systemFontOfSize:12]];
    [self.speakerLbl setTextAlignment:NSTextAlignmentCenter];
    [self.speakerLbl setText:@"挂断"];
    [self.view addSubview:self.speakerLbl];
    
    self.muteLbl = [[UILabel alloc]initWithFrame:CGRectMake(2*titleWidth, self.hangBtn.frame.origin.y+self.hangBtn.frame.size.height, titleWidth, 40)];
    [self.muteLbl setTextColor:[UIColor whiteColor]];
    [self.muteLbl setFont:[UIFont systemFontOfSize:12]];
    [self.muteLbl setTextAlignment:NSTextAlignmentCenter];
    [self.muteLbl setText:@"免提"];
    [self.view addSubview:self.muteLbl];
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

#pragma mark 结束通话
- (void)endCallMethod
{
    [self.endCallPromptLbl setText:@"结束通话"];
    [UIView animateWithDuration:0.8 animations:^{
        [self.endCallPromptLbl setAlpha:1];
    }];
    [self performSelector:@selector(goBack) withObject:nil afterDelay:1];
    [self.voipHelper.ucsService hangUp:self.overall.pubAttr.currentCallId];
}

#pragma mark 返回
- (void)goBack
{
    [self stopCallTimer];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark 免提
- (void)speakerBtnMethod:(UIButton *)button
{
    if (button.tag == 1) {
        button.tag = 2;
        [button setBackgroundColor:[UIColor lightGrayColor]];
        [self.voipHelper.ucsService setSpeakerphone:YES];
    }else{
        button.tag = 1;
        [button setBackgroundColor:[UIColor clearColor]];
        [self.voipHelper.ucsService setSpeakerphone:NO];
    }
}

#pragma mark 静音
- (void)muteBtnMethod:(UIButton *)button
{
    if (button.tag == 1) {
        button.tag = 2;
        [button setBackgroundColor:[UIColor lightGrayColor]];
        [self.voipHelper.ucsService setMicMute:YES];
    }else{
        button.tag = 1;
        [button setBackgroundColor:[UIColor clearColor]];
        [self.voipHelper.ucsService setMicMute:NO];
    }
}

#pragma mark 代理
//与云通讯平台连接成功
- (void)onConnectionSuccessful:(NSInteger)result
{
    [self.voipHelper call:@"73350043801661" type:0];
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
    [self hiddenWithHangBtn:NO speakerBtn:NO muteBtn:NO prompt:NO relaseBtn:YES answerBtn:YES hangLbl:NO speakerLbl:NO muteLbl:NO];
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
    [self.self.callTimeLbl setText:timerStr];
}

//设置定时器
- (void)voipTimer
{
    self.callTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(updateRealtimeLabel) userInfo:nil repeats:YES];
    [self stopCallTimer];
}
- (void)stopCallTimer
{
    [self.callTimer setFireDate:[NSDate distantFuture]];
}
- (void)startCallTimer
{
    [self.callTimer setFireDate:[NSDate date]];
}

@end
