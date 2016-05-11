//
//  RobotCodeViewController.m
//  ETRobot
//
//  Created by IHOME on 16/5/8.
//  Copyright © 2016年 IHOME. All rights reserved.
//

#import "RobotCodeViewController.h"

@interface RobotCodeViewController ()

@property (nonatomic, strong) UITextField *robotCodeText;

@property (nonatomic, strong) OverallObject *overall;

@end

@implementation RobotCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setToolClass];
    [self setAdjustUI];
}

- (void)setToolClass
{
    self.overall = [OverallObject sharedLoginInfo];
}

- (void)setAdjustUI
{
    [self.view setBackgroundColor:[UIColor colorWithRed:239/255.0 green:239/255.0 blue:246/255.0 alpha:1]];
    CGRect rects = [UIScreen mainScreen].bounds;
    
    UIView *userOperateView = [[UIView alloc]init];
    [userOperateView setBackgroundColor:[UIColor whiteColor]];
    [userOperateView.layer setBorderWidth:0.3];
    [userOperateView.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [userOperateView setFrame:CGRectMake(-2, 80, rects.size.width+4, 45)];
    [self.view addSubview:userOperateView];
    
    [self.view addSubview:[self.overall.pubAttr.pulicViewModel setTabBarView:@"机器人编号"]];

    self.robotCodeText = [self.overall.pubAttr.pulicViewModel setTextFieldViewWithFrame:CGRectMake(20, 0, rects.size.width-40, 45) textValue:@"" placeholderValue:@"输入机器人编号" pwd:NO];
    [userOperateView addSubview:self.robotCodeText];
    [self.robotCodeText setKeyboardType:UIKeyboardTypeNumberPad];
    [self.robotCodeText becomeFirstResponder];
    
    UIButton *goBackBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 15, 60, 60)];
    [goBackBtn setImage:[UIImage imageNamed:goBackIcon] forState:UIControlStateNormal];
    [goBackBtn addTarget:self action:@selector(goBackBtnMethod) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:goBackBtn];
    
    UIButton *addRobot = [[UIButton alloc]initWithFrame:CGRectMake(15, 150, rects.size.width-30, 45)];
    [addRobot setBackgroundColor:[UIColor colorWithRed:0.3 green:0.32 blue:0.9 alpha:1]];
    [addRobot setTitle:@"添加机器人" forState:UIControlStateNormal];
    [addRobot.titleLabel setTextColor:[UIColor whiteColor]];
    [addRobot.titleLabel setFont:[UIFont systemFontOfSize:18]];
    [addRobot addTarget:self action:@selector(addRobotOperateMethod) forControlEvents:UIControlEventTouchUpInside];
    [addRobot.layer setCornerRadius:5];
    [addRobot.layer setMasksToBounds:YES];
    [self.view addSubview:addRobot];
}

#pragma mark 添加机器人
- (void)addRobotOperateMethod
{
    
}

- (void)goBackBtnMethod
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
