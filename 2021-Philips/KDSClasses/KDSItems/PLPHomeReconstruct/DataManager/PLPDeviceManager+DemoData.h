//
//  PLPDeviceManager+DemoData.h
//  Pages
//
//  Created by Apple on 2021/5/19.
//

#import "PLPDeviceManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface PLPDeviceManager (DemoData)
//演示数据
+(NSArray <id<PLPDeviceProtocol>>*) demoDevices;
@end

NS_ASSUME_NONNULL_END
