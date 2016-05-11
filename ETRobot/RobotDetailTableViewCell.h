//
//  RobotDetailTableViewCell.h
//  ETRobot
//
//  Created by IHOME on 16/5/7.
//  Copyright © 2016年 IHOME. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RobotDetailTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *robotView;
@property (weak, nonatomic) IBOutlet UIView *otherView;
@property (weak, nonatomic) IBOutlet UILabel *rTitle;
@property (weak, nonatomic) IBOutlet UIImageView *adminIcon;
@property (weak, nonatomic) IBOutlet UILabel *oTitle;
@property (weak, nonatomic) IBOutlet UILabel *contentValue;

@end
