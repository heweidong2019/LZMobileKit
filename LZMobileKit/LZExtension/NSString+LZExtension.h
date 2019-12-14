//
//  NSString+LZExtension.h
//  LZExtensionExample
//
//  Created by 何伟东 on 2019/11/14.
//  Copyright (c) 2019年 LZMobileKit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LZExtensionConst.h"

@interface NSString (LZExtension)
/**
 *  驼峰转下划线（loveYou -> love_you）
 */
- (NSString *)lz_underlineFromCamel;
/**
 *  下划线转驼峰（love_you -> loveYou）
 */
- (NSString *)lz_camelFromUnderline;
/**
 * 首字母变大写
 */
- (NSString *)lz_firstCharUpper;
/**
 * 首字母变小写
 */
- (NSString *)lz_firstCharLower;

- (BOOL)lz_isPureInt;

- (NSURL *)lz_url;
@end
