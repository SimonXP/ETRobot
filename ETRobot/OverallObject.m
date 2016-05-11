//
//  OverallObject.m
//  IHomeInteligent
//
//  Created by 向平 on 14-12-10.
//  Copyright (c) 2014年 ihome-sys. All rights reserved.
//

#import "OverallObject.h"

@implementation OverallObject
@synthesize isLogin,pubAttr,cookies,pubMethod;


static OverallObject *loginInfo = nil;
+(OverallObject *) sharedLoginInfo{
    @synchronized(self){
        if (loginInfo == nil) {
            loginInfo = [[self alloc] init];
        }
    }
    return  loginInfo;
}

+(id) allocWithZone:(NSZone *)zone{
    @synchronized(self){
        if (loginInfo == nil) {
            loginInfo = [super allocWithZone:zone];
            return  loginInfo;
        }
    }
    return nil;
}

-(id)init
{
    if (self = [super init]) {
        //全局属性，公共属性
        pubAttr = [[OverallAttribute alloc]init];
        pubMethod = [[PublicMethodModel alloc]init];
        cookies = [[NSMutableArray alloc] initWithCapacity:1];
        isLogin = NO;
    }
    return self;
}

- (id)copyWithZone:(NSZone*)zone
{
    return self;
}

- (void)loginOut
{
    isLogin = NO;
    loginInfo = nil;
}

@end
