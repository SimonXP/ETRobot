//
//  RobotViewController.m
//  ETRobot
//
//  Created by IHOME on 16/5/5.
//  Copyright © 2016年 IHOME. All rights reserved.
//

#import "RobotViewController.h"

@interface RobotViewController ()<UITableViewDelegate,UITableViewDataSource,RobotTableViewCellDelegate>

@property (nonatomic, strong) UITableView *robotTableView;
@property (nonatomic, strong) NSMutableArray *robotArray;

@property (nonatomic, strong) OverallObject *overall;

@end

@implementation RobotViewController

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
    self.overall.pubAttr.currentUser = [self.overall.pubMethod getCurrentUserWithAccount:self.overall.pubAttr.currentUserAccount];
    NSLog(@"当前登录的用户账号：%@",self.overall.pubAttr.currentUser.mobile);
}

#pragma mark 添加机器人
- (void)addRobotMethod
{
    AddRobotViewController *addRobotVC = [[AddRobotViewController alloc]init];
    [self presentViewController:addRobotVC animated:YES completion:nil];
}

- (void)robotMsgButMethod
{

}

- (void)setAdjustUI
{
    CGRect rects = [UIScreen mainScreen].bounds;
    [self.view addSubview:[self.overall.pubAttr.pulicViewModel setTabBarView:@"机器人"]];
    UIButton *addRobot = [[UIButton alloc]initWithFrame:CGRectMake(rects.size.width - 58, 15, 55, 55)];
    [addRobot setImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
    [addRobot addTarget:self action:@selector(addRobotMethod) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addRobot];
    
    UIButton *robotMsgBut = [[UIButton alloc]initWithFrame:CGRectMake(3, 15, 55, 55)];
    [robotMsgBut setImage:[UIImage imageNamed:@"action_item_notification"] forState:UIControlStateNormal];
    [robotMsgBut addTarget:self action:@selector(robotMsgButMethod) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:robotMsgBut];
    
    self.robotTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 70, rects.size.width, rects.size.height - 70) style:UITableViewStyleGrouped];
    [self.robotTableView setDelegate:self];
    [self.robotTableView setDataSource:self];
    [self.view addSubview:self.robotTableView];
    [self.robotTableView registerNib:[UINib nibWithNibName:@"RobotTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"robot"];
}

#pragma mark tableView代理

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"robot";
    RobotTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    [cell setDelegate:self];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 400;
}


#pragma mark 操作回调
- (void)operateMethodTag:(NSInteger)operateTag
{
    UIViewController *operateVC = nil;
    if (operateTag == 0) {
        return;
    }else if (operateTag == 1){
        return;
    }else if (operateTag == 2){
        operateVC = [[VoiceViewController alloc]init];
    }else if (operateTag == 3){
        operateVC = [[VideoViewController alloc]init];
    }else if (operateTag == 4){
        operateVC = [[InspectViewController alloc]init];
    }else if (operateTag == 5){
        operateVC = [[MoreOperateViewController alloc]init];
    }else if (operateTag == 110){
        operateVC = [[RobotDetailViewController alloc]init];
    }
    [self presentViewController:operateVC animated:YES completion:nil];
}

@end
