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

@interface FinishPersonNewsViewController ()<SettingCameraViewControllerDelegate,ChooicePictureViewControllerDelegate>

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
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)btnClick:(id)sender {
    UIButton *btn = sender;
    if (btn.tag == 1001) {
        [self.navigationController popToRootViewControllerAnimated:YES];
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
        
    }else{
    
    }
}

#pragma mark - chooicedPicDelegate

- (void)SettingCameraViewController:(SettingCameraViewController *)vc andSelectedPhone:(UIImage *)image{
   
    _logoImageView.image = image;
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"personNews"]];
    NSData *imageData = UIImagePNGRepresentation([UIImage fixOrientation:image]);
    if (dic) {
        //UIImage转换为NSData
        
        [dic setObject:imageData forKey:@"userLogoImage"];
    }else{
        dic = [[NSMutableDictionary alloc] init];
        [dic setObject:imageData forKey:@"userLogoImage"];
    }
    [[NSUserDefaults standardUserDefaults] setObject:dic forKey:@"personNews"];
    
}

- (void)WHCChoicePictureVC:(ChooicePictureViewController *)choicePictureVC didSelectedPhoto:(UIImage *)image{
    _logoImageView.image = image;
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"personNews"]];
    NSData *imageData = UIImagePNGRepresentation([UIImage fixOrientation:image]);
    if (dic) {
        //UIImage转换为NSData
        
        [dic setObject:imageData forKey:@"userLogoImage"];
    }else{
        dic = [[NSMutableDictionary alloc] init];
        [dic setObject:imageData forKey:@"userLogoImage"];
    }
    [[NSUserDefaults standardUserDefaults] setObject:dic forKey:@"personNews"];
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
