//
//  TicklingViewController.m
//  好梦学车
//
//  Created by haomeng on 2017/5/31.
//  Copyright © 2017年 haomeng. All rights reserved.
//

#import "TicklingViewController.h"
#import "CustomAlertView.h"

@interface TicklingViewController ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *btn;

@end

@implementation TicklingViewController
- (IBAction)btnClick:(id)sender {
    UIButton *btn = sender;
    if (btn.tag == 1001) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        NSLog(@"  发送按钮");
        NSDictionary *dic =@{ @"content":_titleTextField.text,
                             @"title":_textView.text
                             };
        
        
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
        
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http:///%@:7072/user-service/feedback/add",PUBLIC_LOCATION]];
        NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"isLogined"];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60];
        [request setHTTPBody:jsonData];
        [request setValue:token forHTTPHeaderField:@"HMAuthorization"];
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
       
        
        [CustomAlertView showAlertViewWithVC:self];
        NSURLSession *session = [NSURLSession sharedSession];
        NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (error == nil) {
                NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                
                NSLog(@"%@",jsonDict);
                dispatch_async(dispatch_get_main_queue(), ^{
                    [CustomAlertView hideAlertView];
                });
                NSString *message = [jsonDict objectForKey:@"message"];
                if ([message isEqualToString:@"请登陆"]) {
                    //验证码输入错误
                    UIAlertController *v = [UIAlertController alertControllerWithTitle:@"提交失败" message:@"请先登录后再提交问题！" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *active = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                        
                    }];
                    [v addAction:active];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self presentViewController:v animated:YES completion:^{
                            
                        }];
                    });
                }else{
                    UIAlertController *v = [UIAlertController alertControllerWithTitle:@"提交成功" message:@"我们已经成功接收到你的反馈，谢谢！" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *active = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                        [self.navigationController popViewControllerAnimated:YES];
                    }];
                    [v addAction:active];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self presentViewController:v animated:YES completion:^{
                            
                        }];
                    });
                }
                
            }else{
                
                
                
                //验证码输入错误
                UIAlertController *v = [UIAlertController alertControllerWithTitle:@"提交失败" message:@"网络或则后台打瞌睡了，请重试！" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *active = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                [v addAction:active];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [CustomAlertView hideAlertView];
                    [self presentViewController:v animated:YES completion:^{
                        
                    }];
                });
                
            }
        }];
        [dataTask resume];
        
        
        
        
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _textView.delegate = self;
    _btn.userInteractionEnabled = NO;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    // Do any additional setup after loading the view from its nib.
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    if ([textView.text isEqualToString:@"输入你的问题、意见或者建议，或者对功能的吐槽等，建议500字以内"]) {
        textView.text = @"";
        textView.textColor = TEXT_COLOR;
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView{
    if (![textView.text isEqualToString:@"输入你的问题、意见或者建议，或者对功能的吐槽等，建议500字以内"] && textView.text.length > 5) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
        });
        if (!_btn.userInteractionEnabled) {
            _btn.userInteractionEnabled = YES;
            _btn.titleLabel.textColor = TEXT_COLOR;
        }
        
    }else{
        if (_btn.userInteractionEnabled) {
            _btn.userInteractionEnabled = NO;
            _btn.titleLabel.textColor = UNMAIN_TEXT_COLOR;
            dispatch_async(dispatch_get_main_queue(), ^{
                
            });
            
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
