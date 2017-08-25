//
//  CustonNavViewController.m
//  好梦学车教练端
//
//  Created by haomeng on 2017/8/25.
//  Copyright © 2017年 haomeng. All rights reserved.
//

#import "CustonNavViewController.h"

@interface CustonNavViewController ()<UIGestureRecognizerDelegate>

@end

@implementation CustonNavViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    __weak __typeof(&*self) weakSelf = self;
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        weakSelf.interactivePopGestureRecognizer.delegate = self;
    }
    // Do any additional setup after loading the view from its nib.
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.enabled = NO;
    }
    
    [super pushViewController:viewController animated:animated];
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
