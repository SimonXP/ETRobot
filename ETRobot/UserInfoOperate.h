//
//  UserInfoOperate.h
//  ETRobot
//
//  Created by IHOME on 16/5/9.
//  Copyright © 2016年 IHOME. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInfo.h"
#import "UserInfoTool.h"

@interface UserInfoOperate : NSObject

@property (nonatomic, strong) OverallObject *overall;
//添加用户
- (BOOL)addUserInfoWithUserInfoTool:(UserInfoTool *)userInfoTool;
//修改用户密码
- (BOOL)updUserPasswordAccorddingToAccount:(NSString *)account password:(NSString *)password uNewPassword:(NSString *)uNewPassword;
//修改用户信息
- (BOOL)updUserInfoWithUserInfoTool:(UserInfoTool *)userInfoTool;
//查询指定用户
- (UserInfo *)selectUserInfoWithAccount:(NSString *)account;
//查询所有用户
- (NSArray *)selectUserInfo;

@end
