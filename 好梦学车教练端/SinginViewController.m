//
//  SinginViewController.m
//  haomengxueche
//
//  Created by haomeng on 2017/4/18.
//  Copyright © 2017年 haomeng. All rights reserved.
//

#import "SinginViewController.h"
#import "ForgetPasswoordViewController.h"
#import "IdentifyingViewController.h"
#import "ResetPasswordViewController.h"
#import "LoginSucceedViewController.h"
#import "Masonry.h"
#import "CustomAlertView.h"

//test


@interface SinginViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *userPasswordTextField;

@end

@implementation SinginViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SubViewController" object:@"Disappear"];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
     [[NSNotificationCenter defaultCenter] postNotificationName:@"SubViewController" object:@"Appear"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.logoImageView.layer.masksToBounds = YES;
    self.logoImageView.layer.cornerRadius = self.logoImageView.frame.size.width/2;
    _userNameTextField.delegate = self;
    _userPasswordTextField.delegate = self;
    _userPasswordTextField.secureTextEntry = YES;
    _btn.layer.cornerRadius = 8;
    _btn.layer.masksToBounds = YES;
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [center addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardWillHideNotification object:nil];
    // Do any additional setup after loading the view from its nib.
}

- (void)keyboardDidShow:(NSNotification *)notification{
    
    //kbSize即為鍵盤尺寸 (有width, height)
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.2 animations:^{
            [self.logoImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.view.mas_top).offset(-50);
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
                make.top.mas_equalTo(self.view.mas_top).offset(94);
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
        //忘记密码登录
        
        ResetPasswordViewController *v = [[ResetPasswordViewController alloc] init];
        [self.navigationController pushViewController:v animated:YES];
        
    }else if (btn.tag == 1002){
        //验证码登录
        IdentifyingViewController *IV = [[IdentifyingViewController alloc] init];
        [self.navigationController pushViewController:IV animated:YES];
        
        //短信登录
//        ForgetPasswoordViewController *v = [[ForgetPasswoordViewController alloc] init];
//        [self.navigationController pushViewController:v animated:YES];
        
    }else if (btn.tag == 1003){
        //左上角退出按钮
        [self.navigationController popToRootViewControllerAnimated:YES];
    
    }else if (btn.tag == 1004){
        
        NSDictionary *dic =@{@"username":_userNameTextField.text, @"password":_userPasswordTextField.text};
        
        
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
        NSURL *url = [NSURL URLWithString:@"http://101.37.29.125:7072/gateway-service/auth/login"];
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
                    NSDictionary *dic = [jsonDict objectForKey:@"data"];
                    NSString *token = [dic objectForKey:@"token"];
                    NSDictionary *userInfoDic = [dic objectForKey:@"info"];
                    
                    [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"isLogined"];
                    
                    NSMutableDictionary *userDic = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"personNews"]];
                    if (!userInfoDic) {
                        userDic = [[NSMutableDictionary alloc] init];
                    }
                    [userDic setValue:[self choosedObjectWithKey:@"nickname" andDic:userInfoDic] forKey:@"userName"];
                    
                    [userDic setValue:[self choosedObjectWithKey:@"headPicture" andDic:userInfoDic] forKey:@"userLogoImage"];
                    
                    [userDic setValue:[self choosedObjectWithKey:@"district" andDic:userInfoDic] forKey:@"address"];
                    [userDic setValue:[self choosedObjectWithKey:@"userId" andDic:userInfoDic] forKey:@"userId"];
                    
                    
                    
                    [[NSUserDefaults standardUserDefaults] setObject:userDic forKey:@"personNews"];
                    
                    //登录成功
                    dispatch_async(dispatch_get_main_queue(), ^{
                        LoginSucceedViewController *locationVC = [[LoginSucceedViewController alloc] init];
                        [self.navigationController pushViewController:locationVC animated:YES];
                        
                    });
                    
                }else{
                    //登录失败
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //验证码输入错误
                        UIAlertController *v = [UIAlertController alertControllerWithTitle:@"登录失败" message:@"输入的账号或者密码错误，请查正后登录" preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction *active = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                            
                        }];
                        [v addAction:active];
                        [self presentViewController:v animated:YES completion:^{
                            
                        }];
                    });
                }
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [CustomAlertView hideAlertView];
                    UIAlertController *v = [UIAlertController alertControllerWithTitle:@"登录失败" message:@"未知错误，请稍后再试" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *active = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                        
                    }];
                    [v addAction:active];
                    [self presentViewController:v animated:YES completion:^{
                        
                    }];
                });
            }
        }];
        [dataTask resume];
        
        
        

    
    }else if (btn.tag == 1005){
        
        if (btn.selected) {
            _userPasswordTextField.secureTextEntry = YES;
        }else{
            _userPasswordTextField.secureTextEntry = NO;
        }
    
        btn.selected = !btn.selected;
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}


- (NSString *)choosedObjectWithKey:(NSString *)key andDic:(NSDictionary *)dic{
    NSString *str = @"";
    NSString *value = [dic objectForKey:key];
    
    if (dic != nil && ![value isEqual:[NSNull null]]) {
        str = [dic objectForKey:key];
        
        NSLog(@"--%@",[dic objectForKey:key]);
    }
    return str;
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
