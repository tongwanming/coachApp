//
//  StartGradeView.m
//  好梦学车
//
//  Created by haomeng on 2017/5/4.
//  Copyright © 2017年 haomeng. All rights reserved.
//

#import "StartGradeView.h"

#define WIDTH 149
#define STARTSIZE 18
#define SPACE 7

@implementation StartGradeView{
    UILabel *_startLabel;
    UILabel *_personNumberLabel;
    UILabel *_passingRateLabel;
    UILabel *_evaluateLabel;
    UILabel *_Label1;
    UILabel *_Label2;
    UILabel *_Label3;
}

- (instancetype)init{
    if (self = [super init]) {
        [self createStart];
    }
    return self;
}

- (void)createStart{
    for (int i = 0; i < 5; i++) {
        UIImageView *startImage = [[UIImageView alloc] initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width - WIDTH)/2 + i * (STARTSIZE + SPACE), 0, STARTSIZE, STARTSIZE)];
        startImage.tag = i+1;
        startImage.image = [UIImage imageNamed:@"icon_groupevaluation_star_disable"];
        startImage.backgroundColor = [UIColor clearColor];
        [self addSubview:startImage];
    }
    
    _startLabel = [[UILabel alloc] initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width - WIDTH)/2 + WIDTH + SPACE, 0, 45, 15)];
    _startLabel.font = [UIFont systemFontOfSize:15];
    _startLabel.textColor = [UIColor colorWithRed:1.00f green:0.52f blue:0.01f alpha:1.00f];
//    [self addSubview:_startLabel];
    
    //下面的按钮
    _personNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_startLabel.frame)+58, [UIScreen mainScreen].bounds.size.width/3, 28)];
    _personNumberLabel.font = [UIFont boldSystemFontOfSize:28];
    _personNumberLabel.textAlignment = NSTextAlignmentCenter;
    _personNumberLabel.textColor = BLACK_TEXT_COLOR;
//    _personNumberLabel.text = @"120";
    [self addSubview:_personNumberLabel];
    
    _passingRateLabel = [[UILabel alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/3, CGRectGetMaxY(_startLabel.frame)+58, [UIScreen mainScreen].bounds.size.width/3, 28)];
    _passingRateLabel.font = [UIFont boldSystemFontOfSize:28];
    _passingRateLabel.textAlignment = NSTextAlignmentCenter;
    _passingRateLabel.textColor = BLACK_TEXT_COLOR;
//    _passingRateLabel.text = @"96%";
    [self addSubview:_passingRateLabel];
    
    _evaluateLabel = [[UILabel alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/3*2, CGRectGetMaxY(_startLabel.frame)+58, [UIScreen mainScreen].bounds.size.width/3, 28)];
    _evaluateLabel.font = [UIFont boldSystemFontOfSize:28];
    _evaluateLabel.textAlignment = NSTextAlignmentCenter;
    _evaluateLabel.textColor = BLACK_TEXT_COLOR;
//    _evaluateLabel.text = @"88";
    [self addSubview:_evaluateLabel];
    
    _Label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_personNumberLabel.frame)+14, [UIScreen mainScreen].bounds.size.width/3, 14)];
    _Label1.font = [UIFont systemFontOfSize:14];
    _Label1.textAlignment = NSTextAlignmentCenter;
    _Label1.textColor = RECORDWORK;
    _Label1.text = @"培训人数";
    [self addSubview:_Label1];
    
    _Label2 = [[UILabel alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/3, CGRectGetMaxY(_personNumberLabel.frame)+14, [UIScreen mainScreen].bounds.size.width/3, 14)];
    _Label2.font = [UIFont systemFontOfSize:14];
    _Label2.textAlignment = NSTextAlignmentCenter;
    _Label2.textColor = RECORDWORK;
    _Label2.text = @"通过率";
    [self addSubview:_Label2];
    
    _Label3 = [[UILabel alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/3*2, CGRectGetMaxY(_personNumberLabel.frame)+14, [UIScreen mainScreen].bounds.size.width/3, 14)];
    _Label3.font = [UIFont systemFontOfSize:14];
    _Label3.textAlignment = NSTextAlignmentCenter;
    _Label3.textColor = RECORDWORK;
    _Label3.text = @"学员评价";
    [self addSubview:_Label3];
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_Label1.frame)+20, [UIScreen mainScreen].bounds.size.width, 10)];
    bottomView.backgroundColor = [UIColor colorWithRed:0.96f green:0.96f blue:0.98f alpha:1.00f];
    [self addSubview:bottomView];
    
}

- (void)setStart:(CGFloat)start{
    _start = start;
    
    _startLabel.text = [NSString stringWithFormat:@"%.1f",_start];
    int one = _start/1;
    CGFloat two = _start - one;
    int n = 0;
    if (two > 0) {
        n = one + 1;
    }else{
        n = one;
    }
    for (UIImageView *imageView in self.subviews) {
        if ([imageView isKindOfClass:[UIImageView class]]) {
            [imageView setImage:[UIImage imageNamed:@"icon_groupevaluation_star_disable"]];
            if (imageView.tag < n) {
                [imageView setImage:[UIImage imageNamed:@"icon_groupevaluation_star_selected"]];
            }
            if (imageView.tag == n) {
                if (n == one) {
                    [imageView setImage:[UIImage imageNamed:@"icon_groupevaluation_star_selected"]];
                }else{
                    [imageView setImage:[UIImage imageNamed:@"icon_personalevaluation_star_half"]];
                }
            }
        }
    }
    
}

- (void)setModel:(ChoosedCocchModel *)model{
    _model = model;
    self.start = [model.starValue floatValue];
    _personNumberLabel.text = model.teachNum;
    _passingRateLabel.text = model.passPercent;
    _evaluateLabel.text = model.commentNum;
}

@end
