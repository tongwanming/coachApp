//
//  MainViewController.m
//  好梦学车教练端
//
//  Created by haomeng on 2017/8/10.
//  Copyright © 2017年 haomeng. All rights reserved.
//

#import "MainViewController.h"
#import "MyViewController.h"
#import "EvaluateViewController.h"
#import "MindViewController.h"
#import "StudentsViewController.h"
#import "RecordViewController.h"
#import "TSZTabBar.h"

//test
#import "CustonNavViewController.h"

@interface MainViewController ()<UITabBarDelegate,UINavigationControllerDelegate>

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addChildVc:[[RecordViewController alloc] init] title:@"记录" image:[UIImage imageNamed:@"tab_btn_recording_normal@2x"] selectedImage:[UIImage imageNamed:@"tab_btn_recording_click@2x"] andHasNav:YES withFrame:CGRectMake(0, 0, CURRENT_BOUNDS.width/5, 44)];
    [self addChildVc:[[StudentsViewController alloc] init] title:@"学员" image:[UIImage imageNamed:@"tab_btn_student_normal@2x"] selectedImage:[UIImage imageNamed:@"tab_btn_student_click@2x"] andHasNav:YES withFrame:CGRectMake(CURRENT_BOUNDS.width/5, 0, CURRENT_BOUNDS.width/5, 44)];
    [self addChildVc:[[MindViewController alloc] init] title:@"" image:[UIImage imageNamed:@"tab_btn_add_normal@2x"] selectedImage:[UIImage imageNamed:@"tab_btn_add_normal@2x"] andHasNav:YES withFrame:CGRectMake(CURRENT_BOUNDS.width/5*2, 0, CURRENT_BOUNDS.width/5, 44)];
    [self addChildVc:[[EvaluateViewController alloc] init] title:@"评价" image:[UIImage imageNamed:@"tab_btn_evaluation_normal@2x"] selectedImage:[UIImage imageNamed:@"tab_btn_evaluation_click@2x"] andHasNav:YES withFrame:CGRectMake(CURRENT_BOUNDS.width/5*3, 0, CURRENT_BOUNDS.width/5, 44)];
    [self addChildVc:[[MyViewController alloc] init] title:@"我的" image:[UIImage imageNamed:@"tab_btn_my_normal@2x"] selectedImage:[UIImage imageNamed:@"tab_btn_my_click@2x"] andHasNav:YES withFrame:CGRectMake(CURRENT_BOUNDS.width/5*4, 0, CURRENT_BOUNDS.width/5, 44)];
    
    TSZTabBar *tabBar = [[TSZTabBar alloc] init];
    //    tabBar.backgroundColor = [UIColor redColor];
    tabBar.delegate = self;
    [self setValue:tabBar forKey:@"tabBar"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(intoReceivedVCPush:) name:@"SubViewController" object:nil];
    // Do any additional setup after loading the view from its nib.
}

- (void)intoReceivedVCPush:(NSNotification *)notification{
    
    CustonNavViewController *selectNav = self.selectedViewController;
    UIViewController *showVC = selectNav.viewControllers.lastObject;
    
    if (![showVC isKindOfClass:[RecordViewController class]] && ![showVC isKindOfClass:[StudentsViewController class]] && ![showVC isKindOfClass:[EvaluateViewController class]] && ![showVC isKindOfClass:[MyViewController class]]) {
        NSString *VCStr = notification.object;
        if ([VCStr isEqualToString:@"Appear"]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.tabBar.hidden = NO;
            });
            
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                self.tabBar.hidden = YES;
            });
        }
    }else{
        if (self.tabBar.hidden) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.tabBar.hidden = NO;
            });
        }
    }
}
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    NSLog(@"%@",item.title);
}


- (void)addChildVc:(UIViewController *)childVc title:(NSString *)title image:(UIImage *)image selectedImage:(UIImage *)selectedImage andHasNav:(BOOL)nav withFrame:(CGRect)frame
{
    // 设置子控制器的文字(可以设置tabBar和navigationBar的文字)
    childVc.title = title;
    
    // 设置子控制器的tabBarItem图片
    childVc.tabBarItem.image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    
    // 禁用图片渲染
    childVc.tabBarItem.selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //    childVc.tabBarItem.imageInsets = UIEdgeInsetsMake(3, 1.5, 0, 1.5);
    
    //    childVc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage] imageWithAlignmentRectInsets:UIEdgeInsetsMake(10, 0, 0, 0)];
    
    // 设置文字的样式
    [childVc.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName :  [UIColor colorWithRed:0.27f green:0.29f blue:0.30f alpha:1.00f]} forState:UIControlStateNormal];
    [childVc.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:0.02f green:0.63f blue:1.00f alpha:1.00f]} forState:UIControlStateSelected];
    //        childVc.view.backgroundColor = RandomColor; // 这句代码会自动加载主页，消息，发现，我四个控制器的view，但是view要在我们用的时候去提前加载
    
    //    childVc.tabBarItem.accessibilityFrame = frame;
    
    // 为子控制器包装导航控制器
    CustonNavViewController *navigationVc;
    if (nav) {
        navigationVc = [[CustonNavViewController alloc] initWithRootViewController:childVc];
        navigationVc.delegate = self;
        // 添加子控制器
        [self addChildViewController:navigationVc];
    }else{
        // 添加子控制器
        [self addChildViewController:childVc];
    }
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if ([navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
