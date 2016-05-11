//
//  AppDelegate.m
//  ETRobot
//
//  Created by IHOME on 16/4/27.
//  Copyright © 2016年 IHOME. All rights reserved.
//

#import "AppDelegate.h"

#define goBackIcon @"bback"

@interface AppDelegate ()

@property (nonatomic, strong) VoipHelper *voipHelper;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSLog(@"app打开");
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];
    self.voipHelper = [VoipHelper sharedObject];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    NSLog(@"即将进入后台");
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    NSLog(@"已经进入后台");
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    NSLog(@"即将进入前台");
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    NSLog(@"已经进入前台");
}

- (void)applicationWillTerminate:(UIApplication *)application {
    NSLog(@"内存泄漏");
}

@end
