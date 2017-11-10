//
//  StudentsViewController.h
//  好梦学车教练端
//
//  Created by haomeng on 2017/8/10.
//  Copyright © 2017年 haomeng. All rights reserved.
//

#import "BasicViewController.h"

@interface StudentsViewController : BasicViewController
@property (weak, nonatomic) IBOutlet UILabel *currentPersons;
@property (weak, nonatomic) IBOutlet UILabel *totalPersons;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIButton *btn2;

@end
