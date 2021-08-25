//
//  PLPDeviceVC.m
//  Pages
//
//  Created by Apple on 2021/5/18.
//

#import "PLPDeviceVC.h"

@interface PLPDeviceVC ()

@end

@implementation PLPDeviceVC

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.view.backgroundColor = [UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1.0];
}

- (void)setDevice:(id<PLPDeviceProtocol>)device  {
    _device = device;
    if (device == nil) {
        NSLog(@"error");
    }
}

- (PLPDeviceWiFiSmartLockUIActionDelegateController *)actionDelegateController {
    if (!_actionDelegateController) {
        self.actionDelegateController = [[PLPDeviceWiFiSmartLockUIActionDelegateController alloc] init];
        _actionDelegateController.parentVC = self;
    }
    return _actionDelegateController;
}

- (PLPDeviceNotificationController *)deviceNotificationController {
    if (!_deviceNotificationController) {
        self.deviceNotificationController =[[PLPDeviceNotificationController alloc] init];
    }
    return _deviceNotificationController;
}
@end
