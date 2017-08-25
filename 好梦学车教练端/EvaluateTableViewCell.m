//
//  EvaluateTableViewCell.m
//  好梦学车
//
//  Created by haomeng on 2017/5/5.
//  Copyright © 2017年 haomeng. All rights reserved.
//

#import "EvaluateTableViewCell.h"
//#import "UIImageView+WebCache.h"

@implementation EvaluateTableViewCell{
    NSMutableArray *_data;
}

- (NSMutableArray *)data{
    if (!_data) {
        _data = [[NSMutableArray alloc] init];
        [_data addObjectsFromArray:@[_imageView1,_imageView2,_imageView3,_imageView4,_imageView5]];
    }else{
        [_data removeAllObjects];
        [_data addObjectsFromArray:@[_imageView1,_imageView2,_imageView3,_imageView4,_imageView5]];
    }
    
    return _data;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.logoImageView.layer.cornerRadius = 17;
    self.logoImageView.layer.masksToBounds = YES;
    
}

- (void)setStar:(CGFloat)star{
    _star = star;
    
    int one = _star/1;
    CGFloat two = _star - one;
    int n = 0;
    if (two > 0) {
        n = one + 1;
    }else{
        n = one;
    }
    for (UIImageView *imageView in self.data) {
        if ([imageView isKindOfClass:[UIImageView class]]) {
            [imageView setImage:[UIImage imageNamed:@"star_little_normal"]];
            if (imageView.tag < n) {
                [imageView setImage:[UIImage imageNamed:@"star_little_lit"]];
            }
            if (imageView.tag == n) {
                if (n == one) {
                    [imageView setImage:[UIImage imageNamed:@"star_little_lit"]];
                }else{
                    [imageView setImage:[UIImage imageNamed:@"star_little_half"]];
                }
            }
        }
    }

}

- (void)setModel:(EvaluateModel *)model{
    _model = model;
    
    self.star = [_model.star floatValue];
//    [_logoImageView sd_setImageWithURL:[NSURL URLWithString:_model.iconUrl] placeholderImage:[UIImage imageNamed:@"pic03"]];
    _logoImageView.image = [UIImage imageNamed:@"seaKing"];
    _nameLabel.text = _model.userName;
    _timeLabel.text = _model.time;
    _describeLabel.text = _model.content;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
