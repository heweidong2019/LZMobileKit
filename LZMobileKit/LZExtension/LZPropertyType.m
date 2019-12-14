//
//  LZPropertyType.m
//  LZExtension
//
//  Created by 何伟东 on 2019/11/14.
//  Copyright (c) 2019年 LZMobileKit. All rights reserved.
//

#import "LZPropertyType.h"
#import "LZExtension.h"
#import "LZFoundation.h"
#import "LZExtensionConst.h"

@implementation LZPropertyType

+ (instancetype)cachedTypeWithCode:(NSString *)code
{
    LZExtensionAssertParamNotNil2(code, nil);
    
    static NSMutableDictionary *types;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        types = [NSMutableDictionary dictionary];
    });
    
    LZPropertyType *type = types[code];
    if (type == nil) {
        type = [[self alloc] init];
        type.code = code;
        types[code] = type;
    }
    return type;
}

#pragma mark - 公共方法
- (void)setCode:(NSString *)code
{
    _code = code;
    
    LZExtensionAssertParamNotNil(code);
    
    if ([code isEqualToString:LZPropertyTypeId]) {
        _idType = YES;
    } else if (code.length == 0) {
        _KVCDisabled = YES;
    } else if (code.length > 3 && [code hasPrefix:@"@\""]) {
        // 去掉@"和"，截取中间的类型名称
        _code = [code substringWithRange:NSMakeRange(2, code.length - 3)];
        _typeClass = NSClassFromString(_code);
        _fromFoundation = [LZFoundation isClassFromFoundation:_typeClass];
        _numberType = [_typeClass isSubclassOfClass:[NSNumber class]];
        
    } else if ([code isEqualToString:LZPropertyTypeSEL] ||
               [code isEqualToString:LZPropertyTypeIvar] ||
               [code isEqualToString:LZPropertyTypeMethod]) {
        _KVCDisabled = YES;
    }
    
    // 是否为数字类型
    NSString *lowerCode = _code.lowercaseString;
    NSArray *numberTypes = @[LZPropertyTypeInt, LZPropertyTypeShort, LZPropertyTypeBOOL1, LZPropertyTypeBOOL2, LZPropertyTypeFloat, LZPropertyTypeDouble, LZPropertyTypeLong, LZPropertyTypeLongLong, LZPropertyTypeChar];
    if ([numberTypes containsObject:lowerCode]) {
        _numberType = YES;
        
        if ([lowerCode isEqualToString:LZPropertyTypeBOOL1]
            || [lowerCode isEqualToString:LZPropertyTypeBOOL2]) {
            _boolType = YES;
        }
    }
}
@end
