//
//  PLPDeviceCardVC.m
//  Pages
//
//  Created by Apple on 2021/5/21.
//

#import "PLPDeviceCardVC.h"

#import "PLPDeviceVC+DeviceView.h"
#import "PLPDeviceWiFiSmartLockUIActionDelegateController.h"
#import "PLPDeviceBaseView+WiFiSmartLock.h"
@interface PLPDeviceCardVC ()
@end

@implementation PLPDeviceCardVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.productViewType = PLPProductViewTypeCard;
    
    [self addDeviceView];
    
    self.deviceBaseView.actionDelegate = self.actionDelegateController;
    
    self.deviceBaseView.layer.cornerRadius = 10;
    self.deviceBaseView.layer.masksToBounds = YES;
    
    self.deviceNotificationController.observerDeviceId = [self.device plpDeviceId];
    
    __weak __typeof(self)weakSelf = self;
    self.deviceNotificationController.nameNotificationBlock = ^(NSNotification * _Nonnull notification, PLPDeviceNotification * _Nonnull deviceNotification) {
        [weakSelf.deviceBaseView updateUI];
    };
    self.deviceNotificationController.powerNotificationBlock = ^(NSNotification * _Nonnull notification, PLPDeviceNotification * _Nonnull deviceNotification) {
        [weakSelf.deviceBaseView updateUI];
    };
    self.deviceNotificationController.unlockRecordNotificationBlock = ^(NSNotification * _Nonnull notification, PLPDeviceNotification * _Nonnull deviceNotification) {
        [weakSelf.deviceBaseView updateLastUnlockRecordLabel];
    };
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.deviceNotificationController addObserverNotification];
}

-(void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.deviceNotificationController removeObserverNotification];
}

@end
