//
//  PLPDeviceListVC.m
//  Pages
//
//  Created by Apple on 2021/5/18.
//

#import "PLPDeviceListVC.h"
#import "PLPDeviceDashboardVC.h"
#import "PLPDeviceWiFiSmartLockUIActionDelegateController.h"
@interface PLPDeviceListVC ()

@end

@implementation PLPDeviceListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //self.tableView.dataSource = self.deviceListDataSource;
    //self.tableView.delegate = self.deviceListDataSource;
    self.view.backgroundColor = [UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1.0];

    self.tableView.tableFooterView = [UIView new];
    self.tableView.backgroundColor = [UIColor clearColor];
    
    if (self.tabBarController) {
        PLPCategoryDeviceDataSource *deviceDataSource =[[PLPCategoryDeviceDataSource alloc] init];
        deviceDataSource.currentCategory = PLPProductCategoryAll;
        self.deviceListDataSource.deviceDataSource = deviceDataSource;
        self.title = NSLocalizedString(@"列表", nil);
    }
    self.deviceListDataSource.tableView = self.tableView;
    __weak __typeof(self)weakSelf = self;
    self.deviceListDataSource.didSelectRowBlock = ^(id<PLPDeviceProtocol>  _Nonnull device) {
        //todo 优化，不同类型的设备不一样
        
        [PLPDeviceWiFiSmartLockUIActionDelegateController pushDevice:device actionType:PLPDeviceUIActionTypeMore navVc:weakSelf.navigationController];
    };
}
- (PLPDeviceTableViewDataSource *)deviceListDataSource {
    if (!_deviceListDataSource) {
        self.deviceListDataSource = [[PLPDeviceTableViewDataSource alloc] init];
        
    }
    return _deviceListDataSource;
}

@end
