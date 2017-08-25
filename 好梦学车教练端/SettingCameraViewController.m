//
//  SettingCameraViewController.m
//  好梦学车
//
//  Created by haomeng on 2017/6/1.
//  Copyright © 2017年 haomeng. All rights reserved.
//

#import "SettingCameraViewController.h"

@interface SettingCameraViewController ()<UIImagePickerControllerDelegate , UINavigationControllerDelegate>{
    UIImagePickerController   *  _cameraVC;
}


@end

@implementation SettingCameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self initData];
}

- (void)initData{
    _cameraVC = [[UIImagePickerController alloc]init];
    _cameraVC.delegate = self;
    _cameraVC.allowsEditing = YES;
    _cameraVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    _cameraVC.view.frame = [UIScreen mainScreen].bounds;
    _cameraVC.cameraDevice = UIImagePickerControllerCameraDeviceFront;
    [self.view addSubview:_cameraVC.view];
}


#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo {
    __weak  typeof(self)  sf = self;
    [self dismissViewControllerAnimated:YES completion:^{
        if(image != nil){
            if(_delegate && [_delegate respondsToSelector:@selector(SettingCameraViewController:andSelectedPhone:)]){
                [_delegate SettingCameraViewController:sf andSelectedPhone:image];
            }
        }
    }];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage  * image = info[@"UIImagePickerControllerOriginalImage"];
    __weak  typeof(self)  sf = self;
    [self dismissViewControllerAnimated:YES completion:^{
        if(image != nil){
            if(_delegate && [_delegate respondsToSelector:@selector(SettingCameraViewController:andSelectedPhone:)]){
                [_delegate SettingCameraViewController:sf andSelectedPhone:image];
            }
        }
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
