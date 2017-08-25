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


@interface EvaluateViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

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
    
    _dataArr = @[@"据说这是一个很好的教练，然后各种给力,据说这是一个很好的教练，然后各种给力,据说这是一个很好的教练，然后各种给力,据说这是一个很好的教练，然后各种给力",@"据说这是一个很好的教练，然后各种给力,据说这是一个很好的教练，",@"据说这是一个很好的教练，然后各种给力,",@"据说这是一个很好的教练，然后各种给力,据说这是一个很好的教练，然后各种给力,据说这是一个很好的教练，然后各种给力,据说这是一个很好的教练，然后各种给力",@"据说这是一个很好的教练，然后各种给力,",@"据说这是一个很好的教练，然后各种给力,据说这是一个很好的教练，然后各种给力,据说这是一个很好的教练，然后各种给力,据说这是一个很好的教练，然后各种给力",@"据说这是一个很好的教练，然后各种给力,据说这是一个很好的教练，然后各种给力,据说这是一个很好的教练，然后各种给力,据说这是一个很好的教练，然后各种给力",@"据说这是一个很好的教练，",@"据说这是一个很好的教练，然后各种给力,据说这是一个很好的教练，",@"据说这是一个很好的教练，然后各种给力,据说这是一个很好的教练，然后各种给力,据说这是一个很好的教练，然后各种给力,据说这是一个很好的教练，然后各种给力",@"据说这是一个很好的教练，",@"据说这是一个很好的教练，然后各种给力,",@"据说这是一个很好的教练，然后各种给力,据说这是一个很好的教练",@"据说这是一个很好的教练，然后各种给力,据说这是一个很好的教练，然后各种给力,据说这是一个很好的教练，然后各种给力,据说这是一个很好的教练，然后各种给力",@"据说这是一个很好的教练，",];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    self.automaticallyAdjustsScrollViewInsets = NO;
//    [_tableView setTableHeaderView:[[UIView alloc] initWithFrame:CGRectNull]];
    // Do any additional setup after loading the view from its nib.
}




- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArr.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CURRENT_BOUNDS.width, 200)];
    headView.backgroundColor = [UIColor whiteColor];
    
    UIImageView *logoView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
    logoView.center = CGPointMake(CURRENT_BOUNDS.width/2, 65);
    logoView.image = [UIImage imageNamed:@"seaKing"];
    logoView.layer.masksToBounds = YES;
    logoView.layer.cornerRadius = 40;
    [headView addSubview:logoView];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(logoView.frame)+20, CURRENT_BOUNDS.width, 20)];
    title.text = @"王玉军";
    title.font = [UIFont boldSystemFontOfSize:20];
    title.textAlignment = NSTextAlignmentCenter;
    title.textColor = BLACK_TEXT_COLOR;
    [headView addSubview:title];
    
    _startView = [[StartGradeView alloc] init];
    _startView.frame = CGRectMake(0, CGRectGetMaxY(title.frame)+15, [UIScreen mainScreen].bounds.size.width, 159);
    ChoosedCocchModel *model = [[ChoosedCocchModel alloc] init];
    model.starValue = @"4";
    model.teachNum = @"30";
    model.passPercent = @"97%";
    model.commentNum = @"100";
    
    _startView.model = model;
    _startView.backgroundColor = [UIColor whiteColor];
    [headView addSubview:_startView];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(title.frame)+63, CURRENT_BOUNDS.width, 0.5)];
    lineView.backgroundColor = DDDDDD;
    [headView addSubview:lineView];
    
    UILabel *studentEvaluate = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(_startView.frame)+22, CURRENT_BOUNDS.width, 16)];
    studentEvaluate.text = @"学员评价（100）";
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
    
    CGFloat height = [self heightForString:_dataArr[indexPath.row] andFontOfSize:15 andWidth:CURRENT_BOUNDS.width-77];
    return height+84;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *indxe = @"";
    EvaluateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indxe];
    if (!cell) {
        cell = [EvaluateTableViewCell cellWithTableToDequeueReusable:tableView identifier:indxe nibName:@"EvaluateTableViewCell"];
    }
    EvaluateModel *model = [[EvaluateModel alloc] init];
    model.star = @"4";
    model.iconUrl = @"";
    model.userName = @"我是路人甲";
    model.time = @"2017.08.14";
    model.content = _dataArr[indexPath.row];
    
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
