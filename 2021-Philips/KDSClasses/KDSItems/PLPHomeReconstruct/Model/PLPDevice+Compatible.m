//
//  PLPDevice+Compatible.m
//  2021-Philips
//
//  Created by Apple on 2021/5/28.
//  Copyright © 2021 com.Kaadas. All rights reserved.
//

#import "PLPDevice+Compatible.h"
#import "KDSDBManager.h"

@implementation PLPDevice (Compatible)
+(PLPOldDeviceType) compareDeviceType:(id) device {
    PLPOldDeviceType deviceType = PLPOldDeviceTypeNone;
    id oldDevice = device;
    
    if(oldDevice){
        if ([oldDevice isKindOfClass:[KDSWifiLockModel class]]) {
            deviceType = PLPOldDeviceTypeWifiLockModel;
        }else if ([oldDevice isKindOfClass:[MyDevice class]]) {
            deviceType = PLPOldDeviceTypeMyDevice;
        }else if ([oldDevice isKindOfClass:[KDSDeviceHangerModel class]]) {
            deviceType = PLPOldDeviceTypeHanger;
        }else if ([oldDevice isKindOfClass:[GatewayDeviceModel  class]]) {
            deviceType = PLPOldDeviceTypeGateway;
        }else if ([oldDevice isKindOfClass:[KDSDevSwithModel  class]]) {
            deviceType = PLPOldDeviceTypeSwith;
        }else if ([oldDevice isKindOfClass:[KDSGW  class]]) {
            deviceType = PLPOldDeviceTypeGw;
        }
        
    }
    
    return deviceType;
}

//原设备 to Lock
+(KDSLock *) oldDeviceToLock:(id) oldDevice {
    KDSLock *lock = [[KDSLock alloc] init];
    PLPOldDeviceType oldDeviceType = [PLPDevice compareDeviceType:oldDevice];
    switch (oldDeviceType) {
  
        case PLPOldDeviceTypeNone:
            
            break;
        case PLPOldDeviceTypeMyDevice: {
            lock.device = oldDevice;
            MyDevice *tempDevice = oldDevice;
            lock.power = [[KDSDBManager sharedManager] queryPowerWithBleName:tempDevice.lockName];
        }
            break;
        case PLPOldDeviceTypeHanger:
            lock.hangerModel = oldDevice;
            break;
        case PLPOldDeviceTypeWifiLockModel: {
            lock.wifiDevice = oldDevice;
            KDSWifiLockModel *wifiLockModel = (KDSWifiLockModel *) oldDevice;
            lock.power = [[KDSDBManager sharedManager] queryPowerWithBleName:wifiLockModel.wifiSN];
        }
            break;
        case PLPOldDeviceTypeGateway:
            lock.gwDevice = oldDevice;
            break;
        case PLPOldDeviceTypeSwith:
            lock.swithDevModel = oldDevice;
            break;
        case PLPOldDeviceTypeGw:
            lock.gw = oldDevice;
            break;
    }
    return lock;
}
//获取原设备名称
-(NSString *) getOldDeviceName {
    return [[PLPDevice oldDeviceToLock:self.oldDevice] name];
}
//获取原设备id
-(NSString *) getOldDeviceId {
    NSString *result = nil;
    PLPOldDeviceType oldDeviceType = [self plpOldDeviceType];
    switch (oldDeviceType) {
  
        case PLPOldDeviceTypeNone:
            
            break;
        case PLPOldDeviceTypeMyDevice: {
            result = [(MyDevice *)self.oldDevice _id];
        }
            break;
        case PLPOldDeviceTypeHanger:
            result = [(KDSDeviceHangerModel *)self.oldDevice wifiSN];
            break;
        case PLPOldDeviceTypeWifiLockModel: {
            result = [(KDSWifiLockModel *)self.oldDevice wifiSN];
        }
            break;
        case PLPOldDeviceTypeGateway:
            result = [(GatewayDeviceModel *)self.oldDevice deviceId];
            break;
        case PLPOldDeviceTypeSwith:
            result = [(KDSDevSwithModel *)self.oldDevice devId];
            break;
        case PLPOldDeviceTypeGw:
            //result = [(KDSGW *)self.oldDevice wifiSN];
            break;
    }
    return result;
}

/// 用户权限
-(BOOL) isAdmin {
    if ([self plpOldDeviceType] == PLPOldDeviceTypeWifiLockModel) {
        KDSWifiLockModel *device = [self plpOldDevice];
        if (device && [device.isAdmin integerValue] == 1) {
            return YES;
        }else {
            return NO;
        }
    }else {
        return YES;
    }
}

/// 获取wifi sn
-(NSString *) getWiFiSN {
    if ([self plpOldDeviceType] == PLPOldDeviceTypeWifiLockModel) {
        KDSWifiLockModel *device = [self plpOldDevice];
        return device.wifiSN;
    }else {
        return nil;
    }
}
@end
