//
//  learningViewController.m
//  好梦学车教练端
//
//  Created by haomeng on 2017/8/14.
//  Copyright © 2017年 haomeng. All rights reserved.
//

#import "learningViewController.h"
#import "LearningCollectionViewCell.h"

typedef void(^StudentBlock)(StudentNewsModel *);

@interface learningViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) StudentBlock student_block;

@end

@implementation learningViewController{
    NSIndexPath *_indexPath;
}
- (IBAction)btnClick:(id)sender {
    UIButton *btn = sender;
    if (btn.tag == 1001) {
        //选择时间
        if ([self.delegate respondsToSelector:@selector(learningViewControllerBtnClickWihtBtn:)]) {
            [self.delegate performSelector:@selector(learningViewControllerBtnClickWihtBtn:) withObject:btn];
        }
    }else if (btn.tag == 1002){
        //选择科目
        if ([self.delegate respondsToSelector:@selector(learningViewControllerBtnClickWihtBtn:)]) {
            [self.delegate performSelector:@selector(learningViewControllerBtnClickWihtBtn:) withObject:btn];
        }
    }else if (btn.tag == 1003){
        //编辑
    
    }else if (btn.tag == 1004){
        //添加学员
    
    }else{
    
    }
}

- (void)choosedPersonBlock:(void (^)(StudentNewsModel *))block{
    _student_block = block;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _logoImageView.layer.masksToBounds = YES;
    _logoImageView.layer.cornerRadius = 8;
    
    _view1.layer.masksToBounds = YES;
    _view2.layer.cornerRadius = 4;
    
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

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 20;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LearningCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([LearningCollectionViewCell class]) forIndexPath:indexPath];
    
    cell.isSelected = NO;
    cell.idexPath = indexPath;
    if (indexPath == _indexPath) {
        cell.isSelected = YES;
    }else{
        cell.isSelected = NO;
    }
    
    cell.backgroundColor = [UIColor redColor];
    cell.imageView.image = [UIImage imageNamed:@"bg_addrecord_avatar.png"];
    cell.titleLabel.text = [NSString stringWithFormat:@"---%ld",(long)indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    _indexPath = indexPath;
    [self.collectionView reloadData];
    for (LearningCollectionViewCell *cell in _collectionView.visibleCells) {
        if (cell.idexPath == indexPath) {
            _logoImageView.image = cell.imageView.image;
            _nameLabel.text = cell.titleLabel.text;
        }
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
