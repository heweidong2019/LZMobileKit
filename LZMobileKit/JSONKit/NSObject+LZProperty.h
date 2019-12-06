//
//  NSObject+LZProperty.h
//  LZMobileKitDemo
//
//  Created by 何伟东 on 2019/12/6.
//  Copyright © 2019 北京幻想悦游网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (LZProperty)

/// 获取对象的所有属性
- (NSDictionary *)getAllProperties;

@end

NS_ASSUME_NONNULL_END
