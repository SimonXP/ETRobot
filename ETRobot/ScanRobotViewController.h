//
//  ScanRobotViewController.h
//  ETRobot
//
//  Created by IHOME on 16/5/8.
//  Copyright © 2016年 IHOME. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScanRobotViewController : UIViewController

@property (nonatomic, copy) void (^ScanRobotCancleBlock) (ScanRobotViewController *);//扫描取消
@property (nonatomic, copy) void (^ScanRobotSuncessBlock) (ScanRobotViewController *,NSString *);//扫描结果
@property (nonatomic, copy) void (^ScanRobotFailBlock) (ScanRobotViewController *);//扫描失败
@end
