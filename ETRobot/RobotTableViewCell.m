//
//  RobotTableViewCell.m
//  ETRobot
//
//  Created by IHOME on 16/4/29.
//  Copyright © 2016年 IHOME. All rights reserved.
//

#import "RobotTableViewCell.h"

@implementation RobotTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    CGRect rects = [UIScreen mainScreen].bounds;
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(rects.size.width-60, 12, 0.3, 25)];
    [line setBackgroundColor:[UIColor lightGrayColor]];
    [self.contentView addSubview:line];
    
    UIButton *back = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, rects.size.width, 1000)];
    [self.contentView addSubview:back];
    
    self.robotName = [[UILabel alloc]initWithFrame:CGRectMake(30, 0, 250, 45)];
    [self.robotName setText:@"小黄人"];
    [self.robotName setTextColor:[UIColor colorWithRed:0.5 green:0.5 blue:0.55 alpha:1]];
    [self.robotName setFont:[UIFont systemFontOfSize:16]];
    [self.contentView addSubview:self.robotName];
    
    UIImageView *icon = [[UIImageView alloc]initWithFrame:CGRectMake(line.frame.origin.x + 15, 7, 30, 30)];
    [icon setImage:[UIImage imageNamed:@"ic_circle_setting"]];
    [self addSubview:icon];
    
    self.robotDetial = [[UIButton alloc]initWithFrame:CGRectMake(line.frame.origin.x, 0, 100, 45)];
    [self.robotDetial setTag:110];
    [self.robotDetial addTarget:self action:@selector(operateMethod:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.robotDetial];
    
    self.robotIcon = [[UIImageView alloc]initWithFrame:CGRectMake(0, 45, rects.size.width, 200)];
    [self.robotIcon setImage:[UIImage imageNamed:@"bg_nemocircle_setting"]];
    [self.contentView addSubview:self.robotIcon];
    
    UIView *operateView = [[UIView alloc]initWithFrame:CGRectMake(0, self.robotIcon.frame.origin.y+self.robotIcon.frame.size.height, rects.size.width, 160)];
    [self.contentView addSubview:operateView];
    
    UILabel *hline = [[UILabel alloc]initWithFrame:CGRectMake(rects.size.width/3, 0, 0.2, 160)];
    [hline setBackgroundColor:[UIColor lightGrayColor]];
    [operateView addSubview:hline];
    
    UILabel *hline1 = [[UILabel alloc]initWithFrame:CGRectMake((rects.size.width/3)*2, 0, 0.2, 160)];
    [hline1 setBackgroundColor:[UIColor lightGrayColor]];
    [operateView addSubview:hline1];
    
    CGFloat width = 25;
    for (NSInteger i = 0; i < 3; i++) {
        UIImageView *imageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(i*rects.size.width/3+((rects.size.width/3-width)/2), ((operateView.frame.size.height/2)-width)/4, width, width)];
        [operateView addSubview:imageView1];
        
        CGFloat y = imageView1.frame.origin.y+imageView1.frame.size.height;
        UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(i*rects.size.width/3, y, rects.size.width/3, (operateView.frame.size.height/2)-y)];
        [title setTextColor:[UIColor grayColor]];
        [title setFont:[UIFont systemFontOfSize:13]];
        [title setTextAlignment:NSTextAlignmentCenter];
        [operateView addSubview:title];
        
        if (i == 0){
            [imageView1 setImage:[UIImage imageNamed:@"player"]];
            [title setText:@"场景"];
        }else if(i == 1){
            [imageView1 setImage:[UIImage imageNamed:@"clock"]];
            [title setText:@"提醒"];
        }else{
            [imageView1 setImage:[UIImage imageNamed:@"voice"]];
            [title setText:@"语音"];
        }
    }

    for (NSInteger i = 0; i < 3; i++) {
        UIImageView *imageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(i*rects.size.width/3+((rects.size.width/3-width)/2), operateView.frame.size.height/2+((operateView.frame.size.height/2)-width)/4, width, width)];
        [operateView addSubview:imageView1];
        
        CGFloat y = imageView1.frame.origin.y+imageView1.frame.size.height+operateView.frame.size.height/2;
        UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(i*rects.size.width/3, y, rects.size.width/3, (operateView.frame.size.height/2)-y)];
        [title setTextColor:[UIColor grayColor]];
        [title setFont:[UIFont systemFontOfSize:13]];
        [title setTextAlignment:NSTextAlignmentCenter];
        [operateView addSubview:title];
        
        if (i == 0){
            [imageView1 setImage:[UIImage imageNamed:@"video"]];
            [title setText:@"视频"];
        }else if(i == 1){
            [imageView1 setImage:[UIImage imageNamed:@"look"]];
            [title setText:@"查看"];
        }else{
            [imageView1 setImage:[UIImage imageNamed:@"more"]];
            [title setText:@"更多"];
        }
    }
    
    NSInteger operateTag = 0;
    for (NSInteger i = 0; i < 2; i++) {
        for (int j = 0; j < 3; j++) {
            UIButton *operateBtn = [[UIButton alloc]initWithFrame:CGRectMake(rects.size.width/3*j, operateView.frame.size.height/2*i, rects.size.width/3, operateView.frame.size.height/2)];
            [operateBtn setTag:operateTag];
            [operateBtn addTarget:self action:@selector(operateMethod:) forControlEvents:UIControlEventTouchUpInside];
            [operateView addSubview:operateBtn];
            operateTag ++;
        }
    }
    
    UILabel *sline = [[UILabel alloc]initWithFrame:CGRectMake(0, operateView.frame.size.height/2, rects.size.width, 0.2)];
    [sline setBackgroundColor:[UIColor lightGrayColor]];
    [operateView addSubview:sline];
}

- (void)operateMethod:(UIButton *)button
{
    [_delegate operateMethodTag:button.tag];
}

@end
