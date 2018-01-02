//
//  FinishPersonNewsViewController.m
//  好梦学车教练端
//
//  Created by haomeng on 2017/8/17.
//  Copyright © 2017年 haomeng. All rights reserved.
//

#import "FinishPersonNewsViewController.h"
#import "SettingCameraViewController.h"
#import "SettingPictureViewController.h"
#import "UIImage+imageOrientation.h"
#import "CustomAlertView.h"
#import "QNUploadManager.h"
#import "QNUploadOption.h"
#import "QNConfiguration.h"
#import "UIImageView+WebCache.h"

@interface FinishPersonNewsViewController ()<SettingCameraViewControllerDelegate,ChooicePictureViewControllerDelegate>

@property (nonatomic, strong)NSString *imageKey;

@end

@implementation FinishPersonNewsViewController


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
    _logoImageView.layer.cornerRadius = 44;
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"personNews"]];
    NSObject *data = [dic objectForKey:@"userLogoImage"];
    if (data && [data isKindOfClass:[NSData class]]) {
        _logoImageView.image = [UIImage fixOrientation:[UIImage imageWithData:(NSData *)data]];
    }else{
        if (((NSString *)data).length > 0) {
            [_logoImageView sd_setImageWithURL:[NSURL URLWithString:(NSString *)data] placeholderImage:[UIImage imageNamed:@"bg_personal_defaultavatar"]];
        }else{
            _logoImageView.image = [UIImage imageNamed:@"bg_personal_defaultavatar"];
        }
        
    }
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)btnClick:(id)sender {
    UIButton *btn = sender;
    if (btn.tag == 1001) {
        [self showAlertView];
    }else if (btn.tag == 1002){
        //  上传照片
        UIAlertController *v = [UIAlertController alertControllerWithTitle:@"" message:@"请选择一种方式设置头像" preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *a = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            SettingCameraViewController *v = [[SettingCameraViewController alloc] init];
            v.delegate = self;
            [self presentViewController:v animated:YES completion:^{
                
            }];
        }];
        UIAlertAction *b = [UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            SettingPictureViewController *v = [[SettingPictureViewController alloc] init];
            v.delegate = self;
            v.maxChoiceImageNumberumber = 1;
            [self presentViewController:[[UINavigationController alloc]initWithRootViewController:v] animated:YES completion:nil];
            
        }];
        UIAlertAction *c = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [v addAction:a];
        [v addAction:b];
        [v addAction:c];
        [self presentViewController:v animated:YES completion:nil];
    }else if (btn.tag == 1003){
        //实名认证
        [self resaveActive];
    }else{
    
    }
}

//修改图片大小
-(UIImage*) OriginImage:(UIImage *)image scaleToSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);  //size 为CGSize类型，即你所需要的图片尺寸
    
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    UIImage *newImage = [self imageFromImage:scaledImage];
    return newImage;   //返回的就是已经改变的图片
}

- (UIImage *)imageFromImage:(UIImage *)image{
    CGRect rect;
    CGFloat scale = [UIScreen mainScreen].scale;
    if (image.size.width >= image.size.height) {
        rect = CGRectMake((image.size.width - image.size.height)/2, 0, image.size.height, image.size.height);
    }else{
        rect = CGRectMake((image.size.height - image.size.width)/2, 0, image.size.width, image.size.width);
    }
    CGFloat x= rect.origin.x*scale,y=rect.origin.y*scale,w=rect.size.width*scale,h=rect.size.height*scale;
    CGRect dianRect = CGRectMake(x, y, w, h);
    
    //截取部分图片并生成新图片
    CGImageRef sourceImageRef = [image CGImage];
    CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, dianRect);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp];
    return newImage;
}

#pragma mark - chooicedPicDelegate

- (void)SettingCameraViewController:(SettingCameraViewController *)vc andSelectedPhone:(UIImage *)image{
  
    UIImage *newImage =  [self OriginImage:image scaleToSize:CGSizeMake(120, 120*image.size.height/image.size.width)];
    _logoImageView.image = newImage;
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"personNews"]];
    NSData *imageData = UIImagePNGRepresentation([UIImage fixOrientation:newImage]);
    if (dic) {
        //UIImage转换为NSData
        
        [dic setObject:imageData forKey:@"userLogoImage"];
    }else{
        dic = [[NSMutableDictionary alloc] init];
        [dic setObject:imageData forKey:@"userLogoImage"];
    }
    [[NSUserDefaults standardUserDefaults] setObject:dic forKey:@"personNews"];
    [self getTokenActive];
    
}

- (void)WHCChoicePictureVC:(ChooicePictureViewController *)choicePictureVC didSelectedPhoto:(UIImage *)image{
    
     UIImage *newImage =  [self OriginImage:image scaleToSize:CGSizeMake(120, 120*image.size.height/image.size.width)];
    _logoImageView.image = newImage;
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"personNews"]];
    NSData *imageData = UIImagePNGRepresentation([UIImage fixOrientation:newImage]);
    if (dic) {
        //UIImage转换为NSData
        
        [dic setObject:imageData forKey:@"userLogoImage"];
    }else{
        dic = [[NSMutableDictionary alloc] init];
        [dic setObject:imageData forKey:@"userLogoImage"];
    }
    [[NSUserDefaults standardUserDefaults] setObject:dic forKey:@"personNews"];
    [self getTokenActive];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showAlertView{
    UIAlertController *v = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否需要将修改内容保存！" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"不保存" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    UIAlertAction *active = [UIAlertAction actionWithTitle:@"保存" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self resaveActive];
    }];
    
    [v addAction:cancel];
    [v addAction:active];
    [self presentViewController:v animated:YES completion:^{
        
    }];
}

- (void)resaveActive{
    [CustomAlertView showAlertViewWithVC:self];
    NSMutableDictionary *dica = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"personNews"]];
    NSString *district = [dica objectForKey:@"address"];
//    NSString *name = [dica objectForKey:@"userName"];
    NSString *userId = [dica objectForKey:@"coachId"];
    if (district == nil) {
        district = @"渝中区";
    }
    NSDictionary *dic;
    if (_imageKey.length < 1) {
        dic =@{};
    }else{
        dic =@{@"id":userId,@"headPicture":_imageKey};
    }
    
    
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
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@:7072/manage-service/coach/update/self",PUBLIC_LOCATION]];
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"isLogined"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60];
    [request setHTTPBody:jsonData];
    [request setValue:token forHTTPHeaderField:@"HMAuthorization"];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [CustomAlertView hideAlertView];
        });
        if (error == nil) {
            NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSString *_success = [jsonDict objectForKey:@"success"];
            if (_success.boolValue) {
                //修改资料成功
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIAlertController *v = [UIAlertController alertControllerWithTitle:@"提示" message:@"修改资料成功" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *active = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self.navigationController popToRootViewControllerAnimated:YES];
                        });
                    }];
                    [v addAction:active];
                    [self presentViewController:v animated:YES completion:^{
                        
                    }];
                });
            }else{
                //上传资料失败
                UIAlertController *v = [UIAlertController alertControllerWithTitle:@"提示" message:@"保存信息失败，请稍后再试" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *active = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                [v addAction:active];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self presentViewController:v animated:YES completion:^{
                        
                    }];
                });
            }
        }else{
            //上传资料失败
            UIAlertController *v = [UIAlertController alertControllerWithTitle:@"提示" message:@"保存信息失败，请稍后再试" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *active = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [v addAction:active];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self presentViewController:v animated:YES completion:^{
                    
                }];
            });
        }
    }];
    [dataTask resume];
    
}

- (void)getTokenActive{
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@:7072/user-service/file/img/getUploadHeadPicToken",PUBLIC_LOCATION]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60];
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"isLogined"];
    [request setValue:token forHTTPHeaderField:@"HMAuthorization"];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error == nil) {
            NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSDictionary *dic = [jsonDict objectForKey:@"data"];
            [self upDataWithImage:[UIImage imageNamed:@"11"] andKey:[dic objectForKey:@"key"] andToken:[dic objectForKey:@"token"]];
            NSLog(@"%@",jsonDict);
            
            
        }else{
            UIAlertController *v = [UIAlertController alertControllerWithTitle:@"验证失败" message:@"服务器异常！！" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *active = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [v addAction:active];
            [self presentViewController:v animated:YES completion:^{
                
            }];
        }
    }];
    [dataTask resume];
}

#pragma mark - 上传图片到服务器的方法
- (void)upDataWithImage:(UIImage *)image andKey:(NSString *)key andToken:(NSString *)token{
    
    
    QNUploadManager *manager = [[QNUploadManager alloc] init];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"personNews"]];
    NSData *data = [dic objectForKey:@"userLogoImage"];
    __weak __typeof(&*self)weakSelf = self;
    if (data) {
        [manager putData:data key:key token:token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
            if (resp) {
                weakSelf.imageKey = [resp objectForKey:@"key"];
            }
            
            
        } option:nil];
    }
}



@end
