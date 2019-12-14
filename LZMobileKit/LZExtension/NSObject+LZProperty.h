//
//  NSObject+LZProperty.h
//  LZExtensionExample
//
//  Created by 何伟东 on 2019/11/14.
//  Copyright (c) 2019年 LZMobileKit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LZExtensionConst.h"

@class LZProperty;

/**
 *  遍历成员变量用的block
 *
 *  @param property 成员的包装对象
 *  @param stop   YES代表停止遍历，NO代表继续遍历
 */
typedef void (^LZPropertiesEnumeration)(LZProperty *property, BOOL *stop);

/** 将属性名换为其他key去字典中取值 */
typedef NSDictionary * (^LZReplacedKeyFromPropertyName)(void);
typedef id (^LZReplacedKeyFromPropertyName121)(NSString *propertyName);
/** 数组中需要转换的模型类 */
typedef NSDictionary * (^LZObjectClassInArray)(void);
/** 用于过滤字典中的值 */
typedef id (^LZNewValueFromOldValue)(id object, id oldValue, LZProperty *property);

/**
 * 成员属性相关的扩展
 */
@interface NSObject (LZProperty)
#pragma mark - 遍历
/**
 *  遍历所有的成员
 */
+ (void)lz_enumerateProperties:(LZPropertiesEnumeration)enumeration;

#pragma mark - 新值配置
/**
 *  用于过滤字典中的值
 *
 *  @param newValueFormOldValue 用于过滤字典中的值
 */
+ (void)lz_setupNewValueFromOldValue:(LZNewValueFromOldValue)newValueFormOldValue;
+ (id)lz_getNewValueFromObject:(__unsafe_unretained id)object oldValue:(__unsafe_unretained id)oldValue property:(__unsafe_unretained LZProperty *)property;

#pragma mark - key配置
/**
 *  将属性名换为其他key去字典中取值
 *
 *  @param replacedKeyFromPropertyName 将属性名换为其他key去字典中取值
 */
+ (void)lz_setupReplacedKeyFromPropertyName:(LZReplacedKeyFromPropertyName)replacedKeyFromPropertyName;
/**
 *  将属性名换为其他key去字典中取值
 *
 *  @param replacedKeyFromPropertyName121 将属性名换为其他key去字典中取值
 */
+ (void)lz_setupReplacedKeyFromPropertyName121:(LZReplacedKeyFromPropertyName121)replacedKeyFromPropertyName121;

#pragma mark - array model class配置
/**
 *  数组中需要转换的模型类
 *
 *  @param objectClassInArray          数组中需要转换的模型类
 */
+ (void)lz_setupObjectClassInArray:(LZObjectClassInArray)objectClassInArray;
@end
