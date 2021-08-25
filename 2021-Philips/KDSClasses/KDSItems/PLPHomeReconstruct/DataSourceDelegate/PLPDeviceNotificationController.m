//
//  PLPDeviceNotificationController.m
//  2021-Philips
//
//  Created by Apple on 2021/6/7.
//  Copyright © 2021 com.Kaadas. All rights reserved.
//

#import "PLPDeviceNotificationController.h"
#import "PLPDeviceManager.h"
@implementation PLPDeviceNotificationController

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

/// 监听设备通知
-(void) addObserverNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(processNotification:) name:PLPDeviceManagerNotification object:nil];
}
/// 删除监听设备通知
-(void) removeObserverNotification {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


/// 处理设备通知
/// @param notification 通知
-(void) processNotification:(NSNotification *) notification {
    PLPDeviceNotification *deviceNotification = notification.object;
    PLPDeviceNotificationType notificationType = deviceNotification.notificationType;
    
    
    
    if (self.notificationBlock) {
        self.notificationBlock(notification, notificationType, deviceNotification);
    }
    
    //比较设备ID，如不一致，不进行回调调用
    BOOL isObserverDeviceId = YES;
    if (self.observerDeviceId) {
        NSString *deviceId = [[deviceNotification device] plpDeviceId];
        if (![self.observerDeviceId isEqualToString:deviceId]) {
            isObserverDeviceId = NO;
        }
    }
    
  
    
    switch (notificationType) {
        case PLPDeviceNotificationTypeDeviceListChange: {
            if (self.deviceListChangeNotificationBlock) {
                self.deviceListChangeNotificationBlock(notification, deviceNotification);
            }
        }
            break;
        case PLPDeviceNotificationTypeAddDevice:{
            if (self.addDeviceNotificationBlock) {
                self.addDeviceNotificationBlock(notification, deviceNotification);
            }
        }
            break;
        case PLPDeviceNotificationTypeRemoveDevice:
            if (self.removeDeviceNotificationBlock) {
                self.removeDeviceNotificationBlock(notification, deviceNotification);
            }
            break;
        case PLPDeviceNotificationTypePower:
            if (self.powerNotificationBlock && isObserverDeviceId) {
                self.powerNotificationBlock(notification, deviceNotification);
            }
            break;
        case PLPDeviceNotificationTypeWiFiLockState:
            if (self.wiFiLockStateNotificationBlock && isObserverDeviceId) {
                self.wiFiLockStateNotificationBlock(notification, deviceNotification);
            }
            break;
        case PLPDeviceNotificationTypeName:
            if (self.nameNotificationBlock && isObserverDeviceId) {
                self.nameNotificationBlock(notification, deviceNotification);
            }
            break;
        case PLPDeviceNotificationTypeUnlockRecord:
            if (self.unlockRecordNotificationBlock && isObserverDeviceId) {
                self.unlockRecordNotificationBlock(notification, deviceNotification);
            }
            break;
        default:
            break;
    }
    
    
    
}
@end
