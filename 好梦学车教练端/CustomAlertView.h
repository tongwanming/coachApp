//
//  CustomAlertView.h
//  好梦学车
//
//  Created by haomeng on 2017/6/2.
//  Copyright © 2017年 haomeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomAlertView : UIView

@property (nonatomic, strong) UIVisualEffectView *visualEffectView;
@property (nonatomic, strong) UIView *popView2;
@property (nonatomic, strong) UIView *popView;
@property (nonatomic, strong) UIActivityIndicatorView *activity;
//@property (nonatomic, weak) id<ILDSAlertViewDelegate>delegate;
@property (nonatomic, assign) BOOL isCancelLoadingShow;

+ (CustomAlertView *)defaultManager;

+ (CustomAlertView *)showAlertViewWithVC:(UIViewController *)vc;

- (instancetype)initAlertViewVC:(UIViewController *)vc;

+ (BOOL)hideAlertView;

@end
