//
//  RegisterMsgViewController.m
//  RecreationRobot
//
//  Created by IHOME on 16/4/21.
//  Copyright (c) 2016年 IHOME. All rights reserved.
//

#import "RegisterMsgViewController.h"

@interface RegisterMsgViewController ()<XPAFNetworkingToolDelegate>

@property (nonatomic, strong) UIScrollView *myScrollView;
@property (nonatomic, strong) UILabel *iphoneLbl;  //手机提示
@property (nonatomic, strong) UITextField *verifyCodeText;//验证码
@property (nonatomic, strong) UILabel *verifyCodeLblPrompt; //验证码提示
@property (nonatomic, strong) UIButton *getVerifyCodeBtn;//获取验证码
@property (nonatomic, strong) UITextField *nameText;//姓名
@property (nonatomic, strong) UITextField *userPwd;//用户密码
@property (nonatomic, strong) UITextField *reUserPwd;//确定用户密码

@property (nonatomic, strong) NSString *registerMobile;

@property (nonatomic, assign) NSInteger reObtainTimeNum;
@property (nonatomic, strong) NSTimer *verifyTimer;

@property (nonatomic, strong) OverallObject *overall;
@property (nonatomic, strong) XPAFNetworkingTool *networkingTool;

@end

@implementation RegisterMsgViewController

- (id)initWithRegisterMSG:(NSString *)mobile
{
    self = [super init];
    if (self) {
        self.registerMobile = mobile;
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

- (void)viewWillAppear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

#pragma mark 初始化工具类
- (void)initToolClass
{
    self.overall = [OverallObject sharedLoginInfo];
    self.networkingTool = [[XPAFNetworkingTool alloc]init];
    [self.networkingTool setDelegate:self];
    self.reObtainTimeNum = 60;
    self.verifyTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(reObtainVerifyCodeTimeMethod) userInfo:nil repeats:YES];
}

#pragma mark 重新获取验证码
- (void)reGetVerifyCodeBtnMethod
{
    //发送验证码，开始请求
    [SVProgressHUD showSuccessWithStatus:SENDVERIFYPROMPT];
    [self.networkingTool postVisitServiceWithURL:VERIFYCODEURL argsDict:@{@"mobile":self.registerMobile,@"templateId":TEXTMESSAGETEMPLATEID} timeoutInterval:10 tag:1];
    [self openVerifyTimer];
}

#pragma mark 注册用户
- (void)registerUserBtnMethod
{
    if (self.verifyCodeText.text.length > 0&&self.nameText.text.length>0&&self.userPwd.text.length>0&&self.reUserPwd.text.length>0) {
        
        if (self.userPwd.text.length > 6) {
            if ([self.userPwd.text isEqualToString:self.reUserPwd.text]) {
                [SVProgressHUD showWithStatus:@"正在注册，请稍候"];
                [self.networkingTool postVisitServiceWithURL:REGISTERURL argsDict:@{@"mobile":self.registerMobile,@"validateCode":self.verifyCodeText.text,@"username":self.nameText.text,@"password":self.userPwd.text} timeoutInterval:10 tag:1];
            }else{
                [SVProgressHUD showErrorWithStatus:PWDERROR];
            }
        }else{
            [SVProgressHUD showErrorWithStatus:PWDSHORT];
        }
    }else{
        [SVProgressHUD showErrorWithStatus:MESSAGENOCOMPLETEPROMPT];
    }
}

#pragma mark 网络代理
- (void)postVisitServiceSuccessServiceData:(id)serviceData tag:(NSInteger)tag
{
    [SVProgressHUD showSuccessWithStatus:@"注册成功"];
    //同步本地数据库
    
    //进入主页面
    self.overall.pubAttr.currentUserAccount = self.registerMobile;
    [self presentViewController:[self.overall.pubAttr.pulicViewModel setTabBar] animated:YES completion:nil];
}

- (void)postVisitServiceFailTag:(NSInteger)tag
{
    [SVProgressHUD showErrorWithStatus:@"注册失败"];
}


#pragma mark 用户图标选择
- (void)userIconBtnMethod
{
    UserIconViewController *userIconVC = [[UserIconViewController alloc]init];
    [self presentViewController:userIconVC animated:YES completion:nil];
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
    CGFloat dwidths = 0.3;
    CGFloat X = 15;
    UIColor *colors = [UIColor colorWithRed:0.7 green:0.7 blue:0.75 alpha:1];
    
    [self.view addSubview:[self.overall.pubAttr.pulicViewModel setTabBarView:@"个人信息"]];
    
    UIButton *goBackBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 15, 60, 60)];
    [goBackBtn setImage:[UIImage imageNamed:goBackIcon] forState:UIControlStateNormal];
    [goBackBtn addTarget:self action:@selector(goBackBtnMethod) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:goBackBtn];
    
    CGFloat dwidth = [UIScreen mainScreen].bounds.size.width;
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, dwidth, 70)];
    [imageView setImage:[UIImage imageNamed:@"backgroud"]];
    [self.view addSubview:imageView];
    
    self.myScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 70, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    [self.myScrollView setContentSize:CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height+20)];
    [self.view addSubview:self.myScrollView];
    
    self.iphoneLbl = [[UILabel alloc]initWithFrame:CGRectMake(X, 14, [UIScreen mainScreen].bounds.size.width - 20, 20)];
    [self.iphoneLbl setFont:fonts];
    [self.iphoneLbl setText:[NSString stringWithFormat:@"发送验证码到您的手机：%@",self.registerMobile]];
    [self.iphoneLbl setNumberOfLines:0];
    [self.iphoneLbl setTextColor:[UIColor colorWithRed:0.5 green:0.5 blue:0.52 alpha:1]];
    [self.myScrollView addSubview:self.iphoneLbl];
    
    UITapGestureRecognizer *tag = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(getTouchEvent)];
    [self.myScrollView addGestureRecognizer:tag];
    
    UIView *verifyCodeView = [[UIView alloc]initWithFrame:CGRectMake(0, self.iphoneLbl.frame.origin.y+self.iphoneLbl.frame.size.height+10, [UIScreen mainScreen].bounds.size.width, height)];
    [verifyCodeView setBackgroundColor:[UIColor whiteColor]];
    [verifyCodeView.layer setBorderWidth:dwidths];
    [verifyCodeView.layer setBorderColor:colors.CGColor];
    [self.myScrollView addSubview:verifyCodeView];
    
    self.verifyCodeText = [self.overall.pubAttr.pulicViewModel setTextFieldViewWithFrame:CGRectMake(X, 0, [UIScreen mainScreen].bounds.size.width - dx-20, height) textValue:@"" placeholderValue:@"验证码" pwd:NO];
    [self.verifyCodeText setKeyboardType:UIKeyboardTypeNumberPad];
    [verifyCodeView addSubview:self.verifyCodeText];
    
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(rects.size.width-dx, 0, 0.3, self.verifyCodeText.frame.size.height)];
    [line setBackgroundColor:[UIColor colorWithRed:0.75 green:0.75 blue:0.75 alpha:1]];
    [verifyCodeView addSubview:line];
    
    
    self.verifyCodeLblPrompt = [[UILabel alloc]initWithFrame:CGRectMake(rects.size.width-dx, 0, dx, height)];
    [self.verifyCodeLblPrompt setFont:fonts];
    [self.verifyCodeLblPrompt setText:@"重新发送(60)"];
    [self.verifyCodeLblPrompt setTextColor:[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.9]];
    [self.verifyCodeLblPrompt setTextAlignment:NSTextAlignmentCenter];
    [verifyCodeView addSubview:self.verifyCodeLblPrompt];
    
    self.getVerifyCodeBtn = [[UIButton alloc]initWithFrame:self.verifyCodeLblPrompt.frame];
    [self.getVerifyCodeBtn addTarget:self action:@selector(reGetVerifyCodeBtnMethod) forControlEvents:UIControlEventTouchUpInside];
    [verifyCodeView addSubview:self.getVerifyCodeBtn];
    
    UILabel *msgLbl = [[UILabel alloc]initWithFrame:CGRectMake(X, verifyCodeView.frame.origin.y+height+10, [UIScreen mainScreen].bounds.size.width - 20, 20)];
    [msgLbl setFont:fonts];
    [msgLbl setText:@"个人基本信息"];
    [msgLbl setTextColor:[UIColor colorWithRed:0.5 green:0.5 blue:0.52 alpha:1]];
    [self.myScrollView addSubview:msgLbl];
    
    UIView *msgView = [[UIView alloc]initWithFrame:CGRectMake(-1, msgLbl.frame.origin.y + 30, [UIScreen mainScreen].bounds.size.width+2, height*3)];
    [msgView setBackgroundColor:[UIColor whiteColor]];
    [msgView.layer setBorderWidth:dwidths];
    [msgView.layer setBorderColor:colors.CGColor];
    [self.myScrollView addSubview:msgView];
    
    for (int i = 1; i < 3; i++) {
        UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, i * height, [UIScreen mainScreen].bounds.size.width, 0.4)];
        [line setBackgroundColor:[UIColor colorWithRed:0.75 green:0.75 blue:0.75 alpha:1]];
        [msgView addSubview:line];
    }
    
    self.nameText = [self.overall.pubAttr.pulicViewModel setTextFieldViewWithFrame:CGRectMake(X, 0, [UIScreen mainScreen].bounds.size.width-X*2, height) textValue:@"" placeholderValue:@"昵称" pwd:NO];
    [msgView addSubview:self.nameText];
    
    self.userPwd = [self.overall.pubAttr.pulicViewModel setTextFieldViewWithFrame:CGRectMake(X,height, [UIScreen mainScreen].bounds.size.width-X*2, height) textValue:@"" placeholderValue:@"密码" pwd:YES];
    [msgView addSubview:self.userPwd];
    
    self.reUserPwd = [self.overall.pubAttr.pulicViewModel setTextFieldViewWithFrame:CGRectMake(X, height*2, [UIScreen mainScreen].bounds.size.width-X*2, height) textValue:@"" placeholderValue:@"确认密码" pwd:YES];
    [msgView addSubview:self.reUserPwd];
    
    
    UIButton *nextStepBtn = [[UIButton alloc]initWithFrame:CGRectMake(15, msgView.frame.origin.y+msgView.frame.size.height+40, [UIScreen mainScreen].bounds.size.width-30, 45)];
    [nextStepBtn setBackgroundColor:[UIColor colorWithRed:0.3 green:0.32 blue:0.9 alpha:1]];
    [nextStepBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [nextStepBtn setTitle:@"注册" forState:UIControlStateNormal];
    [nextStepBtn addTarget:self action:@selector(registerUserBtnMethod) forControlEvents:UIControlEventTouchUpInside];
    [nextStepBtn.layer setCornerRadius:5];
    [nextStepBtn.layer setMasksToBounds:YES];
    [self.myScrollView addSubview:nextStepBtn];
    
//    //个人图片
//    UILabel *otherMsgLbl = [[UILabel alloc]initWithFrame:CGRectMake(10,  msgView.frame.origin.y + height *3+10, [UIScreen mainScreen].bounds.size.width - 20, 20)];
//    [otherMsgLbl setFont:fonts];
//    [otherMsgLbl setText:@"个人图标"];
//    [otherMsgLbl setTextColor:[UIColor colorWithRed:0.5 green:0.5 blue:0.52 alpha:1]];
//    [self.myScrollView addSubview:otherMsgLbl];
//    
//    UIView *otherMsgView = [[UIView alloc]initWithFrame:CGRectMake(-1, otherMsgLbl.frame.origin.y + 30, [UIScreen mainScreen].bounds.size.width+2, height)];
//    [otherMsgView setBackgroundColor:[UIColor whiteColor]];
//    [otherMsgView.layer setBorderWidth:dwidths];
//    [otherMsgView.layer setBorderColor:colors.CGColor];
//    [self.myScrollView addSubview:otherMsgView];
//    
//    UILabel *picLblTitle = [[UILabel alloc]initWithFrame:CGRectMake(10, otherMsgLbl.frame.origin.y + 30, [UIScreen mainScreen].bounds.size.width, height)];
//    [picLblTitle setFont:fonts];
//    [picLblTitle setText:@"用户图标"];
//    [picLblTitle setTextColor:[UIColor colorWithRed:0.65 green:0.65 blue:0.65 alpha:1]];
//    [self.myScrollView addSubview:picLblTitle];
//    
//    UIButton *picBtn = [[UIButton alloc]initWithFrame:CGRectMake(-1, otherMsgLbl.frame.origin.y + 30, [UIScreen mainScreen].bounds.size.width+2, height)];
//    [picBtn addTarget:self action:@selector(userIconBtnMethod) forControlEvents:UIControlEventTouchUpInside];
//    [self.myScrollView addSubview:picBtn];
    
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
