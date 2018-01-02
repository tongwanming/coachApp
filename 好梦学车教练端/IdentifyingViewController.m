//
//  IdentifyingViewController.m
//  haomengxueche
//
//  Created by haomeng on 2017/4/18.
//  Copyright © 2017年 haomeng. All rights reserved.
//

#import "IdentifyingViewController.h"
#import "ForgetPasswoordViewController.h"
#import "SinginViewController.h"
#import "CustomAlertView.h"
#import "Masonry.h"


@interface IdentifyingViewController ()

@end

@implementation IdentifyingViewController{
    int _time;
    NSTimer *_timer;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SubViewController" object:@"Disappear"];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SubViewController" object:@"Appear"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _time = 60;
    self.logoImageView.layer.masksToBounds = YES;
    self.logoImageView.layer.cornerRadius = self.logoImageView.frame.size.width/2;
    
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [center addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardWillHideNotification object:nil];
    _nextBtn.layer.masksToBounds = YES;
    _nextBtn.layer.cornerRadius = 8;
    
    // Do any additional setup after loading the view from its nib.
}

- (void)keyboardDidShow:(NSNotification *)notification{

    //kbSize即為鍵盤尺寸 (有width, height)
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.2 animations:^{
            [self.logoImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                
                make.top.equalTo(self.view.mas_top).offset(-50);
                make.centerX.mas_equalTo(self.view.mas_centerX);
                make.width.mas_equalTo(self.logoImageView.mas_width);
                make.height.mas_equalTo(self.logoImageView.mas_height);
            }];
        }];
    });
}

- (void)keyboardDidHide:(NSNotification *)notification{
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.2 animations:^{
            [self.logoImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.view.mas_top).offset(92);
                make.centerX.mas_equalTo(self.view.mas_centerX);
                make.width.mas_equalTo(self.logoImageView.mas_width);
                make.height.mas_equalTo(self.logoImageView.mas_height);
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
        if ([self validateMobile:_phoneNum.text]) {
            NSDictionary *dic =@{@"phone":_phoneNum.text};
            
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
            
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@:7072/message-service/sms/sendRegisterVerifyCode",PUBLIC_LOCATION]];
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60];
            [request setHTTPBody:jsonData];
            [request setHTTPMethod:@"POST"];
            [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            
            
            NSURLSession *session = [NSURLSession sharedSession];
            NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                if (error == nil) {
                    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                    NSString *dic = [jsonDict objectForKey:@"success"];
                   
                    
                    
                }else{
                    
                }
            }];
            [dataTask resume];
            
            if (_timer) {
                _time = 60;
                [_timer invalidate];
                _timer = nil;
            }
            _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(refreshBtn) userInfo:nil repeats:YES];
        }else{
            UIAlertController *v = [UIAlertController alertControllerWithTitle:@"提示" message:@"电话号码输入错误，请输入正确的电话号码" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *active = [UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [v addAction:active];
            [self presentViewController:v animated:YES completion:^{
                
            }];
        }
        
    }else if(btn.tag == 1002){
        //下一步
        if (_shortVerify.text.length == 6) {
            [CustomAlertView showAlertViewWithVC:self];
            NSDictionary *dic =@{@"phone":_phoneNum.text,@"code":_shortVerify.text};
            
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
            
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@:7072/message-service/sms/verifyRegisterCode",PUBLIC_LOCATION]];
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60];
            [request setHTTPBody:jsonData];
            [request setHTTPMethod:@"POST"];
            [request setValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
            
            
            NSURLSession *session = [NSURLSession sharedSession];
            NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                if (error == nil) {
                    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                    NSString *_success = [jsonDict objectForKey:@"success"];
                    if (_success.boolValue) {
                        //验证成功
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [CustomAlertView hideAlertView];
                            ForgetPasswoordViewController *v = [[ForgetPasswoordViewController alloc] init];
                            v.code = _shortVerify.text;
                            v.phoneNum = _phoneNum.text;
                            [self.navigationController pushViewController:v animated:YES];
                        });
                    }else{
                        //验证失败
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [CustomAlertView hideAlertView];
                            
                            //验证码输入错误
                            UIAlertController *v = [UIAlertController alertControllerWithTitle:@"验证失败" message:@"请重新获取验证码验证！" preferredStyle:UIAlertControllerStyleAlert];
                            UIAlertAction *active = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                                
                            }];
                            [v addAction:active];
                            [self presentViewController:v animated:YES completion:^{
                                
                            }];
                        });
                    }
                    NSLog(@"--%@",[jsonDict objectForKey:@"success"]);
//                    NSDictionary *dic = [jsonDict objectForKey:@"data"];
//                   
//                    
                    
                    
                    
                }else{
                    
                    [CustomAlertView hideAlertView];
                    
                    //验证码输入错误
                    UIAlertController *v = [UIAlertController alertControllerWithTitle:@"验证失败" message:@"请重新获取验证码验证！" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *active = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                        
                    }];
                    [v addAction:active];
                    [self presentViewController:v animated:YES completion:^{
                        
                    }];
                }
            }];
            [dataTask resume];
        }else{
            //验证码输入错误
            UIAlertController *v = [UIAlertController alertControllerWithTitle:@"验证失败" message:@"输入的验证码有误！" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *active = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [v addAction:active];
            [self presentViewController:v animated:YES completion:^{
                
            }];
        }
        
        
        
        
        
        
    }else if (btn.tag == 1003){
//        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"isLogin"];
        [self.navigationController popViewControllerAnimated:YES];
    }else if (btn.tag == 1004){
        //密码登录
        SinginViewController *v = [[SinginViewController alloc] init];
        [self.navigationController pushViewController:v animated:YES];
    }else{
    
    }
}

- (void)refreshBtn{
    if (_time > 0) {
        _time  -= 1;
        _btn.userInteractionEnabled = NO;
        if (!_btn.hidden) {
            _btn.hidden = YES;
        }
        if (_timelabel.hidden) {
            _timelabel.hidden = NO;
        }
        _timelabel.text = [NSString stringWithFormat:@"%ds",_time];
//        [_btn setTitle:[NSString stringWithFormat:@"%ds",_time] forState:UIControlStateNormal];
    }else{
        if (_btn.hidden) {
            _btn.hidden = NO;
        }
        if (!_timelabel.hidden) {
            _timelabel.hidden = YES;
        }
        _timelabel.text = @"";
        [_btn setTitle:[NSString stringWithFormat:@"%@",@"获取验证码"] forState:UIControlStateNormal];
        _btn.userInteractionEnabled = YES;
    }
}

/**
 *  正则表达式验证手机号
 *
 *  @param mobile 传入手机号
 *
 *  
 */
- (BOOL)validateMobile:(NSString *)mobile
{
    // 130-139  150-153,155-159  180-189  145,147  170,171,173,176,177,178
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0-9])|(14[57])|(17[013678]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}

@end
