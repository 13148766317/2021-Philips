//
//  KDSRealTimeVideoSettingsVC.m
//  2021-Philips
//
//  Created by zhaoxueping on 2020/9/17.
//  Copyright © 2020 com.Kaadas. All rights reserved.
//

#import "KDSRealTimeVideoSettingsVC.h"
#import "KDSLongConnectionPeriodVC.h"
#import "KDSMediaSettingCell.h"
#import "KDSMQTTManager+SmartHome.h"
#import "XMP2PManager.h"
#import "XMUtil.h"
#import "NSString+extension.h"
#import "PLPPublicProgressHub.h"

@interface KDSRealTimeVideoSettingsVC ()<UITableViewDataSource, UITableViewDelegate,PLPPublicProgressHubDelegate>

//表视图。
@property (nonatomic, strong) UITableView *tableView;

//标题数组
@property (nonatomic, strong) NSMutableArray * titles;

//长连接设置的开始时间-结束时间字符串
@property (nonatomic, strong) NSString * settingTimeStarAndEndStr;

//设置长连接的重复周期
@property (nonatomic, strong)NSArray * keep_alive_snooze;

//开始时间:时分的秒数和
@property (nonatomic, assign)int snooze_start_time;

//结束时间:时分的秒数和
@property (nonatomic, assign)int snooze_end_time;

//长连接状态(0/1)  1  为长连接 0 为短连接
@property (nonatomic, assign)int keep_alive_status;

///服务器原始长连接数据
@property (nonatomic, strong)NSDictionary * alive_time;

//蒙板
@property (nonatomic, strong) UIView *maskView;

//提示框
@property (nonatomic, strong) PLPPublicProgressHub *publicProgressHub;

@end

@implementation KDSRealTimeVideoSettingsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化主视图
    [self setUI];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}

#pragma mark - 初始化主视图
- (void)setUI{
    
    self.navigationTitleLabel.text = Localized(@"DevicesDetailSetting_Video_Model");
    
    if (self.lock.wifiDevice.keep_alive_status == 1) {
        [self.titles addObjectsFromArray:@[Localized(@"DevicesDetailSetting_Normal_Type"),Localized(@"DevicesDetailSetting_LowPower")]];
    }else{
        [self.titles addObjectsFromArray:@[Localized(@"DevicesDetailSetting_Normal_Type"),Localized(@"DevicesDetailSetting_LowPower")]];
    }
    
    NSDictionary * dic = self.lock.wifiDevice.alive_time;
    NSString * WeekStr = [NSString getWeekStrWithWeekDic:dic];
    self.alive_time = dic;
    NSString * snooze_end_time = dic[@"snooze_end_time"];
    NSString * snooze_start_time = dic[@"snooze_start_time"];
    self.snooze_start_time = snooze_start_time.intValue;
    self.snooze_end_time = snooze_end_time.intValue;
    self.keep_alive_snooze = dic[@"keep_alive_snooze"];
    if (self.keep_alive_snooze.count == 7) {
        WeekStr = Localized(@"Every_Day");
    }
    self.keep_alive_status = self.lock.wifiDevice.keep_alive_status;
    self.settingTimeStarAndEndStr = [NSString stringWithFormat:@"%@ %@-%@",WeekStr,[NSString timeFormatted:self.snooze_start_time],[NSString timeFormatted:self.snooze_end_time]];
    
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
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titles.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return  80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *reuseId = NSStringFromClass([self class]);
    KDSMediaSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (!cell){
        cell = [[KDSMediaSettingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
    }
    cell.title = self.titles[indexPath.row];
    cell.hideSeparator = YES;
    cell.clipsToBounds = YES;
    if ([cell.title isEqualToString:Localized(@"DevicesDetailSetting_Normal_Type")]){
        __weak typeof(self) weakSelf = self;
        cell.subtitle = nil;
        cell.hideSwitch = YES;
        cell.hideArrow = YES;
       
        [cell.selectButton setImage:self.keep_alive_status == 0 ? [UIImage imageNamed:@"philips_icon_default"] : [UIImage imageNamed:@"philips_icon_selected"] forState:UIControlStateNormal];
        cell.switchOn = self.keep_alive_status == 0 ? NO : YES;
        cell.explain = Localized(@"DevicesDetailSetting_Call_Video");
        
        //开关Button点击事件监听
        cell.selectButtonClickBlock = ^(UIButton * _Nonnull butn) {
            //点击设置视频长连接
            [weakSelf setPlanRecordInfoWithChannel :butn];
        };
        
        cell.switchXMStateDidChangeBlock = ^(UISwitch * _Nonnull sender) {
            //点击设置视频长连接
            //[weakSelf setPlanRecordInfoWithChannel :sender];
        };
        
    }else if ([cell.title isEqualToString:@"省电模式"]) {
        
        __weak typeof(self) weakSelf = self;
        cell.hideSwitch = YES;
        cell.switchEnable = YES;
        cell.hideArrow = YES;
        
        [cell.selectButton setImage:self.keep_alive_status == 1 ? [UIImage imageNamed:@"philips_icon_default"] : [UIImage imageNamed:@"philips_icon_selected"] forState:UIControlStateNormal];
        //cell.switchOn = self.keep_alive_status == 1 ? NO : YES;
        cell.explain = Localized(@"DevicesDetailSetting_Has_LowPower");
        
        //开关Button点击事件监听
        cell.selectButtonClickBlock = ^(UIButton * _Nonnull butn) {
            //点击设置视频短连接
            [weakSelf setPlanRecordInfoWithChannel1 :butn];
        };
        
        cell.switchXMStateDidChangeBlock = ^(UISwitch * _Nonnull sender) {
            //点击设置视频短连接
            //[weakSelf setPlanRecordInfoWithChannel1 :sender];
        };
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    KDSMediaSettingCell * cell = (KDSMediaSettingCell *)[tableView cellForRowAtIndexPath:indexPath];
    if ([cell.title isEqualToString:@"长连接周期"]) {
        KDSLongConnectionPeriodVC * vc = [KDSLongConnectionPeriodVC new];
        vc.lock = self .lock;
        // 选中的回调
        vc.didSelectWeekAndTimeBlock = ^(NSArray * _Nonnull keep_alive_snooze, int snooze_start_time, int snooze_end_time) {
            self.keep_alive_snooze = keep_alive_snooze;
            self.snooze_start_time = snooze_start_time;
            self.snooze_end_time = snooze_end_time;
            NSDictionary * dic = @{@"keep_alive_snooze":keep_alive_snooze};
            self.settingTimeStarAndEndStr = [NSString stringWithFormat:@"%@ %@-%@",[NSString getWeekStrWithWeekDic:dic],[NSString timeFormatted:snooze_start_time],[NSString timeFormatted:snooze_end_time]];
            [self.tableView reloadData];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
}
#pragma mark - 设置短连接 -- 正常模式
- (void)setPlanRecordInfoWithChannel1:(UIButton *)sender{
    
    if (self.lock.wifiDevice.keep_alive_status == 1) {
        
        NSDictionary *informationDic = @{@"Title":Localized(@"DevicesDetailSetting_Sure_LowPower"),@"SibTitle":Localized(@"DevicesDetailSetting_LowPower_Not"),@"LButton":Localized(@"MediaLibrary_Cancel"),@"RButton":Localized(@"Message_Sure")};
        [self showPublicProgressView:informationDic];
    }
    
    
    //if (self.lock.wifiDevice.keep_alive_status == 0) {//是否为视频长链接

    //    UIAlertController * alerVC = [UIAlertController alertControllerWithTitle:@"您确定要关闭吗?" message:@"关闭会导致APP无法远程查看门外情况\n有人按门铃时，可视对讲不受影响" preferredStyle:UIAlertControllerStyleAlert];
    //    UIAlertAction *retryAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    //        self.keep_alive_status  = 1;
    //    }];
    //    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    //        [sender setOn:!sender.isOn animated:YES];
    //        self.keep_alive_status  = 0;
    //    }];

        //修改message
    //    NSMutableAttributedString *alertControllerMessageStr = [[NSMutableAttributedString alloc] initWithString:@"打开省电模式会导致APP无法远程查看门外情况\n有人按门铃时，可视对讲不受影响"];

    //    [alertControllerMessageStr addAttribute:NSForegroundColorAttributeName value:KDSRGBColor(0, 0, 0) range:NSMakeRange(0, 18)];
    //    [alertControllerMessageStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0, 18)];

    //    [alertControllerMessageStr addAttribute:NSForegroundColorAttributeName value:KDSRGBColor(153, 153, 153) range:NSMakeRange(18, alertControllerMessageStr.length-18)];
    //    [alertControllerMessageStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10] range:NSMakeRange(18, alertControllerMessageStr.length-18)];

    //    [alerVC setValue:alertControllerMessageStr forKey:@"attributedMessage"];
    //    [retryAction setValue:KDSRGBColor(32, 150, 248) forKey:@"titleTextColor"];
    //    [cancelAction setValue:KDSRGBColor(154, 154, 154) forKey:@"titleTextColor"];

    //    [alerVC addAction:cancelAction];
    //    [alerVC addAction:retryAction];
    //    [self presentViewController:alerVC animated:YES completion:nil];
    //}else{
        //开启长连接
    //    self.keep_alive_status = 0;
    //    [self setRealTimeVideoSetting:sender];
    //}
    
    // 刷新视图显示
    //[self.tableView  reloadData];
}

#pragma mark - 设置长连接 -- 省电模式
- (void)setPlanRecordInfoWithChannel:(UIButton *)sender{
    
    //暂不支持切换
    if (self.lock.wifiDevice.keep_alive_status == 0) {
        
        //开启长连接
        //self.keep_alive_status = 1;
        //[self setRealTimeVideoSetting:sender];
        
        NSDictionary *informationDic = @{@"Title":Localized(@"DevicesDetailSetting_Open_Energy"),@"SibTitle":Localized(@"RealTimeVideo_Opened_Energy_Title"),@"LButton":@"",@"RButton":Localized(@"Message_Sure")};
        [self showPublicProgressView:informationDic];
    }
    
    
    //if (self.lock.wifiDevice.keep_alive_status == 1) {

    //    UIAlertController * alerVC = [UIAlertController alertControllerWithTitle:@"您确定要关闭吗?" message:@"关闭会导致APP无法远程查看门外情况\n有人按门铃时，可视对讲不受影响" preferredStyle:UIAlertControllerStyleAlert];
    //    UIAlertAction *retryAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    //        self.keep_alive_status  = 0;
    //    }];
    //    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    //        [sender setOn:!sender.isOn animated:YES];
    //        self.keep_alive_status  = 1;
    //    }];

        //修改message
    //    NSMutableAttributedString *alertControllerMessageStr = [[NSMutableAttributedString alloc] initWithString:@"关闭会导致APP无法远程查看门外情况\n有人按门铃时，可视对讲不受影响"];

    //    [alertControllerMessageStr addAttribute:NSForegroundColorAttributeName value:KDSRGBColor(0, 0, 0) range:NSMakeRange(0, 18)];
    //    [alertControllerMessageStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0, 18)];

    //    [alertControllerMessageStr addAttribute:NSForegroundColorAttributeName value:KDSRGBColor(153, 153, 153) range:NSMakeRange(18, alertControllerMessageStr.length-18)];
    //    [alertControllerMessageStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10] range:NSMakeRange(18, alertControllerMessageStr.length-18)];

    //    [alerVC setValue:alertControllerMessageStr forKey:@"attributedMessage"];
    //    [retryAction setValue:KDSRGBColor(32, 150, 248) forKey:@"titleTextColor"];
    //    [cancelAction setValue:KDSRGBColor(154, 154, 154) forKey:@"titleTextColor"];

    //    [alerVC addAction:cancelAction];
    //    [alerVC addAction:retryAction];
    //    [self presentViewController:alerVC animated:YES completion:nil];
    //}else{
        //开启长连接
    //    self.keep_alive_status = 1;
    //    [self setRealTimeVideoSetting:sender];
    //}
    
    
    // 刷新视图显示
    //[self.tableView  reloadData];
}

#pragma mark - 左上角返回点击事件  +  保存数据
- (void)navBackClick{
    
    if (self.lock.wifiDevice.keep_alive_status == 0) {
        ///如果是短连接的话，返回不下发设置
        NSLog(@"短连接直接returen");
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    NSDictionary * severDic = self.lock.wifiDevice.alive_time;
    NSString * snooze_start_time = severDic[@"snooze_start_time"];
    NSString * snooze_end_time = severDic[@"snooze_end_time"];
    NSArray * keep_alive_snooze = severDic[@"keep_alive_snooze"];
    if (snooze_start_time.intValue == self.snooze_start_time && snooze_end_time.intValue == self.snooze_end_time && self.keep_alive_snooze.count == keep_alive_snooze.count && [self.keep_alive_snooze isEqualToArray:keep_alive_snooze] && self.keep_alive_status == self.lock.wifiDevice.keep_alive_status) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    [self setRealTimeVideoSetting:nil];
}

#pragma mark -UISwitch 开关点击事件
- (void)setRealTimeVideoSetting:(UIButton *)sender
{
    MBProgressHUD *hud = [MBProgressHUD showMessage:Localized(@"DevicesDetailSetting_Video_Setting") toView:self.view];
    [XMP2PManager sharedXMP2PManager].model = self.lock.wifiDevice;
    [[XMP2PManager sharedXMP2PManager] connectDevice];
    [XMP2PManager sharedXMP2PManager].XMP2PConnectDevStateBlock = ^(NSInteger resultCode) {
        if (resultCode > 0) {
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud hideAnimated:YES];
                if (sender && self.lock.wifiDevice.keep_alive_status == 0) {
                    ///短连接状态
                    NSLog(@"连接失败调用");
                    [self alertShowView:sender];
                    return;
                }
                NSString *message = [NSString stringWithFormat:@"%@%@",Localized(@"RealTimeVideo_Disconnect_Device"), [XMUtil checkPPCSErrorStringWithRet:resultCode]];
                UIAlertController *controller = [UIAlertController alertControllerWithTitle:Localized(@"Message_Progress") message:message preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:Localized(@"MediaLibrary_Cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    [self.navigationController popViewControllerAnimated:true];
                }];
                UIAlertAction *retryAction = [UIAlertAction actionWithTitle:Localized(@"RealTimeVideo_Reconnecting") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [hud showAnimated:YES];
                    [XMP2PManager sharedXMP2PManager].model = self.lock.wifiDevice;
                    [[XMP2PManager sharedXMP2PManager] connectDevice];
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
        if (sender && self.lock.wifiDevice.keep_alive_status == 0) {
            ///短连接状态
            NSLog(@"超时连接失败调用");
            [self alertShowView:sender];
            return;
        }
        NSString *message = [NSString stringWithFormat:Localized(@"Connect_Sever_Overtime")];
        UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"" message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:Localized(@"RealTimeVideo_Close") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [hud hideAnimated:YES];
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
                dic[@"keep_alive_snooze"] = self.keep_alive_snooze;
                dic[@"snooze_start_time"] = @(self.snooze_start_time);
                dic[@"snooze_end_time"] = @(self.snooze_end_time);
                [[KDSMQTTManager sharedManager] setCameraVideoConnectionSettingsWithWf:self.lock.wifiDevice alive_time:dic keep_alive_status:self.keep_alive_status completion:^(NSError * _Nullable error, BOOL success) {
                    if (success) {
                        [MBProgressHUD showSuccess:Localized(@"Setting_Status_Successful")];
                        self.lock.wifiDevice.keep_alive_status = self.keep_alive_status;
                        self.lock.wifiDevice.alive_time = dic;
                    }else{
                        [MBProgressHUD showError:Localized(@"Setting_Status_Fail")];
                    }
                    [hud hideAnimated:YES];
                    [[XMP2PManager sharedXMP2PManager] releaseLive];
                    [self.navigationController popViewControllerAnimated:YES];
                }];

            });
        }else{
            [hud hideAnimated:YES];
            [MBProgressHUD showError:Localized(@"Setting_Status_Fail")];
            [[XMP2PManager sharedXMP2PManager] releaseLive];
            [self.navigationController popViewControllerAnimated:YES];
        }
    };
}

#pragma mark - 提示框 / 设置失败
- (void)alertShowView:(UIButton *)sender{
    
    //[sender setOn:NO animated:YES];
    UIAlertController * alerVC = [UIAlertController alertControllerWithTitle:Localized(@"Setting_Status_Fail") message:Localized(@"DevicesDetailSetting_OpenLowPower") preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *retryAction = [UIAlertAction actionWithTitle:Localized(@"Message_Sure") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    [retryAction setValue:KDSRGBColor(32, 150, 248) forKey:@"titleTextColor"];
    [alerVC addAction:retryAction];
    [self presentViewController:alerVC animated:YES completion:nil];
}

#pragma mark -PLPPublicProgressHub(弹窗)
-(void) publicProgressHubClick:(NSInteger)index{
    
    switch (index) {
        case 10://取消
        {
            [self dismissPublicProgressView];
            break;
        }
        case 11://确定
        {
            //将弹框收回
            [self dismissPublicProgressView];
            
            if (self.lock.wifiDevice.keep_alive_status == 1) {
                
                //设置
                self.keep_alive_status = 0;
                [self setRealTimeVideoSetting:nil];
                
                // 刷新视图显示
                [self.tableView  reloadData];
            }
            break;
        }
            
        default:
            break;
    }
}

#pragma mark - PLPProgressHub显示视图
-(void)showPublicProgressView:(NSDictionary *)dic{
    
    [_maskView removeFromSuperview];
    [_publicProgressHub removeFromSuperview];
    
    _maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    _maskView.alpha = 0.5;
    _maskView.backgroundColor = [UIColor blackColor];
    [[UIApplication sharedApplication].keyWindow addSubview:self.maskView];
    
    NSString *title = [dic objectForKey:@"Title"];
    if ([title isEqualToString:Localized(@"DevicesDetailSetting_Open_Energy")]) {
        _publicProgressHub = [[PLPPublicProgressHub alloc] initWithFrame:CGRectMake(50, kScreenHeight/2 - 150/2, kScreenWidth-100, 240) InformationDic:dic];
    }else{
        _publicProgressHub = [[PLPPublicProgressHub alloc] initWithFrame:CGRectMake(50, kScreenHeight/2 - 150/2, kScreenWidth-100, 200) InformationDic:dic];
    }
    _publicProgressHub.backgroundColor = [UIColor whiteColor];
    _publicProgressHub.publicProgressHubDelegate = self;
    [[UIApplication sharedApplication].keyWindow addSubview:_publicProgressHub];
}

#pragma mark - PLPProgressHub删除视图
-(void)dismissPublicProgressView{
    
    __weak typeof(self)weakSelf = self;
    [UIView animateWithDuration:0.1 animations:^{
        weakSelf.maskView.alpha = 0;
    } completion:^(BOOL finished) {
        [weakSelf.maskView removeFromSuperview];
        [weakSelf.publicProgressHub removeFromSuperview];
    }];
}

#pragma Lazy --load
- (NSMutableArray *)titles{
    if (!_titles) {
        _titles = [NSMutableArray array];
    }
    return _titles;
}

@end
