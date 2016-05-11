
//
//  PublicViewModel.m
//  ETRobot
//
//  Created by IHOME on 16/4/28.
//  Copyright © 2016年 IHOME. All rights reserved.
//

#import "PublicViewModel.h"

@implementation PublicViewModel

- (UIView *)setTabBarView:(NSString *)text
{
    UIView *tabBarView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 70)];
    [tabBarView setBackgroundColor:[UIColor colorWithRed:250/255.0 green:251/255.0 blue:253/255.0 alpha:1]];
    [tabBarView.layer setBorderWidth:0.3];
    [tabBarView.layer setBorderColor:[UIColor colorWithRed:0.7 green:0.7 blue:0.8 alpha:1].CGColor];
    
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 13, [UIScreen mainScreen].bounds.size.width, 60)];
    [title setText:text];
    [title setFont:[UIFont systemFontOfSize:20]];
    [title setTextColor:[UIColor colorWithRed:0.35 green:0.35 blue:0.4 alpha:1]];
    [title setTextAlignment:NSTextAlignmentCenter];
    [tabBarView addSubview:title];
    
    return tabBarView;
}

- (UITextField *)setTextFieldViewWithFrame:(CGRect)frame textValue:(NSString *)textValue placeholderValue:(NSString *)placeholderValue pwd:(BOOL)pwd
{
    UITextField *filed = [[UITextField alloc]initWithFrame:frame];
    [filed setPlaceholder:placeholderValue];
    [filed setText:textValue];
    [filed setFont:[UIFont systemFontOfSize:16]];
    [filed setClearButtonMode:1];
    [filed setTextColor:[UIColor colorWithRed:0.35 green:0.35 blue:0.4 alpha:1]];
    [filed setValue:[UIColor colorWithRed:0.75 green:0.75 blue:0.78 alpha:1]
                    forKeyPath:@"_placeholderLabel.textColor"];
    [filed setValue:[UIFont systemFontOfSize:15]
         forKeyPath:@"_placeholderLabel.font"];
    if (pwd) {
        [filed setSecureTextEntry:YES];
    }
    return filed;
}

- (UILabel *)setLabelWithFrame:(CGRect)frame textValue:(NSString *)textValue fontSize:(CGFloat)fontSize
{
    UILabel *label = [[UILabel alloc]initWithFrame:frame];
    [label setText:textValue];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setTextColor:[UIColor colorWithRed:0.8 green:0.8 blue:0.85 alpha:1]];
    [label setFont:[UIFont systemFontOfSize:fontSize]];
    return label;
}

- (XPTabBarViewController *)setTabBar
{
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault];
    //创建子控制器
    RobotViewController *robotVC=[[RobotViewController alloc]init];
    robotVC.tabBarItem.title = @"机器人";
    robotVC.tabBarItem.image=[[UIImage imageNamed:@"robot"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    robotVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"srobot"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    AlbumViewController *albumVC=[[AlbumViewController alloc]init];
    albumVC.tabBarItem.title = @"相册";
    albumVC.tabBarItem.image=[[UIImage imageNamed:@"robot"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    albumVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"srobot"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    MeViewController *meVC=[[MeViewController alloc]init];
    meVC.tabBarItem.title = @"我";
    meVC.tabBarItem.image=[[UIImage imageNamed:@"robot"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    meVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"srobot"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    
    XPTabBarViewController *tabBar = [[XPTabBarViewController alloc]init];
    [tabBar setViewControllers:@[robotVC,albumVC,meVC]];
    
    //设置tabbar的颜色
    UIView *mView=[[UIView alloc]initWithFrame:CGRectMake(0,0,[UIScreen mainScreen].bounds.size.width,50)];
    [mView setBackgroundColor:[UIColor colorWithRed:250/255.0 green:251/255.0 blue:253/255.0 alpha:1]];
    [tabBar.tabBar insertSubview:mView atIndex:0];
    
    //未选中的颜色
    [[UITabBarItem appearance]setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor lightGrayColor], NSForegroundColorAttributeName, [UIFont systemFontOfSize:12],NSFontAttributeName,nil] forState:UIControlStateNormal];
    //选中的颜色
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor greenColor], NSForegroundColorAttributeName, [UIFont systemFontOfSize:12],NSFontAttributeName,nil] forState:UIControlStateSelected];
    return tabBar;
}

@end
