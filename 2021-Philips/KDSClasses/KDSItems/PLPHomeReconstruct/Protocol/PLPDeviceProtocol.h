//
//  PLPDeviceProtocol.h
//  Pages
//
//  Created by Apple on 2021/5/19.
//

#import <Foundation/Foundation.h>
#import "PLPProductInfoProtocol.h"
#import "PLPDeviceViewDataSourceProtocol.h"

NS_ASSUME_NONNULL_BEGIN

/// 设备协议
@protocol PLPDeviceProtocol <NSObject,PLPDeviceViewDataSourceProtocol>

//设备id
-(NSString *) plpDeviceId;
//产品
-(id<PLPProductInfoProtocol>) plpProduct;
//产品分类，待定
-(PLPProductCategory) plpProductCategory;
//原有设备
-(id) plpOldDevice;
//原有设备Lock类型
-(id) plpLockWithOldDevice;
//原有设备类型
-(PLPOldDeviceType) plpOldDeviceType;
//产品显示顺序
-(NSUInteger) plpSort;


@end

NS_ASSUME_NONNULL_END
