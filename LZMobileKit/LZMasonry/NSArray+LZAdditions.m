//
//  NSArray+LZAdditions.m
//  
//
//  Created by 何伟东 on 2019/11/25.
//
//

#import "NSArray+LZAdditions.h"
#import "View+LZAdditions.h"

@implementation NSArray (LZAdditions)

- (NSArray *)lz_makeConstraints:(void(^)(LZConstraintMaker *make))block {
    NSMutableArray *constraints = [NSMutableArray array];
    for (LZ_VIEW *view in self) {
        NSAssert([view isKindOfClass:[LZ_VIEW class]], @"All objects in the array must be views");
        [constraints addObjectsFromArray:[view lz_makeConstraints:block]];
    }
    return constraints;
}

- (NSArray *)lz_updateConstraints:(void(^)(LZConstraintMaker *make))block {
    NSMutableArray *constraints = [NSMutableArray array];
    for (LZ_VIEW *view in self) {
        NSAssert([view isKindOfClass:[LZ_VIEW class]], @"All objects in the array must be views");
        [constraints addObjectsFromArray:[view lz_updateConstraints:block]];
    }
    return constraints;
}

- (NSArray *)lz_remakeConstraints:(void(^)(LZConstraintMaker *make))block {
    NSMutableArray *constraints = [NSMutableArray array];
    for (LZ_VIEW *view in self) {
        NSAssert([view isKindOfClass:[LZ_VIEW class]], @"All objects in the array must be views");
        [constraints addObjectsFromArray:[view lz_remakeConstraints:block]];
    }
    return constraints;
}

- (void)lz_distributeViewsAlongAxis:(LZAxisType)axisType withFixedSpacing:(CGFloat)fixedSpacing leadSpacing:(CGFloat)leadSpacing tailSpacing:(CGFloat)tailSpacing {
    if (self.count < 2) {
        NSAssert(self.count>1,@"views to distribute need to bigger than one");
        return;
    }
    
    LZ_VIEW *tempSuperView = [self lz_commonSuperviewOfViews];
    if (axisType == LZAxisTypeHorizontal) {
        LZ_VIEW *prev;
        for (int i = 0; i < self.count; i++) {
            LZ_VIEW *v = self[i];
            [v lz_makeConstraints:^(LZConstraintMaker *make) {
                if (prev) {
                    make.width.equalTo(prev);
                    make.left.equalTo(prev.lz_right).offset(fixedSpacing);
                    if (i == self.count - 1) {//last one
                        make.right.equalTo(tempSuperView).offset(-tailSpacing);
                    }
                }
                else {//first one
                    make.left.equalTo(tempSuperView).offset(leadSpacing);
                }
                
            }];
            prev = v;
        }
    }
    else {
        LZ_VIEW *prev;
        for (int i = 0; i < self.count; i++) {
            LZ_VIEW *v = self[i];
            [v lz_makeConstraints:^(LZConstraintMaker *make) {
                if (prev) {
                    make.height.equalTo(prev);
                    make.top.equalTo(prev.lz_bottom).offset(fixedSpacing);
                    if (i == self.count - 1) {//last one
                        make.bottom.equalTo(tempSuperView).offset(-tailSpacing);
                    }                    
                }
                else {//first one
                    make.top.equalTo(tempSuperView).offset(leadSpacing);
                }
                
            }];
            prev = v;
        }
    }
}

- (void)lz_distributeViewsAlongAxis:(LZAxisType)axisType withFixedItemLength:(CGFloat)fixedItemLength leadSpacing:(CGFloat)leadSpacing tailSpacing:(CGFloat)tailSpacing {
    if (self.count < 2) {
        NSAssert(self.count>1,@"views to distribute need to bigger than one");
        return;
    }
    
    LZ_VIEW *tempSuperView = [self lz_commonSuperviewOfViews];
    if (axisType == LZAxisTypeHorizontal) {
        LZ_VIEW *prev;
        for (int i = 0; i < self.count; i++) {
            LZ_VIEW *v = self[i];
            [v lz_makeConstraints:^(LZConstraintMaker *make) {
                make.width.equalTo(@(fixedItemLength));
                if (prev) {
                    if (i == self.count - 1) {//last one
                        make.right.equalTo(tempSuperView).offset(-tailSpacing);
                    }
                    else {
                        CGFloat offset = (1-(i/((CGFloat)self.count-1)))*(fixedItemLength+leadSpacing)-i*tailSpacing/(((CGFloat)self.count-1));
                        make.right.equalTo(tempSuperView).multipliedBy(i/((CGFloat)self.count-1)).with.offset(offset);
                    }
                }
                else {//first one
                    make.left.equalTo(tempSuperView).offset(leadSpacing);
                }
            }];
            prev = v;
        }
    }
    else {
        LZ_VIEW *prev;
        for (int i = 0; i < self.count; i++) {
            LZ_VIEW *v = self[i];
            [v lz_makeConstraints:^(LZConstraintMaker *make) {
                make.height.equalTo(@(fixedItemLength));
                if (prev) {
                    if (i == self.count - 1) {//last one
                        make.bottom.equalTo(tempSuperView).offset(-tailSpacing);
                    }
                    else {
                        CGFloat offset = (1-(i/((CGFloat)self.count-1)))*(fixedItemLength+leadSpacing)-i*tailSpacing/(((CGFloat)self.count-1));
                        make.bottom.equalTo(tempSuperView).multipliedBy(i/((CGFloat)self.count-1)).with.offset(offset);
                    }
                }
                else {//first one
                    make.top.equalTo(tempSuperView).offset(leadSpacing);
                }
            }];
            prev = v;
        }
    }
}

- (LZ_VIEW *)lz_commonSuperviewOfViews
{
    LZ_VIEW *commonSuperview = nil;
    LZ_VIEW *previousView = nil;
    for (id object in self) {
        if ([object isKindOfClass:[LZ_VIEW class]]) {
            LZ_VIEW *view = (LZ_VIEW *)object;
            if (previousView) {
                commonSuperview = [view lz_closestCommonSuperview:commonSuperview];
            } else {
                commonSuperview = view;
            }
            previousView = view;
        }
    }
    NSAssert(commonSuperview, @"Can't constrain views that do not share a common superview. Make sure that all the views in this array have been added into the same view hierarchy.");
    return commonSuperview;
}

@end
