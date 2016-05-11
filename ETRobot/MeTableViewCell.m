//
//  MeTableViewCell.m
//  ETRobot
//
//  Created by IHOME on 16/5/5.
//  Copyright © 2016年 IHOME. All rights reserved.
//

#import "MeTableViewCell.h"

@implementation MeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    [self.userIcon.layer setCornerRadius:self.userIcon.frame.size.width/2];
    [self.userIcon.layer setMasksToBounds:YES];
}

@end
