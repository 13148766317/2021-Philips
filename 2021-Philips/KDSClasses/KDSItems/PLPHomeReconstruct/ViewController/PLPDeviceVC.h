//
//  PLPDeviceVC.h
//  Pages
//
//  Created by Apple on 2021/5/18.
//

#import <UIKit/UIKit.h>

#import "PLPDeviceVCProtocol.h"
#import "PLPDeviceBaseView.h"
#import "PLPDeviceWiFiSmartLockUIActionDelegateController.h"
#import "PLPDeviceNotificationController.h"
#import "KDSBaseViewController.h"
NS_ASSUME_NONNULL_BEGIN

@interface PLPDeviceVC : KDSBaseViewController <PLPDeviceVCProtocol>
//关联设备
@property(nonatomic, strong) id<PLPDeviceProtocol> device;
//产品设备视图类别
@property(nonatomic, assign) PLPProductViewType productViewType;
//设备视图
@property(nonatomic, strong) PLPDeviceBaseView *deviceBaseView;
//设备视图交互动作委托
@property(nonatomic, strong) PLPDeviceWiFiSmartLockUIActionDelegateController  *actionDelegateController;

/// 设备通知处理
@property(nonatomic, strong) PLPDeviceNotificationController *deviceNotificationController;
@end

NS_ASSUME_NONNULL_END
