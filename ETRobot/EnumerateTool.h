//
//  EnumerateTool.h
//  ETRobot
//
//  Created by IHOME on 16/4/29.
//  Copyright © 2016年 IHOME. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, VoipRole) {
    VoipRoleCallers = 0,
    VoipRoleCalleds = 1<<0
};

@interface EnumerateTool : NSObject

@end
