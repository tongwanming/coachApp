//
//  ChooicePictureViewController.h
//  好梦学车
//
//  Created by haomeng on 2017/6/1.
//  Copyright © 2017年 haomeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>


@class ChooicePictureViewController;

@protocol ChooicePictureViewControllerDelegate <NSObject>

- (void)WHCChoicePictureVC:(ChooicePictureViewController *)choicePictureVC didSelectedPhoto:(UIImage *)image;

@end

@interface ChooicePictureViewController : UIViewController

@property (nonatomic , assign)id <ChooicePictureViewControllerDelegate> delegate;
@property (nonatomic , assign)NSInteger maxChoiceImageNumber;
@property (nonatomic , strong) ALAssetsGroup  * assetsGroup;

@end
