//
//  KDSMediaMessagePushVC.m
//  2021-Philips
//
//  Created by zhaoxueping on 2020/9/17.
//  Copyright © 2020 com.Kaadas. All rights reserved.
//

#import "KDSMediaMessagePushVC.h"
#import "KDSMediaSettingCell.h"
#import "KDSHttpManager+WifiLock.h"


@interface KDSMediaMessagePushVC ()<UITableViewDataSource, UITableViewDelegate>

///表视图。
@property (nonatomic, strong) UITableView *tableView;

//数据源
@property (nonatomic, strong) NSMutableArray * titles;

@end

@implementation KDSMediaMessagePushVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationTitleLabel.text = Localized(@"DevicesDetailSetting_Message_Push");
    //[self.titles addObjectsFromArray:@[@"消息免打扰",@"开关锁消息",@"门铃消息",@"徘徊报警消息"]];
    [self.titles addObjectsFromArray:@[Localized(@"DevicesDetailSetting_Message_NotDisturb")]];
    CGFloat offset = 0;
    if (kStatusBarHeight + kNavBarHeight + 9*60 + 84 > kScreenHeight)
    {
        offset = -44;
    }
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.backgroundColor = self.view.backgroundColor;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableHeaderView = [UIView new];
    self.tableView.tableFooterView = [UIView new];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(15);
        make.bottom.equalTo(self.view);
    }];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = 60;
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titles.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  65;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *reuseId = NSStringFromClass([self class]);
    KDSMediaSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (!cell)
    {
        cell = [[KDSMediaSettingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
    }
    cell.title = self.titles[indexPath.row];
    cell.hideSeparator = YES;
    cell.clipsToBounds = YES;
    cell.subtitle = nil;
    cell.hideSwitch = NO;
    cell.switchEnable = YES;
    cell.selectButton.hidden = YES;
    cell.explain = Localized(@"DevicesDetailSetting_Not_ShowMessages");
    if (self.lock.wifiDevice.pushSwitch.intValue == 2) {
        ///关闭推送（消息免打扰开启）
        cell.switchOn = YES;
    }else{
        ///开启推送（消息免打扰关闭:1/0）
        cell.switchOn = NO;
    }
    __weak typeof(self) weakSelf = self;
    cell.switchXMStateDidChangeBlock = ^(UISwitch * _Nonnull sender) {
        ///消息免打扰
        [weakSelf switchClickSetNotificationMode:sender];
    };
    return cell;
}

///点击免打扰cell中的开关时设置锁报警信息本地通知功能或设置wifi锁开锁通知功能
- (void)switchClickSetNotificationMode:(UISwitch *)sender
{
    int switchNumber;
    if (sender.on) {
        switchNumber = 2;
    }else{
        switchNumber = 1;
    }
    NSLog(@"消息免打扰的值：%d",switchNumber);
    [[KDSHttpManager sharedManager] setUserWifiLockUnlockNotification:switchNumber withUid:[KDSUserManager sharedManager].user.uid wifiSN:self.lock.wifiDevice.wifiSN completion:^{
        [MBProgressHUD showSuccess:Localized(@"Setting_Status_Successful")];
        self.lock.wifiDevice.pushSwitch = [NSString stringWithFormat:@"%d",switchNumber];
    } error:^(NSError * _Nonnull error) {
        [MBProgressHUD showError:Localized(@"Setting_Status_Fail")];
        [sender setOn:!sender.on animated:YES];
    } failure:^(NSError * _Nonnull error) {
        [MBProgressHUD showError:Localized(@"Setting_Status_Fail")];
        [sender setOn:!sender.on animated:YES];
    }];
}

#pragma Lazy --load

- (NSMutableArray *)titles
{
    if (!_titles) {
        _titles = [NSMutableArray array];
    }
    return _titles;
}


@end
