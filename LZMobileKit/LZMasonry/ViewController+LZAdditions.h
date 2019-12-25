//
//  UIViewController+LZAdditions.h
//  Masonry
//
//  Created by 何伟东 on 2019/11/25.
//
//

#import "LZUtilities.h"
#import "LZConstraintMaker.h"
#import "LZViewAttribute.h"

#ifdef LZ_VIEW_CONTROLLER

@interface LZ_VIEW_CONTROLLER (LZAdditions)

/**
 *	following properties return a new LZViewAttribute with appropriate UILayoutGuide and NSLayoutAttribute
 */
@property (nonatomic, strong, readonly) LZViewAttribute *lz_topLayoutGuide;
@property (nonatomic, strong, readonly) LZViewAttribute *lz_bottomLayoutGuide;
@property (nonatomic, strong, readonly) LZViewAttribute *lz_topLayoutGuideTop;
@property (nonatomic, strong, readonly) LZViewAttribute *lz_topLayoutGuideBottom;
@property (nonatomic, strong, readonly) LZViewAttribute *lz_bottomLayoutGuideTop;
@property (nonatomic, strong, readonly) LZViewAttribute *lz_bottomLayoutGuideBottom;


@end

#endif
