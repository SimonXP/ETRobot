//
//  ViewController.m
//  ETRobot
//
//  Created by IHOME on 16/4/27.
//  Copyright © 2016年 IHOME. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, strong) LoginUserInfoOperate *loginUserInfoOperate;
@property (nonatomic, strong) OverallObject *overall;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initClassTool];
    [self performSelector:@selector(verifyUserMsg) withObject:nil afterDelay:0.1];
}

- (void)initClassTool
{
    self.overall = [OverallObject sharedLoginInfo];
    self.loginUserInfoOperate = [[LoginUserInfoOperate alloc]init];
    [[LocationHelper sharedInstance]locationCurrentPlace];
}

#pragma armk 验证用户信息
- (void)verifyUserMsg
{
    NSArray *array = [self.loginUserInfoOperate selectLoginUserInfo];
    if (array.count > 0) {
        self.overall.pubAttr.currentUserAccount = ((LoginUserInfo *)array[0]).loginUserAccount;
        [self presentViewController:[self.overall.pubAttr.pulicViewModel setTabBar] animated:YES completion:nil];
    }else{
        //验证用户信息
        LoginViewController *mainVC = [[LoginViewController alloc]init];
        [self presentViewController:mainVC animated:YES completion:nil];
    }
}


@end
