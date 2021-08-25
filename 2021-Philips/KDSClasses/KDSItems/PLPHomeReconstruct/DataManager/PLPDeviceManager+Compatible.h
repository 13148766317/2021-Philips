//
//  PLPDeviceManager+Compatible.h
//  2021-Philips
//
//  Created by Apple on 2021/5/28.
//  Copyright © 2021 com.Kaadas. All rights reserved.
//

#import "PLPDeviceManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface PLPDeviceManager (Compatible)

//添加设备前删除已有设备
-(void) removeBeforeAddingDevices:(NSArray *) devices;

@end

NS_ASSUME_NONNULL_END
