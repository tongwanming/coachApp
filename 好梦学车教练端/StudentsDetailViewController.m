//
//  StudentsDetailViewController.m
//  好梦学车教练端
//
//  Created by haomeng on 2017/8/15.
//  Copyright © 2017年 haomeng. All rights reserved.
//

#import "StudentsDetailViewController.h"

@interface StudentsDetailViewController ()

@end

@implementation StudentsDetailViewController
- (IBAction)btnClick:(id)sender {
    UIButton *btn = sender;
    if (btn.tag == 1001) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else if (btn.tag == 1002){
    
    }else if (btn.tag == 1003){
        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",@"15123151660"];
        UIWebView * callWebview = [[UIWebView alloc] init];
        [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
        [self.view addSubview:callWebview];
        
    }else if (btn.tag == 1004){
        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"sms:%@",@"15123151660"];
        UIWebView * callWebview = [[UIWebView alloc] init];
        [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
        [self.view addSubview:callWebview];
    }else{
    
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SubViewController" object:@"Disappear"];
     [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
     [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _logoImageView.layer.masksToBounds = YES;
    _logoImageView.layer.cornerRadius = 6;
    
    _callBtn.layer.masksToBounds = YES;
    _callBtn.layer.cornerRadius = 3;
    
    _messageBtn.layer.masksToBounds = YES;
    _messageBtn.layer.cornerRadius = 3;
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
