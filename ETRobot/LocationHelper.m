//
//  LocationHelper.m
//  ETRobot
//
//  Created by IHOME on 16/5/6.
//  Copyright © 2016年 IHOME. All rights reserved.
//

#import "LocationHelper.h"

@interface LocationHelper ()<CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *mgr;
@property (nonatomic, strong) CLGeocoder *geocoder;
@property (nonatomic, strong) OverallObject *overall;

@end

@implementation LocationHelper

static LocationHelper *locationHelper;

+ (LocationHelper *) sharedInstance
{
    if (locationHelper == nil)
    {
        locationHelper = [[LocationHelper alloc] init];
    }
    return locationHelper;
}

- (LocationHelper*) init
{
    if (self = [super init])
    {
        self.overall = [OverallObject sharedLoginInfo];
        
        self.mgr = [[CLLocationManager alloc]init];
        self.mgr.delegate = self;
        self.mgr.distanceFilter = 20;
        [self.mgr setDesiredAccuracy:kCLLocationAccuracyBest];
        // 判断是否是iOS8
        if([[UIDevice currentDevice].systemVersion doubleValue] >= 8.0)
        {
            // 主动要求用户对我们的程序授权, 授权状态改变就会通知代理
            [self.mgr requestAlwaysAuthorization]; // 请求前台和后台定位权限
            //        [self.mgr requestWhenInUseAuthorization];// 请求前台定位权限
        }else
        {
            // 3.开始监听(开始获取位置)
            [self.mgr startUpdatingLocation];
        }
    }
    return self;
}

#pragma mark 定位当前位置
- (void)locationCurrentPlace
{
    // 开始监听(开始获取位置)
    [self.mgr startUpdatingLocation];
}

#pragma mark - 懒加载
- (CLGeocoder *)geocoder
{
    if (_geocoder == nil) {
        _geocoder = [[CLGeocoder alloc] init];
    }
    return _geocoder;
}

/**
 *  授权状态发生改变时调用
 *
 *  @param manager 触发事件的对象
 *  @param status  当前授权的状态
 */
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    /*
     用户从未选择过权限
     kCLAuthorizationStatusNotDetermined
     无法使用定位服务，该状态用户无法改变
     kCLAuthorizationStatusRestricted
     用户拒绝该应用使用定位服务，或是定位服务总开关处于关闭状态
     kCLAuthorizationStatusDenied
     已经授权（废弃）
     kCLAuthorizationStatusAuthorized
     用户允许该程序无论何时都可以使用地理信息
     kCLAuthorizationStatusAuthorizedAlways
     用户同意程序在可见时使用地理位置
     kCLAuthorizationStatusAuthorizedWhenInUse
     */
    
    if (status == kCLAuthorizationStatusNotDetermined) {
        //        NSLog(@"等待用户授权");
    }else if (status == kCLAuthorizationStatusAuthorizedAlways ||
              status == kCLAuthorizationStatusAuthorizedWhenInUse)
    {
        //        NSLog(@"授权成功");
        // 开始定位
        [self.mgr startUpdatingLocation];
    }else{
        //        NSLog(@"授权失败");
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    [self.mgr stopUpdatingLocation];
    // 1.获取用户位置的对象
    CLLocation *location = [locations lastObject];
    CLLocation *loc = [location locationMarsFromEarth];
    CLLocationCoordinate2D coordinate = loc.coordinate;
    self.overall.pubAttr.latitudeValue = [NSString stringWithFormat:@"%f",coordinate.latitude];
    self.overall.pubAttr.longtitudeValue = [NSString stringWithFormat:@"%f",coordinate.longitude];
    NSLog(@"纬度lat:%f 经度lon:%f", coordinate.latitude, coordinate.longitude);
    NSLog(@"纬度lat:%@ 经度lon:%@", self.overall.pubAttr.latitudeValue, self.overall.pubAttr.longtitudeValue);
    [self reverseGeocodeWithLocation:loc];
}

- (void)reverseGeocodeWithLocation:(CLLocation *)location
{
    [self.geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        for (CLPlacemark *placemark in placemarks) {
            self.overall.pubAttr.locationAddress = placemark.name;
            NSLog(@"%@,%@", self.overall.pubAttr.locationAddress,placemark.name);
        }
    }];
}


- (void)reverseGeocode:(double)latitude longtitude:(double)longtitude
{
    // 2.根据用户输入的经纬度创建CLLocation对象
    CLLocation *location = [[CLLocation alloc] initWithLatitude:latitude longitude:longtitude];
    
    // 3.根据CLLocation对象获取对应的地标信息
    [self.geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        for (CLPlacemark *placemark in placemarks) {
            self.overall.pubAttr.locationAddress = placemark.name;
            NSLog(@"%@,%@", self.overall.pubAttr.locationAddress,placemark.name);
        }
    }];
}


@end
