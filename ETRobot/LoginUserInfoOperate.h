//
//  LoginUserInfoOperate.h
//  ETRobot
//
//  Created by IHOME on 16/5/10.
//  Copyright © 2016年 IHOME. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoginUserInfo.h"

@interface LoginUserInfoOperate : NSObject

@property (nonatomic, strong) OverallObject *overall;
//添加用户
- (BOOL)addLoginUserInfoWithUserAccount:(NSString *)userAccount userPassword:(NSString *)userPassword;
//查询是否有用户登录
- (NSArray *)selectLoginUserInfo;

@end
