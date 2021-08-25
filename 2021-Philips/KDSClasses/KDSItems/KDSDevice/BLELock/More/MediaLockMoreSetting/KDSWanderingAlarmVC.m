//
//  KDSWanderingAlarmVC.m
//  2021-Philips
//
//  Created by zhaoxueping on 2020/9/16.
//  Copyright © 2020 com.Kaadas. All rights reserved.
//

#import "KDSWanderingAlarmVC.h"
#import "KDSMediaLockPIRSensitivityVC.h"
#import "KDSMediaSettingCell.h"
#import "KDSMediaWanderingTimeVC.h"
#import "XMP2PManager.h"
#import "XMUtil.h"
#import "KDSMQTTManager+SmartHome.h"

@interface KDSWanderingAlarmVC ()<UITableViewDataSource, UITableViewDelegate>
///表视图。
@property (nonatomic, strong) UITableView *tableView;

//恢复默认Button
@property (nonatomic, strong) UIButton *confirmBurron;

@property (nonatomic, strong) NSArray * titles;

/// 菊花loading
//@property (nonatomic, strong)UIActivityIndicatorView *indicatorView;

///PIR徘徊判定的时间：10~60秒
@property (nonatomic,assign)int WanderingTimeNum;

///PIR灵敏度：0~100
@property (nonatomic,assign)int PIRSensitivityNum;

///徘徊检测开关状态(0/1)
@property (nonatomic,assign)int stay_status;
                                                                   
///服务器原始PIR数据
@property (nonatomic,strong)NSDictionary * setPir;

@end

@implementation KDSWanderingAlarmVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化主视图
    [self setUI];
}

#pragma mark - 初始化主视图
- (void)setUI
{
    self.navigationTitleLabel.text = Localized(@"DevicesDetailSetting_Wandering_Alarm");
    
    NSDictionary * dic = self.lock.wifiDevice.setPir;
    NSString * pirNum = [NSString stringWithFormat:@"%@",dic[@"pir_sen"]];
    NSString * stay_time = [NSString stringWithFormat:@"%@",dic[@"stay_time"]];
    self.PIRSensitivityNum = pirNum.intValue;
    self.WanderingTimeNum = stay_time.intValue;
    self.stay_status = self.lock.wifiDevice.stay_status;
    self.setPir = dic;
    
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
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = 80;
    
    //添加恢复默认Button
    [self.view addSubview:self.confirmBurron];
    if (self.stay_status == 1) {
        self.confirmBurron.hidden = NO;
    }else{
        self.confirmBurron.hidden = YES;
    }
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    
    if (self.stay_status == 1) {//徘徊开关是打开状态
        return 2;
    }else{
        return 1;
    }
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
    cell.title = self.titles[indexPath.section][indexPath.row];
    cell.hideSeparator = YES;
    cell.clipsToBounds = YES;
    if ([cell.title isEqualToString:@"徘徊报警"]){
        cell.subtitle = nil;
        cell.hideSwitch = NO;
        cell.switchEnable = YES;
        cell.selectButton.hidden = YES;
        cell.switchOn = self.stay_status == 1 ? YES : NO;
        cell.explain = Localized(@"DevicesDetailSetting_Open_WanderingAlarm");
        __weak typeof(self) weakSelf = self;
        cell.switchXMStateDidChangeBlock = ^(UISwitch * _Nonnull sender) {
            
            [weakSelf setWanderingAlarmStatus:sender];
        };
        
    }else if ([cell.title isEqualToString:@"探测距离"]) {
        NSString * pir;
        if (self.PIRSensitivityNum == 90) {
            pir = [NSString stringWithFormat:@"3%@",Localized(@"DevicesDetailSetting_Meter")];
        }else if (self.PIRSensitivityNum == 70){
            pir = [NSString stringWithFormat:@"2%@",Localized(@"DevicesDetailSetting_Meter")];
        }else{
            pir = [NSString stringWithFormat:@"1%@",Localized(@"DevicesDetailSetting_Meter")];
        }
        cell.subtitle = pir;
        cell.hideSwitch = YES;
        cell.selectButton.hidden = YES;
        cell.explain = Localized(@"DevicesDetailSetting_Range_Alarm");
    }else if ([cell.title isEqualToString:@"徘徊时长"]){
        cell.subtitle = [NSString stringWithFormat:@"%d%@",self.WanderingTimeNum,Localized(@"DevicesDetailSetting_Second")];
        cell.explain = Localized(@"DevicesDetailSetting_Linger_Overtime");
        cell.hideSwitch = YES;
        cell.selectButton.hidden = YES;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    KDSMediaSettingCell * cell = (KDSMediaSettingCell *)[tableView cellForRowAtIndexPath:indexPath];
    if ([cell.title isEqualToString:@"探测距离"]) {
        KDSMediaLockPIRSensitivityVC * vc = [KDSMediaLockPIRSensitivityVC new];
        vc.lock = self.lock;
        vc.didSelectPIRSensitivityBlock = ^(int PIRSensitivityNum) {
            self.PIRSensitivityNum = PIRSensitivityNum;
            [self.tableView reloadData];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([cell.title isEqualToString:@"徘徊时长"]){
        KDSMediaWanderingTimeVC * vc = [KDSMediaWanderingTimeVC new];
        vc.lock = self.lock;
        vc.didSelectWanderingTimeBlock = ^(int WanderingTimeNum) {
            self.WanderingTimeNum = WanderingTimeNum;
            [self.tableView reloadData];
        };
    
        [self.navigationController pushViewController:vc animated:YES];
    }
}
- (void)setWanderingAlarmStatus:(UISwitch *)sender
{
    if (sender.on) {
        self.stay_status = 1;
        self.confirmBurron.hidden = NO;
        self.titles = @[@[Localized(@"MessageRecord_Linger_Alarm")],@[Localized(@"DevicesDetailSetting_Ture_Range"),Localized(@"DevicesDetailSetting_Linger_Time")]];
    }else{
        self.stay_status = 0;
        self.confirmBurron.hidden = YES;
        self.titles = @[@[Localized(@"MessageRecord_Linger_Alarm")]];
    }
    
    [self.tableView reloadData];
}

#pragma mark - 返回上级页面+数据保存
- (void)navBackClick{
   
    [self saveData:1];
}

#pragma mark - 恢复默认点击事件
-(void) confirmButtonClick:(UIButton *)btn{
    
    //默认值设置
    self.WanderingTimeNum = 10;
    self.PIRSensitivityNum = 70;
    
    //保存数据
    [self saveData:2];
}

#pragma mark - 数据保存
-(void) saveData:(NSInteger) index{
    
    NSDictionary * setPirDic = self.lock.wifiDevice.setPir;
    
    //徘徊时长
    NSString * stay_time = setPirDic[@"stay_time"];
    NSString * pir_sen = setPirDic[@"pir_sen"];
    if (stay_time.intValue == self.WanderingTimeNum && pir_sen.intValue == self.PIRSensitivityNum && self.stay_status == self.lock.wifiDevice.stay_status) {
        if (index == 1) {
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [self.tableView reloadData];
            [MBProgressHUD showSuccess:Localized(@"DevicesDetailSetting_Has_NormalModel")];
        }
        return;
    }
    
    MBProgressHUD *hud = [MBProgressHUD showMessage:Localized(@"DevicesDetailSetting_Setting_DuressAlarm_Late") toView:self.view];
    [XMP2PManager sharedXMP2PManager].model = self.lock.wifiDevice;
    [[XMP2PManager sharedXMP2PManager] connectDevice];
    [XMP2PManager sharedXMP2PManager].XMP2PConnectDevStateBlock = ^(NSInteger resultCode) {
        if (resultCode > 0) {
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud hideAnimated:YES];
                NSString *message = [NSString stringWithFormat:@"%@ %@",Localized(@"RealTimeVideo_Disconnect_Device"), [XMUtil checkPPCSErrorStringWithRet:resultCode]];
                UIAlertController *controller = [UIAlertController alertControllerWithTitle:Localized(@"Message_Progress") message:message preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:Localized(@"RealTimeVideo_Close") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    [self.navigationController popViewControllerAnimated:true];
                }];
                UIAlertAction *retryAction = [UIAlertAction actionWithTitle:Localized(@"RealTimeVideo_Reconnecting") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [XMP2PManager sharedXMP2PManager].model = self.lock.wifiDevice;
                    [[XMP2PManager sharedXMP2PManager] connectDevice];
                    [hud showAnimated:YES];
                }];
                [cancelAction setValue:KDSRGBColor(154, 154, 154) forKey:@"titleTextColor"];
                [retryAction setValue:KDSRGBColor(32, 150, 248) forKey:@"titleTextColor"];
                [controller addAction:cancelAction];
                [controller addAction:retryAction];
                [self presentViewController:controller animated:true completion:nil];
                return;
                
            });
        }
    };
    
    [XMP2PManager sharedXMP2PManager].XMMQTTConnectDevOutTimeBlock = ^{
        ///超时
        [hud hideAnimated:YES];
        NSString *message = [NSString stringWithFormat:Localized(@"Connect_Sever_Overtime")];
        UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"" message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:Localized(@"RealTimeVideo_Close") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popViewControllerAnimated:true];
        }];
        UIAlertAction *retryAction = [UIAlertAction actionWithTitle:Localized(@"RealTimeVideo_Reconnecting") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [XMP2PManager sharedXMP2PManager].model = self.lock.wifiDevice;
            [[XMP2PManager sharedXMP2PManager] connectDevice];
            [hud showAnimated:YES];
        }];
        [cancelAction setValue:KDSRGBColor(154, 154, 154) forKey:@"titleTextColor"];
        [retryAction setValue:KDSRGBColor(32, 150, 248) forKey:@"titleTextColor"];
        [controller addAction:cancelAction];
        [controller addAction:retryAction];
        [self presentViewController:controller animated:true completion:nil];
        return;
        
    };
    [XMP2PManager sharedXMP2PManager].XMMQTTConnectDevStateBlock = ^(BOOL isCanBeDistributed) {
        if (isCanBeDistributed == YES) {
            ///讯美登录MQTT成功
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"MQTT 登录成功");
                NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
                dic[@"stay_time"] = @(self.WanderingTimeNum);
                dic[@"pir_sen"] = @(self.PIRSensitivityNum);
                [[KDSMQTTManager sharedManager] setCameraPIRSensitivitySettingsWithWf:self.lock.wifiDevice setPir:dic stay_status:self.stay_status completion:^(NSError * _Nullable error, BOOL success) {
                    if (success) {
                        [MBProgressHUD showSuccess:Localized(@"UnlockModel_Setting_Sucessful")];
                        self.lock.wifiDevice.setPir = dic;
                        self.lock.wifiDevice.stay_status = self.stay_status;
                    }else{
                        [MBProgressHUD showError:Localized(@"Setting_Status_Fail")];
                    }
                    [hud hideAnimated:YES];
                    [[XMP2PManager sharedXMP2PManager] releaseLive];
                    
                    if (index == 1) {
                        [self.navigationController popViewControllerAnimated:YES];
                    }else{
                        [self.tableView reloadData];
                    }
                }];
            });
        }else{
            
            [MBProgressHUD showError:Localized(@"Setting_Status_Fail")];
            [hud hideAnimated:YES];
            [[XMP2PManager sharedXMP2PManager] releaseLive];
            if (index == 1) {
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [self.tableView reloadData];
            }
        }
    };
}

#pragma Lazy --load

- (NSArray *)titles
{
    if (!_titles) {
        if (self.stay_status == 1) {
            _titles = @[@[Localized(@"DevicesDetailSetting_Wandering_Alarm")],@[Localized(@"DevicesDetailSetting_Ture_Range"),Localized(@"DevicesDetailSetting_Linger_Time")]];
        }else{
            _titles = @[@[Localized(@"DevicesDetailSetting_Wandering_Alarm")]];
        }
    }
    return _titles;
}

//恢复默认
-(UIButton *) confirmBurron{
    if (!_confirmBurron) {
        _confirmBurron = [UIButton buttonWithType:UIButtonTypeCustom];
        [_confirmBurron setFrame:CGRectMake(20, kScreenHeight-200, kScreenWidth-40, 40)];
        [_confirmBurron setBackgroundColor:KDSRGBColor(45, 100, 156)];
        [_confirmBurron setTitle:Localized(@"DevicesDetailSetting_Normal") forState:UIControlStateNormal];
        _confirmBurron.hidden = YES;
        [_confirmBurron setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_confirmBurron addTarget:self action:@selector(confirmButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _confirmBurron;
}


@end
