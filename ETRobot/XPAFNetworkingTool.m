//
//  XPAFNetworkingTool.m
//  PIRO
//
//  Created by IHOME on 15/11/25.
//  Copyright (c) 2015年 IHOME. All rights reserved.
//

#import "XPAFNetworkingTool.h"

@interface XPAFNetworkingTool ()

@property (nonatomic, strong) OverallObject *login;

@end

@implementation XPAFNetworkingTool

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.login = [OverallObject sharedLoginInfo];
    }
    return self;
}

#pragma mark post访问服务器
- (void)postVisitServiceWithURL:(NSString *)url argsDict:(NSDictionary *)argsDict timeoutInterval:(NSTimeInterval)timeoutInterval tag:(NSInteger)tag
{
    if ([self.login.pubMethod isConnectionAvailable]) {
        [self.login.pubAttr.manager POST:url parameters:argsDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSString *code = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"resultCode"]];
            NSLog(@"responseObject:%@  \n code:%@ ",responseObject,code);
            if ([code isEqualToString:@"00"]) {
                [self.delegate postVisitServiceSuccessServiceData:responseObject tag:tag];
            }else{
                [self.delegate postVisitServiceFailTag:tag];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [SVProgressHUD showErrorWithStatus:NONETPROMPT];
        } timeoutInterval:timeoutInterval];
    }else{
        [SVProgressHUD showErrorWithStatus:NONETPROMPT];
    }
}

@end
