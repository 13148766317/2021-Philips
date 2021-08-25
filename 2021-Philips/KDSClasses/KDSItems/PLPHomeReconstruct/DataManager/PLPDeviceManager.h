//
//  PLPDeviceManager.h
//  Pages
//
//  Created by Apple on 2021/5/18.
//

#import <Foundation/Foundation.h>
#import "PLPDeviceProtocol.h"

NS_ASSUME_NONNULL_BEGIN

//设备管理通知
extern NSString *const PLPDeviceManagerNotification;

@interface PLPDeviceManager : NSObject

+ (instancetype)sharedInstance;

//所有设备
-(NSArray <id<PLPDeviceProtocol>>*) allDevices;


@end

NS_ASSUME_NONNULL_END
