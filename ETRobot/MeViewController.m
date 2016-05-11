//
//  MeViewController.m
//  ETRobot
//
//  Created by IHOME on 16/5/5.
//  Copyright © 2016年 IHOME. All rights reserved.
//

#import "MeViewController.h"

@interface MeViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *meTableView;

@property (nonatomic, strong) OverallObject *overall;

@end

@implementation MeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initToolClass];
    [self setAdjustUI];
}

- (void)initToolClass
{
    self.overall = [OverallObject sharedLoginInfo];
}

- (void)setAdjustUI
{
    CGRect rect = [UIScreen mainScreen].bounds;
    [self.view addSubview:[self.overall.pubAttr.pulicViewModel setTabBarView:@"我"]];
    [self.view setBackgroundColor:[UIColor colorWithRed:239/255.0 green:239/255.0 blue:246/255.0 alpha:1]];
    self.meTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 70, rect.size.width, rect.size.height - 70) style:UITableViewStyleGrouped];
    [self.meTableView setDelegate:self];
    [self.meTableView setDataSource:self];
    [self.view addSubview:self.meTableView];
    [self.meTableView registerNib:[UINib nibWithNibName:@"MeTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"MeTableViewCell"];

}

#pragma mark tableView代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return 2;
            break;
        case 2:
            return 1;
            break;
        case 3:
            return 1;
            break;
            
        default:
            break;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"MeTableViewCell";
    MeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    switch (indexPath.section) {
        case 0:
            [cell.userView setHidden:NO];
            [cell.otherView setHidden:YES];
            [cell.userIcon setImage:[UIImage imageNamed:@"ic_remote_mute_default_profile"]];
            [cell.userName setText:@"向平"/*self.overall.pubAttr.currentUser.userName*/];
            break;
        case 1:
            [cell.userView setHidden:YES];
            [cell.otherView setHidden:NO];
            switch (indexPath.row) {
                case 0:
                    cell.title.text = @"设置";
                    cell.icon.image = [UIImage imageNamed:@"set"];
                    break;
                case 1:
                    cell.title.text = @"周边机器人";
                    cell.icon.image = [UIImage imageNamed:@"fuji"];
                    break;
                    
                default:
                    break;
            }
            break;
        case 2:
            [cell.userView setHidden:YES];
            [cell.otherView setHidden:NO];
            cell.title.text = @"帮助";
            cell.icon.image = [UIImage imageNamed:@"help"];
            [cell.userView setHidden:YES];
            break;
        case 3:
            [cell.userView setHidden:YES];
            [cell.otherView setHidden:NO];
            cell.title.text = @"关于";
            cell.icon.image = [UIImage imageNamed:@"about"];
            [cell.userView setHidden:YES];
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    UIViewController *userVC = nil;
    switch (indexPath.section) {
        case 0:
            userVC = [[UserViewController alloc]init];
            break;
        case 1:
            switch (indexPath.row) {
                case 0:
                    
                    break;
                case 1:
                    
                    break;
                    
                default:
                    break;
            }
            return;
            break;
        case 2:
            return;
            break;
        case 3:
            return;
            break;
    }
    [self presentViewController:userVC animated:YES completion:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return 80;
    }else{
        return 45;
    }
}

@end
