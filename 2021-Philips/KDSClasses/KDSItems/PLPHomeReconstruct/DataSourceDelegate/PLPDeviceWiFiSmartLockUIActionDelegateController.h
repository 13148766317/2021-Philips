//
//  PLPDeviceUIController.h
//  Pages
//
//  Created by Apple on 2021/5/25.
//

#import <Foundation/Foundation.h>
#import "PLPDeviceBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface PLPDeviceWiFiSmartLockUIActionDelegateController : NSObject <PLPDeviceViewActionDelegateProtocol>

//视图控制器，用于弹出操作
@property(nonatomic, weak) UIViewController *parentVC;

/// 显示设备交互对应视图控制器
/// @param device 设备
/// @param actionType 交互类型
/// @param navVc 导航控制器
+(UIViewController * ) pushDevice:(id<PLPDeviceProtocol>) device actionType:(PLPDeviceUIActionType) actionType navVc:(UINavigationController *) navVc;
@end

NS_ASSUME_NONNULL_END
