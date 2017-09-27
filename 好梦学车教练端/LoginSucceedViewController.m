//
//  LoginSucceedViewController.m
//  好梦学车
//
//  Created by haomeng on 2017/4/25.
//  Copyright © 2017年 haomeng. All rights reserved.
//

#import "LoginSucceedViewController.h"

@interface LoginSucceedViewController ()

@end

@implementation LoginSucceedViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
//    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SubViewController" object:@"Disappear"];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    //    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SubViewController" object:@"Appear"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _desLabel.font = [UIFont systemFontOfSize:36*TYPERATION];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)btnClick:(id)sender {
    NSLog(@"立即进入按钮！");
    [[NSUserDefaults standardUserDefaults] setObject:@"login" forKey:@"isLogin"];
    [self dismissViewControllerAnimated:YES completion:nil];
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
