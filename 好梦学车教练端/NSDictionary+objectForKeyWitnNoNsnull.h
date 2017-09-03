//
//  NSDictionary+objectForKeyWitnNoNsnull.h
//  好梦学车
//
//  Created by haomeng on 2017/7/28.
//  Copyright © 2017年 haomeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (objectForKeyWitnNoNsnull)

- (id)objectForKeyWithNoNsnull:(NSString *)key;

- (BOOL)objectWithKeyReturnBool:(NSString *)key;

@end
