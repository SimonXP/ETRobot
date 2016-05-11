//
//  LocalNotificationHelper.h
//  ETRobot
//
//  Created by IHOME on 16/5/6.
//  Copyright © 2016年 IHOME. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocalNotificationHelper : NSObject

+ (LocalNotificationHelper *) sharedInstance;

//如果手机挂起后台，发本地推送
- (void)setupNotificationSetting;
//如果手机挂起后台，发本地推送
- (void)scheduleLocalNotificationWithValue:(NSString *)value;

@end
