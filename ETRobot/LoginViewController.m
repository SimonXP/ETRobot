
//
//  LoginViewController.m
//  RecreationRobot
//
//  Created by IHOME on 16/4/21.
//  Copyright (c) 2016年 IHOME. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()<XPAFNetworkingToolDelegate>

@property (nonatomic, strong) UIView *loginView;
@property (nonatomic, strong) UIImageView *userIcon;
@property (nonatomic, strong) UITextField *userAccount;
@property (nonatomic, strong) UITextField *userPwd;
@property (nonatomic, strong) UIButton *loginBtn;
@property (nonatomic, strong) UIButton *registerBtn;
@property (nonatomic, strong) UIButton *forgetPwdBtn;

@property (nonatomic, strong) OverallObject *overall;
@property (nonatomic, strong) XPAFNetworkingTool *networkingTool;
@property (nonatomic, strong) LoginUserInfoOperate *loginUserInfoOperate;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化工具类
    [self setToolClass];
    //设置调整UI
    [self setAdjustUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)setToolClass
{
    self.overall = [OverallObject sharedLoginInfo];
    self.networkingTool = [[XPAFNetworkingTool alloc]init];
    [self.networkingTool setDelegate:self];
    self.loginUserInfoOperate = [[LoginUserInfoOperate alloc]init];
}

#pragma mark 注册或忘记密码
- (void)accountOperateMethod:(UIButton *)button
{
    UIViewController *viewController = nil;
    if (button.tag == 1) {
//        if (self.userAccount.text.length > 0 && self.userPwd.text.length > 0) {
//            //提示请稍候
//            [SVProgressHUD showWithStatus:NETPROMPT];
//            //网络请求
//            [self.networkingTool postVisitServiceWithURL:LOGINURL argsDict:@{@"mobile":self.userAccount.text,@"password":self.userPwd.text} timeoutInterval:10 tag:1];
//        }else{
//            [SVProgressHUD showErrorWithStatus:MESSAGENOCOMPLETEPROMPT];
//        }
        [self presentViewController:[self.overall.pubAttr.pulicViewModel setTabBar] animated:YES completion:nil];
        return;
    }else if (button.tag == 2){
        viewController = [[VerifyCodeViewController alloc]initVerifyCodeVCWithTag:11012];
    }else{
        viewController = [[VerifyCodeViewController alloc]initVerifyCodeVCWithTag:11011];
    }
    [self presentViewController:viewController animated:YES completion:nil];
}

#pragma mark 网络请求代理
- (void)postVisitServiceSuccessServiceData:(id)serviceData tag:(NSInteger)tag
{
    //提示请稍候
    [SVProgressHUD showSuccessWithStatus:@"登录成功"];
    self.overall.pubAttr.currentUserAccount = self.userAccount.text;
    [self.loginUserInfoOperate addLoginUserInfoWithUserAccount:self.userAccount.text userPassword:self.userPwd.text];
    [self presentViewController:[self.overall.pubAttr.pulicViewModel setTabBar] animated:YES completion:nil];
    
    
}
- (void)postVisitServiceFailTag:(NSInteger)tag
{
    //提示请稍候
    [SVProgressHUD showErrorWithStatus:@"账号或密码有误"];
}

- (void)setAdjustUI
{
    CGRect rects = [UIScreen mainScreen].bounds;
    [self.view setBackgroundColor:[UIColor colorWithRed:0.94 green:0.94 blue:0.96 alpha:1]];
    
    UIImageView *tImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, rects.size.width, rects.size.height)];
    [tImageView setImageToBlur:[UIImage imageNamed:@"bg_nemocircle_setting"/*@"voice.jpg"*/] blurRadius:4 completionBlock:nil];
    [self.view addSubview:tImageView];
    
    CGFloat width = 80;
    self.userIcon = [[UIImageView alloc]initWithFrame:CGRectMake((rects.size.width-width)/2, rects.size.height/11, width, width)];
    [self.userIcon.layer setCornerRadius:width/2];
    [self.userIcon.layer setMasksToBounds:YES];
    [self.userIcon setImage:[UIImage imageNamed:@"mem.jpg"]];
    [self.view addSubview:self.userIcon];
    
    UIView *views = [[UIView alloc]initWithFrame:CGRectMake(0, self.userIcon.frame.origin.y+width+10, rects.size.width, 88)];
    [views setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:views];
    
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, views.frame.size.height/2, views.frame.size.width, 0.26)];
    [line setBackgroundColor:[UIColor colorWithRed:0.66 green:0.66 blue:0.7 alpha:1]];
    [views addSubview:line];
    
    self.userAccount = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, rects.size.width, views.frame.size.height/2)];
    [self.userAccount setPlaceholder:@"请输入手机号"];
    [self.userAccount setTextAlignment:NSTextAlignmentCenter];
    [self.userAccount setFont:[UIFont systemFontOfSize:16]];
    [self.userAccount setKeyboardType:UIKeyboardTypeNumberPad];
    [self.userAccount setClearButtonMode:UITextFieldViewModeWhileEditing];
    [views addSubview:self.userAccount];
    
    self.userPwd = [[UITextField alloc]initWithFrame:CGRectMake(0, views.frame.size.height/2, rects.size.width, views.frame.size.height/2)];
    [self.userPwd setPlaceholder:@"请输入密码"];
    [self.userPwd setTextAlignment:NSTextAlignmentCenter];
    [self.userPwd setFont:[UIFont systemFontOfSize:16]];
    [self.userPwd setClearButtonMode:UITextFieldViewModeWhileEditing];
    [self.userPwd setSecureTextEntry:YES];
    [views addSubview:self.userPwd];
    
    self.loginBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, views.frame.origin.y+views.frame.size.height+20, rects.size.width-20, 45)];
    [self.loginBtn setBackgroundColor:[UIColor colorWithRed:0.3 green:0.32 blue:0.9 alpha:1]];
    [self.loginBtn setTag:1];
    [self.loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [self.loginBtn.titleLabel setTextColor:[UIColor whiteColor]];
    [self.loginBtn.titleLabel setFont:[UIFont systemFontOfSize:18]];
    [self.loginBtn addTarget:self action:@selector(accountOperateMethod:) forControlEvents:UIControlEventTouchUpInside];
    [self.loginBtn.layer setCornerRadius:5];
    [self.loginBtn.layer setMasksToBounds:YES];
    [self.view addSubview:self.loginBtn];
    
    self.forgetPwdBtn = [[UIButton alloc]initWithFrame:CGRectMake((rects.size.width-80)/2, self.loginBtn.frame.origin.y+60, 80, 40)];
    [self.forgetPwdBtn setBackgroundColor:[UIColor clearColor]];
    [self.forgetPwdBtn setTag:2];
    [self.forgetPwdBtn setTitle:@"忘记密码？" forState:UIControlStateNormal];
    [self.forgetPwdBtn addTarget:self action:@selector(accountOperateMethod:) forControlEvents:UIControlEventTouchUpInside];
    [self.forgetPwdBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [self.view addSubview:self.forgetPwdBtn];
    
    self.registerBtn = [[UIButton alloc]initWithFrame:CGRectMake(15, rects.size.height-60, rects.size.width-30, 40)];
    [self.registerBtn setBackgroundColor:[UIColor clearColor]];
    [self.registerBtn setTitle:@"没有账号？请注册" forState:UIControlStateNormal];
    [self.registerBtn.layer setCornerRadius:1];
    [self.registerBtn.layer setMasksToBounds:YES];
    [self.registerBtn.layer setBorderWidth:0];
    [self.registerBtn.layer setBorderColor:[UIColor whiteColor].CGColor];
    [self.registerBtn setTag:3];
    [self.registerBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [self.registerBtn addTarget:self action:@selector(accountOperateMethod:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.registerBtn];
}

#pragma mark 获取touch事件
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

@end
