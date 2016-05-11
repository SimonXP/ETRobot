//
//  VerifyCodeViewController.m
//  RecreationRobot
//
//  Created by IHOME on 16/4/21.
//  Copyright (c) 2016年 IHOME. All rights reserved.
//

#import "VerifyCodeViewController.h"

@interface VerifyCodeViewController ()

@property (nonatomic, strong) UITextField *account;

@property (nonatomic, assign) NSInteger operateTag;
@property (nonatomic, strong) OverallObject *overall;
@property (nonatomic, strong) XPAFNetworkingTool *netWorkingTool;


@end

@implementation VerifyCodeViewController

//tag 11011 注册   11012 忘记密码
- (id)initVerifyCodeVCWithTag:(NSInteger)tag
{
    self = [super init];
    if (self) {
        self.operateTag = tag;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化工具类
    [self setToolClass];
    //设置调整UI
    [self setAdjustUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [self.account becomeFirstResponder];
}

- (void)setToolClass
{
    self.overall = [OverallObject sharedLoginInfo];
    self.netWorkingTool = [[XPAFNetworkingTool alloc]init];
}

- (void)setAdjustUI
{
    [self.view setBackgroundColor:[UIColor colorWithRed:0.93 green:0.93 blue:0.95 alpha:1]];
    CGRect rects = [UIScreen mainScreen].bounds;
    [self.view addSubview:[self.overall.pubAttr.pulicViewModel setTabBarView:@"验证手机号码"]];
    
    UIButton *goBackBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 15, 60, 60)];
    [goBackBtn setImage:[UIImage imageNamed:goBackIcon] forState:UIControlStateNormal];
    [goBackBtn addTarget:self action:@selector(goBackBtnMethod) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:goBackBtn];
    
    UIView *accountView = [[UIView alloc]initWithFrame:CGRectMake(0, 100, rects.size.width, 45)];
    [accountView.layer setBorderWidth:0.3];
    [accountView.layer setBorderColor:[UIColor colorWithRed:0.7 green:0.7 blue:0.75 alpha:1].CGColor];
    [accountView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:accountView];
    
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(100, 0, 0.3, 45)];
    [line setBackgroundColor:[UIColor colorWithRed:0.75 green:0.75 blue:0.75 alpha:1]];
    [accountView addSubview:line];
    
    UILabel *iphoneCode = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, line.frame.size.height)];
    [iphoneCode setText:@"手机号"];
    [iphoneCode setTextAlignment:NSTextAlignmentCenter];
    [iphoneCode setTextColor:[UIColor colorWithRed:0.4 green:0.4 blue:0.43 alpha:1]];
    [iphoneCode setFont:[UIFont systemFontOfSize:16]];
    [accountView addSubview:iphoneCode];
    
    self.account = [self.overall.pubAttr.pulicViewModel setTextFieldViewWithFrame:CGRectMake(120, 0, rects.size.width-130, line.frame.size.height) textValue:@"" placeholderValue:@"请输入手机号码" pwd:NO];
    [self.account setKeyboardType:UIKeyboardTypeNumberPad];
    [accountView addSubview:self.account];
    
    UIButton *verifyBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, accountView.frame.origin.y+accountView.frame.size.height+40, rects.size.width-20, 45)];
    [verifyBtn setBackgroundColor:[UIColor colorWithRed:0.3 green:0.32 blue:0.9 alpha:1]];
    [verifyBtn setTag:1];
    [verifyBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [verifyBtn.titleLabel setTextColor:[UIColor whiteColor]];
    [verifyBtn.titleLabel setFont:[UIFont systemFontOfSize:titleFontSize]];
    [verifyBtn addTarget:self action:@selector(getVerifyCodeMethod) forControlEvents:UIControlEventTouchUpInside];
    [verifyBtn.layer setCornerRadius:5];
    [verifyBtn.layer setMasksToBounds:YES];
    [self.view addSubview:verifyBtn];
}

- (void)getVerifyCodeMethod
{
    if (self.account.text.length > 0) {
        if ([self.overall.pubMethod isMobileNumber:self.account.text]) {
            //发送验证码，开始请求
            [SVProgressHUD showSuccessWithStatus:SENDVERIFYPROMPT];
            [self.netWorkingTool postVisitServiceWithURL:VERIFYCODEURL argsDict:@{@"mobile":self.account.text,@"templateId":TEXTMESSAGETEMPLATEID} timeoutInterval:10 tag:1];
            
            UIViewController *operateVC = nil;
            if (self.operateTag == 11011) {
                operateVC = [[RegisterMsgViewController alloc]initWithRegisterMSG:self.account.text];
            }else{
                operateVC = [[ForgotPwdViewController alloc]initWithForgotPwd:self.account.text];
            }
            [self presentViewController:operateVC animated:YES completion:nil];
        }else{
            [SVProgressHUD showErrorWithStatus:@"格式不正确"];
        }
    }else{
        [SVProgressHUD showErrorWithStatus:MESSAGENOCOMPLETEPROMPT];
    }
}

- (void)goBackBtnMethod
{
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
