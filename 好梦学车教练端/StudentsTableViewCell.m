//
//  StudentsTableViewCell.m
//  好梦学车教练端
//
//  Created by haomeng on 2017/8/11.
//  Copyright © 2017年 haomeng. All rights reserved.
//

#import "StudentsTableViewCell.h"

@implementation StudentsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _logoImageView.layer.masksToBounds = YES;
    _logoImageView.layer.cornerRadius = 6;
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
