//
//  KDSLock+DeviceManager.m
//  2021-Philips
//
//  Created by Apple on 2021/6/4.
//  Copyright © 2021 com.Kaadas. All rights reserved.
//

#import "KDSLock+DeviceManager.h"
#import "KDSHttpManager+WifiLock.h"
#import "PLPDeviceManager+Notification.h"
#import "PLPDevice+WiFiSmartLockDeviceViewDataSource.h"


@implementation KDSLock (DeviceManager)
/// 更改锁状态
/// @param state 状态
-(void)setLockState:(KDSLockState) state {
    if (self.state != state) {
        self.state = state;
    }
}

/// 获取第一页的开锁记录
-(void)getUnlockRecord {
    
    NSDateFormatter *dateFmt = [[NSDateFormatter alloc] init];
    dateFmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    [[KDSHttpManager sharedManager] getWifiLockBindedDeviceOperationWithWifiSN:self.wifiDevice.wifiSN index:1 StartTime:1 EndTime:1 MarkIndex:1 success:^(NSArray<KDSWifiLockOperation *> * _Nonnull operations) {
        NSMutableArray <KDSWifiLockOperation *>*unlockRecordArr = [[NSMutableArray alloc] init];
        
           for (KDSWifiLockOperation * operation in operations)
           {
               operation.date = [dateFmt stringFromDate:[NSDate dateWithTimeIntervalSince1970:operation.time]];
               [unlockRecordArr insertObject:operation atIndex:[operations indexOfObject:operation]];
           }
        
        
        PLPDevice *device = (PLPDevice *)[[PLPDeviceManager sharedInstance] findDeviceWithDeviceId:self.wifiDevice.wifiSN];
        
        // todo，记录类型很多，优化只保存提后一次开锁记录

        [device setLastUnlockRecord:unlockRecordArr.firstObject];
        
        //发出记录更新通知
        [PLPDeviceManager postNotificationType:PLPDeviceNotificationTypeUnlockRecord device:device];

    } error:^(NSError * _Nonnull error) {
         
    } failure:^(NSError * _Nonnull error) {
         
    }];
}

/// 获取开锁次数
-(void)getUnlockTimes {
    [[KDSHttpManager sharedManager] getWifiLockBindedDeviceOperationCountWithUid:[KDSUserManager sharedManager].user.uid wifiSN:self.wifiDevice.wifiSN index:1 success:^(int count) {
        
    } error:nil failure:nil];
}


@end
