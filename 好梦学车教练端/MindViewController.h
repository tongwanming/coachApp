//
//  MindViewController.h
//  好梦学车教练端
//
//  Created by haomeng on 2017/8/10.
//  Copyright © 2017年 haomeng. All rights reserved.
//

#import "BasicViewController.h"

@interface MindViewController : BasicViewController
@property (weak, nonatomic) IBOutlet UIButton *recordLearn;
@property (weak, nonatomic) IBOutlet UIButton *recordExam;
@property (weak, nonatomic) IBOutlet UIButton *resaveBtn;
@property (weak, nonatomic) IBOutlet UIView *learnView;
@property (weak, nonatomic) IBOutlet UIView *examView;
@property (weak, nonatomic) IBOutlet UIView *mindSubView;

@end
