//
//  LZConstraint.h
//  Masonry
//
//  Created by 何伟东 on 2019/11/25.
//  Copyright (c) 2013 LZMobileKit. All rights reserved.
//

#import "LZUtilities.h"

/**
 *	Enables Constraints to be created with chainable syntax
 *  Constraint can represent single NSLayoutConstraint (LZViewConstraint) 
 *  or a group of NSLayoutConstraints (LZComposisteConstraint)
 */
@interface LZConstraint : NSObject

// Chaining Support

/**
 *	Modifies the NSLayoutConstraint constant,
 *  only affects LZConstraints in which the first item's NSLayoutAttribute is one of the following
 *  NSLayoutAttributeTop, NSLayoutAttributeLeft, NSLayoutAttributeBottom, NSLayoutAttributeRight
 */
- (LZConstraint * (^)(LZEdgeInsets insets))insets;

/**
 *	Modifies the NSLayoutConstraint constant,
 *  only affects LZConstraints in which the first item's NSLayoutAttribute is one of the following
 *  NSLayoutAttributeTop, NSLayoutAttributeLeft, NSLayoutAttributeBottom, NSLayoutAttributeRight
 */
- (LZConstraint * (^)(CGFloat inset))inset;

/**
 *	Modifies the NSLayoutConstraint constant,
 *  only affects LZConstraints in which the first item's NSLayoutAttribute is one of the following
 *  NSLayoutAttributeWidth, NSLayoutAttributeHeight
 */
- (LZConstraint * (^)(CGSize offset))sizeOffset;

/**
 *	Modifies the NSLayoutConstraint constant,
 *  only affects LZConstraints in which the first item's NSLayoutAttribute is one of the following
 *  NSLayoutAttributeCenterX, NSLayoutAttributeCenterY
 */
- (LZConstraint * (^)(CGPoint offset))centerOffset;

/**
 *	Modifies the NSLayoutConstraint constant
 */
- (LZConstraint * (^)(CGFloat offset))offset;

/**
 *  Modifies the NSLayoutConstraint constant based on a value type
 */
- (LZConstraint * (^)(NSValue *value))valueOffset;

/**
 *	Sets the NSLayoutConstraint multiplier property
 */
- (LZConstraint * (^)(CGFloat multiplier))multipliedBy;

/**
 *	Sets the NSLayoutConstraint multiplier to 1.0/dividedBy
 */
- (LZConstraint * (^)(CGFloat divider))dividedBy;

/**
 *	Sets the NSLayoutConstraint priority to a float or LZLayoutPriority
 */
- (LZConstraint * (^)(LZLayoutPriority priority))priority;

/**
 *	Sets the NSLayoutConstraint priority to LZLayoutPriorityLow
 */
- (LZConstraint * (^)(void))priorityLow;

/**
 *	Sets the NSLayoutConstraint priority to LZLayoutPriorityMedium
 */
- (LZConstraint * (^)(void))priorityMedium;

/**
 *	Sets the NSLayoutConstraint priority to LZLayoutPriorityHigh
 */
- (LZConstraint * (^)(void))priorityHigh;

/**
 *	Sets the constraint relation to NSLayoutRelationEqual
 *  returns a block which accepts one of the following:
 *    LZViewAttribute, UIView, NSValue, NSArray
 *  see readme for more details.
 */
- (LZConstraint * (^)(id attr))equalTo;

/**
 *	Sets the constraint relation to NSLayoutRelationGreaterThanOrEqual
 *  returns a block which accepts one of the following:
 *    LZViewAttribute, UIView, NSValue, NSArray
 *  see readme for more details.
 */
- (LZConstraint * (^)(id attr))greaterThanOrEqualTo;

/**
 *	Sets the constraint relation to NSLayoutRelationLessThanOrEqual
 *  returns a block which accepts one of the following:
 *    LZViewAttribute, UIView, NSValue, NSArray
 *  see readme for more details.
 */
- (LZConstraint * (^)(id attr))lessThanOrEqualTo;

/**
 *	Optional semantic property which has no effect but improves the readability of constraint
 */
- (LZConstraint *)with;

/**
 *	Optional semantic property which has no effect but improves the readability of constraint
 */
- (LZConstraint *)and;

/**
 *	Creates a new LZCompositeConstraint with the called attribute and reciever
 */
- (LZConstraint *)left;
- (LZConstraint *)top;
- (LZConstraint *)right;
- (LZConstraint *)bottom;
- (LZConstraint *)leading;
- (LZConstraint *)trailing;
- (LZConstraint *)width;
- (LZConstraint *)height;
- (LZConstraint *)centerX;
- (LZConstraint *)centerY;
- (LZConstraint *)baseline;

#if (__IPHONE_OS_VERSION_MIN_REQUIRED >= 80000) || (__TV_OS_VERSION_MIN_REQUIRED >= 9000) || (__MAC_OS_X_VERSION_MIN_REQUIRED >= 101100)

- (LZConstraint *)firstBaseline;
- (LZConstraint *)lastBaseline;

#endif

#if (__IPHONE_OS_VERSION_MIN_REQUIRED >= 80000) || (__TV_OS_VERSION_MIN_REQUIRED >= 9000)

- (LZConstraint *)leftMargin;
- (LZConstraint *)rightMargin;
- (LZConstraint *)topMargin;
- (LZConstraint *)bottomMargin;
- (LZConstraint *)leadingMargin;
- (LZConstraint *)trailingMargin;
- (LZConstraint *)centerXWithinMargins;
- (LZConstraint *)centerYWithinMargins;

#endif


/**
 *	Sets the constraint debug name
 */
- (LZConstraint * (^)(id key))key;

// NSLayoutConstraint constant Setters
// for use outside of lz_updateConstraints/lz_makeConstraints blocks

/**
 *	Modifies the NSLayoutConstraint constant,
 *  only affects LZConstraints in which the first item's NSLayoutAttribute is one of the following
 *  NSLayoutAttributeTop, NSLayoutAttributeLeft, NSLayoutAttributeBottom, NSLayoutAttributeRight
 */
- (void)setInsets:(LZEdgeInsets)insets;

/**
 *	Modifies the NSLayoutConstraint constant,
 *  only affects LZConstraints in which the first item's NSLayoutAttribute is one of the following
 *  NSLayoutAttributeTop, NSLayoutAttributeLeft, NSLayoutAttributeBottom, NSLayoutAttributeRight
 */
- (void)setInset:(CGFloat)inset;

/**
 *	Modifies the NSLayoutConstraint constant,
 *  only affects LZConstraints in which the first item's NSLayoutAttribute is one of the following
 *  NSLayoutAttributeWidth, NSLayoutAttributeHeight
 */
- (void)setSizeOffset:(CGSize)sizeOffset;

/**
 *	Modifies the NSLayoutConstraint constant,
 *  only affects LZConstraints in which the first item's NSLayoutAttribute is one of the following
 *  NSLayoutAttributeCenterX, NSLayoutAttributeCenterY
 */
- (void)setCenterOffset:(CGPoint)centerOffset;

/**
 *	Modifies the NSLayoutConstraint constant
 */
- (void)setOffset:(CGFloat)offset;


// NSLayoutConstraint Installation support

#if TARGET_OS_MAC && !(TARGET_OS_IPHONE || TARGET_OS_TV)
/**
 *  Whether or not to go through the animator proxy when modifying the constraint
 */
@property (nonatomic, copy, readonly) LZConstraint *animator;
#endif

/**
 *  Activates an NSLayoutConstraint if it's supported by an OS. 
 *  Invokes install otherwise.
 */
- (void)activate;

/**
 *  Deactivates previously installed/activated NSLayoutConstraint.
 */
- (void)deactivate;

/**
 *	Creates a NSLayoutConstraint and adds it to the appropriate view.
 */
- (void)install;

/**
 *	Removes previously installed NSLayoutConstraint
 */
- (void)uninstall;

@end


/**
 *  Convenience auto-boxing macros for LZConstraint methods.
 *
 *  Defining LZ_SHORTHAND_GLOBALS will turn on auto-boxing for default syntax.
 *  A potential drawback of this is that the unprefixed macros will appear in global scope.
 */
#define lz_equalTo(...)                 equalTo(LZBoxValue((__VA_ARGS__)))
#define lz_greaterThanOrEqualTo(...)    greaterThanOrEqualTo(LZBoxValue((__VA_ARGS__)))
#define lz_lessThanOrEqualTo(...)       lessThanOrEqualTo(LZBoxValue((__VA_ARGS__)))

#define lz_offset(...)                  valueOffset(LZBoxValue((__VA_ARGS__)))


#ifdef LZ_SHORTHAND_GLOBALS

#define equalTo(...)                     lz_equalTo(__VA_ARGS__)
#define greaterThanOrEqualTo(...)        lz_greaterThanOrEqualTo(__VA_ARGS__)
#define lessThanOrEqualTo(...)           lz_lessThanOrEqualTo(__VA_ARGS__)

#define offset(...)                      lz_offset(__VA_ARGS__)

#endif


@interface LZConstraint (AutoboxingSupport)

/**
 *  Aliases to corresponding relation methods (for shorthand macros)
 *  Also needed to aid autocompletion
 */
- (LZConstraint * (^)(id attr))lz_equalTo;
- (LZConstraint * (^)(id attr))lz_greaterThanOrEqualTo;
- (LZConstraint * (^)(id attr))lz_lessThanOrEqualTo;

/**
 *  A dummy method to aid autocompletion
 */
- (LZConstraint * (^)(id offset))lz_offset;

@end
