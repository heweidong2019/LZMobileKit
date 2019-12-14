//
//  NSObject+LZProperty.m
//  LZExtensionExample
//
//  Created by 何伟东 on 2019/11/14.
//  Copyright (c) 2019年 LZMobileKit. All rights reserved.
//

#import "NSObject+LZProperty.h"
#import "NSObject+LZKeyValue.h"
#import "NSObject+LZCoding.h"
#import "NSObject+LZClass.h"
#import "LZProperty.h"
#import "LZFoundation.h"
#import <objc/runtime.h>

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"

static const char LZReplacedKeyFromPropertyNameKey = '\0';
static const char LZReplacedKeyFromPropertyName121Key = '\0';
static const char LZNewValueFromOldValueKey = '\0';
static const char LZObjectClassInArrayKey = '\0';

static const char LZCachedPropertiesKey = '\0';

@implementation NSObject (Property)

+ (NSMutableDictionary *)mj_propertyDictForKey:(const void *)key
{
    static NSMutableDictionary *replacedKeyFromPropertyNameDict;
    static NSMutableDictionary *replacedKeyFromPropertyName121Dict;
    static NSMutableDictionary *newValueFromOldValueDict;
    static NSMutableDictionary *objectClassInArrayDict;
    static NSMutableDictionary *cachedPropertiesDict;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        replacedKeyFromPropertyNameDict = [NSMutableDictionary dictionary];
        replacedKeyFromPropertyName121Dict = [NSMutableDictionary dictionary];
        newValueFromOldValueDict = [NSMutableDictionary dictionary];
        objectClassInArrayDict = [NSMutableDictionary dictionary];
        cachedPropertiesDict = [NSMutableDictionary dictionary];
    });
    
    if (key == &LZReplacedKeyFromPropertyNameKey) return replacedKeyFromPropertyNameDict;
    if (key == &LZReplacedKeyFromPropertyName121Key) return replacedKeyFromPropertyName121Dict;
    if (key == &LZNewValueFromOldValueKey) return newValueFromOldValueDict;
    if (key == &LZObjectClassInArrayKey) return objectClassInArrayDict;
    if (key == &LZCachedPropertiesKey) return cachedPropertiesDict;
    return nil;
}

#pragma mark - --私有方法--
+ (id)mj_propertyKey:(NSString *)propertyName
{
    LZExtensionAssertParamNotNil2(propertyName, nil);
    
    __block id key = nil;
    // 查看有没有需要替换的key
    if ([self respondsToSelector:@selector(mj_replacedKeyFromPropertyName121:)]) {
        key = [self mj_replacedKeyFromPropertyName121:propertyName];
    }
    
    // 调用block
    if (!key) {
        [self mj_enumerateAllClasses:^(__unsafe_unretained Class c, BOOL *stop) {
            LZReplacedKeyFromPropertyName121 block = objc_getAssociatedObject(c, &LZReplacedKeyFromPropertyName121Key);
            if (block) {
                key = block(propertyName);
            }
            if (key) *stop = YES;
        }];
    }
    
    // 查看有没有需要替换的key
    if ((!key || [key isEqual:propertyName]) && [self respondsToSelector:@selector(mj_replacedKeyFromPropertyName)]) {
        key = [self mj_replacedKeyFromPropertyName][propertyName];
    }
    
    if (!key || [key isEqual:propertyName]) {
        [self mj_enumerateAllClasses:^(__unsafe_unretained Class c, BOOL *stop) {
            NSDictionary *dict = objc_getAssociatedObject(c, &LZReplacedKeyFromPropertyNameKey);
            if (dict) {
                key = dict[propertyName];
            }
            if (key && ![key isEqual:propertyName]) *stop = YES;
        }];
    }
    
    // 2.用属性名作为key
    if (!key) key = propertyName;
    
    return key;
}

+ (Class)mj_propertyObjectClassInArray:(NSString *)propertyName
{
    __block id clazz = nil;
    if ([self respondsToSelector:@selector(mj_objectClassInArray)]) {
        clazz = [self mj_objectClassInArray][propertyName];
    }
    
    if (!clazz) {
        [self mj_enumerateAllClasses:^(__unsafe_unretained Class c, BOOL *stop) {
            NSDictionary *dict = objc_getAssociatedObject(c, &LZObjectClassInArrayKey);
            if (dict) {
                clazz = dict[propertyName];
            }
            if (clazz) *stop = YES;
        }];
    }
    
    // 如果是NSString类型
    if ([clazz isKindOfClass:[NSString class]]) {
        clazz = NSClassFromString(clazz);
    }
    return clazz;
}

#pragma mark - --公共方法--
+ (void)mj_enumerateProperties:(LZPropertiesEnumeration)enumeration
{
    // 获得成员变量
    LZExtensionSemaphoreCreate
    LZExtensionSemaphoreWait
    NSArray *cachedProperties = [self mj_properties];
    LZExtensionSemaphoreSignal
    // 遍历成员变量
    BOOL stop = NO;
    for (LZProperty *property in cachedProperties) {
        enumeration(property, &stop);
        if (stop) break;
    }
}

#pragma mark - 公共方法
+ (NSMutableArray *)mj_properties
{
    NSMutableArray *cachedProperties = [self mj_propertyDictForKey:&LZCachedPropertiesKey][NSStringFromClass(self)];
    if (cachedProperties == nil) {
    
        if (cachedProperties == nil) {
            cachedProperties = [NSMutableArray array];
            
            [self mj_enumerateClasses:^(__unsafe_unretained Class c, BOOL *stop) {
                // 1.获得所有的成员变量
                unsigned int outCount = 0;
                objc_property_t *properties = class_copyPropertyList(c, &outCount);
                
                // 2.遍历每一个成员变量
                for (unsigned int i = 0; i<outCount; i++) {
                    LZProperty *property = [LZProperty cachedPropertyWithProperty:properties[i]];
                    // 过滤掉Foundation框架类里面的属性
                    if ([LZFoundation isClassFromFoundation:property.srcClass]) continue;
                    // 过滤掉`hash`, `superclass`, `description`, `debugDescription`
                    if ([LZFoundation isFromNSObjectProtocolProperty:property.name]) continue;
                    
                    property.srcClass = c;
                    [property setOriginKey:[self mj_propertyKey:property.name] forClass:self];
                    [property setObjectClassInArray:[self mj_propertyObjectClassInArray:property.name] forClass:self];
                    [cachedProperties addObject:property];
                }
                
                // 3.释放内存
                free(properties);
            }];
            
            [self mj_propertyDictForKey:&LZCachedPropertiesKey][NSStringFromClass(self)] = cachedProperties;
        }
    }
    
    return cachedProperties;
}

#pragma mark - 新值配置
+ (void)mj_setupNewValueFromOldValue:(LZNewValueFromOldValue)newValueFormOldValue
{
    objc_setAssociatedObject(self, &LZNewValueFromOldValueKey, newValueFormOldValue, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

+ (id)mj_getNewValueFromObject:(__unsafe_unretained id)object oldValue:(__unsafe_unretained id)oldValue property:(LZProperty *__unsafe_unretained)property{
    // 如果有实现方法
    if ([object respondsToSelector:@selector(mj_newValueFromOldValue:property:)]) {
        return [object mj_newValueFromOldValue:oldValue property:property];
    }
    
    // 查看静态设置
    __block id newValue = oldValue;
    [self mj_enumerateAllClasses:^(__unsafe_unretained Class c, BOOL *stop) {
        LZNewValueFromOldValue block = objc_getAssociatedObject(c, &LZNewValueFromOldValueKey);
        if (block) {
            newValue = block(object, oldValue, property);
            *stop = YES;
        }
    }];
    return newValue;
}

#pragma mark - array model class配置
+ (void)mj_setupObjectClassInArray:(LZObjectClassInArray)objectClassInArray
{
    [self mj_setupBlockReturnValue:objectClassInArray key:&LZObjectClassInArrayKey];
    
    LZExtensionSemaphoreCreate
    LZExtensionSemaphoreWait
    [[self mj_propertyDictForKey:&LZCachedPropertiesKey] removeAllObjects];
    LZExtensionSemaphoreSignal
}

#pragma mark - key配置
+ (void)mj_setupReplacedKeyFromPropertyName:(LZReplacedKeyFromPropertyName)replacedKeyFromPropertyName
{
    [self mj_setupBlockReturnValue:replacedKeyFromPropertyName key:&LZReplacedKeyFromPropertyNameKey];
    
    LZExtensionSemaphoreCreate
    LZExtensionSemaphoreWait
    [[self mj_propertyDictForKey:&LZCachedPropertiesKey] removeAllObjects];
    LZExtensionSemaphoreSignal
}

+ (void)mj_setupReplacedKeyFromPropertyName121:(LZReplacedKeyFromPropertyName121)replacedKeyFromPropertyName121
{
    objc_setAssociatedObject(self, &LZReplacedKeyFromPropertyName121Key, replacedKeyFromPropertyName121, OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    LZExtensionSemaphoreCreate
    LZExtensionSemaphoreWait
    [[self mj_propertyDictForKey:&LZCachedPropertiesKey] removeAllObjects];
    LZExtensionSemaphoreSignal
}
@end
#pragma clang diagnostic pop
