//
//  LZViewConstraint.h
//  Masonry
//
//  Created by 何伟东 on 2019/11/25.
//  Copyright (c) 2013 LZMobileKit. All rights reserved.
//

#import "LZViewAttribute.h"
#import "LZConstraint.h"
#import "LZLayoutConstraint.h"
#import "LZUtilities.h"

/**
 *  A single constraint.
 *  Contains the attributes neccessary for creating a NSLayoutConstraint and adding it to the appropriate view
 */
@interface LZViewConstraint : LZConstraint <NSCopying>

/**
 *	First item/view and first attribute of the NSLayoutConstraint
 */
@property (nonatomic, strong, readonly) LZViewAttribute *firstViewAttribute;

/**
 *	Second item/view and second attribute of the NSLayoutConstraint
 */
@property (nonatomic, strong, readonly) LZViewAttribute *secondViewAttribute;

/**
 *	initialises the LZViewConstraint with the first part of the equation
 *
 *	@param	firstViewAttribute	view.lz_left, view.lz_width etc.
 *
 *	@return	a new view constraint
 */
- (id)initWithFirstViewAttribute:(LZViewAttribute *)firstViewAttribute;

/**
 *  Returns all LZViewConstraints installed with this view as a first item.
 *
 *  @param  view  A view to retrieve constraints for.
 *
 *  @return An array of LZViewConstraints.
 */
+ (NSArray *)installedConstraintsForView:(LZ_VIEW *)view;

@end
