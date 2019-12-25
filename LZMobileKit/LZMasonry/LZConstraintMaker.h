//
//  LZConstraintMaker.h
//  Masonry
//
//  Created by 何伟东 on 2019/11/25.
//  Copyright (c) 2013 LZMobileKit. All rights reserved.
//

#import "LZConstraint.h"
#import "LZUtilities.h"

typedef NS_OPTIONS(NSInteger, LZAttribute) {
    LZAttributeLeft = 1 << NSLayoutAttributeLeft,
    LZAttributeRight = 1 << NSLayoutAttributeRight,
    LZAttributeTop = 1 << NSLayoutAttributeTop,
    LZAttributeBottom = 1 << NSLayoutAttributeBottom,
    LZAttributeLeading = 1 << NSLayoutAttributeLeading,
    LZAttributeTrailing = 1 << NSLayoutAttributeTrailing,
    LZAttributeWidth = 1 << NSLayoutAttributeWidth,
    LZAttributeHeight = 1 << NSLayoutAttributeHeight,
    LZAttributeCenterX = 1 << NSLayoutAttributeCenterX,
    LZAttributeCenterY = 1 << NSLayoutAttributeCenterY,
    LZAttributeBaseline = 1 << NSLayoutAttributeBaseline,
    
#if (__IPHONE_OS_VERSION_MIN_REQUIRED >= 80000) || (__TV_OS_VERSION_MIN_REQUIRED >= 9000) || (__MAC_OS_X_VERSION_MIN_REQUIRED >= 101100)
    
    LZAttributeFirstBaseline = 1 << NSLayoutAttributeFirstBaseline,
    LZAttributeLastBaseline = 1 << NSLayoutAttributeLastBaseline,
    
#endif
    
#if (__IPHONE_OS_VERSION_MIN_REQUIRED >= 80000) || (__TV_OS_VERSION_MIN_REQUIRED >= 9000)
    
    LZAttributeLeftMargin = 1 << NSLayoutAttributeLeftMargin,
    LZAttributeRightMargin = 1 << NSLayoutAttributeRightMargin,
    LZAttributeTopMargin = 1 << NSLayoutAttributeTopMargin,
    LZAttributeBottomMargin = 1 << NSLayoutAttributeBottomMargin,
    LZAttributeLeadingMargin = 1 << NSLayoutAttributeLeadingMargin,
    LZAttributeTrailingMargin = 1 << NSLayoutAttributeTrailingMargin,
    LZAttributeCenterXWithinMargins = 1 << NSLayoutAttributeCenterXWithinMargins,
    LZAttributeCenterYWithinMargins = 1 << NSLayoutAttributeCenterYWithinMargins,

#endif
    
};

/**
 *  Provides factory methods for creating LZConstraints.
 *  Constraints are collected until they are ready to be installed
 *
 */
@interface LZConstraintMaker : NSObject

/**
 *	The following properties return a new LZViewConstraint
 *  with the first item set to the makers associated view and the appropriate LZViewAttribute
 */
@property (nonatomic, strong, readonly) LZConstraint *left;
@property (nonatomic, strong, readonly) LZConstraint *top;
@property (nonatomic, strong, readonly) LZConstraint *right;
@property (nonatomic, strong, readonly) LZConstraint *bottom;
@property (nonatomic, strong, readonly) LZConstraint *leading;
@property (nonatomic, strong, readonly) LZConstraint *trailing;
@property (nonatomic, strong, readonly) LZConstraint *width;
@property (nonatomic, strong, readonly) LZConstraint *height;
@property (nonatomic, strong, readonly) LZConstraint *centerX;
@property (nonatomic, strong, readonly) LZConstraint *centerY;
@property (nonatomic, strong, readonly) LZConstraint *baseline;

#if (__IPHONE_OS_VERSION_MIN_REQUIRED >= 80000) || (__TV_OS_VERSION_MIN_REQUIRED >= 9000) || (__MAC_OS_X_VERSION_MIN_REQUIRED >= 101100)

@property (nonatomic, strong, readonly) LZConstraint *firstBaseline;
@property (nonatomic, strong, readonly) LZConstraint *lastBaseline;

#endif

#if (__IPHONE_OS_VERSION_MIN_REQUIRED >= 80000) || (__TV_OS_VERSION_MIN_REQUIRED >= 9000)

@property (nonatomic, strong, readonly) LZConstraint *leftMargin;
@property (nonatomic, strong, readonly) LZConstraint *rightMargin;
@property (nonatomic, strong, readonly) LZConstraint *topMargin;
@property (nonatomic, strong, readonly) LZConstraint *bottomMargin;
@property (nonatomic, strong, readonly) LZConstraint *leadingMargin;
@property (nonatomic, strong, readonly) LZConstraint *trailingMargin;
@property (nonatomic, strong, readonly) LZConstraint *centerXWithinMargins;
@property (nonatomic, strong, readonly) LZConstraint *centerYWithinMargins;

#endif

/**
 *  Returns a block which creates a new LZCompositeConstraint with the first item set
 *  to the makers associated view and children corresponding to the set bits in the
 *  LZAttribute parameter. Combine multiple attributes via binary-or.
 */
@property (nonatomic, strong, readonly) LZConstraint *(^attributes)(LZAttribute attrs);

/**
 *	Creates a LZCompositeConstraint with type LZCompositeConstraintTypeEdges
 *  which generates the appropriate LZViewConstraint children (top, left, bottom, right)
 *  with the first item set to the makers associated view
 */
@property (nonatomic, strong, readonly) LZConstraint *edges;

/**
 *	Creates a LZCompositeConstraint with type LZCompositeConstraintTypeSize
 *  which generates the appropriate LZViewConstraint children (width, height)
 *  with the first item set to the makers associated view
 */
@property (nonatomic, strong, readonly) LZConstraint *size;

/**
 *	Creates a LZCompositeConstraint with type LZCompositeConstraintTypeCenter
 *  which generates the appropriate LZViewConstraint children (centerX, centerY)
 *  with the first item set to the makers associated view
 */
@property (nonatomic, strong, readonly) LZConstraint *center;

/**
 *  Whether or not to check for an existing constraint instead of adding constraint
 */
@property (nonatomic, assign) BOOL updateExisting;

/**
 *  Whether or not to remove existing constraints prior to installing
 */
@property (nonatomic, assign) BOOL removeExisting;

/**
 *	initialises the maker with a default view
 *
 *	@param	view	any LZConstraint are created with this view as the first item
 *
 *	@return	a new LZConstraintMaker
 */
- (id)initWithView:(LZ_VIEW *)view;

/**
 *	Calls install method on any LZConstraints which have been created by this maker
 *
 *	@return	an array of all the installed LZConstraints
 */
- (NSArray *)install;

- (LZConstraint * (^)(dispatch_block_t))group;

@end
