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

@interface StudentsViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation StudentsViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showNewVC:) name:@"showChoosedStduents" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SubViewController" object:@"Appear"];
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
    
    // Do any additional setup after loading the view from its nib.
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
    return 3;
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
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *veiw = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CURRENT_BOUNDS.width, 50)];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, CURRENT_BOUNDS.width,45 )];
    label.font = [UIFont systemFontOfSize:16];
    if (section == 0) {
        label.text = @"在学学员（3）";
    }else{
        label.text = @"已完成学员（3）";
    }
    label.textColor = RECORDWORK;
    //    label.backgroundColor = [UIColor redColor];
    [veiw addSubview:label];
    
    return veiw;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    StudentsDetailViewController *v = [[StudentsDetailViewController alloc] init];
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
