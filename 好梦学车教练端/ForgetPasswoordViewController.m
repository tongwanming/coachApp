//
//  ForgetPasswoordViewController.m
//  haomengxueche
//
//  Created by haomeng on 2017/4/18.
//  Copyright © 2017年 haomeng. All rights reserved.
//

#import "ForgetPasswoordViewController.h"
#import "CustomAlertView.h"
#import "LoginSucceedViewController.h"
#import "Masonry.h"

@interface ForgetPasswoordViewController ()

@end

@implementation ForgetPasswoordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"短信验证";
    _passWord1.secureTextEntry = YES;
    _passWord2.secureTextEntry = YES;
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [center addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardWillHideNotification object:nil];
    _finishBtn.layer.masksToBounds = YES;
    _finishBtn.layer.cornerRadius = 8;
    // Do any additional setup after loading the view from its nib.
}

- (void)keyboardDidShow:(NSNotification *)notification{
    
    //kbSize即為鍵盤尺寸 (有width, height)
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.2 animations:^{
            [self.topLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.view.mas_top).offset(95);
                
                make.centerX.mas_equalTo(self.view.mas_centerX);
                make.width.mas_equalTo(self.topLineView.mas_width);
                make.height.mas_equalTo(self.topLineView.mas_height);
            }];
        }];
    });
}

- (void)keyboardDidHide:(NSNotification *)notification{
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.2 animations:^{
            [self.topLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.view.mas_top).offset(134);
                make.centerX.mas_equalTo(self.view.mas_centerX);
                make.width.mas_equalTo(self.topLineView.mas_width);
                make.height.mas_equalTo(self.topLineView.mas_height);
            }];
        }];
    });
}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)btnClick:(id)sender {
    UIButton *btn = sender;
    if (btn.tag == 1001) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        NSDictionary *dic =@{@"username":_phoneNum,
                             @"nickname":_userName.text,
                             @"password":_passWord1.text,
                             @"roleId":@1,
                             @"code":_code};
                             
        
        NSData *data1 = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
        NSString *jsonStr = [[NSString alloc] initWithData:data1 encoding:NSUTF8StringEncoding];
        
        
        NSMutableString *mutStr = [NSMutableString stringWithString:jsonStr];
        
        NSRange range = {0,jsonStr.length};
        
        [mutStr replaceOccurrencesOfString:@" "withString:@""options:NSLiteralSearch range:range];
        
        NSRange range2 = {0,mutStr.length};
        
        [mutStr replaceOccurrencesOfString:@"\n"withString:@""options:NSLiteralSearch range:range2];
        NSRange range3 = {0,mutStr.length};
        [mutStr replaceOccurrencesOfString:@"\\"withString:@""options:NSLiteralSearch range:range3];
        NSData *jsonData = [mutStr dataUsingEncoding:NSUTF8StringEncoding];
        
        
        //    NSURL *url = [NSURL URLWithString:urlstr];
        
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://101.37.29.125:7072/user-service/user/register",PUBLIC_LOCATION]];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60];
        [request setHTTPBody:jsonData];
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
        
        
        NSURLSession *session = [NSURLSession sharedSession];
        [CustomAlertView showAlertViewWithVC:self];
        NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (error == nil) {
                NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                NSString *success = [NSString stringWithFormat:@"%@",[jsonDict objectForKey:@"success"]];
                dispatch_async(dispatch_get_main_queue(), ^{
                   
                    [CustomAlertView hideAlertView];
                });
                if (success.boolValue) {
                    //  注册成功
                    NSDictionary *dic = [jsonDict objectForKey:@"data"];
                    
                    [[NSUserDefaults standardUserDefaults] setObject:[dic objectForKey:@"token"] forKey:@"isLogined"];
                    NSMutableDictionary *personDic = [[NSMutableDictionary alloc] init];
                    [personDic setObject:_userName.text forKey:@"userName"];
                    [personDic setObject:[NSString stringWithFormat:@"%@",[dic objectForKey:@"userId"]] forKey:@"userId"];
                    
                    [[NSUserDefaults standardUserDefaults] setObject:personDic forKey:@"personNews"];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        LoginSucceedViewController *v = [[LoginSucceedViewController alloc] init];
                        [self.navigationController pushViewController:v animated:YES];
                    });
                    
                }else{
                    //注册失败
                    
                
                }
                
                
                
                
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [CustomAlertView hideAlertView];
                });
            }
        }];
        [dataTask resume];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SubViewController" object:@"Disappear"];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SubViewController" object:@"Appear"];
}

@end
