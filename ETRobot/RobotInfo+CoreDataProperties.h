//
//  RobotInfo+CoreDataProperties.h
//  ETRobot
//
//  Created by IHOME on 16/5/10.
//  Copyright © 2016年 IHOME. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "RobotInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface RobotInfo (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *rid;
@property (nullable, nonatomic, retain) NSString *robotAdmin;
@property (nullable, nonatomic, retain) NSString *robotIcon;
@property (nullable, nonatomic, retain) NSString *robotMemberNum;
@property (nullable, nonatomic, retain) NSString *robotName;
@property (nullable, nonatomic, retain) NSString *robotNumber;

@end

NS_ASSUME_NONNULL_END
