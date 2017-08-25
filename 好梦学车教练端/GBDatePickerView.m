//
//  KTDatePickerView.m
//  DatePickerView
//
//  Created by Grabin on 17/7/28.
//  Copyright © 2017年 Grabin. All rights reserved.
//

#import "GBDatePickerView.h"

#define sreenW [UIScreen mainScreen].bounds.size.width
#define sreenH [UIScreen mainScreen].bounds.size.height
#define picker_view_height 250.0  /**< 选择器高度 */
#define topView_view_height 40.0  /**< 选择器顶部“确定”“取消”栏高度 */
#define btn_width 70.0            /**< 选择器顶部“确定”“取消”按钮宽度 */
#define kAppMainColor [UIColor colorWithRed:113/255.0 green:176/255.0 blue:255/255.0 alpha:1.0];         /**< 选择器顶部“确定”“取消”栏颜色 */

@interface GBDatePickerView ()

@property (nonatomic, strong)UIDatePicker *datePicker;

@end

@implementation GBDatePickerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:CGRectMake(0, sreenH, sreenW, sreenH)];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    [self initBackView];
    [self initDatePicker];
    [self initTopView];
}

- (void)initTopView
{
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMinY(_datePicker.frame)-topView_view_height, sreenW, topView_view_height)];
    topView.backgroundColor = DDDDDD;
    
    UIButton *cacelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, btn_width, topView_view_height)];
    cacelBtn.tag = 0;
    [cacelBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [cacelBtn setTitle:@"取消" forState:UIControlStateNormal];
    cacelBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [cacelBtn setTitleColor:UNMAIN_TEXT_COLOR forState:UIControlStateNormal];
    [topView addSubview:cacelBtn];
    
    UIButton *makeSureBtn = [[UIButton alloc] initWithFrame:CGRectMake(sreenW-btn_width, 0, btn_width, topView_view_height)];
    makeSureBtn.tag = 1;
    [makeSureBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [makeSureBtn setTitle:@"确定" forState:UIControlStateNormal];
    makeSureBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [makeSureBtn setTitleColor:BLUE_BACKGROUND_COLOR forState:UIControlStateNormal];
    [topView addSubview:makeSureBtn];
    
    [self addSubview:topView];
}

- (void)initBackView
{
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, sreenW, sreenH-picker_view_height-topView_view_height)];
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
    [tapGestureRecognizer setNumberOfTapsRequired:1];
    [backView addGestureRecognizer:tapGestureRecognizer];
    [self addSubview:backView];
}

- (void)initDatePicker
{
    _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, sreenH-picker_view_height, sreenW, picker_view_height)];
    _datePicker.backgroundColor = [UIColor whiteColor];
//    _datePicker.minimumDate = [NSDate date];
    _datePicker.date = [NSDate date];
    _datePicker.datePickerMode = UIDatePickerModeDate;
    [self addSubview:_datePicker];
}


#pragma mark - actions
- (void)setMinDate:(NSDate *)minDate
{
    _datePicker.minimumDate = minDate;
}

- (void)btnAction:(UIButton *)abtn
{
    switch (abtn.tag) {
        case 0:
            NSLog(@"取消");
            break;
            
        default:
            NSLog(@"确定");
            if (self.blockForDatePickerView != nil) {
                self.blockForDatePickerView(_datePicker.date);
            }
            break;
    }
    [self hide];
}

- (void)show
{
    _datePicker.date = [NSDate date];
    CGRect temp = self.frame;
    temp.origin.y = 0;
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = temp;
    }];
}

- (void)hide
{
    CGRect temp = self.frame;
    temp.origin.y = sreenH;
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = temp;
    }];
}

@end
