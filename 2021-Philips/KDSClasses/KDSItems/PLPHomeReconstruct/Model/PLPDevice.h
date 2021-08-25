//
//  PLPDevice.h
//  Pages
//
//  Created by Apple on 2021/5/18.
//

#import <Foundation/Foundation.h>
#import "PLPDeviceProtocol.h"
#import "PLPDeviceViewDataSourceProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface PLPDevice : NSObject <PLPDeviceProtocol>
//原有设备
@property(nonatomic, strong) id oldDevice;
//原有设备类型
@property(nonatomic, assign) PLPOldDeviceType oldDeviceType;
//设备名称
@property(nonatomic, strong) NSString *name;

//产品id
@property(nonatomic, strong) NSString *pid;
//设备id
@property(nonatomic, assign) NSString *deviceId;
+(NSArray<PLPDevice *> *) demoDevices;
@end

NS_ASSUME_NONNULL_END
