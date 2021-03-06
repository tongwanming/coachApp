//
//  StudentsTableViewCell.m
//  好梦学车教练端
//
//  Created by haomeng on 2017/8/11.
//  Copyright © 2017年 haomeng. All rights reserved.
//

#import "StudentsTableViewCell.h"
#import "UIImageView+WebCache.h"

@implementation StudentsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _logoImageView.layer.masksToBounds = YES;
    _logoImageView.layer.cornerRadius = 6;
    
    // Initialization code
}

- (void)setModel:(StudentNewsModel *)model{
    _model = model;
    if (model.logoUrl) {
        [_logoImageView sd_setImageWithURL:[NSURL URLWithString:model.logoUrl] placeholderImage:[UIImage imageNamed:@"bg_secondarylogin03_avatar"]];
    }else{
        _logoImageView.image = [UIImage imageNamed:@"bg_secondarylogin03_avatar"];
    }
    _nameLabel.text = model.name;
    _desLabel.text = [NSString stringWithFormat:@"%@学习中",model.subject];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
