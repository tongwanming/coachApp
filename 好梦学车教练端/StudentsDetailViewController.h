//
//  StudentsDetailViewController.h
//  好梦学车教练端
//
//  Created by haomeng on 2017/8/15.
//  Copyright © 2017年 haomeng. All rights reserved.
//

#import "BasicViewController.h"

#import "StudentNewsModel.h"

@interface StudentsDetailViewController : BasicViewController
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIButton *btn2;
@property (weak, nonatomic) IBOutlet UIButton *btn3;
@property (weak, nonatomic) IBOutlet UILabel *progressLabel;
@property (weak, nonatomic) IBOutlet UIButton *callBtn;
@property (weak, nonatomic) IBOutlet UIButton *messageBtn;
@property (weak, nonatomic) IBOutlet UILabel *addTime;

@property (nonatomic, strong) StudentNewsModel *model;

@end
