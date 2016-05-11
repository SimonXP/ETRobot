//
//  UserInfo+CoreDataProperties.h
//  ETRobot
//
//  Created by IHOME on 16/5/10.
//  Copyright © 2016年 IHOME. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "UserInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface UserInfo (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *avatar;
@property (nullable, nonatomic, retain) NSString *createTime;
@property (nullable, nonatomic, retain) NSString *email;
@property (nullable, nonatomic, retain) NSString *gender;
@property (nullable, nonatomic, retain) NSString *ip;
@property (nullable, nonatomic, retain) NSString *lastloginTime;
@property (nullable, nonatomic, retain) NSString *mobile;
@property (nullable, nonatomic, retain) NSString *uid;
@property (nullable, nonatomic, retain) NSString *updateTime;
@property (nullable, nonatomic, retain) NSString *userName;
@property (nullable, nonatomic, retain) NSString *userPassword;
@property (nullable, nonatomic, retain) NSString *clientAccount;
@property (nullable, nonatomic, retain) NSString *clientPwd;
@property (nullable, nonatomic, retain) NSString *voipAccount;
@property (nullable, nonatomic, retain) NSString *voipToken;

@end

NS_ASSUME_NONNULL_END
