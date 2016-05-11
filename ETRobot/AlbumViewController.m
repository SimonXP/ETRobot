//
//  AlbumViewController.m
//  ETRobot
//
//  Created by IHOME on 16/5/5.
//  Copyright © 2016年 IHOME. All rights reserved.
//

#import "AlbumViewController.h"

@interface AlbumViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIView *noContentView;
@property (nonatomic, strong) UIView *haveContentView;

@property (nonatomic, strong) UIView *playView;
@property (nonatomic, strong) UIButton *playBut;
@property (nonatomic, strong) UITableView *albumTableView;

@property (nonatomic, strong) OverallObject *overall;

@end

@implementation AlbumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initToolClass];
    [self setHaveContentViewUI];
    [self setNoContentViewUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.noContentView setHidden:YES];
    [self.haveContentView setHidden:NO];
}

- (void)initToolClass
{
    self.overall = [OverallObject sharedLoginInfo];
}

#pragma mark 设置没有内容的UI
- (void)setNoContentViewUI
{
    CGRect rects = [UIScreen mainScreen].bounds;
    self.noContentView = [[UIView alloc]initWithFrame:CGRectMake(0, 70, rects.size.width, rects.size.height-120)];
    [self.view addSubview:self.noContentView];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake((rects.size.width-80)/2, self.noContentView.frame.size.height/2-100, 80, 80)];
    [imageView setImage:[UIImage imageNamed:@"robot"]];
    [imageView.layer setCornerRadius:imageView.frame.size.width/2];
    [imageView setAlpha:0.5];
    [imageView.layer setMasksToBounds:YES];
    [self.noContentView addSubview:imageView];
    
    UILabel *promptLbl = [self.overall.pubAttr.pulicViewModel setLabelWithFrame:CGRectMake(0, self.noContentView.frame.size.height/2, rects.size.width, 20) textValue:@"您还没有相册" fontSize:16];
    [self.noContentView addSubview:promptLbl];
}

#pragma mark 设置有内容的UI
- (void)setHaveContentViewUI
{
    CGRect rects = [UIScreen mainScreen].bounds;
    [self.view addSubview:[self.overall.pubAttr.pulicViewModel setTabBarView:@"相册"]];
    [self.view setBackgroundColor:[UIColor colorWithRed:239/255.0 green:239/255.0 blue:246/255.0 alpha:1]];
    
    CGFloat withd = 70.2;
    
    self.haveContentView = [[UIView alloc]initWithFrame:CGRectMake(0, withd, rects.size.width, rects.size.height-120)];
    [self.view addSubview:self.haveContentView];
    
    self.playView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, rects.size.width, (rects.size.height/5)*2)];
    [self.playView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_nemocircle_setting"]]];
    [self.haveContentView addSubview:self.playView];

    self.playBut = [[UIButton alloc]initWithFrame:CGRectMake((self.playView.frame.size.width-withd)/2, (self.playView.frame.size.height-withd)/2, withd, withd)];
    [self.playBut setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
    [self.playBut addTarget:self action:@selector(playMethod) forControlEvents:UIControlEventTouchUpInside];
    [self.playView addSubview:self.playBut];
    
    self.albumTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, self.playView.frame.size.height, [UIScreen mainScreen].bounds.size.width, self.self.haveContentView.frame.size.height - self.playView.frame.size.height) style:UITableViewStyleGrouped];
    [self.albumTableView setDelegate:self];
    [self.albumTableView setDataSource:self];
    [self.haveContentView addSubview:self.albumTableView];
    [self.albumTableView registerNib:[UINib nibWithNibName:@"AlbumTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"Album"];
}

#pragma mark 播放
- (void)playMethod
{
    
}

#pragma mark tableView代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"Album";
    AlbumTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    
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
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

@end
