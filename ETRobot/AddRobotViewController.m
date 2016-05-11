//
//  AddRobotViewController.m
//  ETRobot
//
//  Created by IHOME on 16/5/6.
//  Copyright © 2016年 IHOME. All rights reserved.
//

#import "AddRobotViewController.h"

@interface AddRobotViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *addRobotTableView;

@property (nonatomic, strong) OverallObject *overall;

@end

@implementation AddRobotViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initToolClass];
    [self setAdjustUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void)initToolClass
{
    self.overall = [OverallObject sharedLoginInfo];
}

- (void)setAdjustUI
{
    [self.view setBackgroundColor:[UIColor colorWithRed:0.93 green:0.93 blue:0.95 alpha:1]];
    CGRect rects = [UIScreen mainScreen].bounds;
    [self.view addSubview:[self.overall.pubAttr.pulicViewModel setTabBarView:@"添加机器人"]];
    
    UIButton *goBackBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 15, 60, 60)];
    [goBackBtn setImage:[UIImage imageNamed:goBackIcon] forState:UIControlStateNormal];
    [goBackBtn addTarget:self action:@selector(goBackBtnMethod) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:goBackBtn];
    
    self.addRobotTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 70, rects.size.width, rects.size.height-70) style:UITableViewStyleGrouped];
    [self.addRobotTableView setDelegate:self];
    [self.addRobotTableView setDataSource:self];
    [self.view addSubview:self.addRobotTableView];
    [self.addRobotTableView registerNib:[UINib nibWithNibName:@"AddRobotTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"AddRobotTableViewCell"];
}

#pragma mark tableView代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"AddRobotTableViewCell";
    AddRobotTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    if (indexPath.row == 1) {
        [cell.robotIcon setImage:[UIImage imageNamed:@"ic_add_nemo_by_scan"]];
        [cell.robotTitle setText:@"扫一扫二维码"];
        [cell.robotDetail setText:@"即刻添加小黄人"];
    }else{
        [cell.robotIcon setImage:[UIImage imageNamed:@"ic_add_nemo_by_number"]];
        [cell.robotTitle setText:@"输入小黄号添加"];
        [cell.robotDetail setText:@"随手添加小黄人"];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.row == 0) {
        RobotCodeViewController *robotCodeVC = [[RobotCodeViewController alloc]init];
        [self presentViewController:robotCodeVC animated:YES completion:nil];
    }else{
        //扫描二维码
        ScanRobotViewController *qrcodevc = [[ScanRobotViewController alloc]init];
        qrcodevc.ScanRobotSuncessBlock = ^(ScanRobotViewController *aqrvc,NSString *qrString){
            NSLog(@"扫描成功的回调：%@",qrString);
            [aqrvc dismissViewControllerAnimated:YES completion:nil];
        };
        qrcodevc.ScanRobotFailBlock = ^(ScanRobotViewController *aqrvc){
            NSLog(@"扫描失败的回调");
            [aqrvc dismissViewControllerAnimated:YES completion:nil];
        };
        qrcodevc.ScanRobotCancleBlock = ^(ScanRobotViewController *aqrvc){
            [aqrvc dismissViewControllerAnimated:YES completion:nil];
            NSLog(@"取消扫描失败的回调");
        };
        [self presentViewController:qrcodevc animated:YES completion:nil];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

- (void)goBackBtnMethod
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
