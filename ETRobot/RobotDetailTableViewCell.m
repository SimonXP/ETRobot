//
//  RobotDetailTableViewCell.m
//  ETRobot
//
//  Created by IHOME on 16/5/7.
//  Copyright © 2016年 IHOME. All rights reserved.
//

#import "RobotDetailTableViewCell.h"

@implementation RobotDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    // Configure the view for the selected state
    [self.adminIcon.layer setCornerRadius:self.adminIcon.frame.size.width/2];
    [self.adminIcon.layer setMasksToBounds:YES];
}

@end
