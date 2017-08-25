//
//  MindViewController.m
//  好梦学车教练端
//
//  Created by haomeng on 2017/8/10.
//  Copyright © 2017年 haomeng. All rights reserved.
//

#import "MindViewController.h"
#import "examingRecordViewController.h"
#import "learningViewController.h"
#import "GBDatePickerView.h"

@interface MindViewController ()<learningViewControllerDelegate,examingRecordViewControllerDelegate>

@property (nonatomic, strong)GBDatePickerView *datePickerView;


@property (nonatomic, strong)learningViewController *v;

@property (nonatomic, strong)examingRecordViewController *ev;

@property (nonatomic, strong) NSString *typeStr;

@end

@implementation MindViewController
{
    NSMutableArray *_VCData;
}

- (IBAction)cancelBtnClick:(id)sender {
    UIButton *btn = sender;
    if (btn.tag == 1001) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else if (btn.tag == 1002){
        _typeStr = @"v";
        _recordLearn.titleLabel.textColor = BLUE_BACKGROUND_COLOR;
        _learnView.backgroundColor = BLUE_BACKGROUND_COLOR;
        _recordExam.titleLabel.textColor = RECORDWORK;
        _examView.backgroundColor = RECORDWORK;
        UIViewController *v = _VCData[0];
        for (UIView *view in self.mindSubView.subviews) {
            [view removeFromSuperview];
        }
        v.view.frame = CGRectMake(0, 0, CURRENT_BOUNDS.width, self.mindSubView.frame.size.height);
        [self.mindSubView addSubview:v.view];
    }else if (btn.tag == 1003){
        _typeStr = @"ev";
        _recordLearn.titleLabel.textColor = RECORDWORK;
        _learnView.backgroundColor = RECORDWORK;
        _recordExam.titleLabel.textColor = BLUE_BACKGROUND_COLOR;
        _examView.backgroundColor = BLUE_BACKGROUND_COLOR;
        UIViewController *v = _VCData[1];
        for (UIView *view in self.mindSubView.subviews) {
            [view removeFromSuperview];
        }
        v.view.frame = CGRectMake(0, 0, CURRENT_BOUNDS.width, self.mindSubView.frame.size.height);
        [self.mindSubView addSubview:v.view];
    }else if (btn.tag == 1004){
    
    }else{
    
    }
    
}

- (void)learningViewControllerBtnClickWihtBtn:(UIButton *)btn{
    if (btn.tag == 1001) {
        [_datePickerView show];
    }else if (btn.tag == 1002){
        UIAlertController *v = [UIAlertController alertControllerWithTitle:@"选择学习科目" message:@"请从下面几种科目中选择一种" preferredStyle:UIAlertControllerStyleActionSheet];
        __weak typeof(self)weakSelf = self;
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"科目一" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            weakSelf.v.typeLabel.text = @"科目一";
        }];
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"科目二" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            weakSelf.v.typeLabel.text = @"科目二";
        }];
        UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"科目三" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            weakSelf.v.typeLabel.text = @"科目三";
        }];
        UIAlertAction *action4 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [v addAction:action1];
        [v addAction:action2];
        [v addAction:action3];
        [v addAction:action4];
        [self presentViewController:v animated:YES completion:nil];
    }else{
    
    }
}

- (void)examingRecordViewControllerClickWithBtn:(UIButton *)btn{
    if (btn.tag == 1001) {
        [_datePickerView show];
    }else if (btn.tag == 1002){
        UIAlertController *v = [UIAlertController alertControllerWithTitle:@"选择学习科目" message:@"请从下面几种科目中选择一种" preferredStyle:UIAlertControllerStyleActionSheet];
        __weak typeof(self)weakSelf = self;
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"科目一" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            weakSelf.ev.typeLabel.text = @"科目一";
        }];
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"科目二" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            weakSelf.ev.typeLabel.text = @"科目二";
        }];
        UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"科目三" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            weakSelf.ev.typeLabel.text = @"科目三";
        }];
        UIAlertAction *action4 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [v addAction:action1];
        [v addAction:action2];
        [v addAction:action3];
        [v addAction:action4];
        [self presentViewController:v animated:YES completion:nil];
    }else{
        
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _VCData = [[NSMutableArray alloc] init];
    
    _v = [[learningViewController alloc] init];
    _v.delegate = self;
    [self addChildViewController:_v];
   
    
    _ev = [[examingRecordViewController alloc] init];
    _ev.delegate = self;
    [self addChildViewController:_ev];
    
    [_VCData addObject:_v];
    [_VCData addObject:_ev];
    _v.view.frame = CGRectMake(0, 0, self.mindSubView.frame.size.width, self.mindSubView.frame.size.height);
    _typeStr = @"v";
    [self.mindSubView addSubview:_v.view];
    
    _resaveBtn.layer.masksToBounds = YES;
    _resaveBtn.layer.cornerRadius = 6;
    
    __weak typeof(self)weakSelf = self;
    _datePickerView = [[GBDatePickerView alloc] init];
    _datePickerView.blockForDatePickerView = ^(NSDate *pickDate){
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSString *dateString = [formatter stringFromDate:pickDate];
        NSLog(@"%@",dateString);
        if ([weakSelf.typeStr isEqualToString:@"v"]) {
            weakSelf.v.timeLabel.text = dateString;
        }else{
            weakSelf.ev.timeLabel.text = dateString;
        }
        
    };
    [self.view addSubview:_datePickerView];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
