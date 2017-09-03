//
//  NSDictionary+objectForKeyWitnNoNsnull.m
//  好梦学车
//
//  Created by haomeng on 2017/7/28.
//  Copyright © 2017年 haomeng. All rights reserved.
//

#import "NSDictionary+objectForKeyWitnNoNsnull.h"

@implementation NSDictionary (objectForKeyWitnNoNsnull)


- (id)objectForKeyWithNoNsnull:(NSString *)key{
    
    if ([self objectForKey:key] == nil) {
        return @"";
    }else if ([[self objectForKey:key] isEqual:[NSNull null]]){
        return @"";
    }else
        return [self objectForKey:key];
        
}
- (BOOL)objectWithKeyReturnBool:(NSString *)key{
    
    if ([self objectForKey:key] == nil) {
        return NO;
    }else if ([[self objectForKey:key] isEqual:[NSNull null]]){
        return NO;
    }else if ([self objectForKey:key] == 0){
        return NO;
    }
    else
        return YES;
}

@end
