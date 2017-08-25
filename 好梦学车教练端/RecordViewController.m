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
#import "IdentifyingViewController.h"
#import "PersonCenterViewController.h"

@interface RecordViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation RecordViewController{
    NSMutableArray *_data;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showNewVC:) name:@"showChoosedStduents" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SubViewController" object:@"Appear"];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self];;
}

- (void)showNewVC:(NSNotification *)notification{
    MindViewController *v = [[MindViewController alloc] init];
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:v];
    [self presentViewController:nav animated:YES completion:nil];
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
    
    for (int i = 0; i < 10; i++) {
        [_data addObject:[NSString stringWithFormat:@"%d",i]];
    }
    NSString *isLogin = [[NSUserDefaults standardUserDefaults] objectForKey:@"isLogin"];
    if (!isLogin) {
        IdentifyingViewController *v = [[IdentifyingViewController alloc] init];
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
    if (section == 0) {
        return _data.count;
    }else
        return 3;
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
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *veiw = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CURRENT_BOUNDS.width, 50)];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, CURRENT_BOUNDS.width,45 )];
    label.font = [UIFont systemFontOfSize:16];
    label.text = @"今天";
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
    
    [_data removeObjectAtIndex:indexPath.row];
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
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
