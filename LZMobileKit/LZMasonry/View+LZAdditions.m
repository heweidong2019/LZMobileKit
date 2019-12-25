//
//  UIView+LZAdditions.m
//  Masonry
//
//  Created by 何伟东 on 2019/11/25.
//  Copyright (c) 2013 LZMobileKit. All rights reserved.
//

#import "View+LZAdditions.h"
#import <objc/runtime.h>

@implementation LZ_VIEW (LZAdditions)

- (NSArray *)lz_makeConstraints:(void(^)(LZConstraintMaker *))block {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    LZConstraintMaker *constraintMaker = [[LZConstraintMaker alloc] initWithView:self];
    block(constraintMaker);
    return [constraintMaker install];
}

- (NSArray *)lz_updateConstraints:(void(^)(LZConstraintMaker *))block {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    LZConstraintMaker *constraintMaker = [[LZConstraintMaker alloc] initWithView:self];
    constraintMaker.updateExisting = YES;
    block(constraintMaker);
    return [constraintMaker install];
}

- (NSArray *)lz_remakeConstraints:(void(^)(LZConstraintMaker *make))block {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    LZConstraintMaker *constraintMaker = [[LZConstraintMaker alloc] initWithView:self];
    constraintMaker.removeExisting = YES;
    block(constraintMaker);
    return [constraintMaker install];
}

#pragma mark - NSLayoutAttribute properties

- (LZViewAttribute *)lz_left {
    return [[LZViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeLeft];
}

- (LZViewAttribute *)lz_top {
    return [[LZViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeTop];
}

- (LZViewAttribute *)lz_right {
    return [[LZViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeRight];
}

- (LZViewAttribute *)lz_bottom {
    return [[LZViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeBottom];
}

- (LZViewAttribute *)lz_leading {
    return [[LZViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeLeading];
}

- (LZViewAttribute *)lz_trailing {
    return [[LZViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeTrailing];
}

- (LZViewAttribute *)lz_width {
    return [[LZViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeWidth];
}

- (LZViewAttribute *)lz_height {
    return [[LZViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeHeight];
}

- (LZViewAttribute *)lz_centerX {
    return [[LZViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeCenterX];
}

- (LZViewAttribute *)lz_centerY {
    return [[LZViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeCenterY];
}

- (LZViewAttribute *)lz_baseline {
    return [[LZViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeBaseline];
}

- (LZViewAttribute *(^)(NSLayoutAttribute))lz_attribute
{
    return ^(NSLayoutAttribute attr) {
        return [[LZViewAttribute alloc] initWithView:self layoutAttribute:attr];
    };
}

#if (__IPHONE_OS_VERSION_MIN_REQUIRED >= 80000) || (__TV_OS_VERSION_MIN_REQUIRED >= 9000) || (__MAC_OS_X_VERSION_MIN_REQUIRED >= 101100)

- (LZViewAttribute *)lz_firstBaseline {
    return [[LZViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeFirstBaseline];
}
- (LZViewAttribute *)lz_lastBaseline {
    return [[LZViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeLastBaseline];
}

#endif

#if (__IPHONE_OS_VERSION_MIN_REQUIRED >= 80000) || (__TV_OS_VERSION_MIN_REQUIRED >= 9000)

- (LZViewAttribute *)lz_leftMargin {
    return [[LZViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeLeftMargin];
}

- (LZViewAttribute *)lz_rightMargin {
    return [[LZViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeRightMargin];
}

- (LZViewAttribute *)lz_topMargin {
    return [[LZViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeTopMargin];
}

- (LZViewAttribute *)lz_bottomMargin {
    return [[LZViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeBottomMargin];
}

- (LZViewAttribute *)lz_leadingMargin {
    return [[LZViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeLeadingMargin];
}

- (LZViewAttribute *)lz_trailingMargin {
    return [[LZViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeTrailingMargin];
}

- (LZViewAttribute *)lz_centerXWithinMargins {
    return [[LZViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeCenterXWithinMargins];
}

- (LZViewAttribute *)lz_centerYWithinMargins {
    return [[LZViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeCenterYWithinMargins];
}

#endif

#if (__IPHONE_OS_VERSION_MAX_ALLOWED >= 110000) || (__TV_OS_VERSION_MAX_ALLOWED >= 110000)

- (LZViewAttribute *)lz_safeAreaLayoutGuide {
    return [[LZViewAttribute alloc] initWithView:self item:self.safeAreaLayoutGuide layoutAttribute:NSLayoutAttributeBottom];
}
- (LZViewAttribute *)lz_safeAreaLayoutGuideTop {
    return [[LZViewAttribute alloc] initWithView:self item:self.safeAreaLayoutGuide layoutAttribute:NSLayoutAttributeTop];
}
- (LZViewAttribute *)lz_safeAreaLayoutGuideBottom {
    return [[LZViewAttribute alloc] initWithView:self item:self.safeAreaLayoutGuide layoutAttribute:NSLayoutAttributeBottom];
}
- (LZViewAttribute *)lz_safeAreaLayoutGuideLeft {
    return [[LZViewAttribute alloc] initWithView:self item:self.safeAreaLayoutGuide layoutAttribute:NSLayoutAttributeLeft];
}
- (LZViewAttribute *)lz_safeAreaLayoutGuideRight {
    return [[LZViewAttribute alloc] initWithView:self item:self.safeAreaLayoutGuide layoutAttribute:NSLayoutAttributeRight];
}

#endif

#pragma mark - associated properties

- (id)lz_key {
    return objc_getAssociatedObject(self, @selector(lz_key));
}

- (void)setMas_key:(id)key {
    objc_setAssociatedObject(self, @selector(lz_key), key, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - heirachy

- (instancetype)lz_closestCommonSuperview:(LZ_VIEW *)view {
    LZ_VIEW *closestCommonSuperview = nil;

    LZ_VIEW *secondViewSuperview = view;
    while (!closestCommonSuperview && secondViewSuperview) {
        LZ_VIEW *firstViewSuperview = self;
        while (!closestCommonSuperview && firstViewSuperview) {
            if (secondViewSuperview == firstViewSuperview) {
                closestCommonSuperview = secondViewSuperview;
            }
            firstViewSuperview = firstViewSuperview.superview;
        }
        secondViewSuperview = secondViewSuperview.superview;
    }
    return closestCommonSuperview;
}

@end
