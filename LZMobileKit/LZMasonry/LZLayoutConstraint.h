//
//  LZLayoutConstraint.h
//  Masonry
//
//  Created by 何伟东 on 2019/11/25.
//  Copyright (c) 2013 LZMobileKit. All rights reserved.
//

#import "LZUtilities.h"

/**
 *	When you are debugging or printing the constraints attached to a view this subclass
 *  makes it easier to identify which constraints have been created via Masonry
 */
@interface LZLayoutConstraint : NSLayoutConstraint

/**
 *	a key to associate with this constraint
 */
@property (nonatomic, strong) id lz_key;

@end
