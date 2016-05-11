//
//  UserOperateViewController.m
//  ETRobot
//
//  Created by IHOME on 16/5/6.
//  Copyright © 2016年 IHOME. All rights reserved.
//

#import "UserOperateViewController.h"

@interface UserOperateViewController ()

@property (nonatomic, assign) NSInteger operateTag;

@property (nonatomic, strong) UITextField *userName;
@property (nonatomic, strong) UITextField *snewPwd;
@property (nonatomic, strong) UITextField *rNewPwd;

@property (nonatomic, strong) OverallObject *overall;

@end

@implementation UserOperateViewController

- (id)initWithUserOperateVCWithOperateTag:(NSInteger)operateTag
{
    self = [super init];
    if (self) {
        self.operateTag = operateTag;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setToolClass];
    [self setUserOperateUI];
}

- (void)setToolClass
{
    self.overall = [OverallObject sharedLoginInfo];
}

- (void)setUserOperateUI
{
    [self.view setBackgroundColor:[UIColor colorWithRed:239/255.0 green:239/255.0 blue:246/255.0 alpha:1]];
    CGRect rects = [UIScreen mainScreen].bounds;
    
    UIView *userOperateView = [[UIView alloc]init];
    [userOperateView setBackgroundColor:[UIColor whiteColor]];
    [userOperateView.layer setBorderWidth:0.3];
    [userOperateView.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    
    UIButton *sureBut = [[UIButton alloc]init];
    CGFloat width = 20;
    if (self.operateTag == 0) {
        [userOperateView setFrame:CGRectMake(-2, 80, rects.size.width+4, 45)];
        [self.view addSubview:[self.overall.pubAttr.pulicViewModel setTabBarView:@"个人名称"]];
        self.userName = [self.overall.pubAttr.pulicViewModel setTextFieldViewWithFrame:CGRectMake(width, 0, rects.size.width-width*2, 45) textValue:@"向平" placeholderValue:@"个人名称" pwd:NO];
        [userOperateView addSubview:self.userName];
        [self.userName becomeFirstResponder];
        [sureBut setFrame:CGRectMake(15, 150, rects.size.width-30, 45)];
        [sureBut setTag:1];
        
    }else{
        [userOperateView setFrame:CGRectMake(-2, 80, rects.size.width+4, 90)];
        [sureBut setFrame:CGRectMake(15, 200, rects.size.width-30, 45)];
        [sureBut setTag:2];
        
        UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(width, 45, rects.size.width-width*2, 0.3)];
        [line setBackgroundColor:[UIColor lightGrayColor]];
        [userOperateView addSubview:line];
        
        [self.view addSubview:[self.overall.pubAttr.pulicViewModel setTabBarView:@"修改密码"]];
        self.snewPwd = [self.overall.pubAttr.pulicViewModel setTextFieldViewWithFrame:CGRectMake(width, 0, rects.size.width-width*2, 45) textValue:@"" placeholderValue:@"输入新密码" pwd:YES];
        [userOperateView addSubview:self.snewPwd];
        self.rNewPwd = [self.overall.pubAttr.pulicViewModel setTextFieldViewWithFrame:CGRectMake(width, 45, rects.size.width-width*2, 45) textValue:@"" placeholderValue:@"确定新密码" pwd:YES];
        [userOperateView addSubview:self.rNewPwd];
        [self.snewPwd becomeFirstResponder];
    }
    [self.view addSubview:userOperateView];
    
    UIButton *goBackBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 15, 60, 60)];
    [goBackBtn setImage:[UIImage imageNamed:goBackIcon] forState:UIControlStateNormal];
    [goBackBtn addTarget:self action:@selector(goBackBtnMethod) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:goBackBtn];
    
    [sureBut setBackgroundColor:[UIColor colorWithRed:0.3 green:0.32 blue:0.9 alpha:1]];
    [sureBut setTitle:@"确定" forState:UIControlStateNormal];
    [sureBut.titleLabel setTextColor:[UIColor whiteColor]];
    [sureBut.titleLabel setFont:[UIFont systemFontOfSize:18]];
    [sureBut addTarget:self action:@selector(sureButOperateMethod) forControlEvents:UIControlEventTouchUpInside];
    [sureBut.layer setCornerRadius:5];
    [sureBut.layer setMasksToBounds:YES];
    [self.view addSubview:sureBut];
    
}

#pragma mark 确定
- (void)sureButOperateMethod
{
    
}

- (void)goBackBtnMethod
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

@end
