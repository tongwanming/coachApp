//
//  FirstBasicTableViewCell.h
//  好梦学车
//
//  Created by haomeng on 2017/5/2.
//  Copyright © 2017年 haomeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FirstBasicTableViewCell : UITableViewCell

/**
 * @brief 创建tableViewCell的类方法
 *
 * @param table 当前的tableView
 * @param identifier 当前创建的tableViewCell的标记
 */
+ (id)cellWithTableToDequeueReusable:(UITableView *)table
                          identifier:(NSString *)identifier
                             nibName:(NSString *)nibName;

@end
