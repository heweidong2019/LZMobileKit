//
//  NSObject+LZClass.m
//  LZExtensionExample
//
//  Created by 何伟东 on 2019/11/14.
//  Copyright (c) 2019年 LZMobileKit. All rights reserved.
//

#import "NSObject+LZClass.h"
#import "NSObject+LZCoding.h"
#import "NSObject+LZKeyValue.h"
#import "LZFoundation.h"
#import <objc/runtime.h>

static const char LZAllowedPropertyNamesKey = '\0';
static const char LZIgnoredPropertyNamesKey = '\0';
static const char LZAllowedCodingPropertyNamesKey = '\0';
static const char LZIgnoredCodingPropertyNamesKey = '\0';

@implementation NSObject (LZClass)

+ (NSMutableDictionary *)lz_classDictForKey:(const void *)key
{
    static NSMutableDictionary *allowedPropertyNamesDict;
    static NSMutableDictionary *ignoredPropertyNamesDict;
    static NSMutableDictionary *allowedCodingPropertyNamesDict;
    static NSMutableDictionary *ignoredCodingPropertyNamesDict;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        allowedPropertyNamesDict = [NSMutableDictionary dictionary];
        ignoredPropertyNamesDict = [NSMutableDictionary dictionary];
        allowedCodingPropertyNamesDict = [NSMutableDictionary dictionary];
        ignoredCodingPropertyNamesDict = [NSMutableDictionary dictionary];
    });
    
    if (key == &LZAllowedPropertyNamesKey) return allowedPropertyNamesDict;
    if (key == &LZIgnoredPropertyNamesKey) return ignoredPropertyNamesDict;
    if (key == &LZAllowedCodingPropertyNamesKey) return allowedCodingPropertyNamesDict;
    if (key == &LZIgnoredCodingPropertyNamesKey) return ignoredCodingPropertyNamesDict;
    return nil;
}

+ (void)lz_enumerateClasses:(LZClassesEnumeration)enumeration
{
    // 1.没有block就直接返回
    if (enumeration == nil) return;
    
    // 2.停止遍历的标记
    BOOL stop = NO;
    
    // 3.当前正在遍历的类
    Class c = self;
    
    // 4.开始遍历每一个类
    while (c && !stop) {
        // 4.1.执行操作
        enumeration(c, &stop);
        
        // 4.2.获得父类
        c = class_getSuperclass(c);
        
        if ([LZFoundation isClassFromFoundation:c]) break;
    }
}

+ (void)lz_enumerateAllClasses:(LZClassesEnumeration)enumeration
{
    // 1.没有block就直接返回
    if (enumeration == nil) return;
    
    // 2.停止遍历的标记
    BOOL stop = NO;
    
    // 3.当前正在遍历的类
    Class c = self;
    
    // 4.开始遍历每一个类
    while (c && !stop) {
        // 4.1.执行操作
        enumeration(c, &stop);
        
        // 4.2.获得父类
        c = class_getSuperclass(c);
    }
}

#pragma mark - 属性黑名单配置
+ (void)lz_setupIgnoredPropertyNames:(LZIgnoredPropertyNames)ignoredPropertyNames
{
    [self lz_setupBlockReturnValue:ignoredPropertyNames key:&LZIgnoredPropertyNamesKey];
}

+ (NSMutableArray *)lz_totalIgnoredPropertyNames
{
    return [self lz_totalObjectsWithSelector:@selector(lz_ignoredPropertyNames) key:&LZIgnoredPropertyNamesKey];
}

#pragma mark - 归档属性黑名单配置
+ (void)lz_setupIgnoredCodingPropertyNames:(LZIgnoredCodingPropertyNames)ignoredCodingPropertyNames
{
    [self lz_setupBlockReturnValue:ignoredCodingPropertyNames key:&LZIgnoredCodingPropertyNamesKey];
}

+ (NSMutableArray *)lz_totalIgnoredCodingPropertyNames
{
    return [self lz_totalObjectsWithSelector:@selector(lz_ignoredCodingPropertyNames) key:&LZIgnoredCodingPropertyNamesKey];
}

#pragma mark - 属性白名单配置
+ (void)lz_setupAllowedPropertyNames:(LZAllowedPropertyNames)allowedPropertyNames;
{
    [self lz_setupBlockReturnValue:allowedPropertyNames key:&LZAllowedPropertyNamesKey];
}

+ (NSMutableArray *)lz_totalAllowedPropertyNames
{
    return [self lz_totalObjectsWithSelector:@selector(lz_allowedPropertyNames) key:&LZAllowedPropertyNamesKey];
}

#pragma mark - 归档属性白名单配置
+ (void)lz_setupAllowedCodingPropertyNames:(LZAllowedCodingPropertyNames)allowedCodingPropertyNames
{
    [self lz_setupBlockReturnValue:allowedCodingPropertyNames key:&LZAllowedCodingPropertyNamesKey];
}

+ (NSMutableArray *)lz_totalAllowedCodingPropertyNames
{
    return [self lz_totalObjectsWithSelector:@selector(lz_allowedCodingPropertyNames) key:&LZAllowedCodingPropertyNamesKey];
}

#pragma mark - block和方法处理:存储block的返回值
+ (void)lz_setupBlockReturnValue:(id (^)(void))block key:(const char *)key
{
    if (block) {
        objc_setAssociatedObject(self, key, block(), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    } else {
        objc_setAssociatedObject(self, key, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    // 清空数据
    LZExtensionSemaphoreCreate
    LZExtensionSemaphoreWait
    [[self lz_classDictForKey:key] removeAllObjects];
    LZExtensionSemaphoreSignal
}

+ (NSMutableArray *)lz_totalObjectsWithSelector:(SEL)selector key:(const char *)key
{
    LZExtensionSemaphoreCreate
    LZExtensionSemaphoreWait
    NSMutableArray *array = [self lz_classDictForKey:key][NSStringFromClass(self)];
    if (array == nil) {
        // 创建、存储
        [self lz_classDictForKey:key][NSStringFromClass(self)] = array = [NSMutableArray array];
        
        if ([self respondsToSelector:selector]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            NSArray *subArray = [self performSelector:selector];
#pragma clang diagnostic pop
            if (subArray) {
                [array addObjectsFromArray:subArray];
            }
        }
        
        [self lz_enumerateAllClasses:^(__unsafe_unretained Class c, BOOL *stop) {
            NSArray *subArray = objc_getAssociatedObject(c, key);
            [array addObjectsFromArray:subArray];
        }];
    }
    LZExtensionSemaphoreSignal
    return array;
}
@end
