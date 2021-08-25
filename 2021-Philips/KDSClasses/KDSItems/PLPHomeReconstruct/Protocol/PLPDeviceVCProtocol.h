//
//  PLPDeviceVCProtocol.h
//  Pages
//
//  Created by Apple on 2021/5/20.
//

#import <Foundation/Foundation.h>
#import "PLPDeviceProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@protocol PLPDeviceVCProtocol <NSObject>
//关联设备
@property(nonatomic, weak) id<PLPDeviceProtocol> device;

@end

NS_ASSUME_NONNULL_END
