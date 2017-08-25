//
//  IdentifyingViewController.h
//  haomengxueche
//
//  Created by haomeng on 2017/4/18.
//  Copyright © 2017年 haomeng. All rights reserved.
//

#import "BasicViewController.h"

@interface IdentifyingViewController : BasicViewController
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UITextField *phoneNum;
@property (weak, nonatomic) IBOutlet UITextField *shortVerify;
@property (weak, nonatomic) IBOutlet UIButton *btn;
@property (weak, nonatomic) IBOutlet UILabel *timelabel;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;

@end
