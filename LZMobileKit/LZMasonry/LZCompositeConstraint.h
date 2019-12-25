//
//  LZCompositeConstraint.h
//  Masonry
//
//  Created by 何伟东 on 2019/11/25.
//  Copyright (c) 2013 LZMobileKit. All rights reserved.
//

#import "LZConstraint.h"
#import "LZUtilities.h"

/**
 *	A group of LZConstraint objects
 */
@interface LZCompositeConstraint : LZConstraint

/**
 *	Creates a composite with a predefined array of children
 *
 *	@param	children	child LZConstraints
 *
 *	@return	a composite constraint
 */
- (id)initWithChildren:(NSArray *)children;

@end
