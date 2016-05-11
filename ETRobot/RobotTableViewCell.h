//
//  RobotTableViewCell.h
//  ETRobot
//
//  Created by IHOME on 16/4/29.
//  Copyright © 2016年 IHOME. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RobotTableViewCellDelegate <NSObject>

@optional
- (void)operateMethodTag:(NSInteger)operateTag;

@end

@interface RobotTableViewCell : UITableViewCell

@property (nonatomic, weak) id<RobotTableViewCellDelegate> delegate;
@property (nonatomic, strong) UILabel *robotName;
@property (nonatomic, strong) UIButton *robotDetial;
@property (nonatomic, strong) UIImageView *robotIcon;

@end
