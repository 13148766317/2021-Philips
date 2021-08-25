//
//  PLPDeviceManager+Notification.m
//  2021-Philips
//
//  Created by Apple on 2021/6/7.
//  Copyright © 2021 com.Kaadas. All rights reserved.
//

#import "PLPDeviceManager+Notification.h"
#import "KDSLock+DeviceManager.h"
#import "KDSFTIndicator.h"
#import "PLPDeviceNotification.h"

#define kParamWifiLockDeviceId    @"wfId"
#define kParamEventType           @"eventType"
#define kParamEventSource           @"eventSource"
#define kParamEventTypeAction           @"action"
#define kParamEventTypeRecord                @"record"
#define kParamEventCode            @"eventCode"
#define kParamEventParams          @"eventparams"
@implementation PLPDeviceManager (Notification)
/// 监听设备管理事件，如添加/删除（分享）
-(void) addObserverDeviceManagerEvent {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(processAddDevice:) name:KDSLockHasBeenAddedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(processRemoveDevice:) name:KDSLockHasBeenDeletedNotification object:nil];
}

/// 删除监听设备管理事件
-(void) removeObserverDeviceManagerEvent {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KDSLockHasBeenAddedNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KDSLockHasBeenDeletedNotification object:nil];
}

/// 监听Mqtt事件通知
-(void) addObserverMqttEvent {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(processMqttEvent:) name:KDSMQTTEventNotification object:nil];
}

/// 删除Mqtt事件通知监听
-(void) removeObserverMqttEvent {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KDSMQTTEventNotification object:nil];
}

/// 处理Mqtt事件
/// @param notification 通知
-(void) processMqttEvent:(NSNotification *) notification {
    MQTTSubEvent event = notification.userInfo[MQTTEventKey];
    
    NSArray *wifiLockEvent = @[
        MQTTSubEventWifiUnlock,
        MQTTSubEventWifiLock,
        MQTTSubEventWifiLockTongueSticksOut,
        MQTTSubEventWifiLockStateChanged,
        MQTTSubEventLockInf,
        MQTTSubEventLockMultiInfo
    ];
    //wifi锁事件
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF = %@",event];
    if ([wifiLockEvent filteredArrayUsingPredicate:predicate]) {
        [self processWiFiLockMqttEvent:notification];
    }
    //晾衣机事件
    //其它

}


/// 只处理WiFi锁相关事件
/// @param notification 通知
-(void) processWiFiLockMqttEvent:(NSNotification *) notification {
    
    PLPDeviceNotificationType notificationType;
    MQTTSubEvent event = notification.userInfo[MQTTEventKey];
    NSDictionary *param = notification.userInfo[MQTTEventParamKey];
    
    id <PLPDeviceProtocol> device = [self findDeviceWithDeviceId:param[kParamWifiLockDeviceId]];
    if (!device) {
        KDSLog(@"找不到设备");
        return;
    }
    if ([device plpOldDeviceType] != PLPOldDeviceTypeWifiLockModel) {
        KDSLog(@"不是WiFi锁");
        return;
    }
    KDSLock *lock = [device plpLockWithOldDevice];
    if (!lock) {
        KDSLog(@"没有lock实例");
        return;
    }
    
   if ([event isEqualToString:MQTTSubEventWifiUnlock]){
       [lock setLockState:KDSLockStateUnlocked];
        [lock getUnlockRecord];
        [lock getUnlockTimes];
       int eventType = [param[kParamEventType] intValue];
       int eventSource = [param[kParamEventSource] intValue];
        if (eventType== 2)
        {
            //指纹、卡片开锁不区分是否是胁迫
            [KDSFTIndicator showNotificationWithTitle:Localized(@"Be careful") message:[NSString stringWithFormat:Localized(@"theLock%@UnlckWithMenace%@"), lock.wifiDevice.lockNickname ?: lock.wifiDevice.wifiSN, Localized((eventSource==0 ? @"password" : (eventSource==3 ? @"card"/*@"menaceCard"*/ : @"fingerprint"/*@"menaceFingerprint"*/)))] tapHandler:^{
            }];
        }
       
       notificationType = PLPDeviceNotificationTypeWiFiLockState;
    }
    else if ([event isEqualToString:MQTTSubEventWifiLock])
    {
        [lock setLockState:KDSLockStateClosed];
        notificationType = PLPDeviceNotificationTypeWiFiLockState;
    }else if ([event isEqualToString:MQTTSubEventWifiLockTongueSticksOut])
    {
        [lock setLockState:KDSLockSpittingState];
        notificationType = PLPDeviceNotificationTypeWiFiLockState;
    }else if ([event isEqualToString:MQTTSubEventWifiLockStateChanged]){
        //todo 细化通知类型
        if (lock.state == KDSLockStateUnlocked) {
            return;
        }
        //action事件
        NSString * eventtype = param[kParamEventType];
        if ([eventtype isEqualToString:kParamEventTypeRecord]) {
            ///WIFI锁操作实时上报
            NSNumber *eventCode = param[kParamEventCode];
            if (eventCode.intValue == 1) {
                //自动模式
                lock.wifiDevice.amMode = [NSString stringWithFormat:@"%d",0];
            }else if (eventCode.intValue == 2){
                //手动模式
                lock.wifiDevice.amMode = [NSString stringWithFormat:@"%d",1];
            }else if (eventCode.intValue == 3){
                //通用模式
                lock.wifiDevice.safeMode = [NSString stringWithFormat:@"%d",0];
            }else if (eventCode.intValue == 4){
                //安全模式
                lock.wifiDevice.safeMode = [NSString stringWithFormat:@"%d",1];
            }else if (eventCode.intValue == 5){
                //反锁模式
                lock.wifiDevice.operatingMode = [NSString stringWithFormat:@"%d",1];
            }else if (eventCode.intValue == 6){
                //布防模式
                lock.wifiDevice.defences = [NSString stringWithFormat:@"%d",1];
            }else if (eventCode.intValue == 7){
                //节能模式
                lock.wifiDevice.powerSave = [NSString stringWithFormat:@"%d",1];
            }
        }else if ([eventtype isEqualToString:kParamEventTypeAction]){
            ///WIFI锁开关推送
            lock.wifiDevice.defences = param[@"defences"];
            lock.wifiDevice.operatingMode = param[@"operatingMode"];
            lock.wifiDevice.safeMode = param[@"safeMode"];
            lock.wifiDevice.defences = param[@"defences"];
            lock.wifiDevice.volume = param[@"volume"];
            lock.wifiDevice.language = param[@"language"];
            lock.wifiDevice.faceStatus = param[@"faceStatus"];
            lock.wifiDevice.powerSave = param[@"powerSave"];
        }
        
        //todo 可能不同的产品不一样
        
        ///目前wifi锁的模式：开锁状态>布防>反锁>安全>面容>节能>锁舌伸出
        if (lock.wifiDevice.powerSave.intValue == 1) {
            [lock setLockState:KDSLockStateEnergy];
        }
        if (lock.wifiDevice.faceStatus.intValue == 1) {
            [lock setLockState:KDSLockStateFaceTurnedOff];
        }
        if (lock.wifiDevice.safeMode.intValue == 1) {
            [lock setLockState:KDSLockStateSecurityMode];
        }
        if (lock.wifiDevice.operatingMode.intValue == 1) {
            [lock setLockState:KDSLockStateLockInside];
        }
        if (lock.wifiDevice.defences.intValue == 1) {
            [lock setLockState:KDSLockStateDefence];
        }
        if (lock.wifiDevice.defences.intValue ==0 && lock.wifiDevice.operatingMode.intValue ==0 && lock.wifiDevice.safeMode.intValue == 0 && lock.wifiDevice.powerSave.intValue == 0 && lock.wifiDevice.faceStatus.intValue == 0) {//正常状态
            [lock setLockState:KDSLockStateOnline];
        }
                
    }else if ([event isEqualToString:MQTTSubEventLockInf]) {
        
        NSNumber *power;
        power = param[kParamEventParams][@"power"];
        lock.power = [power intValue];
        //todo 更新其它信息
        notificationType = PLPDeviceNotificationTypePower;

    }else if ([event isEqualToString:MQTTSubEventLockMultiInfo]) {
        NSNumber *power;
        power = param[kParamEventParams][@"lockInfo"][@"power"];
        lock.power = [power intValue];
        //todo 更新其它信息
        notificationType = PLPDeviceNotificationTypePower;

    }
    
    //发送通知
    if (notificationType != PLPDeviceNotificationTypeNone) {
        [PLPDeviceManager postNotificationType:notificationType device:device];
    }

}


/// 查找设备id对应的设备
/// @param deviceId 设备id
-(id<PLPDeviceProtocol>) findDeviceWithDeviceId:(NSString *) deviceId {
    __block id<PLPDeviceProtocol> result = nil;
    if (deviceId) {
        [self.allDevices enumerateObjectsUsingBlock:^(id<PLPDeviceProtocol>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([[obj plpDeviceId] isEqualToString:deviceId]) {
                result = obj;
                *stop = YES;
            }
        }];
    }
    
    return result;
}

-(void) processAddDevice:(NSNotification *) notification {
    //todo 优化，重新获取设备;目前是PLPCompatibleController在处理
}
-(void) processRemoveDevice:(NSNotification *) notification {
    //todo 优化，重新获取设备;目前是PLPCompatibleController在处理
}
/// 发送通知
/// @param notificationType 通知类型
/// @param device 通知相关设备
+(void) postNotificationType:(PLPDeviceNotificationType) notificationType device:(nullable id<PLPDeviceProtocol>) device {
    
    PLPDeviceNotification *deviceNotification  = [PLPDeviceNotification deviceNotificationWithDevice:device notificationType:notificationType];
    NSNotification *notification = [NSNotification notificationWithName:PLPDeviceManagerNotification object:deviceNotification];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}
@end
