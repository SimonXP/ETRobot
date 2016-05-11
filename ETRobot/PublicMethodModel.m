//
//  PublicMethodModel.m
//  ETRobot
//
//  Created by IHOME on 16/4/28.
//  Copyright © 2016年 IHOME. All rights reserved.
//

#import "PublicMethodModel.h"

#define EARTH_RADIUS  6378.137
#define PI 3.1415926


@interface PublicMethodModel ()

@property (nonatomic, strong) UserInfoOperate *userInfoOperate;

@end

@implementation PublicMethodModel

#pragma mark 获取当前用户
- (UserInfo *)getCurrentUserWithAccount:(NSString *)userAccount
{
    return [self.userInfoOperate selectUserInfoWithAccount:userAccount];
}

#pragma mark 网络验证
- (BOOL)isConnectionAvailable
{
    BOOL isExistenceNetwork = YES;
    Reachability *reach = [Reachability reachabilityWithHostName:@"www.apple.com"];
    switch ([reach currentReachabilityStatus]) {
        case NotReachable:
            isExistenceNetwork = NO;
            NSLog(@"notReachable");
            break;
        case ReachableViaWiFi:
            isExistenceNetwork = YES;
            NSLog(@"WIFI");
            break;
        case ReachableViaWWAN:
            isExistenceNetwork = YES;
            NSLog(@"3G");
            break;
    }
    return isExistenceNetwork;
}

#pragma mark 对图片尺寸进行压缩
- (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark 判断是否为邮箱
- (BOOL)isValidateEmail:(NSString *)Email
{
    NSString *emailCheck = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",emailCheck];
    return [emailTest evaluateWithObject:Email];
}

#pragma mark 正则判断手机号码地址格式
- (BOOL)isMobileNumber:(NSString *)mobileNum
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

#pragma mark 绑定账号
- (NSString *)clientBindAccount:(NSString *)account
{
    NSString *time = [NSString stringWithFormat:@"<timestamp>%@</timestamp>",[self getTimeInterval]];
    NSMutableString *xmlBody=[[NSMutableString alloc] init];
    [xmlBody appendFormat:@"%@",@"<?xml version=\"1.0\" encoding=\"UTF-8\"?>"];
    [xmlBody appendString:@"<sent>"];
    [xmlBody appendFormat:@"<key>client_bind</key>"];
    [xmlBody appendFormat:time];
    [xmlBody appendString:@"<data>"];
    [xmlBody appendFormat:@"<account>%@</account>",account];
    [xmlBody appendFormat:@"<deviceId>10201</deviceId>"];
    [xmlBody appendFormat:@"<channel>IOS</channel>"];
    [xmlBody appendFormat:@"<device>IPHONE6S</device>"];
    [xmlBody appendString:@"</data>"];
    [xmlBody appendString:@"</sent>\b"];
    return xmlBody;
}

#pragma mark 发送心跳包
- (NSString *)clientHeartbeat
{
    NSString *time = [NSString stringWithFormat:@"<timestamp>%@</timestamp>",[self getTimeInterval]];
    
    NSMutableString *xmlBody=[[NSMutableString alloc] init];
    [xmlBody appendFormat:@"%@",@"<?xml version=\"1.0\" encoding=\"UTF-8\"?>"];
    [xmlBody appendString:@"<sent>"];
    [xmlBody appendFormat:@"<key>client_heartbeat</key>"];
    [xmlBody appendFormat:time];
    [xmlBody appendString:@"<data>"];
    [xmlBody appendString:@"</data>"];
    [xmlBody appendString:@"</sent>\b"];
    return xmlBody;
}

#pragma mark 获取时间戳
- (NSString *)getTimeInterval
{
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970]*1000;
    NSString *timeString = [[NSString stringWithFormat:@"%f",a] componentsSeparatedByString:@"."][0];//转为字符型
    NSLog(@"当前的时间戳:%@",timeString);
    
    return timeString;
}

#pragma mark 获取geohash
-(NSString *)getGeoHashesWithLatitude:(NSString *)latitude longitude:(NSString *)longitude
{
    NSString *geohash;
    
    return geohash;
}



#pragma mark 获取两个位置的距离
- (double)getTwoSpotDistance:(double)lat1 lng1:(double)lng1 lat2:(double)lat2 lng2:(double) lng2
{
    double a = [self rad:lat1] - [self rad:lat2];
    double b = [self rad:lng1] - [self rad:lng2];
    double s = 2 * asin(sqrt(pow(sin(a/2),2) + cos([self rad:lat1])*cos([self rad:lat2])*pow(sin(b/2),2)));
    s = s * EARTH_RADIUS;
    return s;
}
- (double)rad:(double)d
{
    return d * PI / 180.0;
}

#pragma mark 加密获取MD5值
- (NSString *)md5:(NSString *)str
{
    // This is the md5 call
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, strlen(cStr), result);
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

//获取两个时间点之间的毫秒数
- (UInt64)millisecondValueWithDate1:(NSDate *)date1 date2:(NSDate *)date2
{
    UInt64 msecond1 = [date1 timeIntervalSince1970]*1000;
    UInt64 msecond2 = [date2 timeIntervalSince1970]*1000;
    NSLog(@"%lld --- %lld  ===== %lld",msecond1,msecond2,msecond2 - msecond1);
    return msecond2 - msecond1;
}

#pragma mark 判断设备型号
- (NSInteger)getDeviceType:(CGFloat)height
{
    if (height == 480) {
        return 4;
    }else if (height == 568){
        return 5;
    }else if (height == 667){
        return 6;
    }else {
        return 7;
    }
}

@end
