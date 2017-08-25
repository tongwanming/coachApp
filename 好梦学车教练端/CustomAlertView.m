//
//  CustomAlertView.m
//  好梦学车
//
//  Created by haomeng on 2017/6/2.
//  Copyright © 2017年 haomeng. All rights reserved.
//

#import "CustomAlertView.h"

#define POPVIEWWIDTH 155
#define POPVIEWHEIGHT 155

#define POPVIEWWIDTHBLACK 100
#define POPVIEWHEIGHTBLACK 100

#define ILDSALERTVIEWSIZE [[UIScreen mainScreen]bounds].size

@implementation CustomAlertView
{

    UIViewController *_controller;
    UILabel *titleLabel;
}

+ (CustomAlertView *)defaultManager{
    static CustomAlertView *defaultManager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        defaultManager = [[CustomAlertView alloc] init];
    });
    return defaultManager;
}



- (instancetype)initAlertViewVC:(UIViewController *)vc{
    if (self = [super init]) {
        for (UIView *v in vc.view.window.subviews) {
            if ([v isKindOfClass:[CustomAlertView class]]) {
                return nil;
            }
        }
        
        _controller = vc;
        self.frame = [UIScreen mainScreen].applicationFrame;
        self.backgroundColor = [UIColor clearColor];
        [vc.view addSubview:self];
//        self.backgroundColor = [UIColor redColor];
        
        [self initWithEmptySubViewBlack];
        titleLabel.textColor = [UIColor grayColor];
        titleLabel.text = @"Loading...";
        [self loadingAnimationShow:YES];
        
    }
    return self;

}

+ (CustomAlertView *)showAlertViewWithVC:(UIViewController *)vc{
    return [[CustomAlertView defaultManager] initAlertViewVC:vc];
}

- (void)initWithEmptySubViewBlack{
    _popView2 = [[UIView alloc] init];
    _popView2.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.38];
    _popView2.layer.cornerRadius = 10;
    _popView2.layer.masksToBounds = YES;
    _popView2.alpha =0;
    [self addSubview:_popView2];
    _popView2.frame = CGRectMake(ILDSALERTVIEWSIZE.width/2-POPVIEWHEIGHTBLACK/2, ILDSALERTVIEWSIZE.height/2-POPVIEWHEIGHTBLACK/2, POPVIEWWIDTHBLACK, POPVIEWHEIGHTBLACK);
    
    UIVisualEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    self.visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blur];
    _visualEffectView.contentView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    _visualEffectView.contentView.alpha = 0.7;
    _visualEffectView.layer.cornerRadius = 10;
    _visualEffectView.layer.masksToBounds = YES;
    _visualEffectView.contentView.layer.cornerRadius = 10;
    _visualEffectView.contentView.layer.masksToBounds = YES;
    [self addSubview:_visualEffectView];
    _visualEffectView.frame = _popView2.frame;
    
    _popView = [[UIView alloc] init];
    //        _popView.backgroundColor = [UIColor colorWithRed:0.78f green:0.77f blue:0.78f alpha:0.30f];
    _popView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.38f];
    _popView.layer.cornerRadius = 10;
    _popView.layer.masksToBounds = YES;
    [self addSubview:_popView];
    _popView.frame = _popView2.frame;
    
    titleLabel = [[UILabel alloc] init];
    titleLabel.frame = CGRectMake(0, _popView.frame.size.height-30, _popView.frame.size.width, 20);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
    titleLabel.textColor = [UIColor whiteColor];
    [_popView addSubview:titleLabel];
}

//loading部分(不可取消)
- (void)loadingAnimationShow:(BOOL)show{
    if (show) {
        _activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        _activity.frame = CGRectMake(_popView.frame.size.width/2-50, _popView.frame.size.height/2-60, 100, 100);
        [_popView addSubview:_activity];
//        [_activity mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerX.mas_equalTo(_popView.mas_centerX);
//            make.centerY.mas_equalTo(_popView.mas_centerY).offset(-10);
//            make.width.mas_equalTo(100);
//            make.height.mas_equalTo(100);
//        }];
        [_activity startAnimating];
        [UIView animateWithDuration:1 animations:^{
            
        } completion:^(BOOL finished) {
            
        }];
    }else{
        [UIView animateWithDuration:1 animations:^{
            _visualEffectView.alpha = 0;
            _visualEffectView.contentView.alpha = 0;
            _popView2.alpha = 0;
            _popView.alpha = 0;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
            [_popView removeFromSuperview];
            [_popView2 removeFromSuperview];
            [_visualEffectView removeFromSuperview];
            [_activity removeFromSuperview];
            [_activity stopAnimating];
        }];
    }
}

+ (BOOL)hideAlertView{
    [[self defaultManager] cancleAlertLoading];
    return YES;
}

- (void)cancleAlertLoading{
    for (UIView *view1 in _controller.view.subviews) {
        if ([view1 isKindOfClass:[CustomAlertView class]]) {
            CustomAlertView *alertView = (CustomAlertView *)view1;
            [UIView animateWithDuration:0.5 animations:^{
                alertView.visualEffectView.alpha = 0;
                alertView.visualEffectView.contentView.alpha = 0;
                alertView.popView.alpha = 0;
                alertView.popView2.alpha = 0;
                alertView.activity.alpha = 0;
            } completion:^(BOOL finished) {
                [view1 removeFromSuperview];
            }];
        }
    }
}
@end
