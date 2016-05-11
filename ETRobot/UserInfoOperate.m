//
//  UserInfoOperate.m
//  ETRobot
//
//  Created by IHOME on 16/5/9.
//  Copyright © 2016年 IHOME. All rights reserved.
//

#import "UserInfoOperate.h"

@implementation UserInfoOperate

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.overall = [OverallObject sharedLoginInfo];
    }
    return self;
}

- (BOOL)addUserInfoWithUserInfoTool:(UserInfoTool *)userInfoTool
{
    UserInfo *user = [NSEntityDescription insertNewObjectForEntityForName:@"UserInfo" inManagedObjectContext:self.overall.pubAttr.context];
    user.uid = userInfoTool.uid;
    user.userName = userInfoTool.userName;
    user.userPassword = userInfoTool.userPassword;
    user.mobile = userInfoTool.mobile;
    user.email = userInfoTool.email;
    user.avatar = userInfoTool.avatar;
    user.gender = userInfoTool.gender;
    user.lastloginTime = userInfoTool.lastloginTime;
    user.ip = userInfoTool.ip;
    user.createTime = userInfoTool.createTime;
    user.updateTime = userInfoTool.updateTime;
    user.clientAccount = userInfoTool.clientAccount;
    user.clientPwd = userInfoTool.clientPwd;
    user.voipAccount = userInfoTool.voipAccount;
    user.voipToken = userInfoTool.voipToken;
    
    if ([self.overall.pubAttr.context save:nil]) {
        NSLog(@"*********注册成功");
        return YES;
    }
    return NO;
}

- (BOOL)updUserPasswordAccorddingToAccount:(NSString *)account password:(NSString *)password uNewPassword:(NSString *)uNewPassword
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"UserInfo"];
    request.predicate = [NSPredicate predicateWithFormat:@"account == %@ && password=%@",account,password];
    NSArray *array = [self.overall.pubAttr.context executeFetchRequest:request error:nil];
    for (UserInfo *user in array) {
        user.userPassword = uNewPassword;
        break;
    }
    if ([self.overall.pubAttr.context save:nil]) {
        NSLog(@"修改用户密码成功");
        return YES;
    }else{
        return NO;
    }
}

- (BOOL)updUserInfoWithUserInfoTool:(UserInfoTool *)userInfoTool
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"UserInfo"];
    request.predicate = [NSPredicate predicateWithFormat:@"account == %@",userInfoTool.mobile];
    NSArray *array = [self.overall.pubAttr.context executeFetchRequest:request error:nil];
    for (UserInfo *user in array) {
        user.uid = userInfoTool.uid;
        user.userName = userInfoTool.userName;
        user.userPassword = userInfoTool.userPassword;
        user.mobile = userInfoTool.mobile;
        user.email = userInfoTool.email;
        user.avatar = userInfoTool.avatar;
        user.gender = userInfoTool.gender;
        user.lastloginTime = userInfoTool.lastloginTime;
        user.ip = userInfoTool.ip;
        user.createTime = userInfoTool.createTime;
        user.updateTime = userInfoTool.updateTime;
        user.clientAccount = userInfoTool.clientAccount;
        user.clientPwd = userInfoTool.clientPwd;
        user.voipAccount = userInfoTool.voipAccount;
        user.voipToken = userInfoTool.voipToken;
        break;
    }
    if ([self.overall.pubAttr.context save:nil]) {
        return YES;
    }else{
        return NO;
    }
}

- (UserInfo *)selectUserInfoWithAccount:(NSString *)account
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"UserInfo"];
    request.predicate = [NSPredicate predicateWithFormat:@"account == %@",account];
    NSArray *array = [self.overall.pubAttr.context executeFetchRequest:request error:nil];
    if (array.count > 0) {
        return array[0];
    }
    return nil;
}

- (NSArray *)selectUserInfo
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"UserInfo"];
    NSArray *array = [self.overall.pubAttr.context executeFetchRequest:request error:nil];
    return array;
}

@end
