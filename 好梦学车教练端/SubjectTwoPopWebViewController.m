//
//  SubjectTwoPopWebViewController.m
//  好梦学车
//
//  Created by haomeng on 2017/5/20.
//  Copyright © 2017年 haomeng. All rights reserved.
//

#import "SubjectTwoPopWebViewController.h"
#import "CustomAlertView.h"

@interface SubjectTwoPopWebViewController ()<UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;

@end

@implementation SubjectTwoPopWebViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:YES animated:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SubViewController" object:@"Disappear"];
    _titleLabel.text = _titleStr;
}

- (IBAction)btnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    // Do any additional setup after loading the view from its nib.
}

- (void)setTitleStr:(NSString *)titleStr{
    _titleStr = titleStr;
}

- (void)setUrl:(NSString *)url{
    _url = url;
    
    _webView = [[UIWebView alloc] init];
    _webView.frame = CGRectMake(0, 64, CURRENT_BOUNDS.width, CURRENT_BOUNDS.height-64);
    _webView.delegate = self;
    _webView.hidden = YES;
    [self.view addSubview:_webView];
    [self loadWebPageWithString:_url];
    
}

#pragma mark--webViewDelegate
- (void)loadWebPageWithString:(NSString*)urlString
{
    [CustomAlertView showAlertViewWithVC:self];
    
//    if (![urlString hasPrefix:@"http://"]) {
//        urlString = [NSString stringWithFormat:@"http://%@",urlString];
//    }
    NSURL *url =[NSURL URLWithString:urlString];
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    [_webView loadRequest:request];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    NSLog(@"begin");
    //    [[CLoadingView instance] startAnimation];
    //    [LDSAlertView showAlertViewWithVC:self withType:LDSAlertViewTypeLoadingCancel];
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"end");
    //    [[CLoadingView instance] stopAnimation];
    //    [LDSAlertView hideAlertView];
    [CustomAlertView hideAlertView];
    _webView.hidden = NO;
    _webView.scalesPageToFit = YES;
    
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    //    [[CLoadingView instance] stopAnimation];
    [CustomAlertView hideAlertView];
    NSLog(@"%@",error);
    
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [_webView stopLoading];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SubViewController" object:@"Appear"];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
