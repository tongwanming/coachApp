//
//  LearningCollectionViewCell.h
//  好梦学车教练端
//
//  Created by haomeng on 2017/8/16.
//  Copyright © 2017年 haomeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LearningCollectionViewCell : UICollectionViewCell

@property (nonatomic, assign) BOOL isSelected;

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, assign) NSIndexPath *idexPath;

@end
