//
//  EvaluateViewController.m
//  好梦学车教练端
//
//  Created by haomeng on 2017/8/10.
//  Copyright © 2017年 haomeng. All rights reserved.
//

#import "EvaluateViewController.h"
#import "MindViewController.h"
#import "StartGradeView.h"
#import "ChoosedCocchModel.h"
#import "EvaluateTableViewCell.h"
#import "EvaluateModel.h"
#import "CustomAlertView.h"
#import "StudentNewsModel.h"
#import "NSDictionary+objectForKeyWitnNoNsnull.m"
#import "UIImageView+WebCache.h"

@interface coachModel : NSObject

@property (nonatomic, strong) NSString *coachName;

@property (nonatomic, strong) NSString *coachUrl;

@property (nonatomic, strong) NSString *coachStars;

@property (nonatomic, strong) NSString *coachPersons;

@property (nonatomic, strong) NSString *coachPass;

@property (nonatomic, strong) NSString *coachEvaluate;

@end

@implementation coachModel



@end

@interface EvaluateViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *data;

@property (nonatomic, strong) coachModel *coachModel;

@end

@implementation EvaluateViewController{
    StartGradeView *_startView;
    NSArray *_dataArr;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showNewVC:) name:@"showChoosedStduents" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SubViewController" object:@"Appear"];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [self getData];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
   [[NSNotificationCenter defaultCenter] removeObserver:self];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)showNewVC:(NSNotification *)notification{
    MindViewController *v = [[MindViewController alloc] init];
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:v];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _coachModel = [[coachModel alloc]init];
    
    _data = [[NSMutableArray alloc] init];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    self.automaticallyAdjustsScrollViewInsets = NO;
//    [_tableView setTableHeaderView:[[UIView alloc] initWithFrame:CGRectNull]];
    // Do any additional setup after loading the view from its nib.
}

- (void)getData{
    NSMutableDictionary *userDic = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"personNews"]];
    __block NSString *cocchId = [userDic objectForKey:@"coachId"];
    NSDictionary *dic =@{@"coachId":cocchId};
    
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
    NSURL *url = [NSURL URLWithString:@"http://101.37.29.125:7076/coach/query/remark"];
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
                if (arr.count >0) {
                    for (NSDictionary *dic in arr) {
                        
                        NSDictionary *infoDic = [dic objectForKeyWithNoNsnull:@"studentInfo"];
                        
                        EvaluateModel *model = [[EvaluateModel alloc] init];
                        
                        model.content = [dic objectForKeyWithNoNsnull:@"remark"];
                        model.time = [dic objectForKeyWithNoNsnull:@"addTime"];
                        model.userName = [infoDic objectForKeyWithNoNsnull:@"name"];
                        model.star = [NSString stringWithFormat:@"%@",[dic objectForKeyWithNoNsnull:@"stars"]];
                        model.iconUrl = [dic objectForKeyWithNoNsnull:@""];//此处还没有数据
                        
                        NSDictionary *coachDic = [dic objectForKeyWithNoNsnull:@"coach"];
                        if (coachDic != nil && ![coachDic isKindOfClass:[NSString class]]) {
                            _coachModel.coachName = [coachDic objectForKeyWithNoNsnull:@"realName"];
                            _coachModel.coachUrl = [coachDic objectForKeyWithNoNsnull:@"headPicture"];
                            _coachModel.coachStars = [NSString stringWithFormat:@"%@",[coachDic objectForKeyWithNoNsnull:@"starValue"]];
                            _coachModel.coachPersons = [NSString stringWithFormat:@"%@",[coachDic objectForKeyWithNoNsnull:@"teachNum"]];
                            _coachModel.coachPass = [NSString stringWithFormat:@"%@",[coachDic objectForKeyWithNoNsnull:@"passRate"]];
                            _coachModel.coachEvaluate = [NSString stringWithFormat:@"%lu",(unsigned long)arr.count];
                        }
                        
                        
                        [_data addObject:model];

                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [_tableView reloadData];
                    });
                }
                
                
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

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CURRENT_BOUNDS.width, 200)];
    headView.backgroundColor = [UIColor whiteColor];
    
    UIImageView *logoView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
    logoView.center = CGPointMake(CURRENT_BOUNDS.width/2, 65);
    [logoView sd_setImageWithURL:[NSURL URLWithString:_coachModel.coachUrl] placeholderImage:[UIImage imageNamed:@"bg_personal_defaultavatar"]];
    logoView.layer.masksToBounds = YES;
    logoView.layer.cornerRadius = 40;
    [headView addSubview:logoView];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(logoView.frame)+20, CURRENT_BOUNDS.width, 20)];
    title.text = _coachModel.coachName;
    title.font = [UIFont boldSystemFontOfSize:20];
    title.textAlignment = NSTextAlignmentCenter;
    title.textColor = BLACK_TEXT_COLOR;
    [headView addSubview:title];
    
    _startView = [[StartGradeView alloc] init];
    _startView.frame = CGRectMake(0, CGRectGetMaxY(title.frame)+15, [UIScreen mainScreen].bounds.size.width, 159);
    
    ChoosedCocchModel *model = [[ChoosedCocchModel alloc] init];
    model.starValue = _coachModel.coachStars;
    model.teachNum = _coachModel.coachPersons;
    model.passPercent = _coachModel.coachPass;
    model.commentNum = _coachModel.coachEvaluate;
    
    _startView.model = model;
    _startView.backgroundColor = [UIColor whiteColor];
    [headView addSubview:_startView];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(title.frame)+63, CURRENT_BOUNDS.width, 0.5)];
    lineView.backgroundColor = DDDDDD;
    [headView addSubview:lineView];
    
    UILabel *studentEvaluate = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(_startView.frame)+22, CURRENT_BOUNDS.width, 16)];
    studentEvaluate.text = [NSString stringWithFormat:@"学员评价(%@)",_coachModel.coachEvaluate];
    studentEvaluate.font = [UIFont boldSystemFontOfSize:16];
    studentEvaluate.textColor = TEXT_COLOR;
    [headView addSubview:studentEvaluate];
    
    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_startView.frame)+60, CURRENT_BOUNDS.width, 10)];
    lineView2.backgroundColor = [UIColor colorWithRed:0.96f green:0.96f blue:0.98f alpha:1.00f];
    [headView addSubview:lineView2];
    
    return headView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 389;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat height = [self heightForString:((EvaluateModel *)_data[indexPath.row]).content andFontOfSize:15 andWidth:CURRENT_BOUNDS.width-77];
    return height+84;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *indxe = @"";
    EvaluateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indxe];
    if (!cell) {
        cell = [EvaluateTableViewCell cellWithTableToDequeueReusable:tableView identifier:indxe nibName:@"EvaluateTableViewCell"];
    }
  
    EvaluateModel *model = _data[indexPath.row];
    
    cell.model = model;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat) heightForString:(NSString *)string{
    NSStringDrawingOptions options =  NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    
    CGRect rect = [string boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 82,MAXFLOAT) options:options attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil];
    
    CGFloat realHeight = ceilf(rect.size.height);
    return realHeight;
}

- (CGFloat) heightForString:(NSString *)string andFontOfSize:(CGFloat)fontSize andWidth:(CGFloat)width{
    NSStringDrawingOptions options =  NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    
    CGRect rect = [string boundingRectWithSize:CGSizeMake(width,MAXFLOAT) options:options attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil];
    
    CGFloat realHeight = ceilf(rect.size.height);
    return realHeight;
}

@end
