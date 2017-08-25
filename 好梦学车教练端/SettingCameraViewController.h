//
//  SettingCameraViewController.h
//  好梦学车
//
//  Created by haomeng on 2017/6/1.
//  Copyright © 2017年 haomeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SettingCameraViewController;
@protocol SettingCameraViewControllerDelegate <NSObject>

- (void)SettingCameraViewController:(SettingCameraViewController *)vc andSelectedPhone:(UIImage *)image;

@end

@interface SettingCameraViewController : UIViewController

@property (nonatomic, weak) id<SettingCameraViewControllerDelegate>delegate;

@end
