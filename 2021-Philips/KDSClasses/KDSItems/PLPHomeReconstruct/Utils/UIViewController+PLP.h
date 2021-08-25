//
//  UIViewController+PLP.h
//  2021-Philips
//
//  Created by Apple on 2021/5/28.
//  Copyright © 2021 com.Kaadas. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PLPDeviceProtocol.h"
NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (PLP)
//实例故事版视图控制器
+(UIViewController *) instantiateViewControllerWithStoryboardName:(NSString *) storyboardName identifier:(NSString *) identifier;
//首页设备控制器
+(UIViewController *) homeDevicesVC;
//显示添加设备控制器
+(void) pushAddDeviceWithNavVC:(UINavigationController *) navVc;




@end

NS_ASSUME_NONNULL_END
