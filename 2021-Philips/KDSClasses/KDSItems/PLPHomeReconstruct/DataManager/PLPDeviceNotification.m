//
//  PLPDeviceNotification.m
//  2021-Philips
//
//  Created by Apple on 2021/6/7.
//  Copyright © 2021 com.Kaadas. All rights reserved.
//

#import "PLPDeviceNotification.h"

@implementation PLPDeviceNotification
/// 创建设备通知
/// @param device 设备
/// @param notificationType 通知类型
+(PLPDeviceNotification *) deviceNotificationWithDevice:(id<PLPDeviceProtocol>) device notificationType:(PLPDeviceNotificationType) notificationType {
    PLPDeviceNotification *notification = [[PLPDeviceNotification alloc] init];
    notification.device = device;
    notification.notificationType = notificationType;
    return notification;
}
@end
