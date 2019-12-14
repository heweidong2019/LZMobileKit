#ifndef __LZExtensionConst__M__
#define __LZExtensionConst__M__

#import <Foundation/Foundation.h>

/**
 *  成员变量类型（属性类型）
 */
NSString *const LZPropertyTypeInt = @"i";
NSString *const LZPropertyTypeShort = @"s";
NSString *const LZPropertyTypeFloat = @"f";
NSString *const LZPropertyTypeDouble = @"d";
NSString *const LZPropertyTypeLong = @"l";
NSString *const LZPropertyTypeLongLong = @"q";
NSString *const LZPropertyTypeChar = @"c";
NSString *const LZPropertyTypeBOOL1 = @"c";
NSString *const LZPropertyTypeBOOL2 = @"b";
NSString *const LZPropertyTypePointer = @"*";

NSString *const LZPropertyTypeIvar = @"^{objc_ivar=}";
NSString *const LZPropertyTypeMethod = @"^{objc_method=}";
NSString *const LZPropertyTypeBlock = @"@?";
NSString *const LZPropertyTypeClass = @"#";
NSString *const LZPropertyTypeSEL = @":";
NSString *const LZPropertyTypeId = @"@";

#endif
