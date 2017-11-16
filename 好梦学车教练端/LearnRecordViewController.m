//
//  LearnRecordViewController.m
//  好梦教练端
//
//  Created by haomeng on 2017/11/10.
//  Copyright © 2017年 haomeng. All rights reserved.
//

#import "LearnRecordViewController.h"
#import "RecordTableViewCell.h"
#import "CustomAlertView.h"
#import "NSDictionary+objectForKeyWitnNoNsnull.h"

@interface LearnRecordViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *data;
@end

@implementation LearnRecordViewController
- (IBAction)btnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _data = [[NSMutableArray alloc] init];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectNull]];
    [self getData];
    // Do any additional setup after loading the view from its nib.
}

- (void)setModel:(StudentNewsModel *)model{
    _model = model;
}

- (void)getData{
    
    NSMutableDictionary *userDic = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"personNews"]];
    __block NSString *cocchId = [userDic objectForKey:@"coachId"];
    NSDictionary *dic =@{@"subject":[NSNull null],@"coachId":cocchId,@"type":@"",@"studentId":_model.studentId};
    
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
    
    
    //    NSURL *url = [NSURL URLWithString:urlstr];http://%@:7076/coach/query/student
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@:7076/coach/student/query/studyRecordList",PUBLIC_LOCATION]];
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
                NSArray *arr = [jsonDict objectForKey:@"data"];
                if (_data.count > 0) {
                    [_data removeAllObjects];
                }
                if (arr.count > 0) {
                    for (NSDictionary *dic in arr) {
                        NSDictionary *infoDic = [dic objectForKey:@"studentInfo"];
                        NSDictionary *coachDic = [dic objectForKey:@"coach"];
                        NSDictionary *placeDic = [dic objectForKey:@"trainplace"];
                        
                        StudentNewsModel *model = [[StudentNewsModel alloc] init];
                        
                        model.addTime = [self choosedNormalDateWithStr:[dic objectForKeyWithNoNsnull:@"addTime"]];
                        model.logoUrl = [infoDic objectForKeyWithNoNsnull:@""];
                        model.name = [infoDic objectForKeyWithNoNsnull:@"name"];
                        model.contacPhone = [infoDic objectForKeyWithNoNsnull:@"contactPhone"];
                        model.learnType = [infoDic objectForKeyWithNoNsnull:@"classType"];
                        model.studentId = [infoDic objectForKeyWithNoNsnull:@"id"];
                        model.subject = [dic objectForKeyWithNoNsnull:@"subject"];
                        model.coachName = [coachDic objectForKeyWithNoNsnull:@"nickname"];
                        model.exercisePlace = [placeDic objectForKeyWithNoNsnull:@"name"];
                        model.coachId = cocchId;
                        [_data addObject:model];
                    }
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_tableView reloadData];
                    
                });
                
            }else{
                //登录失败
                dispatch_async(dispatch_get_main_queue(), ^{
                    //验证码输入错误
                    UIAlertController *v = [UIAlertController alertControllerWithTitle:@"错误提示" message:@"获取数据失败，请稍后再试" preferredStyle:UIAlertControllerStyleAlert];
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
                UIAlertController *v = [UIAlertController alertControllerWithTitle:@"错误提示" message:@"获取数据失败，请稍后再试" preferredStyle:UIAlertControllerStyleAlert];
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _data.count;
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
    cell.showRecordLabel = YES;
    cell.model = _data[indexPath.row];
    return cell;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)choosedNormalDateWithStr:(NSString *)str{
    NSString *sr;
    NSMutableString *mutStr = [NSMutableString stringWithString:str];
    [mutStr deleteCharactersInRange:NSMakeRange(10, 9)];
    sr = [NSString stringWithString:mutStr];
    
    return sr;
    
}

@end
