//
//  OverallObject.h
//  IHomeInteligent
//
//  Created by 向平 on 14-12-10.
//  Copyright (c) 2014年 ihome-sys. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OverallAttribute.h"
#import "PublicMethodModel.h"

@interface OverallObject : NSObject
{
    //全局属性，公共属性
    OverallAttribute *pubAttr;
    PublicMethodModel *pubMethod;
    BOOL isLogin;
    NSMutableArray *cookies;
}
//全局属性，公共属性
@property (nonatomic ,retain) OverallAttribute *pubAttr;
@property (nonatomic, retain) PublicMethodModel *pubMethod;
@property (nonatomic ,retain) NSMutableArray *cookies;
@property (nonatomic ,assign) BOOL isLogin;
+(OverallObject *) sharedLoginInfo;
+(id) allocWithZone:(NSZone *)zone;
- (void)loginOut;

@end
