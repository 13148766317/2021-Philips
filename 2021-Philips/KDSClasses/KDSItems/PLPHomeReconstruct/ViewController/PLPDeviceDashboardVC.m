//
//  PLPDeviceDashboardVC.m
//  Pages
//
//  Created by Apple on 2021/5/18.
//

#import "PLPDeviceDashboardVC.h"
#import "PLPDeviceVC+DeviceView.h"
#import "KDSLock+DeviceManager.h"
#import "PLPDevice+WiFiSmartLockDeviceViewDataSource.h"
#import "PLPDeviceBaseView+WiFiSmartLock.h"
#import "PLPDevice+Compatible.h"

@interface PLPDeviceDashboardVC ()
@property(nonatomic, assign) BOOL isAdmin;
@end

@implementation PLPDeviceDashboardVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.productViewType = PLPProductViewTypeDashboard;
    [self addDeviceView];
    //self.title = [self.device plpDeviceViewName];
    self.navigationTitleLabel.text = [self.device plpDeviceViewName];

    if ([self.device plpOldDeviceType] == PLPOldDeviceTypeWifiLockModel) {

        //右上角设置按钮
        [self setRightButton];
        KDSWifiLockModel *wifiLockModel = (KDSWifiLockModel *)[self.device plpOldDevice];
        self.isAdmin = [wifiLockModel.isAdmin intValue];
        if (self.isAdmin) {//管理员权限
            [self.rightButton setImage:[UIImage imageNamed:@"philips_mine_icon_setting"] forState:UIControlStateNormal];
        }else{//被分享用户权限
            [self.rightButton setImage:[UIImage imageNamed:@"philips_equipment_icon_delete"] forState:UIControlStateNormal];
        }
    }
    
    self.deviceBaseView.contentView.backgroundColor = [UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1.0];
    self.deviceBaseView.actionDelegate = self.actionDelegateController;

    
    self.deviceNotificationController.observerDeviceId = [self.device plpDeviceId];

    __weak __typeof(self)weakSelf = self;
    self.deviceNotificationController.nameNotificationBlock = ^(NSNotification * _Nonnull notification, PLPDeviceNotification * _Nonnull deviceNotification) {
        [weakSelf.deviceBaseView updateUI];
        weakSelf.navigationTitleLabel.text = [weakSelf.device plpDeviceViewName];

    };
    self.deviceNotificationController.powerNotificationBlock = ^(NSNotification * _Nonnull notification, PLPDeviceNotification * _Nonnull deviceNotification) {
        [weakSelf.deviceBaseView updateUI];
    };
    
    self.deviceNotificationController.wiFiLockStateNotificationBlock = ^(NSNotification * _Nonnull notification, PLPDeviceNotification * _Nonnull deviceNotification) {
        [weakSelf.deviceBaseView updateUI];
    };
    self.deviceNotificationController.unlockRecordNotificationBlock = ^(NSNotification * _Nonnull notification, PLPDeviceNotification * _Nonnull deviceNotification) {
        [weakSelf.deviceBaseView updateUI];
    };
    
    if ([self.device plpOldDeviceType] == PLPOldDeviceTypeWifiLockModel) {
        PLPDevice *device = (PLPDevice *)self.device;
        if (![device plpWiFiSmartLockDeviceLastUnlockRecord]) {
            KDSLock *lock = [self.device plpLockWithOldDevice];
            [lock getUnlockRecord];
        }
    }
  
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.deviceNotificationController addObserverNotification];
}

-(void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.deviceNotificationController removeObserverNotification];
}

//-(void) viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    if (self.navigationController && self.navigationController.navigationBarHidden) {
//        [self.navigationController setNavigationBarHidden:NO];
//    }
//    if (self.navigationController.tabBarController) {
//        [self.navigationController.tabBarController.tabBar setHidden:YES];
//    }
//
//}
//
//-(void) viewWillDisappear:(BOOL)animated {
//    [super viewWillDisappear:animated];
//
//    if (self.navigationController.tabBarController) {
//
//        if ([self.navigationController.viewControllers indexOfObject:self] == NSNotFound) {
//            [self.navigationController.tabBarController.tabBar setHidden:NO];
//        }
//    }
//
//}

#pragma mark - 右上角 设置点击事件
-(void) navRightClick{
    
    if ([self.device plpOldDeviceType] == PLPOldDeviceTypeWifiLockModel) {
        if (self.isAdmin) {
            [self.actionDelegateController deviceView:self.deviceBaseView actionType:PLPDeviceUIActionTypeSetting];
        }else {
            [self.actionDelegateController deviceView:self.deviceBaseView actionType:PLPDeviceUIActionTypeShareDelete];
        }
    }
}
@end
