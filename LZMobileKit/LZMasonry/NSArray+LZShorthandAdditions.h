//
//  NSArray+LZShorthandAdditions.h
//  Masonry
//
//  Created by 何伟东 on 2019/11/25.
//  Copyright (c) 2013 LZMobileKit. All rights reserved.
//

#import "NSArray+LZAdditions.h"

#ifdef LZ_SHORTHAND

/**
 *	Shorthand array additions without the 'lz_' prefixes,
 *  only enabled if LZ_SHORTHAND is defined
 */
@interface NSArray (LZShorthandAdditions)

- (NSArray *)makeConstraints:(void(^)(LZConstraintMaker *make))block;
- (NSArray *)updateConstraints:(void(^)(LZConstraintMaker *make))block;
- (NSArray *)remakeConstraints:(void(^)(LZConstraintMaker *make))block;

@end

@implementation NSArray (LZShorthandAdditions)

- (NSArray *)makeConstraints:(void(^)(LZConstraintMaker *))block {
    return [self lz_makeConstraints:block];
}

- (NSArray *)updateConstraints:(void(^)(LZConstraintMaker *))block {
    return [self lz_updateConstraints:block];
}

- (NSArray *)remakeConstraints:(void(^)(LZConstraintMaker *))block {
    return [self lz_remakeConstraints:block];
}

@end

#endif
