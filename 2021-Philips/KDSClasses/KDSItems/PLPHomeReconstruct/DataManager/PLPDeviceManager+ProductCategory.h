//
//  PLPDeviceManager+ProductCategory.h
//  Pages
//
//  Created by Apple on 2021/5/19.
//

#import "PLPDeviceManager.h"
#import "PLPProductInfoProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface PLPDeviceManager (ProductCategory)
//产品分类设备
-(NSArray <id<PLPDeviceProtocol,PLPDeviceViewDataSourceProtocol>> *) devicesWithCategory:(PLPProductCategory) category;

//产品分类，提取所有设备类别，不包括全部分类
-(NSArray<NSNumber *> *) categorysFromDevices;

@end

NS_ASSUME_NONNULL_END
