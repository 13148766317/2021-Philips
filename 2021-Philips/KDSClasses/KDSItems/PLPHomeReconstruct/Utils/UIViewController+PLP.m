//
//  UIViewController+PLP.m
//  2021-Philips
//
//  Created by Apple on 2021/5/28.
//  Copyright © 2021 com.Kaadas. All rights reserved.
//

#import "UIViewController+PLP.h"
#import "PLPAddDeviceVC.h"
#import "PLPNewAddDeviceVC.h"
//添加调试弹窗的界面
#import "KDSAddBleAndWiFiLockSuccessVC.h"
#import "KDSAddWiFiLockSuccessVC.h"
#import "KDSBleAndWiFiForgetAdminPwdVC.h"


NSString *const PLPStoryboardName = @"PLPMain";
NSString *const PLPStoryboardHomeDevicesIdentifier = @"PLPHomeDevicesVC";

@implementation UIViewController (PLP)
//实例故事版视图控制器
+(UIViewController *) instantiateViewControllerWithStoryboardName:(NSString *) storyboardName identifier:(NSString *) identifier {
    if (storyboardName && identifier) {
        return [[UIStoryboard storyboardWithName:storyboardName  bundle:nil] instantiateViewControllerWithIdentifier:identifier];
    }else {
        return nil;
    }
}
//首页设备控制器
+(UIViewController *) homeDevicesVC {
    return [UIViewController instantiateViewControllerWithStoryboardName:PLPStoryboardName identifier:PLPStoryboardHomeDevicesIdentifier];
}

//显示添加设备控制器
+(void) pushAddDeviceWithNavVC:(UINavigationController *) navVc {
    
    PLPNewAddDeviceVC *vc =  [PLPNewAddDeviceVC  new];
    vc.isOpenInterestRect = YES;
    vc.isVideoZoom = YES;
    vc.fromWhereVC = @"AddDeviceVC";//添加设备
    vc.hidesBottomBarWhenPushed = YES;
    [navVc pushViewController:vc animated:YES];
}

@end
