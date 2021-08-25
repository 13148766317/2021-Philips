//
//  PLPDevice+Compatible.h
//  2021-Philips
//
//  Created by Apple on 2021/5/28.
//  Copyright © 2021 com.Kaadas. All rights reserved.
//

#import "PLPDevice.h"
#import "KDSLock.h"

NS_ASSUME_NONNULL_BEGIN

@interface PLPDevice (Compatible)


/// 获取设备类型
/// @param device 设备
+(PLPOldDeviceType) compareDeviceType:(id) device;
//原设备 to Lock
+(KDSLock *) oldDeviceToLock:(id) device;
//获取原设备名称
-(NSString *) getOldDeviceName;

///  获取原设备id
-(NSString *) getOldDeviceId;

/// 用户权限
-(BOOL) isAdmin;


/// 获取wifi sn 
-(NSString *) getWiFiSN;

@end

NS_ASSUME_NONNULL_END
