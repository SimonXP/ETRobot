//
//  OverallAttribute.h
//  IHomeInteligent
//
//  Created by 向平 on 14-12-10.
//  Copyright (c) 2014年 ihome-sys. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "PublicViewModel.h"
#import "TCPHelper.h"
#import "OpenDBOperate.h"
#import "UserInfo.h"

@interface OverallAttribute : NSObject

#pragma mark 定位
@property (nonatomic, strong) NSString *latitudeValue;                  //经度
@property (nonatomic, strong) NSString *longtitudeValue;                //纬度
@property (nonatomic, strong) NSString *locationAddress;                //地址

#pragma mark 云之讯_当前通话ID
@property (nonatomic, strong) NSString *currentCallId;

#pragma mark 网络工具类
@property (nonatomic, strong) AFHTTPRequestOperationManager *manager;   //网络访问工具

#pragma mark 公共界面模型类
@property (nonatomic, strong) PublicViewModel *pulicViewModel;

@property (nonatomic, strong) TCPHelper *tcpHelper;
@property (nonatomic, assign) BOOL tcpConnected;

#pragma mark 数据库
@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic, strong) OpenDBOperate *openData;

#pragma mark 当前登录的用户账号
@property (nonatomic, strong) NSString *currentUserAccount;
@property (nonatomic, strong) UserInfo *currentUser;

@end



