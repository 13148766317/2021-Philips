//
//  KDSLock+DeviceManager.h
//  2021-Philips
//
//  Created by Apple on 2021/6/4.
//  Copyright © 2021 com.Kaadas. All rights reserved.
//

#import "KDSLock.h"

NS_ASSUME_NONNULL_BEGIN

@interface KDSLock (DeviceManager)

/// 更改锁状态
/// @param state 状态
-(void)setLockState:(KDSLockState) state;

/// 获取第一页的开锁记录
-(void)getUnlockRecord;

/// 获取开锁次数
-(void)getUnlockTimes;
@end

NS_ASSUME_NONNULL_END
