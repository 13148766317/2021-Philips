//
//  PLPDeviceManager+Notification.h
//  2021-Philips
//
//  Created by Apple on 2021/6/7.
//  Copyright © 2021 com.Kaadas. All rights reserved.
//

#import "PLPDeviceManager.h"




NS_ASSUME_NONNULL_BEGIN

@interface PLPDeviceManager (Notification)

/// 监听设备管理事件，如添加/删除
-(void) addObserverDeviceManagerEvent;

/// 删除监听设备管理事件
-(void) removeObserverDeviceManagerEvent;

/// 监听Mqtt事件通知
-(void) addObserverMqttEvent;

/// 删除Mqtt事件通知监听
-(void) removeObserverMqttEvent;

/// 查找设备id对应的设备
/// @param deviceId 设备id
-(id<PLPDeviceProtocol>) findDeviceWithDeviceId:(NSString *) deviceId;

/// 发送通知
/// @param notificationType 通知类型
/// @param device 通知相关设备
+(void) postNotificationType:(PLPDeviceNotificationType) notificationType device:(nullable id<PLPDeviceProtocol>) device;
@end

NS_ASSUME_NONNULL_END
