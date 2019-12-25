//
//  LZConstraintMaker.m
//  Masonry
//
//  Created by 何伟东 on 2019/11/25.
//  Copyright (c) 2013 LZMobileKit. All rights reserved.
//

#import "LZConstraintMaker.h"
#import "LZViewConstraint.h"
#import "LZCompositeConstraint.h"
#import "LZConstraint+Private.h"
#import "LZViewAttribute.h"
#import "View+LZAdditions.h"

@interface LZConstraintMaker () <LZConstraintDelegate>

@property (nonatomic, weak) LZ_VIEW *view;
@property (nonatomic, strong) NSMutableArray *constraints;

@end

@implementation LZConstraintMaker

- (id)initWithView:(LZ_VIEW *)view {
    self = [super init];
    if (!self) return nil;
    
    self.view = view;
    self.constraints = NSMutableArray.new;
    
    return self;
}

- (NSArray *)install {
    if (self.removeExisting) {
        NSArray *installedConstraints = [LZViewConstraint installedConstraintsForView:self.view];
        for (LZConstraint *constraint in installedConstraints) {
            [constraint uninstall];
        }
    }
    NSArray *constraints = self.constraints.copy;
    for (LZConstraint *constraint in constraints) {
        constraint.updateExisting = self.updateExisting;
        [constraint install];
    }
    [self.constraints removeAllObjects];
    return constraints;
}

#pragma mark - LZConstraintDelegate

- (void)constraint:(LZConstraint *)constraint shouldBeReplacedWithConstraint:(LZConstraint *)replacementConstraint {
    NSUInteger index = [self.constraints indexOfObject:constraint];
    NSAssert(index != NSNotFound, @"Could not find constraint %@", constraint);
    [self.constraints replaceObjectAtIndex:index withObject:replacementConstraint];
}

- (LZConstraint *)constraint:(LZConstraint *)constraint addConstraintWithLayoutAttribute:(NSLayoutAttribute)layoutAttribute {
    LZViewAttribute *viewAttribute = [[LZViewAttribute alloc] initWithView:self.view layoutAttribute:layoutAttribute];
    LZViewConstraint *newConstraint = [[LZViewConstraint alloc] initWithFirstViewAttribute:viewAttribute];
    if ([constraint isKindOfClass:LZViewConstraint.class]) {
        //replace with composite constraint
        NSArray *children = @[constraint, newConstraint];
        LZCompositeConstraint *compositeConstraint = [[LZCompositeConstraint alloc] initWithChildren:children];
        compositeConstraint.delegate = self;
        [self constraint:constraint shouldBeReplacedWithConstraint:compositeConstraint];
        return compositeConstraint;
    }
    if (!constraint) {
        newConstraint.delegate = self;
        [self.constraints addObject:newConstraint];
    }
    return newConstraint;
}

- (LZConstraint *)addConstraintWithAttributes:(LZAttribute)attrs {
    __unused LZAttribute anyAttribute = (LZAttributeLeft | LZAttributeRight | LZAttributeTop | LZAttributeBottom | LZAttributeLeading
                                          | LZAttributeTrailing | LZAttributeWidth | LZAttributeHeight | LZAttributeCenterX
                                          | LZAttributeCenterY | LZAttributeBaseline
#if (__IPHONE_OS_VERSION_MIN_REQUIRED >= 80000) || (__TV_OS_VERSION_MIN_REQUIRED >= 9000) || (__MAC_OS_X_VERSION_MIN_REQUIRED >= 101100)
                                          | LZAttributeFirstBaseline | LZAttributeLastBaseline
#endif
#if (__IPHONE_OS_VERSION_MIN_REQUIRED >= 80000) || (__TV_OS_VERSION_MIN_REQUIRED >= 9000)
                                          | LZAttributeLeftMargin | LZAttributeRightMargin | LZAttributeTopMargin | LZAttributeBottomMargin
                                          | LZAttributeLeadingMargin | LZAttributeTrailingMargin | LZAttributeCenterXWithinMargins
                                          | LZAttributeCenterYWithinMargins
#endif
                                          );
    
    NSAssert((attrs & anyAttribute) != 0, @"You didn't pass any attribute to make.attributes(...)");
    
    NSMutableArray *attributes = [NSMutableArray array];
    
    if (attrs & LZAttributeLeft) [attributes addObject:self.view.lz_left];
    if (attrs & LZAttributeRight) [attributes addObject:self.view.lz_right];
    if (attrs & LZAttributeTop) [attributes addObject:self.view.lz_top];
    if (attrs & LZAttributeBottom) [attributes addObject:self.view.lz_bottom];
    if (attrs & LZAttributeLeading) [attributes addObject:self.view.lz_leading];
    if (attrs & LZAttributeTrailing) [attributes addObject:self.view.lz_trailing];
    if (attrs & LZAttributeWidth) [attributes addObject:self.view.lz_width];
    if (attrs & LZAttributeHeight) [attributes addObject:self.view.lz_height];
    if (attrs & LZAttributeCenterX) [attributes addObject:self.view.lz_centerX];
    if (attrs & LZAttributeCenterY) [attributes addObject:self.view.lz_centerY];
    if (attrs & LZAttributeBaseline) [attributes addObject:self.view.lz_baseline];
    
#if (__IPHONE_OS_VERSION_MIN_REQUIRED >= 80000) || (__TV_OS_VERSION_MIN_REQUIRED >= 9000) || (__MAC_OS_X_VERSION_MIN_REQUIRED >= 101100)
    
    if (attrs & LZAttributeFirstBaseline) [attributes addObject:self.view.lz_firstBaseline];
    if (attrs & LZAttributeLastBaseline) [attributes addObject:self.view.lz_lastBaseline];
    
#endif
    
#if (__IPHONE_OS_VERSION_MIN_REQUIRED >= 80000) || (__TV_OS_VERSION_MIN_REQUIRED >= 9000)
    
    if (attrs & LZAttributeLeftMargin) [attributes addObject:self.view.lz_leftMargin];
    if (attrs & LZAttributeRightMargin) [attributes addObject:self.view.lz_rightMargin];
    if (attrs & LZAttributeTopMargin) [attributes addObject:self.view.lz_topMargin];
    if (attrs & LZAttributeBottomMargin) [attributes addObject:self.view.lz_bottomMargin];
    if (attrs & LZAttributeLeadingMargin) [attributes addObject:self.view.lz_leadingMargin];
    if (attrs & LZAttributeTrailingMargin) [attributes addObject:self.view.lz_trailingMargin];
    if (attrs & LZAttributeCenterXWithinMargins) [attributes addObject:self.view.lz_centerXWithinMargins];
    if (attrs & LZAttributeCenterYWithinMargins) [attributes addObject:self.view.lz_centerYWithinMargins];
    
#endif
    
    NSMutableArray *children = [NSMutableArray arrayWithCapacity:attributes.count];
    
    for (LZViewAttribute *a in attributes) {
        [children addObject:[[LZViewConstraint alloc] initWithFirstViewAttribute:a]];
    }
    
    LZCompositeConstraint *constraint = [[LZCompositeConstraint alloc] initWithChildren:children];
    constraint.delegate = self;
    [self.constraints addObject:constraint];
    return constraint;
}

#pragma mark - standard Attributes

- (LZConstraint *)addConstraintWithLayoutAttribute:(NSLayoutAttribute)layoutAttribute {
    return [self constraint:nil addConstraintWithLayoutAttribute:layoutAttribute];
}

- (LZConstraint *)left {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeLeft];
}

- (LZConstraint *)top {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeTop];
}

- (LZConstraint *)right {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeRight];
}

- (LZConstraint *)bottom {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeBottom];
}

- (LZConstraint *)leading {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeLeading];
}

- (LZConstraint *)trailing {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeTrailing];
}

- (LZConstraint *)width {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeWidth];
}

- (LZConstraint *)height {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeHeight];
}

- (LZConstraint *)centerX {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeCenterX];
}

- (LZConstraint *)centerY {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeCenterY];
}

- (LZConstraint *)baseline {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeBaseline];
}

- (LZConstraint *(^)(LZAttribute))attributes {
    return ^(LZAttribute attrs){
        return [self addConstraintWithAttributes:attrs];
    };
}

#if (__IPHONE_OS_VERSION_MIN_REQUIRED >= 80000) || (__TV_OS_VERSION_MIN_REQUIRED >= 9000) || (__MAC_OS_X_VERSION_MIN_REQUIRED >= 101100)

- (LZConstraint *)firstBaseline {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeFirstBaseline];
}

- (LZConstraint *)lastBaseline {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeLastBaseline];
}

#endif


#if (__IPHONE_OS_VERSION_MIN_REQUIRED >= 80000) || (__TV_OS_VERSION_MIN_REQUIRED >= 9000)

- (LZConstraint *)leftMargin {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeLeftMargin];
}

- (LZConstraint *)rightMargin {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeRightMargin];
}

- (LZConstraint *)topMargin {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeTopMargin];
}

- (LZConstraint *)bottomMargin {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeBottomMargin];
}

- (LZConstraint *)leadingMargin {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeLeadingMargin];
}

- (LZConstraint *)trailingMargin {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeTrailingMargin];
}

- (LZConstraint *)centerXWithinMargins {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeCenterXWithinMargins];
}

- (LZConstraint *)centerYWithinMargins {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeCenterYWithinMargins];
}

#endif


#pragma mark - composite Attributes

- (LZConstraint *)edges {
    return [self addConstraintWithAttributes:LZAttributeTop | LZAttributeLeft | LZAttributeRight | LZAttributeBottom];
}

- (LZConstraint *)size {
    return [self addConstraintWithAttributes:LZAttributeWidth | LZAttributeHeight];
}

- (LZConstraint *)center {
    return [self addConstraintWithAttributes:LZAttributeCenterX | LZAttributeCenterY];
}

#pragma mark - grouping

- (LZConstraint *(^)(dispatch_block_t group))group {
    return ^id(dispatch_block_t group) {
        NSInteger previousCount = self.constraints.count;
        group();

        NSArray *children = [self.constraints subarrayWithRange:NSMakeRange(previousCount, self.constraints.count - previousCount)];
        LZCompositeConstraint *constraint = [[LZCompositeConstraint alloc] initWithChildren:children];
        constraint.delegate = self;
        return constraint;
    };
}

@end
