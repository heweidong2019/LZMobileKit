//
//  UIView+LZAdditions.h
//  Masonry
//
//  Created by 何伟东 on 2019/11/25.
//  Copyright (c) 2013 LZMobileKit. All rights reserved.
//

#import "LZUtilities.h"
#import "LZConstraintMaker.h"
#import "LZViewAttribute.h"

/**
 *	Provides constraint maker block
 *  and convience methods for creating LZViewAttribute which are view + NSLayoutAttribute pairs
 */
@interface LZ_VIEW (LZAdditions)

/**
 *	following properties return a new LZViewAttribute with current view and appropriate NSLayoutAttribute
 */
@property (nonatomic, strong, readonly) LZViewAttribute *lz_left;
@property (nonatomic, strong, readonly) LZViewAttribute *lz_top;
@property (nonatomic, strong, readonly) LZViewAttribute *lz_right;
@property (nonatomic, strong, readonly) LZViewAttribute *lz_bottom;
@property (nonatomic, strong, readonly) LZViewAttribute *lz_leading;
@property (nonatomic, strong, readonly) LZViewAttribute *lz_trailing;
@property (nonatomic, strong, readonly) LZViewAttribute *lz_width;
@property (nonatomic, strong, readonly) LZViewAttribute *lz_height;
@property (nonatomic, strong, readonly) LZViewAttribute *lz_centerX;
@property (nonatomic, strong, readonly) LZViewAttribute *lz_centerY;
@property (nonatomic, strong, readonly) LZViewAttribute *lz_baseline;
@property (nonatomic, strong, readonly) LZViewAttribute *(^lz_attribute)(NSLayoutAttribute attr);

#if (__IPHONE_OS_VERSION_MIN_REQUIRED >= 80000) || (__TV_OS_VERSION_MIN_REQUIRED >= 9000) || (__MAC_OS_X_VERSION_MIN_REQUIRED >= 101100)

@property (nonatomic, strong, readonly) LZViewAttribute *lz_firstBaseline;
@property (nonatomic, strong, readonly) LZViewAttribute *lz_lastBaseline;

#endif

#if (__IPHONE_OS_VERSION_MIN_REQUIRED >= 80000) || (__TV_OS_VERSION_MIN_REQUIRED >= 9000)

@property (nonatomic, strong, readonly) LZViewAttribute *lz_leftMargin;
@property (nonatomic, strong, readonly) LZViewAttribute *lz_rightMargin;
@property (nonatomic, strong, readonly) LZViewAttribute *lz_topMargin;
@property (nonatomic, strong, readonly) LZViewAttribute *lz_bottomMargin;
@property (nonatomic, strong, readonly) LZViewAttribute *lz_leadingMargin;
@property (nonatomic, strong, readonly) LZViewAttribute *lz_trailingMargin;
@property (nonatomic, strong, readonly) LZViewAttribute *lz_centerXWithinMargins;
@property (nonatomic, strong, readonly) LZViewAttribute *lz_centerYWithinMargins;

#endif

#if (__IPHONE_OS_VERSION_MAX_ALLOWED >= 110000) || (__TV_OS_VERSION_MAX_ALLOWED >= 110000)

@property (nonatomic, strong, readonly) LZViewAttribute *lz_safeAreaLayoutGuide API_AVAILABLE(ios(11.0),tvos(11.0));
@property (nonatomic, strong, readonly) LZViewAttribute *lz_safeAreaLayoutGuideTop API_AVAILABLE(ios(11.0),tvos(11.0));
@property (nonatomic, strong, readonly) LZViewAttribute *lz_safeAreaLayoutGuideBottom API_AVAILABLE(ios(11.0),tvos(11.0));
@property (nonatomic, strong, readonly) LZViewAttribute *lz_safeAreaLayoutGuideLeft API_AVAILABLE(ios(11.0),tvos(11.0));
@property (nonatomic, strong, readonly) LZViewAttribute *lz_safeAreaLayoutGuideRight API_AVAILABLE(ios(11.0),tvos(11.0));

#endif

/**
 *	a key to associate with this view
 */
@property (nonatomic, strong) id lz_key;

/**
 *	Finds the closest common superview between this view and another view
 *
 *	@param	view	other view
 *
 *	@return	returns nil if common superview could not be found
 */
- (instancetype)lz_closestCommonSuperview:(LZ_VIEW *)view;

/**
 *  Creates a LZConstraintMaker with the callee view.
 *  Any constraints defined are added to the view or the appropriate superview once the block has finished executing
 *
 *  @param block scope within which you can build up the constraints which you wish to apply to the view.
 *
 *  @return Array of created LZConstraints
 */
- (NSArray *)lz_makeConstraints:(void(NS_NOESCAPE ^)(LZConstraintMaker *make))block;

/**
 *  Creates a LZConstraintMaker with the callee view.
 *  Any constraints defined are added to the view or the appropriate superview once the block has finished executing.
 *  If an existing constraint exists then it will be updated instead.
 *
 *  @param block scope within which you can build up the constraints which you wish to apply to the view.
 *
 *  @return Array of created/updated LZConstraints
 */
- (NSArray *)lz_updateConstraints:(void(NS_NOESCAPE ^)(LZConstraintMaker *make))block;

/**
 *  Creates a LZConstraintMaker with the callee view.
 *  Any constraints defined are added to the view or the appropriate superview once the block has finished executing.
 *  All constraints previously installed for the view will be removed.
 *
 *  @param block scope within which you can build up the constraints which you wish to apply to the view.
 *
 *  @return Array of created/updated LZConstraints
 */
- (NSArray *)lz_remakeConstraints:(void(NS_NOESCAPE ^)(LZConstraintMaker *make))block;

@end
