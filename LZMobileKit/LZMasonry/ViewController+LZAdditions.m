//
//  UIViewController+LZAdditions.m
//  Masonry
//
//  Created by 何伟东 on 2019/11/25.
//
//

#import "ViewController+LZAdditions.h"

#ifdef LZ_VIEW_CONTROLLER

@implementation LZ_VIEW_CONTROLLER (LZAdditions)

- (LZViewAttribute *)lz_topLayoutGuide {
    return [[LZViewAttribute alloc] initWithView:self.view item:self.topLayoutGuide layoutAttribute:NSLayoutAttributeBottom];
}
- (LZViewAttribute *)lz_topLayoutGuideTop {
    return [[LZViewAttribute alloc] initWithView:self.view item:self.topLayoutGuide layoutAttribute:NSLayoutAttributeTop];
}
- (LZViewAttribute *)lz_topLayoutGuideBottom {
    return [[LZViewAttribute alloc] initWithView:self.view item:self.topLayoutGuide layoutAttribute:NSLayoutAttributeBottom];
}

- (LZViewAttribute *)lz_bottomLayoutGuide {
    return [[LZViewAttribute alloc] initWithView:self.view item:self.bottomLayoutGuide layoutAttribute:NSLayoutAttributeTop];
}
- (LZViewAttribute *)lz_bottomLayoutGuideTop {
    return [[LZViewAttribute alloc] initWithView:self.view item:self.bottomLayoutGuide layoutAttribute:NSLayoutAttributeTop];
}
- (LZViewAttribute *)lz_bottomLayoutGuideBottom {
    return [[LZViewAttribute alloc] initWithView:self.view item:self.bottomLayoutGuide layoutAttribute:NSLayoutAttributeBottom];
}



@end

#endif
