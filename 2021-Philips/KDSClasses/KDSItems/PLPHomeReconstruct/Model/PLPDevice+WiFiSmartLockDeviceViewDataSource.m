//
//  PLPDevice+WiFiSmartLockDeviceViewDataSource.m
//  2021-Philips
//
//  Created by Apple on 2021/6/8.
//  Copyright © 2021 com.Kaadas. All rights reserved.
//

#import "PLPDevice+WiFiSmartLockDeviceViewDataSource.h"
#import "PLPDeviceManager+Cache.h"

@implementation PLPDevice (WiFiSmartLockDeviceViewDataSource)

/// 设备界面电量
-(NSInteger) plpWiFiSmartLockDevicePower {
    NSInteger power = 0;
    if ([self plpOldDeviceType] == PLPOldDeviceTypeWifiLockModel) {
        KDSLock *lock = [self plpLockWithOldDevice];
        power = [lock power];
        if (power > 100 || power < 0) {
            KDSWifiLockModel *wifiLock = (KDSWifiLockModel *) [self plpOldDevice];
            power = [wifiLock power];
            
        }
    }
    return power;
}

/// 设备界面WiFi锁状态
-(NSInteger) plpWiFiSmartLockDeviceLockState {
    NSInteger state = 0;
    if ([self plpOldDeviceType] == PLPOldDeviceTypeWifiLockModel) {
        KDSLock *lock = [self plpLockWithOldDevice];
        if (lock.wifiDevice) {
            if (lock.wifiDevice.openStatus == 3) {
                lock.state = KDSLockSpittingState;
            }if (lock.wifiDevice.powerSave.intValue == 1) {
                lock.state = KDSLockStateEnergy;
            }if (lock.wifiDevice.faceStatus.intValue == 0) {
                lock.state = KDSLockStateFaceTurnedOff;
            }if (lock.wifiDevice.safeMode.intValue == 1) {
                lock.state = KDSLockStateSecurityMode;
            }if (lock.wifiDevice.operatingMode.intValue == 1) {
                lock.state = KDSLockStateLockInside;
            }if (lock.wifiDevice.defences.intValue == 1) {
                lock.state = KDSLockStateDefence;
            }if (lock.wifiDevice.defences.intValue ==0 && lock.wifiDevice.operatingMode.intValue ==0 && lock.wifiDevice.safeMode.intValue == 0 && lock.wifiDevice.powerSave.intValue ==0 && lock.wifiDevice.faceStatus.intValue == 1 && (lock.wifiDevice.openStatus ==1 || lock.wifiDevice.openStatus == 0)) {//正常状态（关闭状态）
                lock.state = KDSLockStateOnline;
            }if (lock.wifiDevice.openStatus == 2 && lock.state != KDSLockStateUnlocked){//门未上锁（开锁状态）
                lock.state = KDSLockStateUnlocked;
                
            }
            
            state = lock.state;
        }else{
            state = [lock state];
        }
    }
    return state;
    
}


/// 生成开锁记录key
-(NSString *) lastUnlockRecordKey {
    return [NSString stringWithFormat:@"device-lastUnlockRecord-%@",[self plpDeviceId]];
}


/// 保存最后开锁记录
/// @param record 记录
-(void) setLastUnlockRecord:(KDSWifiLockOperation *) record {
    [[PLPDeviceManager sharedInstance] setCacheObject:record forKey:[self lastUnlockRecordKey]];
}

/// 设备最后开锁记录
-(KDSWifiLockOperation *) plpWiFiSmartLockDeviceLastUnlockRecord {
    KDSWifiLockOperation *result = [[PLPDeviceManager sharedInstance] cacheObjectForKey:[self lastUnlockRecordKey]];
    if (result) {
        return result;
    }else {
        return nil;
    }
}
@end
