//
//  PersonNewsViewController.m
//  好梦学车
//
//  Created by haomeng on 2017/6/6.
//  Copyright © 2017年 haomeng. All rights reserved.
//

#import "PersonNewsViewController.h"
#import "SettingPersonNewsModel.h"
#import "UIImageView+WebCache.h"
#import "SubjectTwoPopWebViewController.h"
#import "CustomAlertView.h"

@interface SettingPersonNewsTableViewCell : UITableViewCell
@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *describeLabel;

@property (nonatomic, strong) UIImageView *showImageView;

@property (nonatomic, strong) SettingPersonNewsModel *model;

@end

@implementation SettingPersonNewsTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = F4F6F9;
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CURRENT_BOUNDS.width/2-85/2, 20, 85, 24)];
        _timeLabel.layer.masksToBounds = YES;
        _timeLabel.layer.cornerRadius = 12;
        _timeLabel.backgroundColor = CCCFD6;
        _timeLabel.textColor = [UIColor whiteColor];
        _timeLabel.font = [UIFont systemFontOfSize:13];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.text = @"08-22 11:30";
        [self.contentView addSubview:_timeLabel];
        
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(10, 59, CURRENT_BOUNDS.width-20, 317.5)];
        backView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:backView];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 16, CURRENT_BOUNDS.width-20-32, 18)];
        _titleLabel.font = [UIFont systemFontOfSize:18];
        _titleLabel.textColor = TEXT_COLOR;
        _titleLabel.text = @"欢迎您加入好梦学车";
        [backView addSubview:_titleLabel];
        
        _describeLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, CGRectGetMaxY(_titleLabel.frame)+15, CURRENT_BOUNDS.width-20-32, 26+10)];
        _describeLabel.font = [UIFont systemFontOfSize:13];
        _describeLabel.textColor = ADB1B9;
        _describeLabel.text = @"这是对该条消息的一个具体描述内容";
        [backView addSubview:_describeLabel];
        
        _showImageView = [[UIImageView alloc] initWithFrame:CGRectMake(16, CGRectGetMaxY(_describeLabel.frame)+16, CURRENT_BOUNDS.width - 20-32, 150)];
        _showImageView.contentMode = UIViewContentModeScaleToFill;
        
        _showImageView.image = [UIImage imageNamed:@"pic04"];
        [backView addSubview:_showImageView];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(16, CGRectGetMaxY(_showImageView.frame)+16, CURRENT_BOUNDS.width-20-32, 0.5)];
        lineView.backgroundColor = EEEEEE;
        [backView addSubview:lineView];
        
        UILabel *logoLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, CGRectGetMaxY(lineView.frame)+20, 200, 15)];
        logoLabel.font = [UIFont systemFontOfSize:15];
        logoLabel.textColor = TEXT_COLOR;
        logoLabel.text = @"了解详情";
        [backView addSubview:logoLabel];
        
        UIImageView *imageLogo = [[UIImageView alloc] initWithFrame:CGRectMake(CURRENT_BOUNDS.width-50, CGRectGetMaxY(lineView.frame)+20, 20, 15)];
        imageLogo.contentMode = UIViewContentModeScaleAspectFit;
        imageLogo.image = [UIImage imageNamed:@"btn_go"];
        [backView addSubview:imageLogo];
        
    }
    return self;
}

- (void)setModel:(SettingPersonNewsModel *)model{
    _model = model;
    _titleLabel.text = _model.timeStr;
    _titleLabel.text = _model.titleStr;
    _describeLabel.text = _model.imageUrl;
    [_showImageView sd_setImageWithURL:[NSURL URLWithString:_model.imageUrl] placeholderImage:[UIImage imageNamed:@""]];
}

@end

@interface PersonNewsViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation PersonNewsViewController
{
    NSArray *_data;
}
- (IBAction)btnClick:(id)sender {
    UIButton *btn = sender;
    if (btn.tag == 1001) {
        [self.navigationController popViewControllerAnimated:YES];
    }else if (btn.tag == 1002){
        SubjectTwoPopWebViewController *v = [[SubjectTwoPopWebViewController alloc] init];
        v.url = @"https://eco-api.meiqia.com/dist/standalone.html?eid=10708";
        v.titleStr = @"在线咨询";
        [self.navigationController pushViewController:v animated:YES];
    }
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SubViewController" object:@"Disappear"];
     [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SubViewController" object:@"Appear"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [_tableView setTableHeaderView:[[UIView alloc] initWithFrame:CGRectZero]];
    // Do any additional setup after loading the view from its nib.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 378;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *index = @"index";
    SettingPersonNewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:index];
    if (!cell) {
        cell = [[SettingPersonNewsTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:index];
    }
    
//    cell.model = _data[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SubjectTwoPopWebViewController *v = [[SubjectTwoPopWebViewController alloc] init];
    v.url = @"https://cq.haomeng.com/wx/about-us";
    v.titleStr = @"系统消息";
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
