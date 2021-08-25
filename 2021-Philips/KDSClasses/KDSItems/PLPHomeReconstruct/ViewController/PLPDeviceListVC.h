//
//  PLPDeviceListVC.h
//  Pages
//
//  Created by Apple on 2021/5/18.
//

#import <UIKit/UIKit.h>
#import "PLPDeviceTableViewDataSource.h"
NS_ASSUME_NONNULL_BEGIN

@interface PLPDeviceListVC : UIViewController
@property(nonatomic, weak) IBOutlet UITableView *tableView;
@property(nonatomic, strong) PLPDeviceTableViewDataSource *deviceListDataSource;
@end

NS_ASSUME_NONNULL_END
