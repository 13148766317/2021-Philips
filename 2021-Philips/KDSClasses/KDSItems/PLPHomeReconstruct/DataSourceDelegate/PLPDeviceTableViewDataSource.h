//
//  PLPDeviceListDataSource.h
//  Pages
//  设备列表tableview数据源与委托
//  Created by Apple on 2021/5/18.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PLPCategoryDeviceDataSource.h"

NS_ASSUME_NONNULL_BEGIN

@interface PLPDeviceTableViewDataSource : NSObject <UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, weak) UITableView *tableView;
//选择设备回调
@property(nonatomic, copy) void (^didSelectRowBlock)(id<PLPDeviceProtocol> device);
@property(nonatomic, strong) PLPCategoryDeviceDataSource *deviceDataSource;
- (instancetype)initWithTableView:(UITableView *) tableView;
-(void) reloadData;
@end

NS_ASSUME_NONNULL_END
