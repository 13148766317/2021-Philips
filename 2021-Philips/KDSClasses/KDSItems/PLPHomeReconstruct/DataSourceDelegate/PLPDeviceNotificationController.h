//
//  PLPDeviceNotificationController.h
//  2021-Philips
//
//  Created by Apple on 2021/6/7.
//  Copyright © 2021 com.Kaadas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PLPDeviceNotification.h"
NS_ASSUME_NONNULL_BEGIN

@interface PLPDeviceNotificationController : NSObject


/// 设备id，用于过滤对应的设备消息
@property(nonatomic, strong) NSString *observerDeviceId;

/// 设备通知回调
@property(nonatomic, copy) void (^notificationBlock)(NSNotification * notification, PLPDeviceNotificationType notificationType, PLPDeviceNotification *deviceNotification);


/// 设备列表变化通知回调
@property(nonatomic, copy) void (^deviceListChangeNotificationBlock)(NSNotification * notification, PLPDeviceNotification *deviceNotification);

/// 添加设备通知回调
@property(nonatomic, copy) void (^addDeviceNotificationBlock)(NSNotification * notification, PLPDeviceNotification *deviceNotification);

/// 删除设备通知回调
@property(nonatomic, copy) void (^removeDeviceNotificationBlock)(NSNotification * notification, PLPDeviceNotification *deviceNotification);

/// 电量通知回调
@property(nonatomic, copy) void (^powerNotificationBlock)(NSNotification * notification, PLPDeviceNotification *deviceNotification);

/// 设备名称变化通知回调
@property(nonatomic, copy) void (^nameNotificationBlock)(NSNotification * notification, PLPDeviceNotification *deviceNotification);

/// WiFi锁状态通知回调
@property(nonatomic, copy) void (^wiFiLockStateNotificationBlock)(NSNotification * notification, PLPDeviceNotification *deviceNotification);

/// 开锁记录获取完成通知回调
@property(nonatomic, copy) void (^unlockRecordNotificationBlock)(NSNotification * notification, PLPDeviceNotification *deviceNotification);


/// 监听设备通知，必需调用才会通知
-(void) addObserverNotification;
/// 删除监听设备通知
-(void) removeObserverNotification;
@end

NS_ASSUME_NONNULL_END
