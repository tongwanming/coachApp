//
//  StudentsViewController.m
//  好梦学车教练端
//
//  Created by haomeng on 2017/8/10.
//  Copyright © 2017年 haomeng. All rights reserved.
//

#import "StudentsViewController.h"
#import "StudentsTableViewCell.h"
#import "MindViewController.h"
#import "StudentsDetailViewController.h"
#import "CustomAlertView.h"
#import "StudentNewsModel.h"
#import "NSDictionary+objectForKeyWitnNoNsnull.h"

@interface StudentsViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *data;

@property (nonatomic, strong) NSMutableArray *data2;

@end

@implementation StudentsViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showNewVC:) name:@"showChoosedStduents" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SubViewController" object:@"Appear"];
    [self getData1];
    [self getData2];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)showNewVC:(NSNotification *)notification{
    MindViewController *v = [[MindViewController alloc] init];
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:v];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    _data = [[NSMutableArray alloc] init];
    _data2 = [[NSMutableArray alloc] init];
    // Do any additional setup after loading the view from its nib.
}

- (void)getData1{
    
    NSMutableDictionary *userDic = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"personNews"]];
    __block NSString *cocchId = [userDic objectForKey:@"coachId"];
    NSDictionary *dic =@{@"coachId":cocchId,@"relationStates":@"1",@"studyStates":@"1"};//0->未开始学习，1->学习中，2->暂停学习，3->申请考试，4->考试通过，5->补考中, 6->考爆
    
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
    
    
    //    NSURL *url = [NSURL URLWithString:urlstr];http://101.37.29.125:7076/coach/query/student
    NSURL *url = [NSURL URLWithString:@"http://101.37.29.125:7076/coach/query/student"];
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
                for (NSDictionary *dic in arr) {
                    NSDictionary *infoDic = [dic objectForKey:@"studentInfo"];
                    NSDictionary *coachDic = [dic objectForKey:@"coach"];
                    NSDictionary *placeDic = [dic objectForKey:@"trainplace"];
                    
                    StudentNewsModel *model = [[StudentNewsModel alloc] init];
                    
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
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_tableView reloadData];
                    _currentPersons.text = [NSString stringWithFormat:@"%lu人",(unsigned long)_data.count];
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

- (void)getData2{
    
    NSMutableDictionary *userDic = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"personNews"]];
    __block NSString *cocchId = [userDic objectForKey:@"coachId"];
    NSDictionary *dic =@{@"coachId":cocchId,@"relationStates":@"1",@"studyStates":@"4"};//0->未开始学习，1->学习中，2->暂停学习，3->申请考试，4->考试通过，5->补考中, 6->考爆
    
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
    
    
    //    NSURL *url = [NSURL URLWithString:urlstr];http://101.37.29.125:7076/coach/query/student
    NSURL *url = [NSURL URLWithString:@"http://101.37.29.125:7076/coach/query/student"];
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
                if (_data2.count > 0) {
                    [_data2 removeAllObjects];
                }
                for (NSDictionary *dic in arr) {
                    NSDictionary *infoDic = [dic objectForKey:@"studentInfo"];
                    NSDictionary *coachDic = [dic objectForKey:@"coach"];
                    NSDictionary *placeDic = [dic objectForKey:@"trainplace"];
                    
                    StudentNewsModel *model = [[StudentNewsModel alloc] init];
                    
                    model.logoUrl = [infoDic objectForKeyWithNoNsnull:@""];
                    model.name = [infoDic objectForKeyWithNoNsnull:@"name"];
                    model.contacPhone = [infoDic objectForKeyWithNoNsnull:@"contactPhone"];
                    model.learnType = [infoDic objectForKeyWithNoNsnull:@"classType"];
                    model.studentId = [infoDic objectForKeyWithNoNsnull:@"id"];
                    model.subject = [dic objectForKeyWithNoNsnull:@"subject"];
                    model.coachName = [coachDic objectForKeyWithNoNsnull:@"nickname"];
                    model.exercisePlace = [placeDic objectForKeyWithNoNsnull:@"name"];
                    model.coachId = cocchId;
                    [_data2 addObject:model];
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_tableView reloadData];
                    _totalPersons.text = [NSString stringWithFormat:@"%lu人",(unsigned long)(_data.count+_data2.count)];
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return _data.count;
    }else
        return _data2.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 182/2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *index = @"dd";
    StudentsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:index];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"StudentsTableViewCell" owner:nil options:nil] lastObject];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    StudentNewsModel *model;
    if (indexPath.section == 0) {
        model = _data[indexPath.row];
    }else{
        model = _data2[indexPath.row];
    }
    cell.model = model;
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *veiw = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CURRENT_BOUNDS.width, 50)];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, CURRENT_BOUNDS.width,45 )];
    label.font = [UIFont systemFontOfSize:16];
    if (section == 0) {
        
        label.text = [NSString stringWithFormat:@"在学学员 (%lu)",(unsigned long)_data.count];
    }else{
        label.text = [NSString stringWithFormat:@"已完成学员 (%lu)",(unsigned long)_data2.count];
    }
    label.textColor = RECORDWORK;
    //    label.backgroundColor = [UIColor redColor];
    [veiw addSubview:label];
    
    return veiw;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    StudentsDetailViewController *v = [[StudentsDetailViewController alloc] init];
    StudentNewsModel *model;
    if (indexPath.section == 0) {
        model = _data[indexPath.row];
    }else{
        model = _data2[indexPath.row];
    }
    v.model = model;
    [self.navigationController pushViewController:v animated:YES];
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
