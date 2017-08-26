//
//  learningViewController.h
//  好梦学车教练端
//
//  Created by haomeng on 2017/8/14.
//  Copyright © 2017年 haomeng. All rights reserved.
//

#import "BasicViewController.h"
#import "StudentNewsModel.h"

@protocol learningViewControllerDelegate <NSObject>

- (void)learningViewControllerBtnClickWihtBtn:(UIButton *)btn;

@end

@interface learningViewController : BasicViewController
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UIView *view2;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UIView *subView;


@property (nonatomic, weak) id<learningViewControllerDelegate>delegate;

- (void)choosedPersonBlock:(void(^)(StudentNewsModel *model))block;

@end
