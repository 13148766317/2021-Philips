//
//  PLPWanderingAlarmListVCViewController.m
//  2021-Philips
//
//  Created by 小凯互联科技有限公司 on 2021/5/11.
//  Copyright © 2021 com.Kaadas. All rights reserved.
//

#import "PLPWanderingAlarmListVCViewController.h"
#import "KDSMediaSettingCell.h"
#import "KDSWanderingAlarmVC.h"

@interface PLPWanderingAlarmListVCViewController ()<UITableViewDelegate,UITableViewDataSource>

///表视图。
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray * titles;

@end

@implementation PLPWanderingAlarmListVCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化主视图
    [self setUI];
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}

#pragma mark - 初始化主视图
- (void)setUI
{
    self.navigationTitleLabel.text = @"徘徊报警";
    
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
    self.tableView.rowHeight = 80;
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titles.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  80;
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
    if ([cell.title isEqualToString:@"徘徊报警"]){
        cell.subtitle = nil;
        cell.hideSwitch = NO;
        cell.switchEnable = YES;
        cell.switchEnable = NO;
        cell.selectButton.hidden = YES;
        //self.lock.wifiDevice.stay_status == 1 ? @"开启": @"已关闭";
        cell.switchOn = self.lock.wifiDevice.stay_status == 1 ? YES : NO;
        cell.explain = @"开启后，门锁摄像头会抓拍门外徘徊人员。\n开启该功能会增加门锁耗电";
        __weak typeof(self) weakSelf = self;
        cell.switchXMStateDidChangeBlock = ^(UISwitch * _Nonnull sender) {
            
            [weakSelf setWanderingAlarmStatus:sender];
        };
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    KDSWanderingAlarmVC * vc = [KDSWanderingAlarmVC new];
    vc.lock = self.lock;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)setWanderingAlarmStatus:(UISwitch *)sender{
    if (sender.on) {
        //self.stay_status = 1;
    }else{
        //self.stay_status = 0;
    }
}

#pragma Lazy --load

- (NSArray *)titles
{
    if (!_titles) {
        _titles = @[@"徘徊报警"];
    }
    return _titles;
}

@end
