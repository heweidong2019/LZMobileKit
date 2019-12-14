//
//  NSObject+LZKeyValue.m
//  LZExtension
//
//  Created by 何伟东 on 2019/11/14.
//  Copyright (c) 2019年 LZMobileKit. All rights reserved.
//

#import "NSObject+LZKeyValue.h"
#import "NSObject+LZProperty.h"
#import "NSString+LZExtension.h"
#import "LZProperty.h"
#import "LZPropertyType.h"
#import "LZExtensionConst.h"
#import "LZFoundation.h"
#import "NSString+LZExtension.h"
#import "NSObject+LZClass.h"

@implementation NSDecimalNumber(LZKeyValue)

- (id)standardValueWithTypeCode:(NSString *)typeCode {
    // 由于这里涉及到编译器问题, 暂时保留 Long, 实际上在 64 位系统上, 这 2 个精度范围相同,
    // 32 位略有不同, 其余都可使用 Double 进行强转不丢失精度
    if ([typeCode isEqualToString:LZPropertyTypeLongLong]) {
        return @(self.longLongValue);
    } else if ([typeCode isEqualToString:LZPropertyTypeLongLong.uppercaseString]) {
        return @(self.unsignedLongLongValue);
    } else if ([typeCode isEqualToString:LZPropertyTypeLong]) {
        return @(self.longValue);
    } else if ([typeCode isEqualToString:LZPropertyTypeLong.uppercaseString]) {
        return @(self.unsignedLongValue);
    } else {
        return @(self.doubleValue);
    }
}

@end

@implementation NSObject (LZKeyValue)

#pragma mark - 错误
static const char LZErrorKey = '\0';
+ (NSError *)lz_error
{
    return objc_getAssociatedObject(self, &LZErrorKey);
}

+ (void)setMj_error:(NSError *)error
{
    objc_setAssociatedObject(self, &LZErrorKey, error, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - 模型 -> 字典时的参考
/** 模型转字典时，字典的key是否参考replacedKeyFromPropertyName等方法（父类设置了，子类也会继承下来） */
static const char LZReferenceReplacedKeyWhenCreatingKeyValuesKey = '\0';

+ (void)lz_referenceReplacedKeyWhenCreatingKeyValues:(BOOL)reference
{
    objc_setAssociatedObject(self, &LZReferenceReplacedKeyWhenCreatingKeyValuesKey, @(reference), OBJC_ASSOCIATION_ASSIGN);
}

+ (BOOL)lz_isReferenceReplacedKeyWhenCreatingKeyValues
{
    __block id value = objc_getAssociatedObject(self, &LZReferenceReplacedKeyWhenCreatingKeyValuesKey);
    if (!value) {
        [self lz_enumerateAllClasses:^(__unsafe_unretained Class c, BOOL *stop) {
            value = objc_getAssociatedObject(c, &LZReferenceReplacedKeyWhenCreatingKeyValuesKey);
            
            if (value) *stop = YES;
        }];
    }
    return [value boolValue];
}

#pragma mark - --常用的对象--
+ (void)load
{
    // 默认设置
    [self lz_referenceReplacedKeyWhenCreatingKeyValues:YES];
}

#pragma mark - --公共方法--
#pragma mark - 字典 -> 模型
- (instancetype)lz_setKeyValues:(id)keyValues
{
    return [self lz_setKeyValues:keyValues context:nil];
}

/**
 核心代码：
 */
- (instancetype)lz_setKeyValues:(id)keyValues context:(NSManagedObjectContext *)context
{
    // 获得JSON对象
    keyValues = [keyValues lz_JSONObject];
    
    LZExtensionAssertError([keyValues isKindOfClass:[NSDictionary class]], self, [self class], @"keyValues参数不是一个字典");
    
    Class clazz = [self class];
    NSArray *allowedPropertyNames = [clazz lz_totalAllowedPropertyNames];
    NSArray *ignoredPropertyNames = [clazz lz_totalIgnoredPropertyNames];
    
    NSLocale *numberLocale = nil;
    if ([self.class respondsToSelector:@selector(lz_numberLocale)]) {
        numberLocale = self.class.lz_numberLocale;
    }
    
    //通过封装的方法回调一个通过运行时编写的，用于返回属性列表的方法。
    [clazz lz_enumerateProperties:^(LZProperty *property, BOOL *stop) {
        @try {
            // 0.检测是否被忽略
            if (allowedPropertyNames.count && ![allowedPropertyNames containsObject:property.name]) return;
            if ([ignoredPropertyNames containsObject:property.name]) return;
            
            // 1.取出属性值
            id value;
            NSArray *propertyKeyses = [property propertyKeysForClass:clazz];
            for (NSArray *propertyKeys in propertyKeyses) {
                value = keyValues;
                for (LZPropertyKey *propertyKey in propertyKeys) {
                    value = [propertyKey valueInObject:value];
                }
                if (value) break;
            }
            
            // 值的过滤
            id newValue = [clazz lz_getNewValueFromObject:self oldValue:value property:property];
            if (newValue != value) { // 有过滤后的新值
                [property setValue:newValue forObject:self];
                return;
            }
            
            // 如果没有值，就直接返回
            if (!value || value == [NSNull null]) return;
            
            // 2.复杂处理
            LZPropertyType *type = property.type;
            Class propertyClass = type.typeClass;
            Class objectClass = [property objectClassInArrayForClass:[self class]];
            
            // 不可变 -> 可变处理
            if (propertyClass == [NSMutableArray class] && [value isKindOfClass:[NSArray class]]) {
                value = [NSMutableArray arrayWithArray:value];
            } else if (propertyClass == [NSMutableDictionary class] && [value isKindOfClass:[NSDictionary class]]) {
                value = [NSMutableDictionary dictionaryWithDictionary:value];
            } else if (propertyClass == [NSMutableString class] && [value isKindOfClass:[NSString class]]) {
                value = [NSMutableString stringWithString:value];
            } else if (propertyClass == [NSMutableData class] && [value isKindOfClass:[NSData class]]) {
                value = [NSMutableData dataWithData:value];
            }
            
            if (!type.isFromFoundation && propertyClass) { // 模型属性
                value = [propertyClass lz_objectWithKeyValues:value context:context];
            } else if (objectClass) {
                if (objectClass == [NSURL class] && [value isKindOfClass:[NSArray class]]) {
                    // string array -> url array
                    NSMutableArray *urlArray = [NSMutableArray array];
                    for (NSString *string in value) {
                        if (![string isKindOfClass:[NSString class]]) continue;
                        [urlArray addObject:string.lz_url];
                    }
                    value = urlArray;
                } else { // 字典数组-->模型数组
                    value = [objectClass lz_objectArrayWithKeyValuesArray:value context:context];
                }
            } else if (propertyClass == [NSString class]) {
                if ([value isKindOfClass:[NSNumber class]]) {
                    // NSNumber -> NSString
                    value = [value description];
                } else if ([value isKindOfClass:[NSURL class]]) {
                    // NSURL -> NSString
                    value = [value absoluteString];
                }
            } else if ([value isKindOfClass:[NSString class]]) {
                if (propertyClass == [NSURL class]) {
                    // NSString -> NSURL
                    // 字符串转码
                    value = [value lz_url];
                } else if (type.isNumberType) {
                    NSString *oldValue = value;
                    
                    // NSString -> NSDecimalNumber, 使用 DecimalNumber 来转换数字, 避免丢失精度以及溢出
                    NSDecimalNumber *decimalValue = [NSDecimalNumber decimalNumberWithString:oldValue
                                                                                      locale:numberLocale];
                    
                    // 检查特殊情况
                    if (decimalValue == NSDecimalNumber.notANumber) {
                        value = @(0);
                    }else if (propertyClass != [NSDecimalNumber class]) {
                        value = [decimalValue standardValueWithTypeCode:type.code];
                    } else {
                        value = decimalValue;
                    }
                    
                    // 如果是BOOL
                    if (type.isBoolType) {
                        // 字符串转BOOL（字符串没有charValue方法）
                        // 系统会调用字符串的charValue转为BOOL类型
                        NSString *lower = [oldValue lowercaseString];
                        if ([lower isEqualToString:@"yes"] || [lower isEqualToString:@"true"]) {
                            value = @YES;
                        } else if ([lower isEqualToString:@"no"] || [lower isEqualToString:@"false"]) {
                            value = @NO;
                        }
                    }
                }
            } else if ([value isKindOfClass:[NSNumber class]] && propertyClass == [NSDecimalNumber class]){
                // 过滤 NSDecimalNumber类型
                if (![value isKindOfClass:[NSDecimalNumber class]]) {
                    value = [NSDecimalNumber decimalNumberWithDecimal:[((NSNumber *)value) decimalValue]];
                }
            }
            
            // 经过转换后, 最终检查 value 与 property 是否匹配
            if (propertyClass && ![value isKindOfClass:propertyClass]) {
                value = nil;
            }
            
            // 3.赋值
            [property setValue:value forObject:self];
        } @catch (NSException *exception) {
            LZExtensionBuildError([self class], exception.reason);
            LZExtensionLog(@"%@", exception);
        }
    }];
    
    // 转换完毕
    if ([self respondsToSelector:@selector(lz_didConvertToObjectWithKeyValues:)]) {
        [self lz_didConvertToObjectWithKeyValues:keyValues];
    }
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
    if ([self respondsToSelector:@selector(lz_keyValuesDidFinishConvertingToObject)]) {
        [self lz_keyValuesDidFinishConvertingToObject];
    }
    if ([self respondsToSelector:@selector(lz_keyValuesDidFinishConvertingToObject:)]) {
        [self lz_keyValuesDidFinishConvertingToObject:keyValues];
    }
#pragma clang diagnostic pop
    return self;
}

+ (instancetype)lz_objectWithKeyValues:(id)keyValues
{
    return [self lz_objectWithKeyValues:keyValues context:nil];
}

+ (instancetype)lz_objectWithKeyValues:(id)keyValues context:(NSManagedObjectContext *)context
{
    // 获得JSON对象
    keyValues = [keyValues lz_JSONObject];
    LZExtensionAssertError([keyValues isKindOfClass:[NSDictionary class]], nil, [self class], @"keyValues参数不是一个字典");
    
    if ([self isSubclassOfClass:[NSManagedObject class]] && context) {
        NSString *entityName = [NSStringFromClass(self) componentsSeparatedByString:@"."].lastObject;
        return [[NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:context] lz_setKeyValues:keyValues context:context];
    }
    return [[[self alloc] init] lz_setKeyValues:keyValues];
}

+ (instancetype)lz_objectWithFilename:(NSString *)filename
{
    LZExtensionAssertError(filename != nil, nil, [self class], @"filename参数为nil");
    
    return [self lz_objectWithFile:[[NSBundle mainBundle] pathForResource:filename ofType:nil]];
}

+ (instancetype)lz_objectWithFile:(NSString *)file
{
    LZExtensionAssertError(file != nil, nil, [self class], @"file参数为nil");
    
    return [self lz_objectWithKeyValues:[NSDictionary dictionaryWithContentsOfFile:file]];
}

#pragma mark - 字典数组 -> 模型数组
+ (NSMutableArray *)lz_objectArrayWithKeyValuesArray:(NSArray *)keyValuesArray
{
    return [self lz_objectArrayWithKeyValuesArray:keyValuesArray context:nil];
}

+ (NSMutableArray *)lz_objectArrayWithKeyValuesArray:(id)keyValuesArray context:(NSManagedObjectContext *)context
{
    // 如果是JSON字符串
    keyValuesArray = [keyValuesArray lz_JSONObject];
    
    // 1.判断真实性
    LZExtensionAssertError([keyValuesArray isKindOfClass:[NSArray class]], nil, [self class], @"keyValuesArray参数不是一个数组");
    
    // 如果数组里面放的是NSString、NSNumber等数据
    if ([LZFoundation isClassFromFoundation:self]) return [NSMutableArray arrayWithArray:keyValuesArray];
    

    // 2.创建数组
    NSMutableArray *modelArray = [NSMutableArray array];
    
    // 3.遍历
    for (NSDictionary *keyValues in keyValuesArray) {
        if ([keyValues isKindOfClass:[NSArray class]]){
            [modelArray addObject:[self lz_objectArrayWithKeyValuesArray:keyValues context:context]];
        } else {
            id model = [self lz_objectWithKeyValues:keyValues context:context];
            if (model) [modelArray addObject:model];
        }
    }
    
    return modelArray;
}

+ (NSMutableArray *)lz_objectArrayWithFilename:(NSString *)filename
{
    LZExtensionAssertError(filename != nil, nil, [self class], @"filename参数为nil");
    
    return [self lz_objectArrayWithFile:[[NSBundle mainBundle] pathForResource:filename ofType:nil]];
}

+ (NSMutableArray *)lz_objectArrayWithFile:(NSString *)file
{
    LZExtensionAssertError(file != nil, nil, [self class], @"file参数为nil");
    
    return [self lz_objectArrayWithKeyValuesArray:[NSArray arrayWithContentsOfFile:file]];
}

#pragma mark - 模型 -> 字典
- (NSMutableDictionary *)lz_keyValues
{
    return [self lz_keyValuesWithKeys:nil ignoredKeys:nil];
}

- (NSMutableDictionary *)lz_keyValuesWithKeys:(NSArray *)keys
{
    return [self lz_keyValuesWithKeys:keys ignoredKeys:nil];
}

- (NSMutableDictionary *)lz_keyValuesWithIgnoredKeys:(NSArray *)ignoredKeys
{
    return [self lz_keyValuesWithKeys:nil ignoredKeys:ignoredKeys];
}

- (NSMutableDictionary *)lz_keyValuesWithKeys:(NSArray *)keys ignoredKeys:(NSArray *)ignoredKeys
{
    // 如果自己不是模型类, 那就返回自己
    // 模型类过滤掉 NSNull
    // 唯一一个不返回自己的
    if ([self isMemberOfClass:NSNull.class]) { return nil; }
    // 这里虽然返回了自己, 但是其实是有报错信息的.
    // TODO: 报错机制不好, 需要重做
    LZExtensionAssertError(![LZFoundation isClassFromFoundation:[self class]], (NSMutableDictionary *)self, [self class], @"不是自定义的模型类")
    
    id keyValues = [NSMutableDictionary dictionary];
    
    Class clazz = [self class];
    NSArray *allowedPropertyNames = [clazz lz_totalAllowedPropertyNames];
    NSArray *ignoredPropertyNames = [clazz lz_totalIgnoredPropertyNames];
    
    [clazz lz_enumerateProperties:^(LZProperty *property, BOOL *stop) {
        @try {
            // 0.检测是否被忽略
            if (allowedPropertyNames.count && ![allowedPropertyNames containsObject:property.name]) return;
            if ([ignoredPropertyNames containsObject:property.name]) return;
            if (keys.count && ![keys containsObject:property.name]) return;
            if ([ignoredKeys containsObject:property.name]) return;
            
            // 1.取出属性值
            id value = [property valueForObject:self];
            if (!value) return;
            
            // 2.如果是模型属性
            LZPropertyType *type = property.type;
            Class propertyClass = type.typeClass;
            if (!type.isFromFoundation && propertyClass) {
                value = [value lz_keyValues];
            } else if ([value isKindOfClass:[NSArray class]]) {
                // 3.处理数组里面有模型的情况
                value = [NSObject lz_keyValuesArrayWithObjectArray:value];
            } else if (propertyClass == [NSURL class]) {
                value = [value absoluteString];
            }
            
            // 4.赋值
            if ([clazz lz_isReferenceReplacedKeyWhenCreatingKeyValues]) {
                NSArray *propertyKeys = [[property propertyKeysForClass:clazz] firstObject];
                NSUInteger keyCount = propertyKeys.count;
                // 创建字典
                __block id innerContainer = keyValues;
                [propertyKeys enumerateObjectsUsingBlock:^(LZPropertyKey *propertyKey, NSUInteger idx, BOOL *stop) {
                    // 下一个属性
                    LZPropertyKey *nextPropertyKey = nil;
                    if (idx != keyCount - 1) {
                        nextPropertyKey = propertyKeys[idx + 1];
                    }
                    
                    if (nextPropertyKey) { // 不是最后一个key
                        // 当前propertyKey对应的字典或者数组
                        id tempInnerContainer = [propertyKey valueInObject:innerContainer];
                        if (tempInnerContainer == nil || [tempInnerContainer isKindOfClass:[NSNull class]]) {
                            if (nextPropertyKey.type == LZPropertyKeyTypeDictionary) {
                                tempInnerContainer = [NSMutableDictionary dictionary];
                            } else {
                                tempInnerContainer = [NSMutableArray array];
                            }
                            if (propertyKey.type == LZPropertyKeyTypeDictionary) {
                                innerContainer[propertyKey.name] = tempInnerContainer;
                            } else {
                                innerContainer[propertyKey.name.intValue] = tempInnerContainer;
                            }
                        }
                        
                        if ([tempInnerContainer isKindOfClass:[NSMutableArray class]]) {
                            NSMutableArray *tempInnerContainerArray = tempInnerContainer;
                            int index = nextPropertyKey.name.intValue;
                            while (tempInnerContainerArray.count < index + 1) {
                                [tempInnerContainerArray addObject:[NSNull null]];
                            }
                        }
                        
                        innerContainer = tempInnerContainer;
                    } else { // 最后一个key
                        if (propertyKey.type == LZPropertyKeyTypeDictionary) {
                            innerContainer[propertyKey.name] = value;
                        } else {
                            innerContainer[propertyKey.name.intValue] = value;
                        }
                    }
                }];
            } else {
                keyValues[property.name] = value;
            }
        } @catch (NSException *exception) {
            LZExtensionBuildError([self class], exception.reason);
            LZExtensionLog(@"%@", exception);
        }
    }];
    
    // 转换完毕
    if ([self respondsToSelector:@selector(lz_objectDidConvertToKeyValues:)]) {
        [self lz_objectDidConvertToKeyValues:keyValues];
    }
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
    if ([self respondsToSelector:@selector(lz_objectDidFinishConvertingToKeyValues)]) {
        [self lz_objectDidFinishConvertingToKeyValues];
    }
#pragma clang diagnostic pop
    
    return keyValues;
}
#pragma mark - 模型数组 -> 字典数组
+ (NSMutableArray *)lz_keyValuesArrayWithObjectArray:(NSArray *)objectArray
{
    return [self lz_keyValuesArrayWithObjectArray:objectArray keys:nil ignoredKeys:nil];
}

+ (NSMutableArray *)lz_keyValuesArrayWithObjectArray:(NSArray *)objectArray keys:(NSArray *)keys
{
    return [self lz_keyValuesArrayWithObjectArray:objectArray keys:keys ignoredKeys:nil];
}

+ (NSMutableArray *)lz_keyValuesArrayWithObjectArray:(NSArray *)objectArray ignoredKeys:(NSArray *)ignoredKeys
{
    return [self lz_keyValuesArrayWithObjectArray:objectArray keys:nil ignoredKeys:ignoredKeys];
}

+ (NSMutableArray *)lz_keyValuesArrayWithObjectArray:(NSArray *)objectArray keys:(NSArray *)keys ignoredKeys:(NSArray *)ignoredKeys
{
    // 0.判断真实性
    LZExtensionAssertError([objectArray isKindOfClass:[NSArray class]], nil, [self class], @"objectArray参数不是一个数组");
    
    // 1.创建数组
    NSMutableArray *keyValuesArray = [NSMutableArray array];
    for (id object in objectArray) {
        if (keys) {
            id convertedObj = [object lz_keyValuesWithKeys:keys];
            if (!convertedObj) { continue; }
            [keyValuesArray addObject:convertedObj];
        } else {
            id convertedObj = [object lz_keyValuesWithIgnoredKeys:ignoredKeys];
            if (!convertedObj) { continue; }
            [keyValuesArray addObject:convertedObj];
        }
    }
    return keyValuesArray;
}

#pragma mark - 转换为JSON
- (NSData *)lz_JSONData
{
    if ([self isKindOfClass:[NSString class]]) {
        return [((NSString *)self) dataUsingEncoding:NSUTF8StringEncoding];
    } else if ([self isKindOfClass:[NSData class]]) {
        return (NSData *)self;
    }
    
    return [NSJSONSerialization dataWithJSONObject:[self lz_JSONObject] options:kNilOptions error:nil];
}

- (id)lz_JSONObject
{
    if ([self isKindOfClass:[NSString class]]) {
        return [NSJSONSerialization JSONObjectWithData:[((NSString *)self) dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
    } else if ([self isKindOfClass:[NSData class]]) {
        return [NSJSONSerialization JSONObjectWithData:(NSData *)self options:kNilOptions error:nil];
    }
    
    return self.lz_keyValues;
}

- (NSString *)lz_JSONString
{
    if ([self isKindOfClass:[NSString class]]) {
        return (NSString *)self;
    } else if ([self isKindOfClass:[NSData class]]) {
        return [[NSString alloc] initWithData:(NSData *)self encoding:NSUTF8StringEncoding];
    }
    
    return [[NSString alloc] initWithData:[self lz_JSONData] encoding:NSUTF8StringEncoding];
}

@end
