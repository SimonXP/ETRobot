//
//  UserViewController.m
//  ETRobot
//
//  Created by IHOME on 16/5/5.
//  Copyright © 2016年 IHOME. All rights reserved.
//

#import "UserViewController.h"

@interface UserViewController ()<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong) UITableView *userTableView;

@property (nonatomic, strong) UIImage *userImage;
@property (nonatomic, strong) OverallObject *overall;

@end

@implementation UserViewController

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
    self.userImage = [UIImage imageNamed:@"ic_remote_mute_default_profile"];
    
    CGRect rect = [UIScreen mainScreen].bounds;
    [self.view addSubview:[self.overall.pubAttr.pulicViewModel setTabBarView:@"个人信息"]];
    [self.view setBackgroundColor:[UIColor colorWithRed:239/255.0 green:239/255.0 blue:246/255.0 alpha:1]];
    
    UIButton *goBackBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 15, 60, 60)];
    [goBackBtn setImage:[UIImage imageNamed:goBackIcon] forState:UIControlStateNormal];
    [goBackBtn addTarget:self action:@selector(goBackBtnMethod) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:goBackBtn];
    
    self.userTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 70, rect.size.width, rect.size.height - 70) style:UITableViewStyleGrouped];
    [self.userTableView setDelegate:self];
    [self.userTableView setDataSource:self];
    [self.view addSubview:self.userTableView];
    [self.userTableView registerNib:[UINib nibWithNibName:@"UserTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"UserTableViewCell"];
    
    UIButton *leaveBtn = [[UIButton alloc]initWithFrame:CGRectMake(15, 300, rect.size.width-30, 45)];
    [leaveBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    [leaveBtn setBackgroundColor:[UIColor colorWithRed:253/255.0 green:100/255.0 blue:100/255.0 alpha:1]];
    [leaveBtn addTarget:self action:@selector(leaveBtnMethod) forControlEvents:UIControlEventTouchUpInside];
    [self.userTableView addSubview:leaveBtn];
}

- (void)goBackBtnMethod
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)leaveBtnMethod
{
    LoginViewController *loginVC = [[LoginViewController alloc]init];
    [self presentViewController:loginVC animated:YES completion:nil];
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
            return 1;
            break;
        case 1:
            return 2;
            break;
        case 2:
            return 1;
            break;
            
        default:
            break;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"UserTableViewCell";
    UserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    switch (indexPath.section) {
        case 0:
            [cell.userView setHidden:NO];
            [cell.otherView setHidden:YES];
            [cell.userIcon setImage:self.userImage];
            [cell.userName setText:@"头像"];
            break;
        case 1:
            [cell.userView setHidden:YES];
            [cell.otherView setHidden:NO];
            switch (indexPath.row) {
                case 0:
                    cell.title.text = @"名字";
                    cell.contentValues.text = @"向平";
                    break;
                case 1:
                    cell.title.text = @"手机号";
                    cell.contentValues.text = @"13167172230";
                    break;
                    
                default:
                    break;
            }
            break;
        case 2:
            [cell.userView setHidden:YES];
            [cell.otherView setHidden:NO];
            cell.title.text = @"修改密码";
            cell.contentValues.text = @"";
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    UIViewController *userOperateVC = nil;
    UIActionSheet *actionSheet;
    switch (indexPath.section) {
        case 0:
            actionSheet = [[UIActionSheet alloc]initWithTitle:@"选择图片来源" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相机",@"相册", nil];
            [actionSheet showInView:self.view];
            return;
            break;
        case 1:
            switch (indexPath.row) {
                case 0:
                    userOperateVC = [[UserOperateViewController alloc]initWithUserOperateVCWithOperateTag:0];
                    break;
                case 1:
                    return;
                default:
                    break;
            }
            break;
        case 2:
            userOperateVC = [[UserOperateViewController alloc]initWithUserOperateVCWithOperateTag:1];
            break;
    }
    [self presentViewController:userOperateVC animated:YES completion:nil];
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

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSInteger type = -1;
    if (buttonIndex == 0) {
        type = UIImagePickerControllerSourceTypeCamera;
    }else if (buttonIndex == 1){
        type = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    if (type != -1) {
        // 跳转到相机或相册页面
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = YES;
        imagePickerController.sourceType = type;
        [self presentViewController:imagePickerController animated:YES completion:^{}];
    }
}

#pragma mark - image picker delegte
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{}];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    //    CGSize imagesize = image.size;
    //    imagesize.height =150;
    //    imagesize.width =150;
    //    //对图片大小进行压缩--
    //    UIImage *images = [self.login.pubMethod imageWithImage:image scaledToSize:imagesize];
    //    self.userIconData = nil;
    //    self.userIconData = [[NSMutableData alloc]initWithData: UIImageJPEGRepresentation(images,0.00001)];
    self.userImage = image;
    [self.userTableView reloadData];
}

@end
