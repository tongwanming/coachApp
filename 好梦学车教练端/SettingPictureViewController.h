//
//  SettingPictureViewController.h
//  好梦学车
//
//  Created by haomeng on 2017/6/1.
//  Copyright © 2017年 haomeng. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ChooicePictureViewController.h"



@interface SettingPictureViewController : UIViewController
@property (nonatomic , assign)id <ChooicePictureViewControllerDelegate> delegate;
@property (nonatomic , assign)NSInteger maxChoiceImageNumberumber;
@end
