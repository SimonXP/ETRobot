//
//  MoreOperateViewController.m
//  ETRobot
//
//  Created by IHOME on 16/5/5.
//  Copyright © 2016年 IHOME. All rights reserved.
//

#import "MoreOperateViewController.h"

@interface MoreOperateViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong) UIImageView *robotIcon;
@property (nonatomic, strong) UILabel *robotName;

@end

@implementation MoreOperateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initToolClass];
    [self setAdjustUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)initToolClass
{
    
}

- (void)operateBtnMethod:(UIButton *)button
{
    
}

#pragma mark 切换图片
- (void)chooseIconMethod
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"选择图片来源" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相机",@"相册", nil];
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
    //    CGSize imagesize = image.size;
    //    imagesize.height =150;
    //    imagesize.width =150;
    //    //对图片大小进行压缩--
    //    UIImage *images = [self.login.pubMethod imageWithImage:image scaledToSize:imagesize];
    //    self.userIconData = nil;
    //    self.userIconData = [[NSMutableData alloc]initWithData: UIImageJPEGRepresentation(images,0.00001)];
    [self.robotIcon setImage:image];
}

- (void)setAdjustUI
{
    CGRect rects = [UIScreen mainScreen].bounds;
    self.robotIcon = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, rects.size.width,rects.size.height/3)];
    [self.robotIcon setImage:[UIImage imageNamed:@"bg_nemocircle_setting"]];
    [self.view addSubview:self.robotIcon];
    
    UIButton *chooseIcon = [[UIButton alloc]initWithFrame:self.robotIcon.frame];
    [chooseIcon setTitle:@"切换背景图片" forState:UIControlStateNormal];
    [chooseIcon setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [chooseIcon addTarget:self action:@selector(chooseIconMethod) forControlEvents:UIControlEventTouchUpInside];
    [chooseIcon.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [self.view addSubview:chooseIcon];
    
    UIButton *goBack = [[UIButton alloc]initWithFrame:CGRectMake(0, 15, 60, 60)];
    [goBack setImage:[UIImage imageNamed:@"wback"] forState:UIControlStateNormal];
    [goBack addTarget:self action:@selector(goBackMethod) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:goBack];
    
    UIScrollView *operateScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, self.robotIcon.frame.size.height, rects.size.width, rects.size.height-self.robotIcon.frame.size.height)];
    [operateScrollView setContentSize:CGSizeMake(rects.size.width, operateScrollView.frame.size.height+operateScrollView.frame.size.height/4)];
    [operateScrollView setBackgroundColor:[UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1]];
    [self.view addSubview:operateScrollView];
    
    UIView *operateView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, rects.size.width, operateScrollView.frame.size.height+operateScrollView.frame.size.height/4)];
    [operateView setBackgroundColor:[UIColor whiteColor]];
    [operateScrollView addSubview:operateView];
    
    NSInteger lindex = 0;
    CGFloat width = 20;
    for (NSInteger line = 0; line < 5; line++) {
        for (NSInteger hline = 0; hline < 4; hline++) {
            UIImageView *imageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(hline*rects.size.width/4+((rects.size.width/4-width)/2), line*operateView.frame.size.height/5+((operateView.frame.size.height/5)-width)/4, width, width)];
            [operateView addSubview:imageView1];
            
            UILabel *titleLbl = [[UILabel alloc]initWithFrame:CGRectMake(hline*(rects.size.width/4), line*(operateScrollView.frame.size.height/4)+((operateScrollView.frame.size.height/4)/12)*5, rects.size.width/4, (operateScrollView.frame.size.height/4)/2)];
            [titleLbl setTextColor:[UIColor colorWithRed:0.5 green:0.5 blue:0.55 alpha:1]];
            [titleLbl setFont:[UIFont systemFontOfSize:14]];
            [titleLbl setTextAlignment:NSTextAlignmentCenter];
            [operateView addSubview:titleLbl];
            
            if (lindex == 0) {
                [titleLbl setText:@"场景"];
                [imageView1 setImage:[UIImage imageNamed:@"11"]];
            }else if (lindex == 1){
                [titleLbl setText:@"提醒"];
                [imageView1 setImage:[UIImage imageNamed:@"12"]];
            }else if (lindex == 2){
                [titleLbl setText:@"语音"];
                [imageView1 setImage:[UIImage imageNamed:@"13"]];
            }else if (lindex == 3){
                [titleLbl setText:@"视频"];
                [imageView1 setImage:[UIImage imageNamed:@"14"]];
            }else if (lindex == 4){
                [titleLbl setText:@"查看"];
                [imageView1 setImage:[UIImage imageNamed:@"15"]];
            }else if (lindex == 5){
                [titleLbl setText:@"私有库"];
                [imageView1 setImage:[UIImage imageNamed:@"16"]];
            }else if (lindex == 6){
                [titleLbl setText:@"问答库"];
                [imageView1 setImage:[UIImage imageNamed:@"17"]];
            }else if (lindex == 7){
                [titleLbl setText:@"家电"];
                [imageView1 setImage:[UIImage imageNamed:@"18"]];
            }else if (lindex == 8){
                [titleLbl setText:@"音乐"];
                [imageView1 setImage:[UIImage imageNamed:@"19"]];
            }else if (lindex == 9){
                [titleLbl setText:@"故事"];
                [imageView1 setImage:[UIImage imageNamed:@"20"]];
            }else if (lindex == 10){
                [titleLbl setText:@"百科"];
                [imageView1 setImage:[UIImage imageNamed:@"21"]];
            }else if (lindex == 11){
                [titleLbl setText:@"谜语"];
                [imageView1 setImage:[UIImage imageNamed:@"22"]];
            }else if (lindex == 12){
                [titleLbl setText:@"笑话"];
                [imageView1 setImage:[UIImage imageNamed:@"23"]];
            }else if (lindex == 13){
                [titleLbl setText:@"学习"];
                [imageView1 setImage:[UIImage imageNamed:@"24"]];
            }else if (lindex == 14){
                [titleLbl setText:@"识别"];
                [imageView1 setImage:[UIImage imageNamed:@"25"]];
            }else if (lindex == 15){
                [titleLbl setText:@"记忆"];
                [imageView1 setImage:[UIImage imageNamed:@"26"]];
            }else if (lindex == 16){
                [titleLbl setText:@"问候"];
                [imageView1 setImage:[UIImage imageNamed:@"27"]];
            }else if (lindex == 17){
                [titleLbl setText:@"迎接"];
                [imageView1 setImage:[UIImage imageNamed:@"28"]];
            }else if (lindex == 18){
                [titleLbl setText:@"自主移动"];
                [imageView1 setImage:[UIImage imageNamed:@"29"]];
            }else if (lindex == 19){
                [titleLbl setText:@"舞动"];
                [imageView1 setImage:[UIImage imageNamed:@"30"]];
            }
            lindex ++;
        }
    }
    
    for (NSInteger i = 0; i < 4; i++) {
        UILabel *sline = [[UILabel alloc]initWithFrame:CGRectMake(i*(rects.size.width/4), 0, 0.2, operateView.frame.size.height)];
        [sline setBackgroundColor:[UIColor grayColor]];
        [operateView addSubview:sline];
    }
    
    for (NSInteger i = 0; i < 6; i++) {
        UILabel *hline = [[UILabel alloc]initWithFrame:CGRectMake(0, i*(operateScrollView.frame.size.height/4), rects.size.width, 0.2)];
        [hline setBackgroundColor:[UIColor grayColor]];
        [operateView addSubview:hline];
    }
    
    CGFloat bIndex = 0;
    for (NSInteger line = 0; line < 5; line++) {
        for (NSInteger hline = 0; hline < 4; hline++) {
            UIButton *operateBtn = [[UIButton alloc]initWithFrame:CGRectMake(hline*(rects.size.width/4), line*(operateView.frame.size.height/5), rects.size.width/4, operateView.frame.size.height/5)];
            [operateBtn addTarget:self action:@selector(operateBtnMethod:) forControlEvents:UIControlEventTouchUpInside];
            [operateBtn setTag:bIndex];
            [operateView addSubview:operateBtn];
            bIndex++;
        }
    }
}

- (void)goBackMethod
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
