//
//  PLPDeviceManager+Cache.h
//  2021-Philips
//
//  Created by Apple on 2021/6/7.
//  Copyright © 2021 com.Kaadas. All rights reserved.
//

#import "PLPDeviceManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface PLPDeviceManager (Cache)



/// 获取缓存对象
/// @param key 键
- (nullable id)cacheObjectForKey:(NSString *)key;

/// 设置缓存对象
/// @param obj 值
/// @param key 键
- (void)setCacheObject:(id)obj forKey:(NSString *)key;

/// 删除缓存对象
/// @param key 键
- (void)removeCacheObjectForKey:(NSString *)key;

/// 删除所有缓存对象
- (void)removeCacheAllObjects;

@end

NS_ASSUME_NONNULL_END
