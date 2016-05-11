//
//  RobotMemberInfo+CoreDataProperties.h
//  ETRobot
//
//  Created by IHOME on 16/5/10.
//  Copyright © 2016年 IHOME. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "RobotMemberInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface RobotMemberInfo (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *rid;
@property (nullable, nonatomic, retain) NSString *uid;
@property (nullable, nonatomic, retain) NSString *userName;
@property (nullable, nonatomic, retain) NSString *userIcon;
@property (nullable, nonatomic, retain) NSString *adminType;

@end

NS_ASSUME_NONNULL_END
