//
//  UserInfoTool.h
//  ETRobot
//
//  Created by IHOME on 16/5/9.
//  Copyright © 2016年 IHOME. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfoTool : NSObject

@property (nonatomic, strong) NSString *uid;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *userPassword;
@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *avatar;
@property (nonatomic, strong) NSString *gender;
@property (nonatomic, strong) NSString *lastloginTime;
@property (nonatomic, strong) NSString *ip;
@property (nonatomic, strong) NSString *createTime;
@property (nonatomic, strong) NSString *updateTime;
@property (nonatomic, strong) NSString *clientAccount;
@property (nonatomic, strong) NSString *clientPwd;
@property (nonatomic, strong) NSString *voipAccount;
@property (nonatomic, strong) NSString *voipToken;

@end
