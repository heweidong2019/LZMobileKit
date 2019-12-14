
#ifndef __LZExtensionConst__H__
#define __LZExtensionConst__H__

#import <Foundation/Foundation.h>

#ifndef LZ_LOCK
#define LZ_LOCK(lock) dispatch_semaphore_wait(lock, DISPATCH_TIME_FOREVER);
#endif

#ifndef LZ_UNLOCK
#define LZ_UNLOCK(lock) dispatch_semaphore_signal(lock);
#endif

// 信号量
#define LZExtensionSemaphoreCreate \
static dispatch_semaphore_t signalSemaphore; \
static dispatch_once_t onceTokenSemaphore; \
dispatch_once(&onceTokenSemaphore, ^{ \
    signalSemaphore = dispatch_semaphore_create(1); \
});

#define LZExtensionSemaphoreWait LZ_LOCK(signalSemaphore)
#define LZExtensionSemaphoreSignal LZ_UNLOCK(signalSemaphore)

// 过期
#define LZExtensionDeprecated(instead) NS_DEPRECATED(2_0, 2_0, 2_0, 2_0, instead)

// 构建错误
#define LZExtensionBuildError(clazz, msg) \
NSError *error = [NSError errorWithDomain:msg code:250 userInfo:nil]; \
[clazz setMj_error:error];

// 日志输出
#ifdef DEBUG
#define LZExtensionLog(...) NSLog(__VA_ARGS__)
#else
#define LZExtensionLog(...)
#endif

/**
 * 断言
 * @param condition   条件
 * @param returnValue 返回值
 */
#define LZExtensionAssertError(condition, returnValue, clazz, msg) \
[clazz setMj_error:nil]; \
if ((condition) == NO) { \
    LZExtensionBuildError(clazz, msg); \
    return returnValue;\
}

#define LZExtensionAssert2(condition, returnValue) \
if ((condition) == NO) return returnValue;

/**
 * 断言
 * @param condition   条件
 */
#define LZExtensionAssert(condition) LZExtensionAssert2(condition, )

/**
 * 断言
 * @param param         参数
 * @param returnValue   返回值
 */
#define LZExtensionAssertParamNotNil2(param, returnValue) \
LZExtensionAssert2((param) != nil, returnValue)

/**
 * 断言
 * @param param   参数
 */
#define LZExtensionAssertParamNotNil(param) LZExtensionAssertParamNotNil2(param, )

/**
 * 打印所有的属性
 */
#define LZLogAllIvars \
- (NSString *)description \
{ \
    return [self mj_keyValues].description; \
}
#define LZExtensionLogAllProperties LZLogAllIvars

/** 仅在 Debugger 展示所有的属性 */
#define LZImplementDebugDescription \
- (NSString *)debugDescription \
{ \
return [self mj_keyValues].debugDescription; \
}

/**
 *  类型（属性类型）
 */
FOUNDATION_EXPORT NSString *const LZPropertyTypeInt;
FOUNDATION_EXPORT NSString *const LZPropertyTypeShort;
FOUNDATION_EXPORT NSString *const LZPropertyTypeFloat;
FOUNDATION_EXPORT NSString *const LZPropertyTypeDouble;
FOUNDATION_EXPORT NSString *const LZPropertyTypeLong;
FOUNDATION_EXPORT NSString *const LZPropertyTypeLongLong;
FOUNDATION_EXPORT NSString *const LZPropertyTypeChar;
FOUNDATION_EXPORT NSString *const LZPropertyTypeBOOL1;
FOUNDATION_EXPORT NSString *const LZPropertyTypeBOOL2;
FOUNDATION_EXPORT NSString *const LZPropertyTypePointer;

FOUNDATION_EXPORT NSString *const LZPropertyTypeIvar;
FOUNDATION_EXPORT NSString *const LZPropertyTypeMethod;
FOUNDATION_EXPORT NSString *const LZPropertyTypeBlock;
FOUNDATION_EXPORT NSString *const LZPropertyTypeClass;
FOUNDATION_EXPORT NSString *const LZPropertyTypeSEL;
FOUNDATION_EXPORT NSString *const LZPropertyTypeId;

#endif
