//
//  ResetPasswordViewController.m
//  好梦学车
//
//  Created by haomeng on 2017/4/25.
//  Copyright © 2017年 haomeng. All rights reserved.
//

#import "ResetPasswordViewController.h"
#import "CustomAlertView.h"
#import "SinginViewController.h"

@interface ResetPasswordViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userPhoneNumber;
@property (weak, nonatomic) IBOutlet UITextField *verifyNumber;
@property (weak, nonatomic) IBOutlet UITextField *UserPassword;
@property (weak, nonatomic) IBOutlet UITextField *UserAgainPassword;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *btn;


@end

@implementation ResetPasswordViewController{
    int _time;
    NSTimer *_timer;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SubViewController" object:@"Disappear"];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SubViewController" object:@"Appear"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"重置密码";
    _time = 60;
    _UserPassword.secureTextEntry = YES;
    _UserAgainPassword.secureTextEntry = YES;
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)btnClickActve:(id)sender {
    UIButton *btn = sender;
    if (btn.tag == 1001) {
        //获取验证码
        if ([self validateMobile:_userPhoneNumber.text]) {
            NSDictionary *dic =@{@"phone":_userPhoneNumber.text};
            
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
            
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@:7072/message-service/sms/sendUpdatePwdVerifyCode",PUBLIC_LOCATION]];
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60];
            [request setHTTPBody:jsonData];
            [request setHTTPMethod:@"POST"];
            [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            
            
            NSURLSession *session = [NSURLSession sharedSession];
            NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                if (error == nil) {
                    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                    NSDictionary *dic = [jsonDict objectForKey:@"data"];
                    //            // NOTE: 调用支付结果开始支付
                    
                    
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
        
    }else if (btn.tag == 1002){
        //查看密码
        
        if (btn.selected) {
            _UserPassword.secureTextEntry = YES;
        }else{
            _UserPassword.secureTextEntry = NO;
        }
        btn.selected = !btn.selected;
    }else if (btn.tag == 1003){
        //查看密码
        
        if (btn.selected) {
            _UserAgainPassword.secureTextEntry = YES;
        }else{
            _UserAgainPassword.secureTextEntry = NO;
        }
        btn.selected = !btn.selected;
        
    }else if (btn.tag == 1004){
        //提交
        if ([_UserAgainPassword.text isEqualToString:_UserPassword.text]) {
            [CustomAlertView showAlertViewWithVC:self];
            NSDictionary *dic =@{@"username":_userPhoneNumber.text,@"code":_verifyNumber.text,@"newPwd":_UserAgainPassword.text};
            
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
            NSURL *url = [NSURL URLWithString:@"http://172.18.21.202:7073/user/modifyPwd"];
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60];
            [request setHTTPBody:jsonData];
            [request setHTTPMethod:@"POST"];
            [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            
            
            NSURLSession *session = [NSURLSession sharedSession];
            NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [CustomAlertView hideAlertView];
                });
                if (error == nil) {
                    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                    NSString *success = [jsonDict objectForKey:@"success"];
                    if (success.boolValue) {
                        UIAlertController *v = [UIAlertController alertControllerWithTitle:@"提示" message:@"密码修改成功" preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction *active = [UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"isLogined"];
                                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"personNews"];
                                SinginViewController *v = [[SinginViewController alloc] init];
                                [self.navigationController pushViewController:v animated:YES];
//                                [self.navigationController popToRootViewControllerAnimated:YES];
                            });
                        }];
                        [v addAction:active];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self presentViewController:v animated:YES completion:^{
                                
                            }];
                        });
                        
                    }else{
                        UIAlertController *v = [UIAlertController alertControllerWithTitle:@"提示" message:@"密码修改失败，请重试！" preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction *active = [UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                            
                        }];
                        [v addAction:active];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self presentViewController:v animated:YES completion:^{
                                
                            }];
                        });
                    }
                }else{
                    UIAlertController *v = [UIAlertController alertControllerWithTitle:@"提示" message:@"密码修改失败，请重试！" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *active = [UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                        
                    }];
                    [v addAction:active];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self presentViewController:v animated:YES completion:^{
                            
                        }];
                    });
                   
                }
            }];
            [dataTask resume];
        }else{
            UIAlertController *v = [UIAlertController alertControllerWithTitle:@"提示" message:@"两次输入的密码不一致，请修改！" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *active = [UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [v addAction:active];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self presentViewController:v animated:YES completion:^{
                    
                }];
            });
            
        }
        
    }else if (btn.tag == 1005){
        //退出
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        //此处备用
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  正则表达式验证手机号
 *
 *  @param mobile 传入手机号
 *
 *  @return
 */
- (BOOL)validateMobile:(NSString *)mobile
{
    // 130-139  150-153,155-159  180-189  145,147  170,171,173,176,177,178
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0-9])|(14[57])|(17[013678]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}

- (void)refreshBtn{
    if (_time > 0) {
        _time  -= 1;
        _btn.userInteractionEnabled = NO;
        if (!_btn.hidden) {
            _btn.hidden = YES;
        }
        if (_timeLabel.hidden) {
            _timeLabel.hidden = NO;
        }
        _timeLabel.text = [NSString stringWithFormat:@"%ds重新获取",_time];
        //        [_btn setTitle:[NSString stringWithFormat:@"%ds",_time] forState:UIControlStateNormal];
    }else{
        if (_btn.hidden) {
            _btn.hidden = NO;
        }
        if (!_timeLabel.hidden) {
            _timeLabel.hidden = YES;
        }
        _timeLabel.text = @"";
        [_btn setTitle:[NSString stringWithFormat:@"%@",@"获取验证码"] forState:UIControlStateNormal];
        _btn.userInteractionEnabled = YES;
    }
}


@end
