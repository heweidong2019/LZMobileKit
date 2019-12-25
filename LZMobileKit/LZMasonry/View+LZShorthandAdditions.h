//
//  UIView+LZShorthandAdditions.h
//  Masonry
//
//  Created by 何伟东 on 2019/11/25.
//  Copyright (c) 2013 LZMobileKit. All rights reserved.
//

#import "View+LZAdditions.h"

#ifdef LZ_SHORTHAND

/**
 *	Shorthand view additions without the 'lz_' prefixes,
 *  only enabled if LZ_SHORTHAND is defined
 */
@interface LZ_VIEW (LZShorthandAdditions)

@property (nonatomic, strong, readonly) LZViewAttribute *left;
@property (nonatomic, strong, readonly) LZViewAttribute *top;
@property (nonatomic, strong, readonly) LZViewAttribute *right;
@property (nonatomic, strong, readonly) LZViewAttribute *bottom;
@property (nonatomic, strong, readonly) LZViewAttribute *leading;
@property (nonatomic, strong, readonly) LZViewAttribute *trailing;
@property (nonatomic, strong, readonly) LZViewAttribute *width;
@property (nonatomic, strong, readonly) LZViewAttribute *height;
@property (nonatomic, strong, readonly) LZViewAttribute *centerX;
@property (nonatomic, strong, readonly) LZViewAttribute *centerY;
@property (nonatomic, strong, readonly) LZViewAttribute *baseline;
@property (nonatomic, strong, readonly) LZViewAttribute *(^attribute)(NSLayoutAttribute attr);

#if (__IPHONE_OS_VERSION_MIN_REQUIRED >= 80000) || (__TV_OS_VERSION_MIN_REQUIRED >= 9000) || (__MAC_OS_X_VERSION_MIN_REQUIRED >= 101100)

@property (nonatomic, strong, readonly) LZViewAttribute *firstBaseline;
@property (nonatomic, strong, readonly) LZViewAttribute *lastBaseline;

#endif

#if (__IPHONE_OS_VERSION_MIN_REQUIRED >= 80000) || (__TV_OS_VERSION_MIN_REQUIRED >= 9000)

@property (nonatomic, strong, readonly) LZViewAttribute *leftMargin;
@property (nonatomic, strong, readonly) LZViewAttribute *rightMargin;
@property (nonatomic, strong, readonly) LZViewAttribute *topMargin;
@property (nonatomic, strong, readonly) LZViewAttribute *bottomMargin;
@property (nonatomic, strong, readonly) LZViewAttribute *leadingMargin;
@property (nonatomic, strong, readonly) LZViewAttribute *trailingMargin;
@property (nonatomic, strong, readonly) LZViewAttribute *centerXWithinMargins;
@property (nonatomic, strong, readonly) LZViewAttribute *centerYWithinMargins;

#endif

#if (__IPHONE_OS_VERSION_MAX_ALLOWED >= 110000) || (__TV_OS_VERSION_MAX_ALLOWED >= 110000)

@property (nonatomic, strong, readonly) LZViewAttribute *safeAreaLayoutGuideTop API_AVAILABLE(ios(11.0),tvos(11.0));
@property (nonatomic, strong, readonly) LZViewAttribute *safeAreaLayoutGuideBottom API_AVAILABLE(ios(11.0),tvos(11.0));
@property (nonatomic, strong, readonly) LZViewAttribute *safeAreaLayoutGuideLeft API_AVAILABLE(ios(11.0),tvos(11.0));
@property (nonatomic, strong, readonly) LZViewAttribute *safeAreaLayoutGuideRight API_AVAILABLE(ios(11.0),tvos(11.0));

#endif

- (NSArray *)makeConstraints:(void(^)(LZConstraintMaker *make))block;
- (NSArray *)updateConstraints:(void(^)(LZConstraintMaker *make))block;
- (NSArray *)remakeConstraints:(void(^)(LZConstraintMaker *make))block;

@end

#define LZ_ATTR_FORWARD(attr)  \
- (LZViewAttribute *)attr {    \
    return [self lz_##attr];   \
}

@implementation LZ_VIEW (LZShorthandAdditions)

LZ_ATTR_FORWARD(top);
LZ_ATTR_FORWARD(left);
LZ_ATTR_FORWARD(bottom);
LZ_ATTR_FORWARD(right);
LZ_ATTR_FORWARD(leading);
LZ_ATTR_FORWARD(trailing);
LZ_ATTR_FORWARD(width);
LZ_ATTR_FORWARD(height);
LZ_ATTR_FORWARD(centerX);
LZ_ATTR_FORWARD(centerY);
LZ_ATTR_FORWARD(baseline);

#if (__IPHONE_OS_VERSION_MIN_REQUIRED >= 80000) || (__TV_OS_VERSION_MIN_REQUIRED >= 9000) || (__MAC_OS_X_VERSION_MIN_REQUIRED >= 101100)

LZ_ATTR_FORWARD(firstBaseline);
LZ_ATTR_FORWARD(lastBaseline);

#endif

#if (__IPHONE_OS_VERSION_MIN_REQUIRED >= 80000) || (__TV_OS_VERSION_MIN_REQUIRED >= 9000)

LZ_ATTR_FORWARD(leftMargin);
LZ_ATTR_FORWARD(rightMargin);
LZ_ATTR_FORWARD(topMargin);
LZ_ATTR_FORWARD(bottomMargin);
LZ_ATTR_FORWARD(leadingMargin);
LZ_ATTR_FORWARD(trailingMargin);
LZ_ATTR_FORWARD(centerXWithinMargins);
LZ_ATTR_FORWARD(centerYWithinMargins);

#endif

#if (__IPHONE_OS_VERSION_MAX_ALLOWED >= 110000) || (__TV_OS_VERSION_MAX_ALLOWED >= 110000)

LZ_ATTR_FORWARD(safeAreaLayoutGuideTop);
LZ_ATTR_FORWARD(safeAreaLayoutGuideBottom);
LZ_ATTR_FORWARD(safeAreaLayoutGuideLeft);
LZ_ATTR_FORWARD(safeAreaLayoutGuideRight);

#endif

- (LZViewAttribute *(^)(NSLayoutAttribute))attribute {
    return [self lz_attribute];
}

- (NSArray *)makeConstraints:(void(NS_NOESCAPE ^)(LZConstraintMaker *))block {
    return [self lz_makeConstraints:block];
}

- (NSArray *)updateConstraints:(void(NS_NOESCAPE ^)(LZConstraintMaker *))block {
    return [self lz_updateConstraints:block];
}

- (NSArray *)remakeConstraints:(void(NS_NOESCAPE ^)(LZConstraintMaker *))block {
    return [self lz_remakeConstraints:block];
}

@end

#endif
