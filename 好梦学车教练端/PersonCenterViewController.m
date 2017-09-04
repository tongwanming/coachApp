//
//  PersonCenterViewController.m
//  好梦学车
//
//  Created by haomeng on 2017/8/1.
//  Copyright © 2017年 haomeng. All rights reserved.
//

#import "PersonCenterViewController.h"
#import "SubjectTwoPopWebViewController.h"
#import "PersonNewsViewController.h"
#import "eventNotictionViewController.h"

@interface PersonCenterTableViewCell : UITableViewCell

@property (nonatomic, strong) NSString *imageUrl;
@property (nonatomic, strong) NSString *titleStr;
@property (nonatomic, strong) NSString *desTitleStr;
@property (nonatomic, strong) NSString *timeStr;
@property (nonatomic, strong) NSString *newsCount;


@end

@implementation PersonCenterTableViewCell{
    UIImageView *_imageView;
    UILabel *_newCount;
    UILabel *_titleLabel;
    UILabel *_dedLabel;
    UILabel *tiumeLabel;
}

- (void)setImageUrl:(NSString *)imageUrl{
    [_imageView setImage:[UIImage imageNamed:imageUrl]];
}

- (void)setTitleStr:(NSString *)titleStr{
    _titleStr = titleStr;
    _titleLabel.text = titleStr;
}

- (void)setDesTitleStr:(NSString *)desTitleStr{
    _desTitleStr = desTitleStr;
    _dedLabel.text = desTitleStr;
}

- (void)setTimeStr:(NSString *)timeStr{
    _timeStr = timeStr;
    tiumeLabel.text = _timeStr;
}

- (void)setNewsCount:(NSString *)newsCount{
    _newsCount = newsCount;
    _newCount.text = newsCount;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(16, 17, 84/2, 84/2)];
        _imageView.center = CGPointMake(16+84/4, self.frame.size.height/2+17);
        _imageView.layer.masksToBounds = YES;
        _imageView.layer.cornerRadius = 84/4;
        _imageView.image = [UIImage imageNamed:@"icon"];
        [self addSubview:_imageView];
        
        _newCount = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 17, 17)];
        _newCount.backgroundColor = [UIColor orangeColor];
        _newCount.layer.masksToBounds = YES;
        _newCount.layer.cornerRadius = 17/2;
        _newCount.layer.borderColor = [UIColor whiteColor].CGColor;
        _newCount.layer.borderWidth = 1;
        _newCount.font = [UIFont systemFontOfSize:12];
        _newCount.textAlignment = NSTextAlignmentCenter;
        _newCount.textColor = [UIColor whiteColor];
        _newCount.text = @"5";
        _newCount.center = CGPointMake(84/2+16-4, self.frame.size.height/2+17-84/4+5);
        [self addSubview:_newCount];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_imageView.frame)+16, 18, CURRENT_BOUNDS.width-100, 16)];
        _titleLabel.font = [UIFont boldSystemFontOfSize:16];
        _titleLabel.textColor = TEXT_COLOR;
        _titleLabel.text = @"系统消息";
        [self addSubview:_titleLabel];
        
        _dedLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_imageView.frame)+16, CGRectGetMaxY(_titleLabel.frame)+9, CURRENT_BOUNDS.width-100, 14)];
        _dedLabel.textColor = ADB1B9;
        _dedLabel.font = [UIFont systemFontOfSize:14];
        _dedLabel.text = @"最新版本v2.24好梦学车客户端已经在各大应用市场上线！";
        [self addSubview:_dedLabel];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CURRENT_BOUNDS.width-150, 19.5, 150-16, 13)];
        _titleLabel.textAlignment = NSTextAlignmentRight;
        _titleLabel.font = [UIFont systemFontOfSize:13];
        _titleLabel.textColor = ADB1B9;
        _titleLabel.text = @"4-21";
        [self addSubview:_titleLabel];
        
        
    }
    
    return self;
}

@end

@interface PersonCenterViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation PersonCenterViewController{
    NSArray *_imageData;
    NSArray *_titleData;
}

- (IBAction)btnClick:(id)sender {
    UIButton *btn = sender;
    if (btn.tag == 1001) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else if (btn.tag == 1002){
        SubjectTwoPopWebViewController *v = [[SubjectTwoPopWebViewController alloc] init];
        v.url = @"https://eco-api.meiqia.com/dist/standalone.html?eid=10708";
        v.titleLabel.text = @"在线咨询";
        [self.navigationController pushViewController:v animated:YES];
    }else{
    
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SubViewController" object:@"Disappear"];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SubViewController" object:@"Appear"];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
    _imageData = @[@"icon_messcenter_system",@"icon_messcenter_activity",@"icon_messcenter_register",@"icon_messcenter_examination"];
    _titleData = @[@"系统消息",@"活动消息",@"签到消息",@"考试消息"];
    // Do any additional setup after loading the view from its nib.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 74;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *indxe = @"ddd";
    PersonCenterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indxe];
    if (!cell) {
        cell = [[PersonCenterTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:indxe];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.imageUrl = _imageData[indexPath.row];
    cell.titleStr = _titleData[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        PersonNewsViewController *v = [[PersonNewsViewController alloc] init];
        [self.navigationController pushViewController:v animated:YES];
    }else if (indexPath.row == 1){
        eventNotictionViewController *v = [[eventNotictionViewController alloc] init];
        [self.navigationController pushViewController:v animated:YES];
    }else{
    
    }
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
