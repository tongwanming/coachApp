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
   
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
     [self getData];
}

- (void)setModel:(StudentNewsModel *)model{
    _model = model;
}

- (void)getData{
    
    NSMutableDictionary *userDic = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"personNews"]];
    __block NSString *cocchId = [userDic objectForKey:@"userId"];
    NSDictionary *dic =@{@"stuId":_model.studentId,@"subject":_model.subject,@"coachUserId":cocchId};
    
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
//    @"http://101.37.161.13:7081/v1/student/study/record/list
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@:7082/v1/student/study/record/list",PUBLIC_LOCATION]];
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
                        
                        StudentNewsModel *model = [[StudentNewsModel alloc] init];
                        
                        model.addTime = [self choosedNormalDateWithStr:[dic objectForKeyWithNoNsnull:@"signTime"]];
                        model.logoUrl = [dic objectForKeyWithNoNsnull:@""];
                        model.name = [dic objectForKeyWithNoNsnull:@"studentName"];
//                        model.contacPhone = [dic objectForKeyWithNoNsnull:@"contactPhone"];
//                        model.learnType = [dic objectForKeyWithNoNsnull:@"classType"];
                        model.studentId = [dic objectForKeyWithNoNsnull:@"id"];
                        model.subject = [dic objectForKeyWithNoNsnull:@"subject"];
                        model.coachName = [dic objectForKeyWithNoNsnull:@"coachName"];
                        model.exercisePlace = [dic objectForKeyWithNoNsnull:@"trainPlaceName"];
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
                    UIAlertController *v = [UIAlertController alertControllerWithTitle:@"错误提示" message:[jsonDict objectForKey:@"message"] preferredStyle:UIAlertControllerStyleAlert];
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
