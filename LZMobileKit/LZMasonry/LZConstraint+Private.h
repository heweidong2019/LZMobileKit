//
//  LZConstraint+Private.h
//  Masonry
//
//  Created by 何伟东 on 2019/11/25.
//  Copyright (c) 2013 LZMobileKit. All rights reserved.
//

#import "LZConstraint.h"

@protocol LZConstraintDelegate;


@interface LZConstraint ()

/**
 *  Whether or not to check for an existing constraint instead of adding constraint
 */
@property (nonatomic, assign) BOOL updateExisting;

/**
 *	Usually LZConstraintMaker but could be a parent LZConstraint
 */
@property (nonatomic, weak) id<LZConstraintDelegate> delegate;

/**
 *  Based on a provided value type, is equal to calling:
 *  NSNumber - setOffset:
 *  NSValue with CGPoint - setPointOffset:
 *  NSValue with CGSize - setSizeOffset:
 *  NSValue with LZEdgeInsets - setInsets:
 */
- (void)setLayoutConstantWithValue:(NSValue *)value;

@end


@interface LZConstraint (Abstract)

/**
 *	Sets the constraint relation to given NSLayoutRelation
 *  returns a block which accepts one of the following:
 *    LZViewAttribute, UIView, NSValue, NSArray
 *  see readme for more details.
 */
- (LZConstraint * (^)(id, NSLayoutRelation))equalToWithRelation;

/**
 *	Override to set a custom chaining behaviour
 */
- (LZConstraint *)addConstraintWithLayoutAttribute:(NSLayoutAttribute)layoutAttribute;

@end


@protocol LZConstraintDelegate <NSObject>

/**
 *	Notifies the delegate when the constraint needs to be replaced with another constraint. For example
 *  A LZViewConstraint may turn into a LZCompositeConstraint when an array is passed to one of the equality blocks
 */
- (void)constraint:(LZConstraint *)constraint shouldBeReplacedWithConstraint:(LZConstraint *)replacementConstraint;

- (LZConstraint *)constraint:(LZConstraint *)constraint addConstraintWithLayoutAttribute:(NSLayoutAttribute)layoutAttribute;

@end
