
//
//  LoginUserInfoOperate.m
//  ETRobot
//
//  Created by IHOME on 16/5/10.
//  Copyright © 2016年 IHOME. All rights reserved.
//

#import "LoginUserInfoOperate.h"

@implementation LoginUserInfoOperate

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.overall = [OverallObject sharedLoginInfo];
    }
    return self;
}

//添加用户
- (BOOL)addLoginUserInfoWithUserAccount:(NSString *)userAccount userPassword:(NSString *)userPassword
{
    LoginUserInfo *user = [NSEntityDescription insertNewObjectForEntityForName:@"LoginUserInfo" inManagedObjectContext:self.overall.pubAttr.context];
    user.loginUserAccount = userAccount;
    user.logiinUserPassword = userPassword;
    
    if ([self.overall.pubAttr.context save:nil]) {
        NSLog(@"*********添加登录用户成功");
        return YES;
    }
    return NO;
}

//查询是否有用户登录
- (NSArray *)selectLoginUserInfo
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"LoginUserInfo"];
    NSArray *array = [self.overall.pubAttr.context executeFetchRequest:request error:nil];
    return array;
}

@end
