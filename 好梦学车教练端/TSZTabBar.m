//
//  TSZTabBar.m
//  tabBar
//
//  Created by tongwanming on 16/5/3.
//  Copyright © 2016年 AURALIC. All rights reserved.
//

#import "TSZTabBar.h"
#import "UIView+Extension.h"
#import "UIBarButtonItem+Extension.h"

@interface  TSZTabBar()

@property (nonatomic, weak) UIButton *plusBtn;

@end

@implementation TSZTabBar

-(instancetype)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    if (self) {
       
    }
    return self;
}

/**
 *  想要重新排布系统控件subview的布局，推荐重写layoutSubviews，在调用父类布局后重新排布。
 */
- (void)layoutSubviews
{
    [super layoutSubviews];

    // 1.设置加号按钮的位置
//    self.plusBtn.centerX = self.width*0.5;
//    self.plusBtn.centerY = self.height*0.5;
    
    // 2.设置其他tabbarButton的frame
    CGFloat tabBarButtonW = CURRENT_BOUNDS.width / 5;
    CGFloat tabBarButtonIndex = 0;
    for (UIView *child in self.subviews) {
        Class class = NSClassFromString(@"UITabBarButton");
        if ([child isKindOfClass:class]) {
            // 设置x
            child.x = tabBarButtonIndex * tabBarButtonW;
            // 设置宽度
            child.width = tabBarButtonW;
            // 增加索引
            if (tabBarButtonIndex == 2) {
                child.y = 7;
            }
           
            tabBarButtonIndex++;
            //            if (tabBarButtonIndex == 2) {
            //                tabBarButtonIndex++;
            //            }
            child.userInteractionEnabled = YES;
        }
    }
}



@end
