//
//  StudentsTableViewCell.h
//  好梦学车教练端
//
//  Created by haomeng on 2017/8/11.
//  Copyright © 2017年 haomeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StudentNewsModel.h"

@interface StudentsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *desLabel;

@property (nonatomic, strong) StudentNewsModel *model;

@end
