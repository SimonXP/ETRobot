
//
//  ScanRobotViewController.m
//  ETRobot
//
//  Created by IHOME on 16/5/8.
//  Copyright © 2016年 IHOME. All rights reserved.
//

#import "ScanRobotViewController.h"
#import <AVFoundation/AVFoundation.h>

//设备宽/高/坐标
#define kDeviceWidth [UIScreen mainScreen].bounds.size.width
#define KDeviceHeight [UIScreen mainScreen].bounds.size.height
#define KDeviceFrame [UIScreen mainScreen].bounds


float kLWidth;
float kLineMinY = 185;
float kLineMaxY = 385;
float kReaderViewWidth = 200;
float kReaderViewHeight = 200;

@interface ScanRobotViewController ()<AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic, strong) AVCaptureSession *qrSession;//回话
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *qrVideoPreviewLayer;//读取
@property (nonatomic, strong) UIImageView *line;//交互线
@property (nonatomic, strong) NSTimer *lineTimer;//交互线控制

@property (nonatomic, strong) OverallObject *overall;

@end

@implementation ScanRobotViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setToolClass];
    [self setAdjustUI];
    [self setOverlayPickerView];
    [self startSYQRCodeReading];
}

- (void)setToolClass
{
    CGRect rect = [UIScreen mainScreen].bounds;
    kLWidth = rect.size.width/2;
    kLineMinY = (rect.size.height-kLWidth)/2-2;
    kLineMaxY = (rect.size.height-kLWidth)/2+kLWidth+5;
    self.overall = [OverallObject sharedLoginInfo];
}

#pragma mark -
#pragma mark 输出代理方法
//此方法是在识别到QRCode，并且完成转换
//如果QRCode的内容越大，转换需要的时间就越长
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    //扫描结果
    if (metadataObjects.count > 0)
    {
        [self stopSYQRCodeReading];
        
        AVMetadataMachineReadableCodeObject *obj = metadataObjects[0];
        
        if (obj.stringValue && ![obj.stringValue isEqualToString:@""] && obj.stringValue.length > 0)
        {
            NSLog(@"扫描结果：%@",obj.stringValue);
            if ([obj.stringValue containsString:@"http"])
            {
                if (self.ScanRobotSuncessBlock) {
                    //扫码到的URL跳转
                    [[UIApplication sharedApplication] openURL: [ NSURL URLWithString:obj.stringValue]];
                    self.ScanRobotSuncessBlock(self,obj.stringValue);
                }
            }else{
                if (self.ScanRobotFailBlock) {
                    self.ScanRobotFailBlock(self);
                }
            }
        }else{
            if (self.ScanRobotFailBlock) {
                self.ScanRobotFailBlock(self);
            }
        }
    }else{
        if (self.ScanRobotFailBlock) {
            self.ScanRobotFailBlock(self);
        }
    }
}


- (void)setAdjustUI
{
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    //摄像头判断
    NSError *error = nil;
    
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    
    if (error)
    {
        NSLog(@"没有摄像头-%@", error.localizedDescription);
        return;
    }
    
    //设置输出(Metadata元数据)
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
    
    //设置输出的代理
    //使用主线程队列，相应比较同步，使用其他队列，相应不同步，容易让用户产生不好的体验
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    [output setRectOfInterest:[self getReaderViewBoundsWithSize:CGSizeMake(kReaderViewWidth, kReaderViewHeight)]];
    
    //拍摄会话
    AVCaptureSession *session = [[AVCaptureSession alloc] init];
    
    // 读取质量，质量越高，可读取小尺寸的二维码
    if ([session canSetSessionPreset:AVCaptureSessionPreset1920x1080])
    {
        [session setSessionPreset:AVCaptureSessionPreset1920x1080];
    }
    else if ([session canSetSessionPreset:AVCaptureSessionPreset1280x720])
    {
        [session setSessionPreset:AVCaptureSessionPreset1280x720];
    }
    else
    {
        [session setSessionPreset:AVCaptureSessionPresetPhoto];
    }
    
    if ([session canAddInput:input])
    {
        [session addInput:input];
    }
    
    if ([session canAddOutput:output])
    {
        [session addOutput:output];
    }
    
    //设置输出的格式
    //一定要先设置会话的输出为output之后，再指定输出的元数据类型
    [output setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
    
    //设置预览图层
    AVCaptureVideoPreviewLayer *preview = [AVCaptureVideoPreviewLayer layerWithSession:session];
    
    //设置preview图层的属性
    //preview.borderColor = [UIColor redColor].CGColor;
    //preview.borderWidth = 1.5;
    [preview setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    
    //设置preview图层的大小
    preview.frame = self.view.layer.bounds;
    //[preview setFrame:CGRectMake(0, 0, kDeviceWidth, KDeviceHeight)];
    
    //将图层添加到视图的图层
    [self.view.layer insertSublayer:preview atIndex:0];
    //[self.view.layer addSublayer:preview];
    self.qrVideoPreviewLayer = preview;
    self.qrSession = session;
}

- (CGRect)getReaderViewBoundsWithSize:(CGSize)asize
{
    return CGRectMake(kLineMinY / KDeviceHeight, ((kDeviceWidth - asize.width) / 2.0) / kDeviceWidth, asize.height / KDeviceHeight, asize.width / kDeviceWidth);
}

- (void)setOverlayPickerView
{
    CGFloat alphaValue = 0.4;
    
    CGRect rect = [UIScreen mainScreen].bounds;
    CGFloat width = kLWidth;
    CGFloat lineWidth;
    
    if ([self.overall.pubMethod getDeviceType:rect.size.height]>5) {
        lineWidth = kLWidth+25;
    }else if ([self.overall.pubMethod getDeviceType:rect.size.height]==5){
        lineWidth = kLWidth+35;
    }else{
        lineWidth = kLWidth;
    }
    
    //画中间的基准线
    _line = [[UIImageView alloc] initWithFrame:CGRectMake((kDeviceWidth - lineWidth) / 2.0, kLineMinY, lineWidth, 12 * lineWidth / 320.0)];
    [_line setImage:[UIImage imageNamed:@"scan1"]];
    [self.view addSubview:_line];
    
    UIView *scanCropView = [[UIView alloc] initWithFrame:CGRectMake((rect.size.width-width)/2, (rect.size.height-width)/2, width, width)];
    [scanCropView setFrame:CGRectMake(scanCropView.frame.origin.x-6.5, scanCropView.frame.origin.y-7.5, scanCropView.frame.size.width+13, scanCropView.frame.size.height+13)];
    scanCropView.layer.borderColor = [UIColor whiteColor].CGColor;
    scanCropView.layer.borderWidth = 0.3;
    [self.view addSubview:scanCropView];
    
    //最上部view
    UIView* upView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, scanCropView.frame.origin.y)];//80
    upView.alpha = alphaValue;
    upView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:upView];
    
    //左侧的view
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, scanCropView.frame.origin.y, scanCropView.frame.origin.x, scanCropView.frame.size.height)];
    leftView.alpha = alphaValue;
    leftView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:leftView];

    //右侧的view
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(scanCropView.frame.origin.x+scanCropView.frame.size.width, scanCropView.frame.origin.y, rect.size.width-(scanCropView.frame.origin.x+scanCropView.frame.size.width), scanCropView.frame.size.height)];
    rightView.alpha = alphaValue;
    rightView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:rightView];

    //底部view
    UIView *downView = [[UIView alloc] initWithFrame:CGRectMake(0, scanCropView.frame.origin.y+scanCropView.frame.size.height, rect.size.width, rect.size.height-( scanCropView.frame.origin.y))];
    downView.alpha = alphaValue;
    downView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:downView];
    
    //说明label
    UILabel *labIntroudction = [[UILabel alloc] initWithFrame:CGRectMake(0, scanCropView.frame.origin.y+scanCropView.frame.size.height+40, rect.size.width, 40)];
    labIntroudction.backgroundColor = [UIColor clearColor];
    labIntroudction.textAlignment = NSTextAlignmentCenter;
    labIntroudction.font = [UIFont systemFontOfSize:14];
    labIntroudction.textColor = [UIColor whiteColor];
    labIntroudction.text = @"将二维码置于框内,即可自动扫描";
    [self.view addSubview:labIntroudction];
    
    
    CGFloat iwidth = 20;
    //四个边角
    UIImage *cornerImage = [UIImage imageNamed:@"QRCodeTopLeft"];
    
    //左侧的imageView
    UIImageView *leftView_image = [[UIImageView alloc] initWithFrame:CGRectMake(scanCropView.frame.origin.x-1, scanCropView.frame.origin.y-1, iwidth, iwidth)];
    leftView_image.image = cornerImage;
    [self.view addSubview:leftView_image];

    //右侧的imageView
    cornerImage = [UIImage imageNamed:@"QRCodeTopRight"];
    UIImageView *rightView_image = [[UIImageView alloc] initWithFrame:CGRectMake(scanCropView.frame.origin.x+scanCropView.frame.size.width-iwidth+1, scanCropView.frame.origin.y-1, iwidth, iwidth)];
    rightView_image.image = cornerImage;
    [self.view addSubview:rightView_image];

    //底部左边imageView
    cornerImage = [UIImage imageNamed:@"QRCodebottomLeft"];
    UIImageView *downView_image = [[UIImageView alloc] initWithFrame:CGRectMake(scanCropView.frame.origin.x-1, scanCropView.frame.origin.y+scanCropView.frame.size.height-iwidth+1, iwidth, iwidth)];
    downView_image.image = cornerImage;
    [self.view addSubview:downView_image];

    //底部右侧imageView
    cornerImage = [UIImage imageNamed:@"QRCodebottomRight"];
    UIImageView *downViewRight_image = [[UIImageView alloc] initWithFrame:CGRectMake(rightView_image.frame.origin.x, downView_image.frame.origin.y, iwidth, iwidth)];
    downViewRight_image.image = cornerImage;
    [self.view addSubview:downViewRight_image];
    
    
    //tabbar
    [self.view setBackgroundColor:[UIColor colorWithRed:239/255.0 green:239/255.0 blue:246/255.0 alpha:1]];
    [self.view addSubview:[self.overall.pubAttr.pulicViewModel setTabBarView:@"扫描机器人"]];
    
    UIButton *goBackBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 15, 60, 60)];
    [goBackBtn setImage:[UIImage imageNamed:goBackIcon] forState:UIControlStateNormal];
    [goBackBtn addTarget:self action:@selector(cancleSYQRCodeReading) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:goBackBtn];
    
}

//- (void)setOverlayPickerView
//{
//    CGFloat alphaValue = 0.4;
//    //画中间的基准线
//    _line = [[UIImageView alloc] initWithFrame:CGRectMake((kDeviceWidth - 300) / 2.0, kLineMinY, 300, 12 * 300 / 320.0)];
//    [_line setImage:[UIImage imageNamed:@"scan"]];
//    [self.view addSubview:_line];
//    
//    //最上部view
//    UIView* upView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kLineMinY)];//80
//    upView.alpha = alphaValue;
//    upView.backgroundColor = [UIColor blackColor];
//    [self.view addSubview:upView];
//    
//    //左侧的view
//    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, kLineMinY, (kDeviceWidth - kReaderViewWidth) / 2.0, kReaderViewHeight)];
//    leftView.alpha = alphaValue;
//    leftView.backgroundColor = [UIColor blackColor];
//    [self.view addSubview:leftView];
//    
//    //右侧的view
//    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(kDeviceWidth - CGRectGetMaxX(leftView.frame), kLineMinY, CGRectGetMaxX(leftView.frame), kReaderViewHeight)];
//    rightView.alpha = alphaValue;
//    rightView.backgroundColor = [UIColor blackColor];
//    [self.view addSubview:rightView];
//    
//    CGFloat space_h = KDeviceHeight - kLineMaxY;
//    
//    //底部view
//    UIView *downView = [[UIView alloc] initWithFrame:CGRectMake(0, kLineMaxY, kDeviceWidth, space_h)];
//    downView.alpha = alphaValue;
//    downView.backgroundColor = [UIColor blackColor];
//    [self.view addSubview:downView];
//    
//    
//    
//    //四个边角
//    UIImage *cornerImage = [UIImage imageNamed:@"QRCodeTopLeft"];
//    
//    //左侧的view
//    UIImageView *leftView_image = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(leftView.frame) - cornerImage.size.width / 2.0, CGRectGetMaxY(upView.frame) - cornerImage.size.height / 2.0, cornerImage.size.width, cornerImage.size.height)];
//    leftView_image.image = cornerImage;
//    //    [self.view addSubview:leftView_image];
//    
//    cornerImage = [UIImage imageNamed:@"QRCodeTopRight"];
//    
//    //右侧的view
//    UIImageView *rightView_image = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(rightView.frame) - cornerImage.size.width / 2.0, CGRectGetMaxY(upView.frame) - cornerImage.size.height / 2.0, cornerImage.size.width, cornerImage.size.height)];
//    rightView_image.image = cornerImage;
//    //    [self.view addSubview:rightView_image];
//    
//    cornerImage = [UIImage imageNamed:@"QRCodebottomLeft"];
//    
//    //底部view
//    UIImageView *downView_image = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(leftView.frame) - cornerImage.size.width / 2.0, CGRectGetMinY(downView.frame) - cornerImage.size.height / 2.0, cornerImage.size.width, cornerImage.size.height)];
//    downView_image.image = cornerImage;
//    //downView.backgroundColor = [UIColor blackColor];
//    //    [self.view addSubview:downView_image];
//    
//    cornerImage = [UIImage imageNamed:@"QRCodebottomRight"];
//    
//    UIImageView *downViewRight_image = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(rightView.frame) - cornerImage.size.width / 2.0, CGRectGetMinY(downView.frame) - cornerImage.size.height / 2.0, cornerImage.size.width, cornerImage.size.height)];
//    downViewRight_image.image = cornerImage;
//    //downView.backgroundColor = [UIColor blackColor];
//    //    [self.view addSubview:downViewRight_image];
//    
//    //说明label
//    UILabel *labIntroudction = [[UILabel alloc] init];
//    labIntroudction.backgroundColor = [UIColor clearColor];
//    labIntroudction.frame = CGRectMake(CGRectGetMaxX(leftView.frame), CGRectGetMinY(downView.frame) + 25, kReaderViewWidth, 20);
//    labIntroudction.textAlignment = NSTextAlignmentCenter;
//    labIntroudction.font = [UIFont systemFontOfSize:14];
//    labIntroudction.textColor = [UIColor whiteColor];
//    labIntroudction.text = @"将二维码置于框内,即可自动扫描";
//    [self.view addSubview:labIntroudction];
//    
//    UIView *scanCropView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(leftView.frame) - 1,kLineMinY,self.view.frame.size.width - 2 * CGRectGetMaxX(leftView.frame) + 2, kReaderViewHeight + 2)];
//    [scanCropView setFrame:CGRectMake(scanCropView.frame.origin.x-6.5, scanCropView.frame.origin.y-7.5, scanCropView.frame.size.width+13, scanCropView.frame.size.height+13)];
//    scanCropView.layer.borderColor = [UIColor grayColor].CGColor;
//    scanCropView.layer.borderWidth = 0.3;
//    [scanCropView setBackgroundColor:[UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:0.2]];
//    [self.view addSubview:scanCropView];
//    
//    
//    [self.view addSubview:leftView_image];
//    [self.view addSubview:downView_image];
//    [self.view addSubview:rightView_image];
//    [self.view addSubview:downViewRight_image];
//}

#pragma mark -
#pragma mark 交互事件
- (void)startSYQRCodeReading
{
    _lineTimer = [NSTimer scheduledTimerWithTimeInterval:0.01f target:self selector:@selector(animationLine) userInfo:nil repeats:YES];
    [self.qrSession startRunning];
    NSLog(@"start reading");
}

- (void)stopSYQRCodeReading
{
    if (_lineTimer)
    {
        [_lineTimer invalidate];
        _lineTimer = nil;
    }
    [self.qrSession stopRunning];
    NSLog(@"stop reading");
}

//取消扫描
- (void)cancleSYQRCodeReading
{
    [self stopSYQRCodeReading];
    if (self.ScanRobotCancleBlock)
    {
        self.ScanRobotCancleBlock(self);
    }
    NSLog(@"cancle reading");
}

#pragma mark -
#pragma mark 上下滚动交互线
- (void)animationLine
{
    __block CGRect frame = _line.frame;
    static BOOL flag = YES;
    if (flag)
    {
        frame.origin.y = kLineMinY;
        flag = NO;
        
        [UIView animateWithDuration:1.0 / 20 animations:^{
            
            frame.origin.y += 1;
            _line.frame = frame;
            
        } completion:nil];
    }else{
        if (_line.frame.origin.y >= kLineMinY)
        {
            if (_line.frame.origin.y >= kLineMaxY - 12)
            {
                frame.origin.y = kLineMinY;
                _line.frame = frame;
                flag = YES;
            }else{
                [UIView animateWithDuration:1.0 / 20 animations:^{
                    frame.origin.y += 1;
                    _line.frame = frame;
                } completion:nil];
            }
        }else{
            flag = !flag;
        }
    }
}

@end
