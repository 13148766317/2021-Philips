//
//  PLPDeviceManager+DemoData.m
//  Pages
//
//  Created by Apple on 2021/5/19.
//

#import "PLPDeviceManager+DemoData.h"
#import "PLPDevice.h"
@implementation PLPDeviceManager (DemoData)
//演示数据
+(NSArray <id<PLPDeviceProtocol>>*) demoDevices {
    return [PLPDevice demoDevices];
}
@end
