//
//  NSObject+LZCoding.m
//  LZExtension
//
//  Created by 何伟东 on 2019/11/14.
//  Copyright (c) 2019年 LZMobileKit. All rights reserved.
//

#import "NSObject+LZCoding.h"
#import "NSObject+LZClass.h"
#import "NSObject+LZProperty.h"
#import "LZProperty.h"

@implementation NSObject (LZCoding)

- (void)lz_encode:(NSCoder *)encoder
{
    Class clazz = [self class];
    
    NSArray *allowedCodingPropertyNames = [clazz lz_totalAllowedCodingPropertyNames];
    NSArray *ignoredCodingPropertyNames = [clazz lz_totalIgnoredCodingPropertyNames];
    
    [clazz lz_enumerateProperties:^(LZProperty *property, BOOL *stop) {
        // 检测是否被忽略
        if (allowedCodingPropertyNames.count && ![allowedCodingPropertyNames containsObject:property.name]) return;
        if ([ignoredCodingPropertyNames containsObject:property.name]) return;
        
        id value = [property valueForObject:self];
        if (value == nil) return;
        [encoder encodeObject:value forKey:property.name];
    }];
}

- (void)lz_decode:(NSCoder *)decoder
{
    Class clazz = [self class];
    
    NSArray *allowedCodingPropertyNames = [clazz lz_totalAllowedCodingPropertyNames];
    NSArray *ignoredCodingPropertyNames = [clazz lz_totalIgnoredCodingPropertyNames];
    
    [clazz lz_enumerateProperties:^(LZProperty *property, BOOL *stop) {
        // 检测是否被忽略
        if (allowedCodingPropertyNames.count && ![allowedCodingPropertyNames containsObject:property.name]) return;
        if ([ignoredCodingPropertyNames containsObject:property.name]) return;
        
        id value = [decoder decodeObjectForKey:property.name];
        if (value == nil) { // 兼容以前的LZExtension版本
            value = [decoder decodeObjectForKey:[@"_" stringByAppendingString:property.name]];
        }
        if (value == nil) return;
        [property setValue:value forObject:self];
    }];
}
@end
