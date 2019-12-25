//
//  LZUtilities.h
//  Masonry
//
//  Created by 何伟东 on 2019/11/25.
//  Copyright (c) 2013 LZMobileKit. All rights reserved.
//

#import <Foundation/Foundation.h>



#if TARGET_OS_IPHONE || TARGET_OS_TV

    #import <UIKit/UIKit.h>
    #define LZ_VIEW UIView
    #define LZ_VIEW_CONTROLLER UIViewController
    #define LZEdgeInsets UIEdgeInsets

    typedef UILayoutPriority LZLayoutPriority;
    static const LZLayoutPriority LZLayoutPriorityRequired = UILayoutPriorityRequired;
    static const LZLayoutPriority LZLayoutPriorityDefaultHigh = UILayoutPriorityDefaultHigh;
    static const LZLayoutPriority LZLayoutPriorityDefaultMedium = 500;
    static const LZLayoutPriority LZLayoutPriorityDefaultLow = UILayoutPriorityDefaultLow;
    static const LZLayoutPriority LZLayoutPriorityFittingSizeLevel = UILayoutPriorityFittingSizeLevel;

#elif TARGET_OS_MAC

    #import <AppKit/AppKit.h>
    #define LZ_VIEW NSView
    #define LZEdgeInsets NSEdgeInsets

    typedef NSLayoutPriority LZLayoutPriority;
    static const LZLayoutPriority LZLayoutPriorityRequired = NSLayoutPriorityRequired;
    static const LZLayoutPriority LZLayoutPriorityDefaultHigh = NSLayoutPriorityDefaultHigh;
    static const LZLayoutPriority LZLayoutPriorityDragThatCanResizeWindow = NSLayoutPriorityDragThatCanResizeWindow;
    static const LZLayoutPriority LZLayoutPriorityDefaultMedium = 501;
    static const LZLayoutPriority LZLayoutPriorityWindowSizeStayPut = NSLayoutPriorityWindowSizeStayPut;
    static const LZLayoutPriority LZLayoutPriorityDragThatCannotResizeWindow = NSLayoutPriorityDragThatCannotResizeWindow;
    static const LZLayoutPriority LZLayoutPriorityDefaultLow = NSLayoutPriorityDefaultLow;
    static const LZLayoutPriority LZLayoutPriorityFittingSizeCompression = NSLayoutPriorityFittingSizeCompression;

#endif

/**
 *	Allows you to attach keys to objects matching the variable names passed.
 *
 *  view1.lz_key = @"view1", view2.lz_key = @"view2";
 *
 *  is equivalent to:
 *
 *  LZAttachKeys(view1, view2);
 */
#define LZAttachKeys(...)                                                        \
    {                                                                             \
        NSDictionary *keyPairs = NSDictionaryOfVariableBindings(__VA_ARGS__);     \
        for (id key in keyPairs.allKeys) {                                        \
            id obj = keyPairs[key];                                               \
            NSAssert([obj respondsToSelector:@selector(setMas_key:)],             \
                     @"Cannot attach lz_key to %@", obj);                        \
            [obj setMas_key:key];                                                 \
        }                                                                         \
    }

/**
 *  Used to create object hashes
 *  Based on http://www.mikeash.com/pyblog/friday-qa-2010-06-18-implementing-equality-and-hashing.html
 */
#define LZ_NSUINT_BIT (CHAR_BIT * sizeof(NSUInteger))
#define LZ_NSUINTROTATE(val, howmuch) ((((NSUInteger)val) << howmuch) | (((NSUInteger)val) >> (LZ_NSUINT_BIT - howmuch)))

/**
 *  Given a scalar or struct value, wraps it in NSValue
 *  Based on EXPObjectify: https://github.com/specta/expecta
 */
static inline id _LZBoxValue(const char *type, ...) {
    va_list v;
    va_start(v, type);
    id obj = nil;
    if (strcmp(type, @encode(id)) == 0) {
        id actual = va_arg(v, id);
        obj = actual;
    } else if (strcmp(type, @encode(CGPoint)) == 0) {
        CGPoint actual = (CGPoint)va_arg(v, CGPoint);
        obj = [NSValue value:&actual withObjCType:type];
    } else if (strcmp(type, @encode(CGSize)) == 0) {
        CGSize actual = (CGSize)va_arg(v, CGSize);
        obj = [NSValue value:&actual withObjCType:type];
    } else if (strcmp(type, @encode(LZEdgeInsets)) == 0) {
        LZEdgeInsets actual = (LZEdgeInsets)va_arg(v, LZEdgeInsets);
        obj = [NSValue value:&actual withObjCType:type];
    } else if (strcmp(type, @encode(double)) == 0) {
        double actual = (double)va_arg(v, double);
        obj = [NSNumber numberWithDouble:actual];
    } else if (strcmp(type, @encode(float)) == 0) {
        float actual = (float)va_arg(v, double);
        obj = [NSNumber numberWithFloat:actual];
    } else if (strcmp(type, @encode(int)) == 0) {
        int actual = (int)va_arg(v, int);
        obj = [NSNumber numberWithInt:actual];
    } else if (strcmp(type, @encode(long)) == 0) {
        long actual = (long)va_arg(v, long);
        obj = [NSNumber numberWithLong:actual];
    } else if (strcmp(type, @encode(long long)) == 0) {
        long long actual = (long long)va_arg(v, long long);
        obj = [NSNumber numberWithLongLong:actual];
    } else if (strcmp(type, @encode(short)) == 0) {
        short actual = (short)va_arg(v, int);
        obj = [NSNumber numberWithShort:actual];
    } else if (strcmp(type, @encode(char)) == 0) {
        char actual = (char)va_arg(v, int);
        obj = [NSNumber numberWithChar:actual];
    } else if (strcmp(type, @encode(bool)) == 0) {
        bool actual = (bool)va_arg(v, int);
        obj = [NSNumber numberWithBool:actual];
    } else if (strcmp(type, @encode(unsigned char)) == 0) {
        unsigned char actual = (unsigned char)va_arg(v, unsigned int);
        obj = [NSNumber numberWithUnsignedChar:actual];
    } else if (strcmp(type, @encode(unsigned int)) == 0) {
        unsigned int actual = (unsigned int)va_arg(v, unsigned int);
        obj = [NSNumber numberWithUnsignedInt:actual];
    } else if (strcmp(type, @encode(unsigned long)) == 0) {
        unsigned long actual = (unsigned long)va_arg(v, unsigned long);
        obj = [NSNumber numberWithUnsignedLong:actual];
    } else if (strcmp(type, @encode(unsigned long long)) == 0) {
        unsigned long long actual = (unsigned long long)va_arg(v, unsigned long long);
        obj = [NSNumber numberWithUnsignedLongLong:actual];
    } else if (strcmp(type, @encode(unsigned short)) == 0) {
        unsigned short actual = (unsigned short)va_arg(v, unsigned int);
        obj = [NSNumber numberWithUnsignedShort:actual];
    }
    va_end(v);
    return obj;
}

#define LZBoxValue(value) _LZBoxValue(@encode(__typeof__((value))), (value))
