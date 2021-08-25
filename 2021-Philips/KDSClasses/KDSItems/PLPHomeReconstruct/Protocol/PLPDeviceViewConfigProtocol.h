//
//  PLPDeviceViewConfigProtocol.h
//  Pages
//
//  Created by Apple on 2021/5/19.
//

#import <Foundation/Foundation.h>
#import "PLPDeviceProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@protocol PLPDeviceViewConfigProtocol <NSObject>
@required
//关联设备
@property(nonatomic, weak) id<PLPDeviceProtocol> device;
//产品视图类别
@property(nonatomic, assign) PLPProductViewType productViewType;
//初始配置
-(void) configure;
//根据设备信息与状态，更新View UI
-(void) updateUI;
@end

NS_ASSUME_NONNULL_END
