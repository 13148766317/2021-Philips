//
//  KDSMediaLockMoreSettingVC.m
//  2021-Philips
//
//  Created by zhaoxueping on 2020/9/16.
//  Copyright © 2020 com.Kaadas. All rights reserved.
//

#import "KDSMediaLockMoreSettingVC.h"
#import "KDSLockMoreSettingCell.h"
#import "UIView+Extension.h"
#import "KDSXMMediaLockLanguageVC.h"
#import "KDSWanderingAlarmVC.h"
#import "KDSMediaMessagePushVC.h"
#import "KDSMediaLockParamVC.h"
#import "KDSRealTimeVideoSettingsVC.h"
#import "KDSHttpManager+VideoWifiLock.h"
#import "KDSHttpManager+WifiLock.h"
#import "KDSMQTTManager+SmartHome.h"
#import "KDSXMMediaUnlockModeVC.h"
#import "KDSMediaSettingCell.h"
#import "KDSAddVideoWifiLockStep3VC.h"
#import "KDSAutolockPeriodSetingVC.h"
#import "XMP2PManager.h"
#import "XMUtil.h"

#import "PLPChangeDeviceNameViewController.h"
#import "KDSChangeWifiLockWifiViewController.h"
#import "PLPWanderingAlarmListVCViewController.h"
#import "PLPProgressHub.h"
#import "PLPDuressAlarmViewController.h"
#import "KDSGWMenaceVC.h"
#import "PLPDuressPasswordViewController.h"
#import "PLPVoiceSettingViewController.h"
#import "PLPOpenDirectionViewController.h"
#import "PLPopenForceViewController.h"
#import "PLPScreenLightLevelViewController.h"
#import "PLPScreenLightLevelViewController.h"
#import "PLPScreenLightTimeViewController.h"

@interface KDSMediaLockMoreSettingVC ()<UITableViewDataSource, UITableViewDelegate,PLPProgressHubDelegate>

///表视图。
@property (nonatomic, strong) UITableView *tableView;

///删除按钮。
@property (nonatomic, strong) UIButton *deleteBtn;

//头部标题数组
@property (nonatomic, strong) NSMutableArray *headTitleArr;
 
//设置详情数据
@property (nonatomic, strong) NSMutableArray * titles;

//蒙板
@property (nonatomic, strong) UIView *maskView;

//提示框
@property (nonatomic, strong) PLPProgressHub *progressHub;


@end

@implementation KDSMediaLockMoreSettingVC


- (void)viewDidLoad {
    [super viewDidLoad];
   
    //初始化主视图
    [self setupMainView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //刷新tableView
    [self.tableView reloadData];
}

#pragma mark - 初始化主视图
-(void) setupMainView{
    
    self.navigationTitleLabel.text = Localized(@"DevicesDetailSetting_Setting");
    CGFloat offset = 0;
    if (kStatusBarHeight + kNavBarHeight + 9*60 + 84 > kScreenHeight)
    {
        offset = -44;
    }
    
    //UITableView初始化
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
    
    //删除用户Button
    self.deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat height = 44;
    CGFloat width = kScreenWidth-30;
    //self.deleteBtn.layer.cornerRadius = height / 2.0;
    self.deleteBtn.backgroundColor = KDSRGBColor(0xff, 0x3b, 0x30);
    [self.deleteBtn setTitle:Localized(@"DevicesDetailSetting_Delete_Device") forState:UIControlStateNormal];
    [self.deleteBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    self.deleteBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.deleteBtn addTarget:self action:@selector(clickDeleteBtnDeleteBindedLock:) forControlEvents:UIControlEventTouchUpInside];
    if (offset > 0){
        [self.view addSubview:self.deleteBtn];
        [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.centerX.equalTo(self.view);
            make.width.equalTo(@(width));
            make.height.equalTo(@(height));
        }];
    }else{
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 132)];
        view.backgroundColor = self.view.backgroundColor;
        self.deleteBtn.frame = (CGRect){15, 40, width, height};
        [view addSubview:self.deleteBtn];
        self.tableView.tableFooterView = view;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wifimqttEventNotification:) name:KDSMQTTEventNotification object:nil];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.headTitleArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        return 0.01;
    }else{
        return 40;
    }
}

-(UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KDSScreenWidth, 40)];
    headerView.backgroundColor = self.view.backgroundColor;
    
    //显示每个分组的标题
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 200, 20)];
    titleLabel.font = [UIFont systemFontOfSize:13];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.text = [NSString stringWithFormat:@"%@",self.headTitleArr[section]];
    [headerView addSubview:titleLabel];
    
    return headerView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.titles[section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //徘徊报警鹤立鸡群，特殊对待
    if ([self.titles[indexPath.section][indexPath.row] isEqualToString:@"徘徊报警"]) {
        return 80;
    }else{
        return 60;
    }
    
    return  60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //徘徊报警鹤立鸡群，特殊对待
    if ([self.titles[indexPath.section][indexPath.row] isEqualToString:@"徘徊报警"]) {//徘徊报警
        
        NSString *reuseIdOne = NSStringFromClass([self class]);
        KDSMediaSettingCell *cellOne = [tableView dequeueReusableCellWithIdentifier:reuseIdOne];
        if (!cellOne) {
            cellOne = [[KDSMediaSettingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdOne];
        }
        cellOne.title = self.titles[indexPath.section][indexPath.row];
        cellOne.hideSeparator = YES;
        cellOne.clipsToBounds = YES;
        cellOne.hideSwitch = YES;
        cellOne.selectButton.hidden = YES;
        
        cellOne.explain = Localized(@"DevicesDetailSetting_WanderingAlarm_Hub");
        
        return cellOne;
        
    }else{
        
        NSString *reuseId = NSStringFromClass([self class]);
        KDSLockMoreSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
        if (!cell)
        {
            cell = [[KDSLockMoreSettingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
        }
        cell.title = self.titles[indexPath.section][indexPath.row];
        cell.hideSeparator = YES;
        cell.clipsToBounds = YES;
        if ([cell.title isEqualToString:Localized(@"DevicesDetailSetting_Device_Name")]) {//设备名称
            cell.subtitle = [KDSTool showNameStr:self.lock.wifiDevice.lockNickname Length:10] ?: [KDSTool showNameStr:self.lock.wifiDevice.wifiSN Length:10];
            cell.hideSwitch = YES;
        }else if ([cell.title isEqualToString:Localized(@"DevicesDetailSetting_WiFi")]){//WiFi设置
            cell.subtitle = self.lock.wifiDevice.wifiName;
            cell.hideSwitch = YES;
        }else if ([cell.title isEqualToString:Localized(@"DevicesDetailSetting_Verification_Mdel")]){//开锁验证模式
            //cell.subtitle = self.lock.wifiDevice.safeMode.intValue == 0 ? @"普通模式" : @"安全模式";
            cell.subtitle = self.lock.wifiDevice.safeMode.intValue == 0 ? Localized(@"DevicesDetailSetting_Once_Type") : Localized(@"DevicesDetailSetting_Double_Type");
            cell.hideSwitch = YES;
        }else if ([cell.title isEqualToString:Localized(@"DevicesDetailSetting_Lock_Set")]){//上锁模式
            if (self.lock.wifiDevice.amMode.intValue == 0) {//自动模式
                cell.subtitle = @"自动上锁";
            }else if (self.lock.wifiDevice.amMode.intValue == 1){//手动上锁
                cell.subtitle = @"手动上锁";
            }
            cell.hideSwitch = YES;
        }else if ([cell.title isEqualToString:Localized(@"DevicesDetailSetting_Language_Setting")]){//门锁语言
            cell.subtitle = [self.lock.wifiDevice.language isEqualToString:@"en"] ? Localized(@"DevicesDetailSetting_English") : Localized(@"DevicesDetailSetting_Chinese");
            cell.hideSwitch = YES;
        }else if ([cell.title isEqualToString:@"语音设置111"]){//原来的静音模式----先修改为语音设置
            __weak typeof(self) weakSelf = self;
            cell.subtitle = nil;
            cell.hideSwitch = NO;
            cell.switchEnable = YES;
            if (self.lock.wifiDevice.volume.intValue == 1) {
                ///静音模式开启
                cell.switchOn = YES;
            }else{
                ///静音模式关闭(语音)
                cell.switchOn = NO;
            }
            cell.switchStateDidChangeBlock = ^(UISwitch * _Nonnull sender) {
                [weakSelf switchClickSetLockVolume:sender];
            };
        }else if ([cell.title isEqualToString:Localized(@"DevicesDetailSetting_Device_Message")] || [cell.title isEqualToString:Localized(@"DevicesDetailSetting_Message_Push")]){
            cell.subtitle = nil;
            cell.hideSwitch = YES;
        }else if ([cell.title isEqualToString:@"视频模式"]){
            if ([KDSLockFunctionSet[self.lock.wifiLockFunctionSet] containsObject:@54]) {//此时为长链接+短链接 54和93互斥
                cell.subtitle = nil;
                cell.hideSwitch = YES;
                cell.hideArrow = NO;
            }else{
                cell.hideSwitch = YES;
                cell.hideArrow = YES;
                if (self.lock.wifiDevice.powerSave.intValue == 1) {
                    cell.subtitle = @"关";
                }else{
                    cell.subtitle = @"开";
                }
            }
        }else if ([cell.title isEqualToString:@"语音设置"]){
            if (self.lock.wifiDevice.volLevel.intValue == 0) {//静音
                cell.subtitle = @"静音";
            }else if (self.lock.wifiDevice.volLevel.intValue == 1){//低音量
                cell.subtitle = @"低音量";
            }else if (self.lock.wifiDevice.volLevel.intValue == 2){//高音量
                cell.subtitle = @"高音量";
            }
            cell.hideSwitch = YES;
        }else if ([cell.title isEqualToString:@"感应把手"]){
            cell.hideSwitch = YES;
            cell.hideArrow = YES;
            if (self.lock.wifiDevice.powerSave.intValue == 1) {
                cell.subtitle = @"关";
            }else{
                cell.subtitle = @"开";
            }
        }else if ([cell.title isEqualToString:@"开门方向"]){
            if (self.lock.wifiDevice.openDirection.intValue == 1) {//左开门
                cell.subtitle = @"左开门";
            }else if (self.lock.wifiDevice.openDirection.intValue == 2){//右开门
                cell.subtitle = @"右开门";
            }
            cell.hideSwitch = YES;
        }else if ([cell.title isEqualToString:@"开门力量"]){
            if (self.lock.wifiDevice.openForce.intValue == 1) {//低扭力
                cell.subtitle = @"低扭力";
            }else if (self.lock.wifiDevice.openForce.intValue == 2){//高扭力
                cell.subtitle = @"高扭力";
            }
            cell.hideSwitch = YES;
        }else if ([cell.title isEqualToString:@"显示屏亮度"]){
            if (self.lock.wifiDevice.screenLightLevel.intValue == 80) {//高
                cell.subtitle = @"高";
            }else if (self.lock.wifiDevice.screenLightLevel.intValue == 50){//中
                cell.subtitle = @"中";
            }else if (self.lock.wifiDevice.screenLightLevel.intValue == 30){//低
                cell.subtitle = @"低";
            }
        }else if ([cell.title isEqualToString:@"显示屏时间"]){
            cell.subtitle = [NSString stringWithFormat:@"%ld s",(long)self.lock.wifiDevice.screenLightTime.integerValue];
            cell.hideSwitch = YES;
        }else if ([cell.title isEqualToString:@"胁迫报警"]){
            cell.subtitle = nil;
            cell.hideSwitch = YES;
        }
        
        return cell;
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    KDSLockMoreSettingCell * cell = (KDSLockMoreSettingCell *)[tableView cellForRowAtIndexPath:indexPath];

    if ([cell.title isEqualToString:Localized(@"DevicesDetailSetting_Device_Name")]) {//设备名称
        
        PLPChangeDeviceNameViewController *settingVC = [PLPChangeDeviceNameViewController new];
        settingVC.lock = self.lock;
        [self.navigationController pushViewController:settingVC animated:YES];
        //[self alterDeviceNickname];
    }else if ([cell.title isEqualToString:@"徘徊报警"]){
        [self canContinueWithTile:Localized(@"MessageRecord_Linger_Alarm")];
    }else if ([cell.title isEqualToString:@"视频模式"]){
        [self canContinueWithTile:Localized(@"DevicesDetailSetting_Video_Model")];
    }else if ([cell.title isEqualToString:@"胁迫报警"]){
        [self canContinueWithTile:@"胁迫报警"];
    }else if ([cell.title isEqualToString:Localized(@"DevicesDetailSetting_WiFi")]){//WiFi设置
        [self changeWiFiName];
    }else if ([cell.title isEqualToString:Localized(@"DevicesDetailSetting_Verification_Mdel")]){//开锁验证模式
        [self canContinueWithTile:cell.title];
    }else if ([cell.title isEqualToString:Localized(@"DevicesDetailSetting_Lock_Set")]){//上锁模式
        [self canContinueWithTile:cell.title];
    }else if ([cell.title isEqualToString:Localized(@"DevicesDetailSetting_Language_Setting")]){//门锁语言
        [self canContinueWithTile:cell.title];
    }else if ([cell.title isEqualToString:Localized(@"DevicesDetailSetting_Device_Message")]){//设备信息
        if (self.lock.wifiDevice.productModel == nil) {
            [MBProgressHUD showError:Localized(@"DevicesDetailSetting_No_DeviceMessage")];
            return;
        }

        KDSMediaLockParamVC * vc = [KDSMediaLockParamVC new];
        vc.lock = self.lock;
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([cell.title isEqualToString:Localized(@"DevicesDetailSetting_Message_Push")]){//消息推送
        KDSMediaMessagePushVC * vc = [KDSMediaMessagePushVC new];
        vc.lock = self.lock;
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([cell.title isEqualToString:Localized(@"DevicesDetailSetting_Video_Model ")]){//实时视频设置
        [self canContinueWithTile:cell.title];
    }else if ([cell.title isEqualToString:@"语音设置"]){//语音设置
        [self canContinueWithTile:@"语音设置"];
    }else if ([cell.title isEqualToString:@"开门方向"]){
        [self canContinueWithTile:@"开门方向"];
    }else if ([cell.title isEqualToString:@"开门力量"]){
        [self canContinueWithTile:@"开门力量"];
    }else if ([cell.title isEqualToString: @"显示屏亮度"]){
        [self canContinueWithTile:@"显示屏亮度"];
    }else if ([cell.title isEqualToString: @"显示屏时间"]){
        [self canContinueWithTile:@"显示屏时间"];
    }
}

#pragma mark - 控件等事件方法。

//MARK:点击删除按钮删除绑定的设备。
- (void)clickDeleteBtnDeleteBindedLock:(UIButton *)sender
{
    //UIAlertController *ac = [UIAlertController alertControllerWithTitle:Localized(@"beSureDeleteDevice?") message:Localized(@"deviceWillBeUnbindAfterDelete") preferredStyle:UIAlertControllerStyleAlert];
    //UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:Localized(@"cancel") style:UIAlertActionStyleCancel handler:nil];
    //UIAlertAction *okAction = [UIAlertAction actionWithTitle:Localized(@"ok") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    //    [self deleteBindedDevice];
        
    //}];
    //[ac addAction:cancelAction];
    //[ac addAction:okAction];
    //[self presentViewController:ac animated:YES completion:nil];
    
    //显示提示框
    [self showContactView];
}

#pragma mark -修改锁昵称。
- (void)alterDeviceNickname
{
    __weak typeof(self) weakSelf = self;
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:Localized(@"DevicesDetailSetting_Write_DeviceName") message:nil preferredStyle:UIAlertControllerStyleAlert];
    [ac addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.textAlignment = NSTextAlignmentCenter;
        textField.textColor = KDSRGBColor(0x10, 0x10, 0x10);
        textField.font = [UIFont systemFontOfSize:13];
        [textField addTarget:weakSelf action:@selector(textFieldTextDidChange:) forControlEvents:UIControlEventEditingChanged];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:Localized(@"MediaLibrary_Cancel") style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:Localized(@"UnlockModel_Sure") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSString *newNickname = ac.textFields.firstObject.text;
        if (newNickname.length && ![newNickname isEqualToString:weakSelf.lock.name])
        {
            MBProgressHUD *hud = [MBProgressHUD showMessage:Localized(@"DevicesDetailSetting_Change_LockName") toView:weakSelf.view];
            [[KDSHttpManager sharedManager] alterWifiBindedDeviceNickname:newNickname withUid:[KDSUserManager sharedManager].user.uid wifiModel:self.lock.wifiDevice success:^{
                [hud hideAnimated:NO];
                [MBProgressHUD showSuccess:Localized(@"Message_Save_Successful")];
                weakSelf.lock.wifiDevice.lockNickname = newNickname;
                [weakSelf.tableView reloadData];
            } error:^(NSError * _Nonnull error) {
                [hud hideAnimated:YES];
                [MBProgressHUD showError:[Localized(@"Message_Save_Fail") stringByAppendingString:error.localizedDescription]];
            } failure:^(NSError * _Nonnull error) {
                [hud hideAnimated:YES];
                [MBProgressHUD showError:[Localized(@"Message_Save_Fail") stringByAppendingString:error.localizedDescription]];
            }];
            
        }
        
    }];
    [ac addAction:cancelAction];
    [ac addAction:okAction];
    [self presentViewController:ac animated:YES completion:nil];
}

#pragma mark - 锁昵称修改文本框文字改变后，限制长度不超过16个字节。
- (void)textFieldTextDidChange:(UITextField *)sender
{
    [sender trimTextToLength:-1];
}

#pragma mark - 点击静音cell中的开关时设置锁的音量，开->锁设置静音，关->锁设置低音。
- (void)switchClickSetLockVolume:(UISwitch *)sender
{
    if (![KDSUserManager sharedManager].netWorkIsAvailable) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *message = [NSString stringWithFormat:Localized(@"NetWork_Not_Open")];
            UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"" message:message preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *retryAction = [UIAlertAction actionWithTitle:Localized(@"Message_Sure") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                //                [self.navigationController popViewControllerAnimated:true];
            }];
            [retryAction setValue:KDSRGBColor(32, 150, 248) forKey:@"titleTextColor"];
            [controller addAction:retryAction];
            [self presentViewController:controller animated:true completion:nil];
        });
        [sender setOn:!sender.on animated:YES];
        return;
    }
    if (self.lock.wifiDevice.powerSave.intValue == 1) {
        
        UIAlertController * alerVC = [UIAlertController alertControllerWithTitle:Localized(@"DevicesDetailSetting_NotSet_LowPower") message:Localized(@"ReplaceBattery") preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *retryAction = [UIAlertAction actionWithTitle:Localized(@"Message_Sure") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    
        }];
        
        //修改title
        NSMutableAttributedString *alertTitleStr = [[NSMutableAttributedString alloc] initWithString:Localized(@"DevicesDetailSetting_NotSet_LowPower")];
        [alertTitleStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(0, alertTitleStr.length)];
        [alerVC setValue:alertTitleStr forKey:@"attributedTitle"];
        
        //修改message
        NSMutableAttributedString *alertControllerMessageStr = [[NSMutableAttributedString alloc] initWithString:Localized(@"ReplaceBattery")];
        [alertControllerMessageStr addAttribute:NSForegroundColorAttributeName value:KDSRGBColor(153, 153, 153) range:NSMakeRange(0, alertControllerMessageStr.length)];
        [alertControllerMessageStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:11] range:NSMakeRange(0, alertControllerMessageStr.length)];
        
        [alerVC setValue:alertControllerMessageStr forKey:@"attributedMessage"];
        [retryAction setValue:KDSRGBColor(32, 150, 248) forKey:@"titleTextColor"];
        
        [alerVC addAction:retryAction];
        [self presentViewController:alerVC animated:YES completion:nil];
        [sender setOn:!sender.on animated:YES];
        return;
    }
    MBProgressHUD *hud = [MBProgressHUD showMessage:Localized(@"UnlockModel_Uploading") toView:self.view];
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
                int switchNumber;
                if (sender.on) {
                    switchNumber = 1;
                }else{
                    switchNumber = 0;
                }
                [[KDSMQTTManager sharedManager] setLockVolumeWithWf:self.lock.wifiDevice volume:switchNumber completion:^(NSError * _Nullable error, BOOL success) {
                    [hud hideAnimated:YES];
                    if (success) {
                        self.lock.wifiDevice.volume = [NSString stringWithFormat:@"%d",switchNumber];
                        [MBProgressHUD showSuccess:Localized(@"UnlockModel_Setting_Sucessful")];
                    }else{
                        [MBProgressHUD showError:Localized(@"Setting_Status_Fail")];
                        [sender setOn:!sender.on animated:YES];
                    }
                    [[XMP2PManager sharedXMP2PManager] releaseLive];
                }];
            });
        }else{
            [hud hideAnimated:YES];
            [[XMP2PManager sharedXMP2PManager] releaseLive];
            [MBProgressHUD showError:Localized(@"Setting_Status_Fail")];
            [sender setOn:!sender.on animated:YES];
        }
    };
}

#pragma mark -删除绑定的设备
- (void)deleteBindedDevice
{
    MBProgressHUD *hud = [MBProgressHUD showMessage:Localized(@"Setting_Status_Deleting") toView:self.view];
    [[KDSHttpManager sharedManager] unbindXMMediaWifiDeviceWithWifiSN:self.lock.wifiDevice.wifiSN uid:[KDSUserManager sharedManager].user.uid success:^{
        [hud hideAnimated:YES];
        [MBProgressHUD showSuccess:Localized(@"Setting_Status_DeleteSuccsee")];
        [[NSNotificationCenter defaultCenter] postNotificationName:KDSLockHasBeenDeletedNotification object:nil userInfo:@{@"lock" : self.lock}];
        [self.navigationController popToRootViewControllerAnimated:YES];
    } error:^(NSError * _Nonnull error) {
        [hud hideAnimated:YES];
        [MBProgressHUD showError:[Localized(@"Setting_Status_DeleteFail") stringByAppendingFormat:@", %@", error.localizedDescription]];
    } failure:^(NSError * _Nonnull error) {
        [hud hideAnimated:YES];
        [MBProgressHUD showError:[Localized(@"Setting_Status_DeleteFail") stringByAppendingFormat:@", %@", error.localizedDescription]];
    }];
}

#pragma mark - 更换wifi
- (void)changeWiFiName
{
    KDSChangeWifiLockWifiViewController *change = [KDSChangeWifiLockWifiViewController new];
    change.lock = self.lock;
    [self.navigationController pushViewController:change animated:YES];
    
    //UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"" message:@"跟换WiFi需重新进入添加门锁步骤" preferredStyle:UIAlertControllerStyleAlert];
    //UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:Localized(@"cancel") style:UIAlertActionStyleCancel handler:nil];
    //UIAlertAction *okAction = [UIAlertAction actionWithTitle:Localized(@"ok") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    //    KDSAddVideoWifiLockStep3VC * vc = [KDSAddVideoWifiLockStep3VC new];
    //    vc.lock = self.lock;
    //    [self.navigationController pushViewController:vc animated:YES];
        
    //}];
    //[cancelAction setValue:KDSRGBColor(154, 154, 154) forKey:@"titleTextColor"];
    //[okAction setValue:KDSRGBColor(32, 150, 248) forKey:@"titleTextColor"];
    //[ac addAction:cancelAction];
    //[ac addAction:okAction];
    //[self presentViewController:ac animated:YES completion:nil];
}

#pragma mark -自动上锁、门锁语言、开锁验证模式、静音模式等进入这些设置页面需先验证，然后讯美P2P服务是保活状态才可以才发设置
- (void)canContinueWithTile:(NSString *)title
{
    if (![KDSUserManager sharedManager].netWorkIsAvailable) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *message = [NSString stringWithFormat:Localized(@"NetWork_Not_Open")];
            UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"" message:message preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *retryAction = [UIAlertAction actionWithTitle:Localized(@"Message_Sure") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [retryAction setValue:KDSRGBColor(32, 150, 248) forKey:@"titleTextColor"];
            [controller addAction:retryAction];
            [self presentViewController:controller animated:true completion:nil];
        });
        return;
    }
    if (self.lock.wifiDevice.powerSave.intValue == 1) {
        
        UIAlertController * alerVC = [UIAlertController alertControllerWithTitle:Localized(@"DevicesDetailSetting_NotSet_LowPower") message:Localized(@"ReplaceBattery") preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *retryAction = [UIAlertAction actionWithTitle:Localized(@"Message_Sure") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        //修改title
        NSMutableAttributedString *alertTitleStr = [[NSMutableAttributedString alloc] initWithString:Localized(@"DevicesDetailSetting_NotSet_LowPower")];
        [alertTitleStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(0, alertTitleStr.length)];
        [alerVC setValue:alertTitleStr forKey:@"attributedTitle"];
        
        //修改message
        NSMutableAttributedString *alertControllerMessageStr = [[NSMutableAttributedString alloc] initWithString:Localized(@"ReplaceBattery")];
        [alertControllerMessageStr addAttribute:NSForegroundColorAttributeName value:KDSRGBColor(153, 153, 153) range:NSMakeRange(0, alertControllerMessageStr.length)];
        [alertControllerMessageStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:11] range:NSMakeRange(0, alertControllerMessageStr.length)];
        
        [alerVC setValue:alertControllerMessageStr forKey:@"attributedMessage"];
        [retryAction setValue:KDSRGBColor(32, 150, 248) forKey:@"titleTextColor"];
        
        [alerVC addAction:retryAction];
        [self presentViewController:alerVC animated:YES completion:nil];
        return;
    }
    
    if ([title isEqualToString:@"验证方式"]) {
        KDSXMMediaUnlockModeVC *vc = [KDSXMMediaUnlockModeVC new];
        vc.lock = self.lock;
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([title isEqualToString:@"上锁模式"]){
        KDSAutolockPeriodSetingVC *vc = [KDSAutolockPeriodSetingVC new];
        vc.lock = self.lock;
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([title isEqualToString:@"语言设置"]){
        KDSXMMediaLockLanguageVC *vc = [KDSXMMediaLockLanguageVC new];
        vc.lock = self.lock;
        vc.language = self.lock.wifiDevice.language;
        vc.lockLanguageDidAlterBlock = ^(NSString * _Nonnull newLanguage) {
            self.lock.wifiDevice.language = newLanguage;
        };
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([title isEqualToString:@"视频模式"]){
        if ([KDSLockFunctionSet[self.lock.wifiLockFunctionSet] containsObject:@54]) {//此时为长链接+短链接 54和93互斥
            KDSRealTimeVideoSettingsVC * vc = [KDSRealTimeVideoSettingsVC new];
            vc.lock = self.lock;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else if ([title isEqualToString:@"徘徊报警"]){
        KDSWanderingAlarmVC * vc = [KDSWanderingAlarmVC new];
        vc.lock = self.lock;
        [self.navigationController pushViewController:vc animated:YES];
        
        //PLPWanderingAlarmListVCViewController *alarmVC = [PLPWanderingAlarmListVCViewController new];
        //alarmVC.lock = self.lock;
        //[self.navigationController pushViewController:alarmVC animated:YES];
    }else if ([title isEqualToString:@"胁迫报警"]){
        PLPDuressPasswordViewController *duressPasswordVC = [PLPDuressPasswordViewController new];
        duressPasswordVC.lock = self.lock;
        [self.navigationController pushViewController:duressPasswordVC animated:YES];
    }else if ([title isEqualToString:@"语音设置"]){
        PLPVoiceSettingViewController * voiceSettingVC = [PLPVoiceSettingViewController new];
        voiceSettingVC.lock = self.lock;
        [self.navigationController pushViewController:voiceSettingVC animated:YES];
    }else if ([title isEqualToString:@"开门方向"]){
        PLPOpenDirectionViewController *openDirectionVC = [PLPOpenDirectionViewController new];
        openDirectionVC.lock = self.lock;
        [self.navigationController pushViewController:openDirectionVC animated:YES];
    }else if ([title isEqualToString:@"开门力量"]){
        PLPopenForceViewController *openForceVC = [PLPopenForceViewController new];
        openForceVC.lock = self.lock;
        [self.navigationController pushViewController:openForceVC animated:YES];
    }else if ([title isEqualToString:@"显示屏亮度"]){
        PLPScreenLightLevelViewController *screenLightLevelVC = [PLPScreenLightLevelViewController new];
        screenLightLevelVC.lock = self.lock;
        [self.navigationController pushViewController:screenLightLevelVC animated:YES];
    }else if ([title isEqualToString:@"显示屏时间"]){
        PLPScreenLightTimeViewController *screenLightTimeVC = [PLPScreenLightTimeViewController new];
        screenLightTimeVC.lock = self.lock;
        [self.navigationController pushViewController:screenLightTimeVC animated:YES];
    }
}

#pragma mark 通知
#pragma mark -mqtt上报事件通知。
- (void)wifimqttEventNotification:(NSNotification *)noti
{
    MQTTSubEvent event = noti.userInfo[MQTTEventKey];
    NSDictionary *param = noti.userInfo[MQTTEventParamKey];
    if ([event isEqualToString:MQTTSubEventWifiLockStateChanged]){
        if ([param[@"wfId"] isEqualToString:self.lock.wifiDevice.wifiSN]){
            self.lock.wifiDevice.volume = param[@"volume"];
            self.lock.wifiDevice.language = param[@"language"];
            self.lock.wifiDevice.amMode = param[@"amMode"];
            [self.tableView reloadData];
        }
    }
}

#pragma mark -PLPProgressHubDelegate(弹窗)
-(void) informationBtnClick:(NSInteger)index{
    
    switch (index) {
        case 10://取消
        {
            [self dismissContactView];
            
            break;
        }
        case 11://删除
        {
            [self deleteBindedDevice];
            
            [self dismissContactView];
            
            break;
        }
            
        default:
            break;
    }
}

#pragma mark - PLPProgressHub显示视图
-(void)showContactView{
    
    [_maskView removeFromSuperview];
    [_progressHub removeFromSuperview];
    
    _maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    _maskView.alpha = 0.5;
    _maskView.backgroundColor = [UIColor blackColor];
    [[UIApplication sharedApplication].keyWindow addSubview:self.maskView];
    
    _progressHub = [[PLPProgressHub alloc] initWithFrame:CGRectMake(50, kScreenHeight/2 - 150/2, kScreenWidth-100, 150) Title:Localized(@"DevicesDetailSetting_Sure_Delete")];
    _progressHub.backgroundColor = [UIColor whiteColor];
    _progressHub.progressHubDelegate = self;
    [[UIApplication sharedApplication].keyWindow addSubview:_progressHub];
}

#pragma mark - PLPProgressHub删除视图
-(void)dismissContactView
{
    __weak typeof(self)weakSelf = self;
    [UIView animateWithDuration:0.1 animations:^{
        weakSelf.maskView.alpha = 0;
    } completion:^(BOOL finished) {
        [weakSelf.maskView removeFromSuperview];
        [weakSelf.progressHub removeFromSuperview];
    }];
}


#pragma Lazy --load

-(NSMutableArray *)headTitleArr{
    if (!_headTitleArr) {
       
        //添加门锁模式
        _headTitleArr = [NSMutableArray arrayWithObjects:@"",@"门锁模式", nil];
        
        //开门方向或者开门力量
        if ([KDSLockFunctionSet[self.lock.wifiLockFunctionSet] containsObject:@60] ||
            [KDSLockFunctionSet[self.lock.wifiLockFunctionSet] containsObject:@61]) [_headTitleArr addObject:@"开门设置"];
        
        //添加其他的
        [_headTitleArr addObject:@"视频设置"];
        [_headTitleArr addObject:@"安全设置"];
        [_headTitleArr addObject:@"设备信息"];
    }
    
    return _headTitleArr;
}

- (NSMutableArray *)titles
{
    if (!_titles) {
        //原版 _titles = @[@[@"设备名称",@"WiFi"],@[@"验证方式",@"上锁模式",@"语言设置",@"语音设置"],@[@"开门方向",@"开门力量"],@[@"徘徊报警",@"视频模式",@"显示屏亮度",@"显示屏时间"],@[@"胁迫报警"],@[@"设备信息",@"消息推送"]];
        
        _titles = [NSMutableArray arrayWithCapacity:0];
        
        //1：设备名称+WiFi
        NSMutableArray *arr1 = [NSMutableArray arrayWithCapacity:0];
        
        //设备名称
        [arr1 addObject:@"设备名称"];
        
        //WiFi
        [arr1 addObject:@"WiFi"];
        
        [_titles addObject:arr1];
        
        //2：门锁模式
        //验证方式
        NSMutableArray *arr2 = [NSMutableArray arrayWithCapacity:0];
        if ([KDSLockFunctionSet[self.lock.wifiLockFunctionSet] containsObject:@1]) {
            [arr2 addObject:@"验证方式"];
        }
        
        //上锁模式
        if ([KDSLockFunctionSet[self.lock.wifiLockFunctionSet] containsObject:@32]) {
            [arr2 addObject:@"上锁模式"];
        }
        
        //语言设置
        [arr2 addObject:@"语言设置"];
        
        //语音设置
        if ([KDSLockFunctionSet[self.lock.wifiLockFunctionSet] containsObject:@88]) {
            [arr2 addObject:@"语音设置"];
        }
        
        //感应把手
        if ([KDSLockFunctionSet[self.lock.wifiLockFunctionSet] containsObject:@91]) {
            [arr2 addObject:@"感应把手"];
        }
        
        //构建第2组数据
        [_titles addObject:arr2];
        
        
        //开门设置
        if ([KDSLockFunctionSet[self.lock.wifiLockFunctionSet] containsObject:@60] || [KDSLockFunctionSet[self.lock.wifiLockFunctionSet] containsObject:@61]) {
            
            //3：开门设置
            NSMutableArray *arr3 = [NSMutableArray arrayWithCapacity:0];
            
            //开门方向
            if ([KDSLockFunctionSet[self.lock.wifiLockFunctionSet] containsObject:@60]){
                [arr3 addObject:@"开门方向"];
            }
            
            //开门力量
            if ([KDSLockFunctionSet[self.lock.wifiLockFunctionSet] containsObject:@61]){
                [arr3 addObject:@"开门力量"];
            }
            
            //构建第3组数据
            [_titles addObject:arr3];
        }
    
        
        //4：视频设置
        NSMutableArray *arr4 = [NSMutableArray arrayWithCapacity:0];
        
        //徘徊报警
        [arr4 addObject:@"徘徊报警"];
        
        //视频模式(54和93互斥)
        if ([KDSLockFunctionSet[self.lock.wifiLockFunctionSet] containsObject:@54] ||
            [KDSLockFunctionSet[self.lock.wifiLockFunctionSet] containsObject:@93]){
            [arr4 addObject:@"视频模式"];
        }
        
        //显示屏亮度
        if ([KDSLockFunctionSet[self.lock.wifiLockFunctionSet] containsObject:@71] ||
            [KDSLockFunctionSet[self.lock.wifiLockFunctionSet] containsObject:@72] ||
            [KDSLockFunctionSet[self.lock.wifiLockFunctionSet] containsObject:@73] ) {
            
            [arr4 addObject:@"显示屏亮度"];
        }
        
        //显示屏时间
        if ([KDSLockFunctionSet[self.lock.wifiLockFunctionSet] containsObject:@74] ||
            [KDSLockFunctionSet[self.lock.wifiLockFunctionSet] containsObject:@75] ||
            [KDSLockFunctionSet[self.lock.wifiLockFunctionSet] containsObject:@76] ) {
            
            [arr4 addObject:@"显示屏时间"];
        }
        
        //构建第4组数据
        [_titles addObject:arr4];
        
        
        //5：安全设置
        NSMutableArray *arr5 = [NSMutableArray arrayWithCapacity:0];
        
        //胁迫报警
        [arr5 addObject:@"胁迫报警"];
        
        [_titles addObject:arr5];
        
        //6：设备信息
        NSMutableArray *arr6 = [NSMutableArray arrayWithCapacity:0];
        
        //设备信息
        [arr6 addObject:@"设备信息"];
        
        //消息推送
        [arr6 addObject:@"消息推送"];
        
        [_titles addObject:arr6];
    }
    
    return _titles;
}

@end
