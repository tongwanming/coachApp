//
//  EvaluateTableViewCell.h
//  好梦学车
//
//  Created by haomeng on 2017/5/5.
//  Copyright © 2017年 haomeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FirstBasicTableViewCell.h"
#import "EvaluateModel.h"

@interface EvaluateTableViewCell : FirstBasicTableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *describeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView1;
@property (weak, nonatomic) IBOutlet UIImageView *imageView2;
@property (weak, nonatomic) IBOutlet UIImageView *imageView3;
@property (weak, nonatomic) IBOutlet UIImageView *imageView4;
@property (weak, nonatomic) IBOutlet UIImageView *imageView5;

@property (nonatomic, strong) EvaluateModel *model;

@property (nonatomic, assign) CGFloat star;

@end
