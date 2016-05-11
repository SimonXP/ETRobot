//
//  PublicMethodModel.h
//  ETRobot
//
//  Created by IHOME on 16/4/28.
//  Copyright © 2016年 IHOME. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PublicMethodModel : NSObject

#pragma mark 获取当前用户
- (UserInfo *)getCurrentUserWithAccount:(NSString *)userAccount;

#pragma mark 网络验证
- (BOOL)isConnectionAvailable;

#pragma mark 对图片尺寸进行压缩
-(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize;

#pragma mark 判断是否为邮箱
- (BOOL)isValidateEmail:(NSString *)Email;

#pragma mark 正则判断手机号码地址格式
- (BOOL)isMobileNumber:(NSString *)mobileNum;

#pragma mark 获取时间戳
- (NSString *)getTimeInterval;

#pragma mark 获取geohash
-(NSString *)getGeoHashesWithLatitude:(NSString *)latitude longitude:(NSString *)longitude;

#pragma mark 获取两个位置的距离
- (double)getTwoSpotDistance:(double)lat1 lng1:(double)lng1 lat2:(double)lat2 lng2:(double) lng2;

#pragma mark 加密获取MD5值
- (NSString *)md5:(NSString *)str;

#pragma mark 获取两个时间点之间的毫秒数
- (UInt64)millisecondValueWithDate1:(NSDate *)date1 date2:(NSDate *)date2;

#pragma mark 判断设备型号
- (NSInteger)getDeviceType:(CGFloat)height;

@end
