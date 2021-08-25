//
//  PLPDevice+WiFiSmartLockDeviceViewDataSource.h
//  2021-Philips
//
//  Created by Apple on 2021/6/8.
//  Copyright © 2021 com.Kaadas. All rights reserved.
//

#import "PLPDevice.h"
#import "KDSWifiLockOperation.h"

NS_ASSUME_NONNULL_BEGIN

@interface PLPDevice (WiFiSmartLockDeviceViewDataSource)

/// 设备界面电量
-(NSInteger) plpWiFiSmartLockDevicePower;

/// 设备界面锁状态
-(NSInteger) plpWiFiSmartLockDeviceLockState;


/// 保存最后开锁记录
/// @param record 记录
-(void) setLastUnlockRecord:(KDSWifiLockOperation *) record;

/// 设备最后开锁记录
-(KDSWifiLockOperation *) plpWiFiSmartLockDeviceLastUnlockRecord;

@end

NS_ASSUME_NONNULL_END
