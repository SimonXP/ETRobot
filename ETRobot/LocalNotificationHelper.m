
//
//  LocalNotificationHelper.m
//  ETRobot
//
//  Created by IHOME on 16/5/6.
//  Copyright © 2016年 IHOME. All rights reserved.
//

#import "LocalNotificationHelper.h"

@implementation LocalNotificationHelper

static LocalNotificationHelper *localNotificationHelper;

+ (LocalNotificationHelper *) sharedInstance
{
    if (localNotificationHelper == nil)
    {
        localNotificationHelper = [[LocalNotificationHelper alloc] init];
    }
    return localNotificationHelper;
}

- (LocalNotificationHelper *) init
{
    if (self = [super init])
    {
        
    }
    return self;
}

//如果手机挂起后台，发本地推送
- (void)setupNotificationSetting
{
    UIUserNotificationType type = UIUserNotificationTypeBadge | UIUserNotificationTypeAlert | UIUserNotificationTypeSound;
    
    UIMutableUserNotificationAction *justInformAction = [[UIMutableUserNotificationAction alloc] init];
    justInformAction.identifier = @"justInform";
    justInformAction.title = @"YES,I got it.";
    justInformAction.activationMode = UIUserNotificationActivationModeBackground;
    justInformAction.destructive = NO;
    justInformAction.authenticationRequired = NO;
    
    UIMutableUserNotificationAction *modifyListAction = [[UIMutableUserNotificationAction alloc] init];
    modifyListAction.identifier = @"editList";
    modifyListAction.title = @"Edit list";
    modifyListAction.activationMode = UIUserNotificationActivationModeForeground;
    modifyListAction.destructive = NO;
    modifyListAction.authenticationRequired = YES;
    
    UIMutableUserNotificationAction *trashAction = [[UIMutableUserNotificationAction alloc] init];
    trashAction.identifier = @"trashAction";
    trashAction.title = @"Delete list";
    trashAction.activationMode = UIUserNotificationActivationModeBackground;
    trashAction.destructive = YES;
    trashAction.authenticationRequired = YES;
    
    NSArray *actionArray = [NSArray arrayWithObjects:justInformAction,modifyListAction,trashAction, nil];
    NSArray *actionArrayMinimal = [NSArray arrayWithObjects:modifyListAction,trashAction, nil];
    
    UIMutableUserNotificationCategory *shoppingListReminderCategory = [[UIMutableUserNotificationCategory alloc] init];
    shoppingListReminderCategory.identifier = @"shoppingListReminderCategory";
    [shoppingListReminderCategory setActions:actionArray forContext:UIUserNotificationActionContextDefault];
    [shoppingListReminderCategory setActions:actionArrayMinimal forContext:UIUserNotificationActionContextMinimal];
    
    NSSet *categoriesForSettings = [[NSSet alloc] initWithObjects:shoppingListReminderCategory, nil];
    UIUserNotificationSettings *newNotificationSettings = [UIUserNotificationSettings settingsForTypes:type categories:categoriesForSettings];
    
    UIUserNotificationSettings *notificationSettings = [[UIApplication sharedApplication] currentUserNotificationSettings];
    if (notificationSettings.types == UIUserNotificationTypeNone) {
        [[UIApplication sharedApplication] registerUserNotificationSettings:newNotificationSettings];
    }
}

//如果手机挂起后台，发本地推送
- (void)scheduleLocalNotificationWithValue:(NSString *)value
{
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    NSDate * pushDate = [NSDate dateWithTimeIntervalSinceNow:1];
    localNotification.fireDate = pushDate;
    localNotification.alertBody = value;
    localNotification.alertAction = @"View List";
    localNotification.category = @"shoppingListReminderCategory";
    localNotification.applicationIconBadgeNumber = localNotification.applicationIconBadgeNumber+1;
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    NSString *path = @"/System/Library/Audio/UISounds/sms-received1.caf";
    SystemSoundID sound = 2000;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path],&sound);
    AudioServicesPlaySystemSound(sound);
}

@end
