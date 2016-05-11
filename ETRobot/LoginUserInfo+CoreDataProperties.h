//
//  LoginUserInfo+CoreDataProperties.h
//  ETRobot
//
//  Created by IHOME on 16/5/10.
//  Copyright © 2016年 IHOME. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "LoginUserInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface LoginUserInfo (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *loginUserAccount;
@property (nullable, nonatomic, retain) NSString *logiinUserPassword;

@end

NS_ASSUME_NONNULL_END
