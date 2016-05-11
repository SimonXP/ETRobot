
//
//  ForgetPwdViewController.m
//  RecreationRobot
//
//  Created by IHOME on 16/4/21.
//  Copyright (c) 2016年 IHOME. All rights reserved.
//

#import "ForgotPwdViewController.h"

@interface ForgotPwdViewController ()

@property (nonatomic, strong) UIScrollView *myScrollView;
@property (nonatomic, strong) UILabel *iphoneLbl;  //手机提示
@property (nonatomic, strong) UITextField *verifyCodeText;//验证码
@property (nonatomic, strong) UILabel *verifyCodeLblPrompt; //验证码提示
@property (nonatomic, strong) UIButton *getVerifyCodeBtn;//获取验证码
@property (nonatomic, strong) UITextField *uNewPwd;//新密码
@property (nonatomic, strong) UITextField *reNewPwd;//确定新密码

@property (nonatomic, strong) NSString *forgotPwdMobile;

@property (nonatomic, assign) NSInteger reObtainTimeNum;
@property (nonatomic, strong) NSTimer *verifyTimer;

@property (nonatomic, strong) OverallObject *overall;
@property (nonatomic, strong) XPAFNetworkingTool *networkingTool;

@end

@implementation ForgotPwdViewController

- (id)initWithForgotPwd:(NSString *)mobile
{
    self = [super init];
    if (self) {
        self.forgotPwdMobile = mobile;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化工具类
    [self initToolClass];
    //设置调整UI
    [self setAdjustUI];
}

#pragma mark 初始化工具类
- (void)initToolClass
{
    self.overall = [OverallObject sharedLoginInfo];
    self.networkingTool = [[XPAFNetworkingTool alloc]init];
    self.reObtainTimeNum = 60;
    self.verifyTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(reObtainVerifyCodeTimeMethod) userInfo:nil repeats:YES];
}

#pragma mark 重新获取验证码
- (void)reGetVerifyCodeBtnMethod
{
    //发送验证码，开始请求
    [SVProgressHUD showSuccessWithStatus:SENDVERIFYPROMPT];
    [self.networkingTool postVisitServiceWithURL:VERIFYCODEURL argsDict:@{@"mobile":self.forgotPwdMobile,@"templateId":TEXTMESSAGETEMPLATEID} timeoutInterval:10 tag:1];
    [self openVerifyTimer];
}

#pragma mark 忘记密码
- (void)forgotPwdBtnMethod
{
    if (self.uNewPwd.text.length > 0 && self.reNewPwd.text.length > 0) {
        if ([self.uNewPwd.text isEqualToString:self.reNewPwd.text]) {
            //忘记密码
            
        }else{
            [SVProgressHUD showErrorWithStatus:PWDERROR];
        }
    }else{
        [SVProgressHUD showErrorWithStatus:MESSAGENOCOMPLETEPROMPT];
    }
}

#pragma mark 重新验证的时间
- (void)reObtainVerifyCodeTimeMethod
{
    self.reObtainTimeNum--;
    if (self.reObtainTimeNum >0) {
        [self.verifyCodeLblPrompt setText:[NSString stringWithFormat:@"重新发送(%ld)",self.reObtainTimeNum]];
        [self.verifyCodeLblPrompt setTextColor:[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.9]];
    }else{
        [self closeVerifyTimer];
        self.reObtainTimeNum = 60;
        [self.verifyCodeLblPrompt setText:@"重新发送"];
        [self.verifyCodeLblPrompt setTextColor:[UIColor colorWithRed:0.4 green:0.5 blue:0.7 alpha:1]];
    }
}

#pragma mark 设置调整UI
- (void)setAdjustUI
{
    [self.view setBackgroundColor:[UIColor colorWithRed:0.93 green:0.93 blue:0.95 alpha:1]];
    CGRect rects = [UIScreen mainScreen].bounds;
    CGFloat dx = 120;
    UIFont *fonts = [UIFont systemFontOfSize:15];
    CGFloat height = 45;
    CGFloat x = 15;
    CGFloat dwidths = 0.4;
    UIColor *colors = [UIColor colorWithRed:0.7 green:0.7 blue:0.75 alpha:1];

    [self.view addSubview:[self.overall.pubAttr.pulicViewModel setTabBarView:@"新密码"]];
    
    UIButton *goBackBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 15, 60, 60)];
    [goBackBtn setImage:[UIImage imageNamed:goBackIcon] forState:UIControlStateNormal];
    [goBackBtn addTarget:self action:@selector(goBackBtnMethod) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:goBackBtn];
    
    self.myScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 70, rects.size.width, rects.size.height)];
    [self.myScrollView setContentSize:CGSizeMake(rects.size.width, rects.size.height+20)];
    [self.view addSubview:self.myScrollView];
    
    self.iphoneLbl = [self.overall.pubAttr.pulicViewModel setLabelWithFrame:CGRectMake(x, 14, rects.size.width - 20, 20) textValue:[NSString stringWithFormat:@"发送验证码到您的手机：%@",self.forgotPwdMobile] fontSize:15];
    [self.iphoneLbl setNumberOfLines:0];
    [self.iphoneLbl setTextAlignment:NSTextAlignmentLeft];
    [self.iphoneLbl setTextColor:[UIColor colorWithRed:0.5 green:0.5 blue:0.52 alpha:1]];
    [self.myScrollView addSubview:self.iphoneLbl];
    
    UITapGestureRecognizer *tag = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(getTouchEvent)];
    [self.myScrollView addGestureRecognizer:tag];
    
    UIView *verifyCodeView = [[UIView alloc]initWithFrame:CGRectMake(0, self.iphoneLbl.frame.origin.y+self.iphoneLbl.frame.size.height+10, rects.size.width, 45)];
    [verifyCodeView.layer setBorderWidth:0.3];
    [verifyCodeView.layer setBorderColor:[UIColor colorWithRed:0.7 green:0.7 blue:0.75 alpha:1].CGColor];
    [verifyCodeView setBackgroundColor:[UIColor whiteColor]];
    [self.myScrollView addSubview:verifyCodeView];
    
    self.verifyCodeText = [self.overall.pubAttr.pulicViewModel setTextFieldViewWithFrame:CGRectMake(x, 0, rects.size.width - dx-20, height) textValue:@"" placeholderValue:@"验证码" pwd:NO];
    [self.verifyCodeText setBackgroundColor:[UIColor clearColor]];
    [self.verifyCodeText setKeyboardType:UIKeyboardTypeNumberPad];
    [verifyCodeView addSubview:self.verifyCodeText];
    
    
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(rects.size.width-dx, 0, 0.3, self.verifyCodeText.frame.size.height)];
    [line setBackgroundColor:[UIColor colorWithRed:0.75 green:0.75 blue:0.75 alpha:1]];
    [verifyCodeView addSubview:line];
    
    
    self.verifyCodeLblPrompt = [self.overall.pubAttr.pulicViewModel setLabelWithFrame:CGRectMake(rects.size.width-dx, 0, dx, 40) textValue:@"重新发送(60)" fontSize:15];
    [self.verifyCodeLblPrompt setTextColor:[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.9]];
    [self.verifyCodeLblPrompt setTextAlignment:NSTextAlignmentCenter];
    [verifyCodeView addSubview:self.verifyCodeLblPrompt];
    
    self.getVerifyCodeBtn = [[UIButton alloc]initWithFrame:self.verifyCodeLblPrompt.frame];
    [self.getVerifyCodeBtn addTarget:self action:@selector(reGetVerifyCodeBtnMethod) forControlEvents:UIControlEventTouchUpInside];
    [verifyCodeView addSubview:self.getVerifyCodeBtn];
    
    UILabel *msgLbl = [[UILabel alloc]initWithFrame:CGRectMake(x, verifyCodeView.frame.origin.y+height+10, rects.size.width - 20, 20)];
    [msgLbl setFont:fonts];
    [msgLbl setText:@"密码重置"];
    [msgLbl setTextColor:[UIColor colorWithRed:0.5 green:0.5 blue:0.52 alpha:1]];
    [self.myScrollView addSubview:msgLbl];
    
    UIView *msgView = [[UIView alloc]initWithFrame:CGRectMake(-1, msgLbl.frame.origin.y + 30, rects.size.width+2, height*2)];
    [msgView setBackgroundColor:[UIColor whiteColor]];
    [msgView.layer setBorderWidth:dwidths];
    [msgView.layer setBorderColor:colors.CGColor];
    [self.myScrollView addSubview:msgView];
    
    for (int i = 1; i < 2; i++) {
        UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, i * height, rects.size.width, 0.4)];
        [line setBackgroundColor:[UIColor colorWithRed:0.75 green:0.75 blue:0.75 alpha:1]];
        [msgView addSubview:line];
    }
    
    self.uNewPwd = [self.overall.pubAttr.pulicViewModel setTextFieldViewWithFrame:CGRectMake(x, 0, rects.size.width-2*x, height) textValue:@"" placeholderValue:@"新密码" pwd:YES];
    [msgView addSubview:self.uNewPwd];    
    
    self.reNewPwd = [self.overall.pubAttr.pulicViewModel setTextFieldViewWithFrame:CGRectMake(x,height, rects.size.width-2*x, height) textValue:@"" placeholderValue:@"确定密码" pwd:YES];
    [msgView addSubview:self.reNewPwd];
    
    UIButton *nextStepBtn = [[UIButton alloc]initWithFrame:CGRectMake(x, msgView.frame.origin.y+120, rects.size.width-30, 45)];
    [nextStepBtn setBackgroundColor:[UIColor colorWithRed:0.3 green:0.32 blue:0.9 alpha:1]];
    [nextStepBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [nextStepBtn setTitle:@"确定" forState:UIControlStateNormal];
    [nextStepBtn addTarget:self action:@selector(forgotPwdBtnMethod) forControlEvents:UIControlEventTouchUpInside];
    [nextStepBtn.layer setCornerRadius:5];
    [nextStepBtn.layer setMasksToBounds:YES];
    [self.myScrollView addSubview:nextStepBtn];
}

#pragma mark 返回
- (void)goBackBtnMethod
{
    [self closeVerifyTimer];
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark 获取UItouch事件
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self getTouchEvent];
}

#pragma mark 获取key事件
- (void)getTouchEvent
{
    [self.view endEditing:YES];
}

#pragma mark 关闭定时器
- (void)closeVerifyTimer
{
    //关闭定时器
    [self.verifyTimer setFireDate:[NSDate distantFuture]];
}
#pragma mark 打开定时器
- (void)openVerifyTimer
{
    //打开定时器
    [self.verifyTimer setFireDate:[NSDate distantPast]];
}

@end
