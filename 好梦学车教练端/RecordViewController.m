//
//  RecordViewController.m
//  好梦学车教练端
//
//  Created by haomeng on 2017/8/10.
//  Copyright © 2017年 haomeng. All rights reserved.
//

#import "RecordViewController.h"
#import "RecordTableViewCell.h"
#import "MindViewController.h"
#import "SinginViewController.h"
#import "PersonCenterViewController.h"
#import "StudentNewsModel.h"
#import "CustomAlertView.h"
#import "NSDictionary+objectForKeyWitnNoNsnull.h"
#import "ScanSuccessJumpVC.h"
#import <AVFoundation/AVFoundation.h>
#import "SGQRCodeScanningVC.h"

@interface RecordViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *data;

@property (nonatomic, strong) NSArray *dateArr;

@end

@implementation RecordViewController{
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showNewVC:) name:@"showChoosedStduents" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SubViewController" object:@"Appear"];
    NSString *isLogin = [[NSUserDefaults standardUserDefaults] objectForKey:@"isLogin"];
    if (isLogin) {
        [self getData];
    }else{
        
    }
    
}

- (void)getData{
    NSMutableDictionary *userDic = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"personNews"]];
    __block NSString *cocchId = [userDic objectForKey:@"coachId"];
    if ([userDic objectForKey:@"coachId"] == nil) {
        return;
    }
    NSDictionary *dic =@{@"subject":[NSNull null],@"coachId":cocchId,@"type":@""};
    
    
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
    
    
    //    NSURL *url = [NSURL URLWithString:urlstr];http://101.37.29.125:7076/coach/student/query/study
    NSURL *url = [NSURL URLWithString:@"http://101.37.29.125:7076/coach/student/query/study"];
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
                
                NSArray *arr1 = [dic objectForKey:@"today"];
                NSArray *arr2 = [dic objectForKey:@"yesterday"];
                NSArray *arr3 = [dic objectForKey:@"moreBefore"];
                if (_data.count > 0) {
                    [_data removeAllObjects];
                }
                NSMutableArray *mutArr1 = [[NSMutableArray alloc] init];
                NSMutableArray *mutArr2 = [[NSMutableArray alloc] init];
                NSMutableArray *mutArr3 = [[NSMutableArray alloc] init];
                for (NSDictionary *dic in arr1) {
                    NSDictionary *infoDic = [dic objectForKey:@"studentInfo"];
                    
                    if ([infoDic isEqual:[NSNull null]]) {
                        
                    }else{
                        StudentNewsModel *model = [[StudentNewsModel alloc] init];
                        
                        model.logoUrl = [infoDic objectForKeyWithNoNsnull:@""];
                        model.name = [infoDic objectForKeyWithNoNsnull:@"name"];
                        model.contacPhone = [infoDic objectForKeyWithNoNsnull:@"contactPhone"];
                        model.learnType = [infoDic objectForKeyWithNoNsnull:@"classType"];
                        model.studentId = [infoDic objectForKeyWithNoNsnull:@"id"];
                        model.subject = [dic objectForKeyWithNoNsnull:@"subject"];
                        model.recordId = [dic objectForKeyWithNoNsnull:@"id"];
                        model.coachId = cocchId;
                        [mutArr1 addObject:model];
                    }
                    
                }
                
                
                for (NSDictionary *dic in arr2) {
                    NSDictionary *infoDic = [dic objectForKey:@"studentInfo"];
                    
                    StudentNewsModel *model = [[StudentNewsModel alloc] init];
                    
                    model.logoUrl = [infoDic objectForKeyWithNoNsnull:@""];
                    model.name = [infoDic objectForKeyWithNoNsnull:@"name"];
                    model.contacPhone = [infoDic objectForKeyWithNoNsnull:@"contactPhone"];
                    model.learnType = [infoDic objectForKeyWithNoNsnull:@"classType"];
                    model.studentId = [infoDic objectForKeyWithNoNsnull:@"id"];
                    model.subject = [dic objectForKeyWithNoNsnull:@"subject"];
                    model.recordId = [dic objectForKeyWithNoNsnull:@"id"];
                    model.coachId = cocchId;
                    [mutArr2 addObject:model];
                }
                
                for (NSDictionary *dic in arr3) {
                    NSDictionary *infoDic = [dic objectForKey:@"studentInfo"];
                    
                    StudentNewsModel *model = [[StudentNewsModel alloc] init];
                    
                    model.logoUrl = [infoDic objectForKeyWithNoNsnull:@""];
                    model.name = [infoDic objectForKeyWithNoNsnull:@"name"];
                    model.contacPhone = [infoDic objectForKeyWithNoNsnull:@"contactPhone"];
                    model.learnType = [infoDic objectForKeyWithNoNsnull:@"classType"];
                    model.studentId = [infoDic objectForKeyWithNoNsnull:@"id"];
                    model.subject = [dic objectForKeyWithNoNsnull:@"subject"];
                    model.recordId = [dic objectForKeyWithNoNsnull:@"id"];
                    model.coachId = cocchId;
                    [mutArr3 addObject:model];
                }
                
                [_data addObject:mutArr1];
                [_data addObject:mutArr2];
                [_data addObject:mutArr3];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_tableView reloadData];
                });
                
            }else{
                //登录失败
                dispatch_async(dispatch_get_main_queue(), ^{
                    //验证码输入错误
                    UIAlertController *v = [UIAlertController alertControllerWithTitle:@"错误" message:@"获取数据失败，请稍后再试" preferredStyle:UIAlertControllerStyleAlert];
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
                UIAlertController *v = [UIAlertController alertControllerWithTitle:@"错误" message:@"获取数据失败，请稍后再试" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *active = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                [v addAction:active];
                [self presentViewController:v animated:YES completion:^{
                    
                }];
            });
        }
    }];
    [dataTask resume];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self];;
}

- (void)showNewVC:(NSNotification *)notification{
    // 1、 获取摄像设备
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (device) {
        AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (status == AVAuthorizationStatusNotDetermined) {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if (granted) {
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        SGQRCodeScanningVC *vc = [[SGQRCodeScanningVC alloc] init];
                        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
                        [self presentViewController:nav animated:YES completion:^{
                            
                        }];
                       
                    });
                    // 用户第一次同意了访问相机权限
                    NSLog(@"用户第一次同意了访问相机权限 - - %@", [NSThread currentThread]);
                    
                } else {
                    // 用户第一次拒绝了访问相机权限
                    NSLog(@"用户第一次拒绝了访问相机权限 - - %@", [NSThread currentThread]);
                }
            }];
        } else if (status == AVAuthorizationStatusAuthorized) { // 用户允许当前应用访问相机
            SGQRCodeScanningVC *vc = [[SGQRCodeScanningVC alloc] init];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
            [self presentViewController:nav animated:YES completion:^{
                
            }];
        } else if (status == AVAuthorizationStatusDenied) { // 用户拒绝当前应用访问相机
            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请去-> [设置 - 隐私 - 相机 - SGQRCodeExample] 打开访问开关" preferredStyle:(UIAlertControllerStyleAlert)];
            UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            
            [alertC addAction:alertA];
            [self presentViewController:alertC animated:YES completion:nil];
            
        } else if (status == AVAuthorizationStatusRestricted) {
            NSLog(@"因为系统原因, 无法访问相册");
        }
    } else {
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"未检测到您的摄像头" preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [alertC addAction:alertA];
        [self presentViewController:alertC animated:YES completion:nil];
    }

}
- (IBAction)btnClick:(id)sender {
    UIButton *btn = sender;
    if (btn.tag == 1001) {
        
    }else if (btn.tag == 1002){
        PersonCenterViewController *v = [[PersonCenterViewController alloc] init];
        [self.navigationController pushViewController:v animated:YES];
    }else{
    
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _data = [[NSMutableArray alloc] init];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    
    _dateArr = @[@"今天",@"昨天",@"更早"];
   
    NSString *isLogin = [[NSUserDefaults standardUserDefaults] objectForKey:@"isLogin"];
    if (!isLogin) {
        SinginViewController *v = [[SinginViewController alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:v];
        [self presentViewController:nav animated:YES completion:nil];
    }else{
        
    }
    
    // Do any additional setup after loading the view from its nib.
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_data.count >0) {
        return ((NSArray *)_data[section]).count;
    }else
        return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 182/2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *index = @"";
    
    RecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:index];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"RecordTableViewCell" owner:nil options:nil] lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    StudentNewsModel *model = (StudentNewsModel *)_data[indexPath.section][indexPath.row];
    cell.model = model;
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *veiw = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CURRENT_BOUNDS.width, 50)];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, CURRENT_BOUNDS.width,45 )];
    label.font = [UIFont systemFontOfSize:16];
    label.text = _dateArr[section];
    label.textColor = RECORDWORK;
//    label.backgroundColor = [UIColor redColor];
    [veiw addSubview:label];
    
    return veiw;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    StudentNewsModel *model = (StudentNewsModel *)_data[indexPath.section][indexPath.row];
    
    
//    [_data removeObjectAtIndex:indexPath.row];
//    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [self delectActiveWithModel:model];
}

- (void)delectActiveWithModel:(StudentNewsModel *)model{
    NSMutableDictionary *userDic = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"personNews"]];
    __block NSString *cocchId = [userDic objectForKey:@"coachId"];
    NSDictionary *dic =@{@"recordId":model.recordId};
    
    
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
    
    
    //    NSURL *url = [NSURL URLWithString:urlstr];http://101.37.29.125:7076/coach/student/query/study
    NSURL *url = [NSURL URLWithString:@"http://101.37.29.125:7076/coach/student/del/study"];
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
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self getData];
                });
            }else{
                //登录失败
                dispatch_async(dispatch_get_main_queue(), ^{
                    //验证码输入错误
                    UIAlertController *v = [UIAlertController alertControllerWithTitle:@"删除失败" message:@"" preferredStyle:UIAlertControllerStyleAlert];
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
                UIAlertController *v = [UIAlertController alertControllerWithTitle:@"删除失败" message:@"" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *active = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                [v addAction:active];
                [self presentViewController:v animated:YES completion:^{
                    
                }];
            });
        }
    }];
    [dataTask resume];
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
