//
//  KDSChangeWifiLockWifiViewController.m
//  2021-Philips
//
//  Created by kaadas on 2021/1/29.
//  Copyright © 2021 com.Kaadas. All rights reserved.
//

#import "KDSChangeWifiLockWifiViewController.h"
#import "KDSLockMoreSettingCell.h"
#import "KDSConnectedReconnectVC.h"

#import "KDSAddVideoWifiLockStep3VC.h"

@interface KDSChangeWifiLockWifiViewController ()<UITableViewDataSource,UITableViewDelegate>
///表视图。
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray * titles;

@end

@implementation KDSChangeWifiLockWifiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationTitleLabel.text = Localized(@"DevicesDetailSetting_Change_WiFi");
   
    // 初始化UItableView
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.backgroundColor = self.view.backgroundColor;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableHeaderView = [UIView new];
    self.tableView.tableFooterView = [UIView new];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = 60;
}

#pragma mark - UITableViewDataSource, UITableViewDelegate

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 2;
}

-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 15;
}

-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 15)];
    headView.backgroundColor = self.view.backgroundColor;
    
    return headView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.titles[section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *reuseId = NSStringFromClass([self class]);
    KDSLockMoreSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (!cell)
    {
        cell = [[KDSLockMoreSettingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
    }
    cell.title = self.titles[indexPath.section][indexPath.row];
    //cell.hideSeparator = indexPath.row == self.titles.count - 1;
    cell.clipsToBounds = YES;
    if ([cell.title isEqualToString:@"更换WiFi"]) {
        cell.hideSwitch = YES;
    }else if ([cell.title isEqualToString:@"WiFi名称"]){
        cell.subtitle = self.lock.wifiDevice.wifiName;
        cell.hideArrow = YES;
        cell.hideSwitch = YES;
    }else if ([cell.title isEqualToString:@"WiFi强度"]){
        cell.subtitle =  [NSString stringWithFormat:@"%ld",self.lock.wifiDevice.wifiStrength ?: @"".intValue];
        cell.hideArrow = YES;
        cell.hideSwitch = YES;
    }else if ([cell.title isEqualToString:@"RSSI"]){
        cell.subtitle = self.lock.wifiDevice.RSSI?: @"";
        cell.hideArrow = YES;
        cell.hideSwitch = YES;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // 进入设备重新配网
    if (indexPath.section ==0) {
        
        // 进入设备重新配网
        KDSAddVideoWifiLockStep3VC * vc = [KDSAddVideoWifiLockStep3VC new];
        vc.lock = self.lock;
        [self.navigationController pushViewController:vc animated:YES];
        
        //KDSConnectedReconnectVC * vc = [KDSConnectedReconnectVC new];
        //vc.lock = self.lock;
        //[self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma Lazy --load

- (NSArray *)titles
{
    if (!_titles) {
        _titles = @[@[Localized(@"DevicesDetailSetting_Change_WiFi")],@[Localized(@"DevicesDetailSetting_WiFi_Name"),Localized(@"DevicesDetailSetting_WiFi_Strong"),Localized(@"DevicesDetailSetting_RSSI")]];
    }
    return _titles;
}


@end
