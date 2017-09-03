//
//  StudentNewsModel.h
//  好梦学车教练端
//
//  Created by haomeng on 2017/8/26.
//  Copyright © 2017年 haomeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StudentNewsModel : NSObject

@property (nonatomic, strong) NSString *choosedType;//当前的阶段，在学车记录或者是在考试记录

@property (nonatomic, strong) NSString *studentId;//学员id

@property (nonatomic, strong) NSString *coachId;//教练id

@property (nonatomic, strong) NSString *name;

@property (nonatomic, strong) NSString *contacPhone;//联系电话

@property (nonatomic, strong) NSString *logoUrl;//头像

@property (nonatomic, strong) NSString *subject;//所学的进度

@property (nonatomic, strong) NSString *learnType;//所学班型

@property (nonatomic, strong) NSString *recordId;//删除的时候用的id

@property (nonatomic, strong) NSString *test1;

@property (nonatomic, strong) NSString *test2;

@end
