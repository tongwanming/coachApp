//
//  LearningCollectionViewCell.m
//  好梦学车教练端
//
//  Created by haomeng on 2017/8/16.
//  Copyright © 2017年 haomeng. All rights reserved.
//

#import "LearningCollectionViewCell.h"
#import "UIImageView+WebCache.h"

@implementation LearningCollectionViewCell{
    
    CALayer *_layer;
}


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initialize];
    }
    return self;
}

- (void)initialize{
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, (CURRENT_BOUNDS.width-90)/4, (CURRENT_BOUNDS.width-90)/4)];
    _imageView.image = [UIImage imageNamed:@"bg_secondarylogin03_avatar"];
    _imageView.layer.masksToBounds = YES;
    _imageView.layer.cornerRadius = 8;
    [self addSubview:_imageView];
    
    _layer = [CALayer layer];
    _layer.frame = CGRectMake(0, 0, (CURRENT_BOUNDS.width-90)/4, (CURRENT_BOUNDS.width-90)/4);
    _layer.backgroundColor = [UIColor blackColor].CGColor;
    _layer.opacity = 0.5;
    
    _layer.hidden = YES;
    _layer.masksToBounds = YES;
    
    [_imageView.layer addSublayer:_layer];
    
    CALayer *laye = [CALayer layer];
    laye.frame = CGRectMake((_layer.frame.size.width-27)/2, (_layer.frame.size.height-18)/2, 27, 18);
    laye.backgroundColor = [UIColor clearColor].CGColor;
    laye.contents = (__bridge id)[UIImage imageNamed:@"icon_addrecord_bingo"].CGImage;
    [_layer addSublayer:laye];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_imageView.frame)+13, (CURRENT_BOUNDS.width-30*5)/3, 14)];
    _titleLabel.font = [UIFont systemFontOfSize:14];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.textColor = UNMAIN_TEXT_COLOR;
    _titleLabel.text = @"韩肖莉";
    [self addSubview:_titleLabel];
    
    
}

- (void)setIsSelected:(BOOL)isSelected{
    _isSelected = isSelected;
    NSLog(@"selected:%d",isSelected);
    if (isSelected) {
        _layer.hidden = NO;
    }else{
        _layer.hidden = YES;
    }
}

- (void)setModel:(StudentNewsModel *)model{
    _model = model;
    if (model.logoUrl) {
        [_imageView sd_setImageWithURL:[NSURL URLWithString:model.logoUrl] placeholderImage:[UIImage imageNamed:@"bg_secondarylogin03_avatar"]];
    }else{
        _imageView.image = [UIImage imageNamed:@"bg_secondarylogin03_avatar"];
    }
    _titleLabel.text = model.name;
    
}


@end
