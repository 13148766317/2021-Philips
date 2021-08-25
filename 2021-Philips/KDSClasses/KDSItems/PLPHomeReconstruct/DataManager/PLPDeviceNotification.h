//
//  PLPDeviceNotification.h
//  2021-Philips
//
//  Created by Apple on 2021/6/7.
//  Copyright © 2021 com.Kaadas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PLPDeviceProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface PLPDeviceNotification : NSObject
//设备通知类型
@property(nonatomic, assign) PLPDeviceNotificationType notificationType;
//设备
@property(nonatomic, strong, nullable) id<PLPDeviceProtocol> device;
//其它参数
@property(nonatomic, strong, nullable) id userInfo;

/// 创建设备通知
/// @param device 设备
/// @param notificationType 通知类型
+(PLPDeviceNotification *) deviceNotificationWithDevice:(id<PLPDeviceProtocol>) device notificationType:(PLPDeviceNotificationType) notificationType;
@end

NS_ASSUME_NONNULL_END
