//
//  SettingViewController.m
//  好梦学车
//
//  Created by haomeng on 2017/5/31.
//  Copyright © 2017年 haomeng. All rights reserved.
//

#import "SettingViewController.h"
#import "TicklingViewController.h"
#import "SubjectTwoPopWebViewController.h"
#import "SDImageCache.h"
#import "CustomAlertView.h"


@interface SettingViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SettingViewController{
    double _cache;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SubViewController" object:@"Disappear"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _showClear.hidden = YES;
    self.view.backgroundColor = [UIColor colorWithRed:0.97f green:0.97f blue:0.97f alpha:1.00f];
    _cache = [self getCacheSize];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _tableView.scrollEnabled = NO;
    
    _outBtn.layer.masksToBounds = YES;
    _outBtn.layer.cornerRadius = 45/2;
    
    NSLog(@"---%f",[self getCacheSize]);
    
    // Do any additional setup after loading the view from its nib.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 2;
    }else
        return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *index = @"index";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:index];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:index];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    cell.textLabel.textColor = TEXT_COLOR;
    NSString *str;
    cell.detailTextLabel.text = @"";
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            str = @"清除缓存";
            if (_cache < 0.005) {
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%dM",0];
            }else{
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2lfM",_cache];
            }
            
        }else{
            str = @"问题反馈";
        }
    }else if (indexPath.section == 1){
        str = @"关于好梦学车";
        
    }else{
    
    }
    cell.textLabel.text = str;
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 1) {
            TicklingViewController *v = [[TicklingViewController alloc] init];
            [self.navigationController pushViewController:v animated:YES];
        }
        if (indexPath.row == 0) {
            [CustomAlertView showAlertViewWithVC:self];
            [[SDImageCache sharedImageCache] clearDisk];
            [[NSFileManager defaultManager] removeItemAtPath:[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)lastObject] error:nil];
            [CustomAlertView hideAlertView];
            _cache = [self getCacheSize];
            [_tableView reloadData];
        }
    }else if (indexPath.section == 1){
        SubjectTwoPopWebViewController *v = [[SubjectTwoPopWebViewController alloc] init];
        v.url = @"https://cq.haomeng.com/wx/about-us";
        v.titleStr = @"关于好梦";
        [self.navigationController pushViewController:v animated:YES];
    }
}

- (IBAction)btnClickActive:(id)sender {
    UIButton *btn = sender;
    if (btn.tag == 1001) {
         [self.navigationController popViewControllerAnimated:YES];
    }else if(btn.tag == 1002){
        NSLog(@"退出登陆   ");
        [CustomAlertView showAlertViewWithVC:self];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"isLogined"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"isLogin"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"personNews"];
        [CustomAlertView hideAlertView];
         [self.navigationController popViewControllerAnimated:YES];
    }else{
    
    }
   
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SubViewController" object:@"Appear"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (double)getCacheSize{
    SDImageCache *imageCache = [SDImageCache sharedImageCache];
    NSUInteger fileSize = [imageCache getSize];
    NSString *myCachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)lastObject];
    
    NSFileManager *fm = [NSFileManager defaultManager];
    NSDictionary *fileInfo = [fm attributesOfItemAtPath:myCachePath error:nil];
    fileSize += fileInfo.fileSize;
    if (fileSize/1024.0/1024.0 < 0.005) {
        _showClear.hidden = NO;
    }
    return fileSize/1024.0/1024.0;
}

@end
