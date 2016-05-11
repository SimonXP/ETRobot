//
//  UserIconViewController.m
//  RecreationRobot
//
//  Created by IHOME on 16/4/25.
//  Copyright (c) 2016年 IHOME. All rights reserved.
//

#import "UserIconViewController.h"

@interface UserIconViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong) NSString *account;
@property (nonatomic, strong) UIImageView *userIcon;
@property (nonatomic, strong) OverallObject *overall;

@end

@implementation UserIconViewController

- (id)initWithUserIcon:(NSString *)account
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initToolClass];
    [self setAdjustUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

#pragma mark 设置调整UI
- (void)setAdjustUI
{
    [self.view setBackgroundColor:[UIColor whiteColor]];
    CGRect rect = [UIScreen mainScreen].bounds;
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height)];
    [imageView setImageToBlur:[UIImage imageNamed:@"voice.jpg"] blurRadius:10 completionBlock:nil];
    [self.view addSubview:imageView];
    
    UIButton *goBack = [[UIButton alloc]initWithFrame:CGRectMake(0, 15, 60, 60)];
    [goBack setImage:[UIImage imageNamed:goWBackIcon] forState:UIControlStateNormal];
    [goBack addTarget:self action:@selector(goBackMethod) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:goBack];
    
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 30, rect.size.width, 30)];
    [title setText:@"用户图标"];
    [title setTextAlignment:NSTextAlignmentCenter];
    [title setTextColor:[UIColor whiteColor]];
    [title setFont:[UIFont boldSystemFontOfSize:20]];
    [self.view addSubview:title];
    
    CGFloat widths = 100;
    self.userIcon = [[UIImageView alloc]initWithFrame:CGRectMake((rect.size.width-widths)/2, rect.size.height/2-widths-widths/3, widths, widths)];
    [self.userIcon.layer setCornerRadius:widths/2];
    [self.userIcon.layer setMasksToBounds:YES];
    [self.userIcon.layer setBorderWidth:1];
    [self.userIcon.layer setBorderColor:[UIColor whiteColor].CGColor];
    [self.userIcon setImage:[UIImage imageNamed:@"mem.jpg"]];
    [self.view addSubview:self.userIcon];
    
    UIButton *chooseUserIconBtn =[[UIButton alloc]initWithFrame:self.userIcon.frame];
    [chooseUserIconBtn addTarget:self action:@selector(chooseUserIconBtnMethod) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:chooseUserIconBtn];
    
    UIButton *setUserIconBtn =[[UIButton alloc]initWithFrame:CGRectMake((rect.size.width-widths)/2, self.userIcon.frame.origin.y+widths+30, widths, 30)];
    [setUserIconBtn addTarget:self action:@selector(setUserIconBtnMethod) forControlEvents:UIControlEventTouchUpInside];
    [setUserIconBtn setTitle:@"立即设置" forState:UIControlStateNormal];
    [setUserIconBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [setUserIconBtn.layer setCornerRadius:4];
    [setUserIconBtn.layer setMasksToBounds:YES];
    [setUserIconBtn.layer setBorderWidth:0.5];
    [setUserIconBtn.layer setBorderColor:[UIColor whiteColor].CGColor];
    [self.view addSubview:setUserIconBtn];
}

#pragma mark 选择用户图标
- (void)chooseUserIconBtnMethod
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"图片来源" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相机",@"相册", nil];
    [actionSheet showInView:self.view];
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
    [self.userIcon setImage:image];
    //    CGSize imagesize = image.size;
    //    imagesize.height =150;
    //    imagesize.width =150;
    //    //对图片大小进行压缩--
    //    UIImage *images = [self.login.pubMethod imageWithImage:image scaledToSize:imagesize];
    //    self.userIconData = nil;
    //    self.userIconData = [[NSMutableData alloc]initWithData: UIImageJPEGRepresentation(images,0.00001)];
}

#pragma mark 设置用户图标
- (void)setUserIconBtnMethod
{
    
}

#pragma mark 初始化工具类
- (void)initToolClass
{
    self.overall = [OverallObject sharedLoginInfo];
}

- (void)goBackMethod
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
