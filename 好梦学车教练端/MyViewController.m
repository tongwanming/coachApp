//
//  MyViewController.m
//  好梦学车教练端
//
//  Created by haomeng on 2017/8/10.
//  Copyright © 2017年 haomeng. All rights reserved.
//

#import "MyViewController.h"
#import "MindViewController.h"
#import "MindViewController.h"
#import "SinginViewController.h"
#import "FinishPersonNewsViewController.h"
#import "SettingViewController.h"
#import "PersonCenterViewController.h"
#import "UIImageView+WebCache.h"

@interface MyViewTableViewcell : UITableViewCell

@property (nonatomic, strong) NSString *detailStr;

@property (nonatomic, strong) NSString *imageStr;

@property (nonatomic, strong) NSString *titleStr;

@end

@implementation MyViewTableViewcell{
    UILabel *_detailLabel;
    UIImageView *_logoImageView;
    UILabel *_titleLabel;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(CURRENT_BOUNDS.width-100, 30-16/2, 100, 16)];
        _detailLabel.textColor = F39D10;
        _detailLabel.font = [UIFont systemFontOfSize:16];
        [self addSubview:_detailLabel];
        
        _logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 30-12, 24, 24)];
        [self addSubview:_logoImageView];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_logoImageView.frame)+14, 30-17/2, 150, 17)];
        _titleLabel.textColor = BLACK_TEXT_COLOR;
        _titleLabel.font = [UIFont systemFontOfSize:17];
        [self addSubview:_titleLabel];
        
    }
    
    return self;
}

//- (void)layoutSubviews{
//    _logoImageView.center = CGPointMake(16+15, self.frame.size.height/2);
//}

- (void)setTitleStr:(NSString *)titleStr{
    _titleStr = titleStr;
    _titleLabel.text = titleStr;
}

- (void)setImageStr:(NSString *)imageStr{
    _imageStr = imageStr;
    _logoImageView.image = [UIImage imageNamed:imageStr];
}

- (void)setDetailStr:(NSString *)detailStr{
    _detailStr = detailStr;
    _detailLabel.text = detailStr;
}

@end

@interface MyViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation MyViewController{
    NSArray *_imageData;
    NSArray *_titleData;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showNewVC:) name:@"showChoosedStduents" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SubViewController" object:@"Appear"];
    
    NSString *isLogin = [[NSUserDefaults standardUserDefaults] objectForKey:@"isLogin"];
    if (!isLogin) {
        SinginViewController *v = [[SinginViewController alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:v];
        [self presentViewController:nav animated:YES completion:nil];
    }else{
        
    }
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"personNews"]];
    NSData *image = [dic objectForKey:@"userLogoImage"];
    if (image && [image isKindOfClass:[NSData class]]) {
        //            [_imageBtn setBackgroundImage:[UIImage imageWithData:image] forState:UIControlStateNormal];
        _logoImageView.image = [UIImage imageWithData:image];
        
    }else{
         [_logoImageView sd_setImageWithURL:[NSURL URLWithString:(NSString *)image] placeholderImage:[UIImage imageNamed:@"bg_secondarylogin03_avatar.png"]];
    }
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    NSMutableDictionary *userDic = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"personNews"]];
    
   
    _nameLabel.text = [NSString stringWithFormat:@"%@",[userDic objectForKey:@"userName"]];
    _locationLabel.text = [NSString stringWithFormat:@"%@",[userDic objectForKey:@"address"]];
    _numberPersons.text = [NSString stringWithFormat:@"%@",[userDic objectForKey:@"totalTeachNum"]];
    _passLabel.text = [NSString stringWithFormat:@"%@%%",[userDic objectForKey:@"passRate"]];
    if ([NSString stringWithFormat:@"%@",[userDic objectForKey:@"totalRemarkNum"]].length > 0) {
        _studentsLabel.text = [NSString stringWithFormat:@"%@",[userDic objectForKey:@"totalRemarkNum"]];
    }else{
        _studentsLabel.text = @"0";
    }
    
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
- (IBAction)btnClick:(id)sender {
    FinishPersonNewsViewController *v = [[FinishPersonNewsViewController alloc] init];
    [self.navigationController pushViewController:v animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _imageData = @[@"icon_my_income@2x",@"icon_my_message@2x",@"icon_my_sitting@2x"];
    _titleData = @[@"我的收入",@"我的消息",@"系统设置"];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _logoImageView.layer.masksToBounds = YES;
    _logoImageView.layer.cornerRadius = _logoImageView.frame.size.height/2;
//    _logoImageView.backgroundColor = [UIColor redColor];
    
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
    
   
    // Do any additional setup after loading the view from its nib.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 2;
    }else
        return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
        static NSString *index = @"d";
    MyViewTableViewcell *cell = [tableView dequeueReusableCellWithIdentifier:index];
    if (!cell) {
        cell = [[MyViewTableViewcell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:index];
    }
    cell.detailStr = @"";
    cell.imageStr = _imageData[indexPath.row];
    
    cell.titleStr = _titleData[indexPath.row];
    if (indexPath.section == 0 && indexPath.row == 1) {
//         cell.detailStr = @"1条未读";
    }
    if (indexPath.section == 1) {
        cell.imageStr = _imageData[2];
        cell.titleStr = _titleData[2];
    }
    if (indexPath.section == 0) {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }else{
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
//        if (indexPath.row == 0) {
//            UIAlertController *v = [UIAlertController alertControllerWithTitle:@"提示" message:@"程序员正在拼命开发中......" preferredStyle:UIAlertControllerStyleAlert];
//            UIAlertAction *active = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//                
//            }];
//            [v addAction:active];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [self presentViewController:v animated:YES completion:^{
//                    
//                }];
//            });
//        }else{
//            PersonCenterViewController *v = [[PersonCenterViewController alloc] init];
//            [self.navigationController pushViewController:v animated:YES];
//        }
        UIAlertController *v = [UIAlertController alertControllerWithTitle:@"提示" message:@"程序员正在拼命开发中......" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *active = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [v addAction:active];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self presentViewController:v animated:YES completion:^{
                
            }];
        });
    }else if (indexPath.section ==1){
        SettingViewController *v = [[SettingViewController alloc] init];
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
