//
//  KTDatePickerView.h
//  DatePickerView
//
//  Created by Grabin on 17/7/28.
//  Copyright © 2017年 Grabin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GBDatePickerView : UIView

typedef void(^GBDatePickerViewBlock)(NSDate *pickDate);

@property (nonatomic, copy)GBDatePickerViewBlock blockForDatePickerView;

/** 设置所能选择的最小时间，default is [NSDate date] 现在 */
- (void)setMinDate:(NSDate *)minDate;

/** 弹出日期选择器 */
- (void)show;

/** 隐藏日期选择器 */
- (void)hide;

@end
