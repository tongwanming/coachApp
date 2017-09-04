//
//  examingRecordViewController.m
//  好梦学车教练端
//
//  Created by haomeng on 2017/8/14.
//  Copyright © 2017年 haomeng. All rights reserved.
//

#import "examingRecordViewController.h"
#import "LearningCollectionViewCell.h"
#import "CustomAlertView.h"
#import "StudentNewsModel.h"
#import "NSDictionary+objectForKeyWitnNoNsnull.h"
#import "UIImageView+WebCache.h"

@interface examingRecordViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *data;

@property (nonatomic, assign) int passState;//通过为4，不通过为5

@end

@implementation examingRecordViewController{
    NSIndexPath *_indexPath;
}
- (IBAction)btnClick:(id)sender {
    UIButton *btn = sender;
    if (btn.tag == 1001) {
        if ([self.delegate respondsToSelector:@selector(examingRecordViewControllerClickWithBtn:)]) {
            [self.delegate performSelector:@selector(examingRecordViewControllerClickWithBtn:) withObject:btn];
        }
    }else if (btn.tag == 1002){
        if ([self.delegate respondsToSelector:@selector(examingRecordViewControllerClickWithBtn:)]) {
            [self.delegate performSelector:@selector(examingRecordViewControllerClickWithBtn:) withObject:btn];
        }
    }else{
    
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
     [self getData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
   
    _logoImageView.layer.masksToBounds = YES;
    _logoImageView.layer.cornerRadius = 8;
    _data = [[NSMutableArray alloc] init];
    
    _view1.layer.masksToBounds = YES;
    _view2.layer.cornerRadius = 4;
    
    _passBtn.layer.masksToBounds = YES;
    _passBtn.layer.cornerRadius = 4;
    _passBtn.selected = YES;
    _noPassBtn.selected = NO;
    _passBtn.backgroundColor = BLUE_BACKGROUND_COLOR;
    _noPassBtn.backgroundColor = EFF2F6;
    _passState = 4;
    
    _noPassBtn.layer.masksToBounds = YES;
    _noPassBtn.layer.cornerRadius = 4;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.subView.frame.size.width, self.subView.frame.size.height) collectionViewLayout:layout];
    self.collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.decelerationRate = UIScrollViewDecelerationRateNormal;
    
    [self.collectionView registerClass:[LearningCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([LearningCollectionViewCell class])];
    [self.collectionView setBackgroundColor:[UIColor clearColor]];
    [self.collectionView setDelegate:self];
    [self.collectionView setDataSource:self];
    self.collectionView.showsVerticalScrollIndicator = NO;
    
    [self.subView addSubview:_collectionView];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateTime = [formatter stringFromDate:[NSDate date]];
    
    self.timeLabel.text = dateTime;
    _indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)passBtnClick:(id)sender {
    UIButton *btn = sender;
    if (btn.tag == 1001) {
        _passBtn.selected = YES;
        _noPassBtn.selected = NO;
        _passBtn.backgroundColor = BLUE_BACKGROUND_COLOR;
        _noPassBtn.backgroundColor = EFF2F6;
        _passState = 4;
    }else if (btn.tag == 1002){
        _passBtn.selected = NO;
        _noPassBtn.selected = YES;
        _passBtn.backgroundColor = EFF2F6;
        _noPassBtn.backgroundColor = BLUE_BACKGROUND_COLOR;
        _passState = 5;
    }else{
    
    }
}

- (void)getData{
    
    NSMutableDictionary *userDic = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"personNews"]];
    __block NSString *cocchId = [userDic objectForKey:@"coachId"];
    NSDictionary *dic =@{@"coachId":cocchId,@"relationStates":@"1",@"studyStates":@"0,1"};
    
    
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
    
    
    //    NSURL *url = [NSURL URLWithString:urlstr];http://172.18.21.74:7076/coach/query/student
    NSURL *url = [NSURL URLWithString:@"http://172.18.21.74:7076/coach/query/student"];
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
                //                NSString *token = [dic objectForKey:@"token"];
                //                NSDictionary *userInfoDic = [dic objectForKey:@"info"];
                if (_data.count > 0) {
                    [_data removeAllObjects];
                }
                for (NSDictionary *dic in arr) {
                    NSDictionary *infoDic = [dic objectForKey:@"studentInfo"];
                    
                    StudentNewsModel *model = [[StudentNewsModel alloc] init];
                    
                    model.logoUrl = [infoDic objectForKeyWithNoNsnull:@""];
                    model.name = [infoDic objectForKeyWithNoNsnull:@"name"];
                    model.contacPhone = [infoDic objectForKeyWithNoNsnull:@"contactPhone"];
                    model.learnType = [infoDic objectForKeyWithNoNsnull:@"classType"];
                    model.studentId = [infoDic objectForKeyWithNoNsnull:@"id"];
                    model.subject = [dic objectForKeyWithNoNsnull:@"subject"];
                    model.recordId = [dic objectForKeyWithNoNsnull:@"id"];
                    model.coachId = cocchId;
                    [_data addObject:model];
                }
                
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_collectionView reloadData];
                    if (_data && _data.count > 0) {
                        StudentNewsModel *model = _data[0];
                        if (model.logoUrl) {
                            [_logoImageView sd_setImageWithURL:[NSURL URLWithString:model.logoUrl] placeholderImage:[UIImage imageNamed:@"seaKing"]];
                        }else{
                            _logoImageView.image = [UIImage imageNamed:@"seaKing"];
                        }
                        
                        _nameLabel.text = model.name;
                        _typeLabel.text = model.subject;
                    }else{
                    
                    }
                    
                });
                
            }else{
                //登录失败
                dispatch_async(dispatch_get_main_queue(), ^{
                    //验证码输入错误
                    UIAlertController *v = [UIAlertController alertControllerWithTitle:@"错误提示" message:@"数据获取失败，请稍后再试" preferredStyle:UIAlertControllerStyleAlert];
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
                UIAlertController *v = [UIAlertController alertControllerWithTitle:@"错误提示" message:@"数据获取失败，请稍后再试" preferredStyle:UIAlertControllerStyleAlert];
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


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _data.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LearningCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([LearningCollectionViewCell class]) forIndexPath:indexPath];
    cell.isSelected = NO;
    if (indexPath == _indexPath) {
        cell.isSelected = YES;
    }else{
        cell.isSelected = NO;
    }
    
    cell.backgroundColor = [UIColor clearColor];
    StudentNewsModel *model = _data[indexPath.row];
    cell.model = model;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    _indexPath = indexPath;
    [self.collectionView reloadData];
    
    StudentNewsModel *model = _data[indexPath.row];
    if (model.logoUrl) {
        [_logoImageView sd_setImageWithURL:[NSURL URLWithString:model.logoUrl] placeholderImage:[UIImage imageNamed:@"seaKing"]];
    }else{
        _logoImageView.image = [UIImage imageNamed:@"seaKing"];
    }
    
    _nameLabel.text = model.name;
    _typeLabel.text = model.subject;
    model.passState = _passState;
    if ([self.delegate respondsToSelector:@selector(addExamStudentWithModel:)]) {
        [self.delegate performSelector:@selector(addExamStudentWithModel:) withObject:model];
    }
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((self.subView.frame.size.width-90)/4, (self.subView.frame.size.width-90)/4+13+14);
}



- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout*)collectionViewLayout
minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout*)collectionViewLayout
minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}

//边距设置:整体边距的优先级，始终高于内部边距的优先级
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                       layout:(UICollectionViewLayout *)collectionViewLayout
       insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(20, 15, 20, 15);
}

- (void)setFinishStr:(NSString *)finishStr{
    if ([finishStr isEqualToString:@"success"]) {
        //添加成功
        UIAlertController *v = [UIAlertController alertControllerWithTitle:@"添加成功" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *active = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [v addAction:active];
        [self presentViewController:v animated:YES completion:^{
            
        }];
    }else{
        //添加失败
        //添加成功
        UIAlertController *v = [UIAlertController alertControllerWithTitle:@"添加失败" message:@"添加失败，请再试一次！" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *active = [UIAlertAction actionWithTitle:@"重新添加" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [v addAction:active];
        [self presentViewController:v animated:YES completion:^{
            
        }];
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
