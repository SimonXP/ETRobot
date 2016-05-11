//
//  XPAFNetworkingTool.h
//  PIRO
//
//  Created by IHOME on 15/11/25.
//  Copyright (c) 2015年 IHOME. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol XPAFNetworkingToolDelegate <NSObject>

@optional
- (void)postVisitServiceSuccessServiceData:(id)serviceData tag:(NSInteger)tag;
- (void)postVisitServiceFailTag:(NSInteger)tag;

@end

@interface XPAFNetworkingTool : NSObject

@property (nonatomic, weak) id<XPAFNetworkingToolDelegate> delegate;

- (void)postVisitServiceWithURL:(NSString *)url argsDict:(NSDictionary *)argsDict timeoutInterval:(NSTimeInterval)timeoutInterval tag:(NSInteger)tag;

@end
