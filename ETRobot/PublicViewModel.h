//
//  PublicViewModel.h
//  ETRobot
//
//  Created by IHOME on 16/4/28.
//  Copyright © 2016年 IHOME. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PublicViewModel : NSObject

- (UIView *)setTabBarView:(NSString *)text;
- (UITextField *)setTextFieldViewWithFrame:(CGRect)frame textValue:(NSString *)textValue placeholderValue:(NSString *)placeholderValue pwd:(BOOL)pwd;
- (UILabel *)setLabelWithFrame:(CGRect)frame textValue:(NSString *)textValue fontSize:(CGFloat)fontSize;
- (XPTabBarViewController *)setTabBar;

@end
