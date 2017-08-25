//
//  ForgetPasswoordViewController.h
//  haomengxueche
//
//  Created by haomeng on 2017/4/18.
//  Copyright © 2017年 haomeng. All rights reserved.
//

#import "BasicViewController.h"

@interface ForgetPasswoordViewController : BasicViewController
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *passWord1;
@property (weak, nonatomic) IBOutlet UITextField *passWord2;
@property (weak, nonatomic) IBOutlet UIButton *finishBtn;

@property (nonatomic, strong) NSString *code;

@property (nonatomic, strong) NSString *phoneNum;
@property (weak, nonatomic) IBOutlet UIView *topLineView;

@end
