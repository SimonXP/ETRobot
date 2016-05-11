//
//  LocationHelper.h
//  ETRobot
//
//  Created by IHOME on 16/5/6.
//  Copyright © 2016年 IHOME. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocationHelper : NSObject

+ (LocationHelper *) sharedInstance;

#pragma mark 定位当前位置
- (void)locationCurrentPlace;

@end
