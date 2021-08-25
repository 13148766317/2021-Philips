//
//  KDSMediaLockParamVC.m
//  2021-Philips
//
//  Created by zhaoxueping on 2020/9/17.
//  Copyright © 2020 com.Kaadas. All rights reserved.
//

#import "KDSMediaLockParamVC.h"
#import "MBProgressHUD+MJ.h"
#import "KDSLockMoreSettingCell.h"
#import "KDSAllPhotoShowImgModel.h"
#import "KDSDoorLockVersionVC.h"
#import "KDSCameraVersionVC.h"

#import <XMStreamComCtrl/XMStreamComCtrl.h>
#import "KDSHttpManager+VideoWifiLock.h"
#import "XMP2PManager.h"
#import "XMUtil.h"

@interface KDSMediaLockParamVC ()<UITableViewDataSource, UITableViewDelegate>

//数据源
@property (nonatomic,strong) NSMutableArray *titles;

//右边的副标题数组
@property (nonatomic, strong) NSMutableArray *subtitleArr;

/// 菊花loading
@property (nonatomic, strong)UIActivityIndicatorView *indicatorView;

@end

@implementation KDSMediaLockParamVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化主视图
    [self setupMainView];
}

#pragma mark - 初始化主视图
-(void) setupMainView{
    
    self.navigationTitleLabel.text = Localized(@"DevicesDetailSetting_Device_Message");
    
    self.tableView.rowHeight = 60;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    //添加菊花
    [self.view addSubview:self.indicatorView];
    [self.indicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(30, 30));
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.view.mas_centerY);
    }];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 4;;
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *reuseId = NSStringFromClass([self class]);
    KDSLockMoreSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (!cell)
    {
        cell = [[KDSLockMoreSettingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
    }
    
    cell.title = self.titles[indexPath.section][indexPath.row];
    cell.subtitle = self.subtitleArr[indexPath.section][indexPath.row];
    cell.hideSeparator = YES;
    cell.hideSwitch = YES;
    
    //是否隐藏右边箭头
    if ([cell.title isEqualToString:@"设备名称"] || [cell.title isEqualToString:@"设备型号"] || [cell.title isEqualToString:@"序列号"] || [cell.title isEqualToString:@"摄像头序列号"] || [cell.title isEqualToString:@"语音模组版本"]) {
        
        cell.hideArrow = YES;
    }else{
        cell.hideArrow = NO;
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    KDSLockMoreSettingCell * cell = (KDSLockMoreSettingCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    //升级编号。1为WIFI模块，2为WIFI锁，3为人脸模组，4为视频模组，5为视频模组微控制器
    if ([cell.title isEqualToString:@"前面板版本"]) {
        if (self.lock.wifiDevice.isAdmin.intValue ==1) {
            [self checkXmWiFiLockOTA:self.lock.wifiDevice.lockFirmwareVersion withDevNum:6];
        }
    }else if ([cell.title isEqualToString:@"后面板版本"]){
        if (self.lock.wifiDevice.isAdmin.intValue ==1) {
            [self checkXmWiFiLockOTA:self.lock.wifiDevice.lockFirmwareVersion withDevNum:7];
        }
    }else if ([cell.title isEqualToString:@"视频模组版本"]){
        if (self.lock.wifiDevice.isAdmin.intValue ==1) {
            [self checkXmWiFiLockOTA:self.lock.wifiDevice.camera_version withDevNum:4];
        }
    }else if ([cell.title isEqualToString:@"视频控制器版本"]){
        if (self.lock.wifiDevice.isAdmin.intValue == 1) {
            [self checkXmWiFiLockOTA:self.lock.wifiDevice.mcu_version withDevNum:5];
        }
    }else if ([cell.title isEqualToString:@"WiFi固件版本"]){
        if (self.lock.wifiDevice.isAdmin.intValue ==  1) {
            [self checkXmWiFiLockOTA:self.lock.wifiDevice.wifiVersion withDevNum:1];
        }
    }
}

#pragma mark - 检查wifi锁/模块是否需要升级
- (void)checkXmWiFiLockOTA:(NSString *)content withDevNum:(int)devNum{
    NSLog(@"--{Kaadas}--检查OTA的softwareRev:%@",content);
    NSLog(@"--{Kaadas}--检查OTA的deviceSN:%@",self.lock.wifiDevice.wifiSN);
    [[KDSHttpManager sharedManager] checkXMWiFiOTAWithSerialNumber:self.lock.wifiDevice.wifiSN withCustomer:4 withVersion:content withDevNum:devNum success:^(id  _Nullable responseObject) {
        NSString *message ;
        
        if([responseObject[@"devNum"] isEqualToNumber:@2]){
            message = [NSString stringWithFormat:@"%@%@,%@",Localized(@"DevicesDetailSetting_Check_WIFIVer"),responseObject[@"fileVersion"],Localized(@"DevicesDetailSetting_Update_Sure")];
        }else if ([responseObject[@"devNum"] isEqualToNumber:@3]){
            message = [NSString stringWithFormat:@"%@%@,%@",Localized(@"DevicesDetailSetting_Check_FaceVer"),responseObject[@"fileVersion"],Localized(@"DevicesDetailSetting_Update_Sure")];
        }else if ([responseObject[@"devNum"] isEqualToNumber:@4]){
            message = [NSString stringWithFormat:@"%@%@,%@",Localized(@"DevicesDetailSetting_Check_VideoModel"),responseObject[@"fileVersion"],Localized(@"DevicesDetailSetting_Update_Sure")];
        }else if ([responseObject[@"devNum"] isEqualToNumber:@5]){
            message = [NSString stringWithFormat:@"%@%@,%@",Localized(@"DevicesDetailSetting_Check_VideoVer"),responseObject[@"fileVersion"],Localized(@"DevicesDetailSetting_Update_Sure")];
        }else{
            message = [NSString stringWithFormat:@"%@%@,%@",Localized(@"DevicesDetailSetting_Check_WIFIModel"),responseObject[@"fileVersion"],Localized(@"DevicesDetailSetting_Update_Sure")];
        }
        UIAlertController *ac = [UIAlertController alertControllerWithTitle:@""/*Localized(@"tips")*/ message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:Localized(@"ok") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"--讯美XXXXX{Kaadas}--responseObject==%@",responseObject);
            
            [self.indicatorView startAnimating];
            [XMP2PManager sharedXMP2PManager].model = self.lock.wifiDevice;
            [[XMP2PManager sharedXMP2PManager] connectDevice];
            [XMP2PManager sharedXMP2PManager].XMP2PConnectDevStateBlock = ^(NSInteger resultCode) {
                if (resultCode > 0) {
                }else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.indicatorView stopAnimating];
                        NSString *message = [NSString stringWithFormat:@"%@%@",Localized(@"RealTimeVideo_Disconnect_Device"), [XMUtil checkPPCSErrorStringWithRet:resultCode]];
                        UIAlertController *controller = [UIAlertController alertControllerWithTitle:Localized(@"Message_Progress") message:message preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:Localized(@"MediaLibrary_Cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                            [self.navigationController popViewControllerAnimated:true];
                        }];
                        UIAlertAction *retryAction = [UIAlertAction actionWithTitle:Localized(@"Try_Agree") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                            [XMP2PManager sharedXMP2PManager].model = self.lock.wifiDevice;
                            [[XMP2PManager sharedXMP2PManager] connectDevice];
                            [self.indicatorView startAnimating];
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
                [self.indicatorView stopAnimating];
                NSString *message = [NSString stringWithFormat:Localized(@"Connect_Sever_Overtime")];
                UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"" message:message preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:Localized(@"RealTimeVideo_Close") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    [self.navigationController popViewControllerAnimated:true];
                }];
                UIAlertAction *retryAction = [UIAlertAction actionWithTitle:Localized(@"RealTimeVideo_Reconnecting") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [XMP2PManager sharedXMP2PManager].model = self.lock.wifiDevice;
                    [[XMP2PManager sharedXMP2PManager] connectDevice];
                    [self.indicatorView startAnimating];
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
                        //[self.indicatorView stopAnimating];
                        NSLog(@"MQTT 登录成功");
                        [[XMP2PManager sharedXMP2PManager].streamManager NotifyGateWayNewVersionWithChannel:0];
                    });
                }else{
                    [self.indicatorView stopAnimating];
                    [MBProgressHUD showError:Localized(@"DevicesDetailSetting_Update_Fail")];
                }
            };
            [[XMP2PManager sharedXMP2PManager] setXMModuleUpgradeResponseBlock:^{
                ///收到通知模块升级的响应再去确认升级
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.indicatorView stopAnimating];
                    [self XMMediaWiFiLockOTA:responseObject];
                });
                
            }];
            
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:Localized(@"MediaLibrary_Cancel") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [cancelAction setValue:UIColor.blackColor forKey:@"titleTextColor"];
        [ac addAction:cancelAction];
        [ac addAction:okAction];
        [self presentViewController:ac animated:YES completion:nil];
        
    } error:^(NSError * _Nonnull error) {
        
        UIAlertController *ac = [UIAlertController alertControllerWithTitle:@""/*Localized(@"Lock OTA upgrade")*/ message:[NSString stringWithFormat:@"%@",error.localizedDescription] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:Localized(@"ok") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        [ac addAction:okAction];
        [self presentViewController:ac animated:YES completion:nil];
        
    } failure:^(NSError * _Nonnull error) {
        
        UIAlertController *ac = [UIAlertController alertControllerWithTitle:@""/*Localized(@"Lock OTA upgrade")*/ message:[NSString stringWithFormat:@"%@",error.localizedDescription] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:Localized(@"ok") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        [ac addAction:okAction];
        [self presentViewController:ac animated:YES completion:nil];
    }];
    
}

#pragma mark - 确认升级
- (void)XMMediaWiFiLockOTA:(id  _Nullable)responseObject{
    
    NSLog(@"--{Kaadas}--发送responseObject=%@",(NSDictionary *)responseObject);
    
    [[KDSHttpManager sharedManager] xmWifiDeviceOTAWithSerialNumber:self.lock.wifiDevice.wifiSN withOTAData:(NSDictionary *)responseObject success:^{
        NSLog(@"--{Kaadas}--发送OTA成功");
        [[XMP2PManager sharedXMP2PManager] releaseLive];
        if([responseObject[@"devNum"] isEqualToNumber:@2])
        {
            [MBProgressHUD showSuccess:Localized(@"DevicesDetailSetting_Check_WIFILock_Update")];
        }else if([responseObject[@"devNum"] isEqualToNumber:@3]){
            UIAlertController * alerVC = [UIAlertController alertControllerWithTitle:Localized(@"DevicesDetailSetting_Mark_Lock") message:Localized(@"DevicesDetailSetting_Updating_FaceModek") preferredStyle:UIAlertControllerStyleAlert];
            [self presentViewController:alerVC animated:YES completion:nil];
            [self performSelector:@selector(dismiss:) withObject:alerVC afterDelay:5.0];
        }else if([responseObject[@"devNum"] isEqualToNumber:@4]){
            //注意观察WiFi锁升级
            [MBProgressHUD showSuccess:Localized(@"DevicesDetailSetting_Observation_VideoModel")];
        }else if([responseObject[@"devNum"] isEqualToNumber:@4]){
            //注意观察WiFi锁升级
            [MBProgressHUD showSuccess:Localized(@"DevicesDetailSetting_Observation_VideoController")];
        }else{
            [MBProgressHUD showSuccess:Localized(@"DevicesDetailSetting_Observation_WIFIModel")];
        }
        
    } error:^(NSError * _Nonnull error) {
        
        UIAlertController *ac = [UIAlertController alertControllerWithTitle: @""/*Localized(@"Lock OTA upgrade")*/ message:[NSString stringWithFormat:@"%@",error.localizedDescription] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:Localized(@"UnlockModel_Sure") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        [ac addAction:okAction];
        [self presentViewController:ac animated:YES completion:nil];
        
    } failure:^(NSError * _Nonnull error) {
        
        UIAlertController *ac = [UIAlertController alertControllerWithTitle:@""/*Localized(@"Lock OTA upgrade")*/ message:[NSString stringWithFormat:@"%@",error.localizedDescription] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:Localized(@"UnlockModel_Sure") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        [ac addAction:okAction];
        [self presentViewController:ac animated:YES completion:nil];
    }];
}

#pragma mark - 菊花消失
- (void)dismiss:(UIAlertController *)alert{
    [alert dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 懒加载

-(NSMutableArray *)titles{
    if (!_titles) {
        _titles = [NSMutableArray arrayWithCapacity:0];
        
        NSArray *arr1 = @[Localized(@"DevicesDetailSetting_Device_Name"),Localized(@"DevicesDetailSetting_Device_Type"),Localized(@"DevicesDetailSetting_Serial")];
        [_titles addObject:arr1];
        
        NSArray *arr2 = @[@"前面板版本",@"后面板版本"];
        [_titles addObject:arr2];
        
        NSArray *arr3 = @[Localized(@"DevicesDetailSetting_Camera_Serial"),Localized(@"DevicesDetailSetting_Video_ModelVer"),Localized(@"DevicesDetailSetting_Video_ControllerVer"),Localized(@"DevicesDetailSetting_Wifi_FirmwareVersion")];
        [_titles addObject:arr3];
        
        
        ////添加语音模组OTA
        if ([KDSLockFunctionSet[self.lock.wifiLockFunctionSet] containsObject:@89] ) {
            NSArray *arr4 = @[@"语音模组版本"];
            [_titles addObject:arr4];
        }
    }
    
    return _titles;
}

-(NSMutableArray *)subtitleArr{
    if (!_subtitleArr) {
        _subtitleArr = [NSMutableArray arrayWithCapacity:0];
        
        NSArray *arr1 = @[self.lock.wifiDevice.lockNickname ?: @"",
                            self.lock.wifiDevice.productModel?: @"",
                            self.lock.wifiDevice.wifiSN?: @""];
        [_subtitleArr addObject:arr1];
        
        NSArray *arr2 = @[self.lock.wifiDevice.frontPanelVersion ? [NSString stringWithFormat:@"%@",self.lock.wifiDevice.frontPanelVersion] : @"",
                          self.lock.wifiDevice.backPanelVersion ? [NSString stringWithFormat:@"%@",self.lock.wifiDevice.backPanelVersion] : @""];
        [_subtitleArr addObject:arr2];
        
        NSArray *arr3 = @[self.lock.wifiDevice.camera_version ? [NSString stringWithFormat:@"%@",self.lock.wifiDevice.device_sn] : @"",
                          self.lock.wifiDevice.camera_version ? [NSString stringWithFormat:@"V%@",self.lock.wifiDevice.camera_version] : @"",//device_model
                          self.lock.wifiDevice.mcu_version ? [NSString stringWithFormat:@"V%@",self.lock.wifiDevice.mcu_version] : @"",
                          self.lock.wifiDevice.wifiVersion ? [NSString stringWithFormat:@"V%@",self.lock.wifiDevice.wifiVersion] : @""];
        [_subtitleArr addObject:arr3];
        
        //添加语音模组OTA
        if ([KDSLockFunctionSet[self.lock.wifiLockFunctionSet] containsObject:@89] ) {
            NSArray *arr4 = @[@""];
            [_subtitleArr addObject:arr4];
        }
    }
    
    return _subtitleArr;
}

- (UIActivityIndicatorView *)indicatorView {
    if (_indicatorView == nil) {
        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    }
    return _indicatorView;
}

@end
