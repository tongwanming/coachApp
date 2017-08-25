//
//  StartGradeView.h
//  好梦学车
//
//  Created by haomeng on 2017/5/4.
//  Copyright © 2017年 haomeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChoosedCocchModel.h"

@interface StartGradeView : UIView

@property (nonatomic, assign) CGFloat start;

@property (nonatomic, strong) NSString *personNumber;

@property (nonatomic, strong) NSString *passingRate;

@property (nonatomic, strong) NSString *evaluate;

@property (nonatomic, strong) ChoosedCocchModel *model;



@end
