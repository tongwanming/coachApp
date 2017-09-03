//
//  RecordTableViewCell.h
//  好梦学车教练端
//
//  Created by haomeng on 2017/8/10.
//  Copyright © 2017年 haomeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StudentNewsModel.h"

@interface RecordTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *desLabelOne;
@property (weak, nonatomic) IBOutlet UILabel *desLabelTwo;
@property (weak, nonatomic) IBOutlet UILabel *recordMarkLabel;

@property (nonatomic, strong) StudentNewsModel *model;

@end
