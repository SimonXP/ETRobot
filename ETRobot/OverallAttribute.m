//
//  OverallAttribute.m
//  IHomeInteligent
//
//  Created by 向平 on 14-12-10.
//  Copyright (c) 2014年 ihome-sys. All rights reserved.
//

#import "OverallAttribute.h"

@implementation OverallAttribute

#pragma mark init
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.manager = [AFHTTPRequestOperationManager manager];
        self.pulicViewModel = [[PublicViewModel alloc]init];
        self.tcpHelper = [[TCPHelper alloc]init];
        self.tcpConnected = NO;
        self.openData = [[OpenDBOperate alloc]init];
        self.context = [self.openData openDB];
        self.currentUserAccount = @"";
    }
    return self;
}

@end
