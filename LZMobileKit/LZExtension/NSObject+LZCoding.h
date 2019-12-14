//
//  NSObject+LZCoding.h
//  LZExtension
//
//  Created by 何伟东 on 2019/11/14.
//  Copyright (c) 2019年 LZMobileKit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LZExtensionConst.h"

/**
 *  Codeing协议
 */
@protocol LZCoding <NSObject>
@optional
/**
 *  这个数组中的属性名才会进行归档
 */
+ (NSArray *)lz_allowedCodingPropertyNames;
/**
 *  这个数组中的属性名将会被忽略：不进行归档
 */
+ (NSArray *)lz_ignoredCodingPropertyNames;
@end

@interface NSObject (LZCoding) <LZCoding>
/**
 *  解码（从文件中解析对象）
 */
- (void)lz_decode:(NSCoder *)decoder;
/**
 *  编码（将对象写入文件中）
 */
- (void)lz_encode:(NSCoder *)encoder;
@end

/**
 归档的实现
 */
#define LZCodingImplementation \
- (id)initWithCoder:(NSCoder *)decoder \
{ \
if (self = [super init]) { \
[self lz_decode:decoder]; \
} \
return self; \
} \
\
- (void)encodeWithCoder:(NSCoder *)encoder \
{ \
[self lz_encode:encoder]; \
}

#define LZExtensionCodingImplementation LZCodingImplementation
