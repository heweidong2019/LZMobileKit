//
//  NSObject+LZProperty.m
//  LZMobileKitDemo
//
//  Created by 何伟东 on 2019/12/6.
//  Copyright © 2019 北京幻想悦游网络科技有限公司. All rights reserved.
//

#import "NSObject+LZProperty.h"
#import <objc/runtime.h>


@implementation NSObject (LZProperty)

/// 获取对象的所有属性
- (NSDictionary *)getAllProperties{
   NSMutableDictionary *props = [NSMutableDictionary dictionary];
   unsigned int outCount, i;
   objc_property_t *properties = class_copyPropertyList([self class], &outCount);
   for (i = 0; i<outCount; i++){
       objc_property_t property = properties[i];
       const char* char_f =property_getName(property);
       NSString *propertyName = [NSString stringWithUTF8String:char_f];
       id propertyValue = [self valueForKey:(NSString *)propertyName];
       if([propertyValue isKindOfClass:[NSObject class]]){
           
       }
       
       if (propertyValue) [props setObject:propertyValue forKey:propertyName];
    }
   free(properties);
    
    
    uint count;
    Ivar *ivars = class_copyIvarList([self class], &count);
    for (unsigned int i = 0; i < count; i ++) {
        Ivar ivar = ivars[i];
        //获取成员变量名称
        NSString* name = @(ivar_getName(ivar));
        //获取成员变量数据类型
        NSString * type = @(ivar_getTypeEncoding(ivar));
        
        
        
    }
    free(ivars);
    
    
    
   return props;

}

@end
