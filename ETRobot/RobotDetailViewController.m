//
//  RobotDetailViewController.m
//  ETRobot
//
//  Created by IHOME on 16/5/7.
//  Copyright © 2016年 IHOME. All rights reserved.
//

#import "RobotDetailViewController.h"

@interface RobotDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIImageView *robotIcon;
@property (nonatomic, strong) UIScrollView *robotDetailScrollView;
@property (nonatomic, strong) UITableView *robotDetailTableView;

@property (nonatomic, strong) OverallObject *overall;

@end

@implementation RobotDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initToolClass];
    [self setAdjustUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarStyle:1];
}

- (void)initToolClass
{
    self.overall = [OverallObject sharedLoginInfo];
}

- (void)delRobotMethod
{
    
}

- (void)chooseIconMethod
{
    
}

- (void)setAdjustUI
{
    [self.view setBackgroundColor:[UIColor colorWithRed:0.93 green:0.93 blue:0.95 alpha:1]];
    CGRect rects = [UIScreen mainScreen].bounds;
    
    self.robotDetailScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, rects.size.width, rects.size.height)];
    CGSize size;
    if ([self.overall.pubMethod getDeviceType:rects.size.height]>5) {
        size = CGSizeMake(rects.size.width, rects.size.height+20);
    }else if ([self.overall.pubMethod getDeviceType:rects.size.height]==5){
        size = CGSizeMake(rects.size.width, rects.size.height+100);
    }else{
        size = CGSizeMake(rects.size.width, rects.size.height+188);
    }
    [self.robotDetailScrollView setContentSize:size];
    [self.robotDetailScrollView setBackgroundColor:[UIColor colorWithRed:0.93 green:0.93 blue:0.95 alpha:1]];
    [self.view addSubview:self.robotDetailScrollView];
    
    self.robotIcon = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, rects.size.width,rects.size.height/3)];
    [self.robotIcon setImage:[UIImage imageNamed:@"bg_nemocircle_setting"]];
    [self.robotDetailScrollView addSubview:self.robotIcon];
    
    UIButton *chooseIcon = [[UIButton alloc]initWithFrame:self.robotIcon.frame];
    [chooseIcon setTitle:@"切换背景图片" forState:UIControlStateNormal];
    [chooseIcon setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [chooseIcon addTarget:self action:@selector(chooseIconMethod) forControlEvents:UIControlEventTouchUpInside];
    [chooseIcon.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [self.robotDetailScrollView addSubview:chooseIcon];
    
    UIButton *goBack = [[UIButton alloc]initWithFrame:CGRectMake(0, 15, 60, 60)];
    [goBack setImage:[UIImage imageNamed:@"wback"] forState:UIControlStateNormal];
    [goBack addTarget:self action:@selector(goBackMethod) forControlEvents:UIControlEventTouchUpInside];
    [self.robotDetailScrollView addSubview:goBack];
    
    self.robotDetailTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, self.robotIcon.frame.size.height, rects.size.width, 355) style:UITableViewStyleGrouped];
    [self.robotDetailTableView setDelegate:self];
    [self.robotDetailTableView setDataSource:self];
    [self.robotDetailTableView setBounces:NO];
    [self.robotDetailTableView setBackgroundColor:[UIColor colorWithRed:0.93 green:0.93 blue:0.95 alpha:1]];
    [self.robotDetailScrollView addSubview:self.robotDetailTableView];
    [self.robotDetailTableView registerNib:[UINib nibWithNibName:@"RobotDetailTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"RobotDetailTableViewCell"];
    
    UIButton *delRobotBtn = [[UIButton alloc]initWithFrame:CGRectMake(15, self.robotDetailTableView.frame.size.height+self.robotDetailTableView.frame.origin.y+20, rects.size.width-30, 45)];
    [delRobotBtn setTitle:@"删除机器人" forState:UIControlStateNormal];
    [delRobotBtn setBackgroundColor:[UIColor colorWithRed:253/255.0 green:100/255.0 blue:100/255.0 alpha:1]];
    [delRobotBtn addTarget:self action:@selector(delRobotMethod) forControlEvents:UIControlEventTouchUpInside];
    [self.robotDetailScrollView addSubview:delRobotBtn];
}

#pragma mark tableView代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 2;
            break;
        case 1:
            return 2;
            break;
        case 2:
            return 2;
            break;
            
        default:
            break;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"RobotDetailTableViewCell";
    RobotDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    switch (indexPath.section) {
        case 0:
            if (indexPath.row==0) {
                [cell.robotView setHidden:NO];
                [cell.otherView setHidden:YES];
                [cell.rTitle setText:@"管理员"];
                [cell.adminIcon setImage:[UIImage imageNamed:@"mem.jpg"]];
            }else{
                [cell.robotView setHidden:YES];
                [cell.otherView setHidden:NO];
                [cell.oTitle setText:@"管理员名称"];
                [cell.contentValue setText:@"向平"];
            }
            break;
        case 1:
            [cell.robotView setHidden:YES];
            [cell.otherView setHidden:NO];
            if (indexPath.row==0) {
                [cell.oTitle setText:@"机器人名称"];
                [cell.contentValue setText:@"小黄人"];
            }else{
                [cell.oTitle setText:@"机器人号"];
                [cell.contentValue setText:@"9527"];
            }
            break;
        case 2:
            [cell.robotView setHidden:YES];
            [cell.otherView setHidden:NO];
            if (indexPath.row==0) {
                [cell.oTitle setText:@"成员"];
                [cell.contentValue setText:@"三个"];
            }else{
                [cell.oTitle setText:@"成员列表"];
                [cell.contentValue setText:@""];
            }
            break;
            
        default:
            break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            if (indexPath.row==0) {
                return 80;
            }else{
                return 45;
            }
            break;
        case 1:
            return 45;
            break;
        case 2:
            return 45;
            break;
            
        default:
            break;
    }
    return 0;
}

- (void)goBackMethod
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
