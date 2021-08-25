//
//  KDSHomeViewController.m
//  2021-Philips
//
//  Created by wzr on 2019/1/15.
//  Copyright © 2019 com.Kaadas. All rights reserved.
//

#import "PLPHomeViewController.h"
#import "KDSDeviceNicknameView.h"
#import "Masonry.h"
#import "MBProgressHUD+MJ.h"
#import "KDSLockInFoVC.h"
#import "KDSCatEyeInForVC.h"
#import "KDSDBManager+GW.h"
#import "KDSHttpManager+Ble.h"
#import "MJRefresh.h"
#import "YGScrollTitleView.h"
#import "KDSLockInFoVC.h"
#import "KDSAddDeviceVC.h"
#import "KDSMQTT.h"
#import "KDSGWLockInfoVC.h"
#import "LinphoneManager.h"
#import "KDSCallIncomingView.h"
#import "KDSCateyeCallVC.h"
#import "KDSHttpManager+User.h"
#import "KDSDBManager+CY.h"
#import "ReactiveObjC.h"
//#import "KDSLinphoneManager.h"
#import "KDSWifiLockInfoVC.h"
#import "KDSZeroFireSingleModel.h"
#import "KDSZeroFireSingleInfoVC.h"
#import "XMPlayController.h"


// 晾衣机
#import "KDSsmartHangerViewController.h"

// 新首页
#import "UIViewController+PLP.h"

// 测试的界面
#import "KDSMediaLockInPutAdminPwdVC.h"

@interface PLPHomeViewController ()


///从服务器获取的绑定设备[MyDevice, GatewayDeviceModel]。// 所有数据的集合
@property (nonatomic, strong) NSMutableArray *devicesArr;

///mqtt 'getAllBindDevice' task receipt, if this variable is not nil, don't request server duplicately.
@property (nonatomic, strong) KDSMQTTTaskReceipt *mqttReceipt;

@end

@implementation PLPHomeViewController

#pragma mark - 生命周期、界面设置方法。
- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(queryP2P_password:)name:@"queryP2P_passwordNotication" object:nil];
    ///从本地获取缓存的设备
    [[KDSUserManager sharedManager].gateways removeAllObjects];
    [[KDSUserManager sharedManager].locks removeAllObjects];
    [[KDSUserManager sharedManager].cateyes removeAllObjects];
    KDSDBManager *db = [KDSDBManager sharedManager];
    NSArray *bleDevices = [db queryBindedDevices];
    if (bleDevices.count) [self.devicesArr addObjectsFromArray:bleDevices];
    NSArray *gws = [db queryBindedGateways];
    for (GatewayModel *model in gws)
    {
        KDSGW *gw = [KDSGW new];
        gw.model = model;
        [[KDSUserManager sharedManager].gateways addObject:gw];
        if (model.devices) [self.devicesArr addObjectsFromArray:model.devices];
    }
    NSArray * wifiModels = [db queryBindedWifiModels];
    if (wifiModels.count) [self.devicesArr addObjectsFromArray:wifiModels];
    
    // android
    [self uploadPushDeviceToken];
    [self startSip];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(lockHasBeenDeleted:) name:KDSLockHasBeenDeletedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(lockDidAlarm:) name:KDSLockDidAlarmNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(lockHasBeenAdded:) name:KDSLockHasBeenAddedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkReachabilityStatusDidChange:) name:AFNetworkingReachabilityDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(localeLanguageDidChange:) name:KDSLocaleLanguageDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(gwOnlineRefreshDevice:) name:KDSGWOnlineNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cateyeHasBeendeleted:) name:KDSCatEyeHasBeenDeletedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateBleVersionRefreshDevices:) name:KDSLockUpdateBleVersionNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateBleVersionRefreshDevices:) name:KDSBleLockUpdateDataSourceNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doorBellNotification:) name:KDSXMMediaDoorBeellNotification object:nil];
    [self refreshChildViewControllersAndTitleView];
    //添加新首页
    [self addHomeDevicesVC];
}

- (void)queryP2P_password:(NSNotification *)text{
[self  getAllBindDevice];
NSLog(@"zhu－－－－－接收到通知 home ------");
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    ///从服务器获取网关下绑定的设备，并刷新界面。
    [self getAllBindDevice];
    [[KDSUserManager sharedManager] monitorNetWork];
       
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];
    [LinphoneManager instance].hasPushkit  = NO;
}


/**
 *@abstract 当绑定的设备被删除时，或从服务器拉取到新的设备列表时，刷新主界面。调用此方法前，请先更新devicesArr属性。页面刷新完成后会发出通知KDSDeviceSyncNotification
 */
- (void)refreshChildViewControllersAndTitleView
{

    
    [[NSNotificationCenter defaultCenter] postNotificationName:KDSDeviceSyncNotification object:nil userInfo:nil];
}

#pragma mark - 网络请求方法。
-(void)uploadPushDeviceToken{
    NSString *deviceToken = [KDSTool getDeviceToken];
    NSString *VoIPToken = [KDSTool getVoIPDeviceToken];
    NSString* phoneVersion = [[UIDevice currentDevice] systemVersion];
    NSLog(@"--{Kaadas}--上传deviceToken=%@,VoIPToken=%@,准备",deviceToken,VoIPToken);

    if (!deviceToken) return;
    if (!VoIPToken) return;
    [[KDSHttpManager sharedManager] uploadPushToken:deviceToken remoteNotificationToken:VoIPToken withUid:[KDSUserManager sharedManager].user.uid mobileInfo:@{@"moble": phoneVersion,@"vesion":[KDSTool getIphoneType]} success:^{
        KDSLog(@"--{Kaadas}--上传deviceToken,成功");
    } error:^(NSError * _Nonnull error) {
        KDSLog(@"%@", [NSString stringWithFormat:@"--{Kaadas}--上传deviceToken,失败-error=%@",error.localizedDescription]);
//        [MBProgressHUD showError:error.localizedDescription];
    } failure:^(NSError * _Nonnull error) {
        KDSLog(@"%@", [NSString stringWithFormat:@"--{Kaadas}--上传deviceToken,失败-failure=%@",error.localizedDescription]);
//        [MBProgressHUD showError:error.localizedDescription];
    }];
};
/**
 *@abstract 当绑定的设备被删除时，或从服务器拉取到新的设备列表时，刷新主界面。加入了缓存数据，没有网络的时候应该使用缓存数据刷新。
 */
-(void)getAllBindDevice
{
    if (self.mqttReceipt) return;
    __weak typeof(self) weakSelf = self;
    self.mqttReceipt = [[KDSMQTTManager sharedManager] getGatewayAndDeviceList:^(NSError * _Nullable error, NSArray<GatewayModel *> * _Nullable gws, NSArray<MyDevice *> * _Nullable bles, NSArray<KDSWifiLockModel *> * _Nullable wifiList, NSArray<KDSProductInfoList *> * _Nullable productInfoList,NSArray<KDSDeviceHangerModel *> * hangerList) {
        
        weakSelf.mqttReceipt = nil;
        KDSUserManager * userManger = [KDSUserManager sharedManager];
        if (error || !userManger.user.token) return;
        
        
        //删除之前衣架
        if(1) {
            NSMutableArray *deleteDevices = [[NSMutableArray alloc] init];
            for (id device in self.devicesArr) {
                if([device isKindOfClass:[KDSDeviceHangerModel class]]) {
                    [deleteDevices addObject:device];
                }
            }
            if(deleteDevices.count) {
                [self.devicesArr removeObjectsInArray:deleteDevices];
            }
            
            //[userManger.hangers removeAllObjects];
            
            if(hangerList.count) {
                //[userManger.hangers addObjectsFromArray:hangerList];
                [self.devicesArr addObjectsFromArray:hangerList];
            }
        }
        if (productInfoList.count > 0) [userManger.productInfoList removeAllObjects];
        for (KDSProductInfoList * product in productInfoList) {
            if (product) {
                [userManger.productInfoList addObject:product];
            }
        }
        //先删除旧的网关
        for (NSInteger i = 0; i < userManger.gateways.count; ++i)
        {
            KDSGW *gw = userManger.gateways[i];
            NSInteger index = [gws indexOfObject:gw.model];
            if (index != NSNotFound)
            {
                gw.model = gws[index];
                continue;
            }
            //如果网关被删除，删除网关下的设备。
            for (NSInteger j = 0; j < weakSelf.devicesArr.count; ++j)
            {
                GatewayDeviceModel *device = weakSelf.devicesArr[j];
                if ([device isKindOfClass:GatewayDeviceModel.class] && [device.gwId isEqualToString:gw.model.deviceSN])
                {
                    [weakSelf.devicesArr removeObjectAtIndex:j];
                    j--;
                }
            }
            [userManger.gateways removeObjectAtIndex:i];
            i--;
        }
        NSMutableArray *gwDevices = [NSMutableArray array];
        //再增加新的网关。如果没有其它属性需要保存，到这儿也可以全部移除单例中保存的网关再新增请求回来的网关。
        for (GatewayModel * gwModel in gws) {
            KDSGW *gw = [KDSGW new];
            gw.model = gwModel;
            if (![userManger.gateways containsObject:gw]) {
                [userManger.gateways addObject:gw];
            }
            if (gwModel.devices.count)
            {
                [gwDevices addObjectsFromArray:gwModel.devices];
            }
        }
        //先删除设备。
        for (NSUInteger i = 0; i < weakSelf.devicesArr.count; ++i)
        {
            id device = weakSelf.devicesArr[i];
            if ([device isKindOfClass:MyDevice.class] && ![bles containsObject:device])
            {
                [weakSelf.devicesArr removeObjectAtIndex:i];
                i--;
            }
            else if ([device isKindOfClass:GatewayDeviceModel.class] && ![gwDevices containsObject:device])
            {
                [weakSelf.devicesArr removeObjectAtIndex:i];
                i--;
            }else if ([device isKindOfClass:KDSWifiLockModel.class] && ![wifiList containsObject:device])
            {
                ///此时不知道wifi锁返回的数组，暂时用的蓝牙锁的，根据具体业务改变判断条件
                [weakSelf.devicesArr removeObjectAtIndex:i];
                i--;
            }
        }
        //再添加设备。
        for (GatewayDeviceModel *device in gwDevices) {
            NSUInteger index = [weakSelf.devicesArr indexOfObject:device];
            if (index == NSNotFound) {
                [weakSelf.devicesArr addObject:device];
            } else {
                [weakSelf.devicesArr replaceObjectAtIndex:index withObject:device];
            }
        }
        for (MyDevice *bledevice in bles)
        {
            NSUInteger index = [weakSelf.devicesArr indexOfObject:bledevice];
            if (index == NSNotFound)
            {
                [weakSelf.devicesArr addObject:bledevice];
            }
            else
            {
                [weakSelf.devicesArr replaceObjectAtIndex:index withObject:bledevice];

            }
        }
        
        for (KDSWifiLockModel * wifiDevice in wifiList) {
            NSUInteger index = [weakSelf.devicesArr indexOfObject:wifiDevice];
            NSLog(@"zhu-- KDSHomeViewController -- 输出p2p密码 == %@ ",wifiDevice.p2p_password);
            
            if (index == NSNotFound)
            {
                [weakSelf.devicesArr addObject:wifiDevice];  // 添加到当前数组中
            }
            else
            {   // 替换当前数组中的数据
                [weakSelf.devicesArr replaceObjectAtIndex:index withObject:wifiDevice];
               
            }
        }
        [weakSelf refreshChildViewControllersAndTitleView];
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [[KDSDBManager sharedManager] updateBindedGateways:gws];
            [[KDSDBManager sharedManager] updateBindedDevices:bles];
            // 保存wifi 设备到数据库中
            [[KDSDBManager sharedManager] updateBindedWifiModels:wifiList];
        });
        
    }];
}

-(void)startSip{
    [[LinphoneManager instance] startLinphoneCore];
    NSString *host;
    host = kSIPHost;
    [LinphoneManager.instance addProxyConfig:[KDSUserManager sharedManager].user.uid password:@"123456" displayName:nil domain:host port:@"5061" withTransport:@"UDP"];
    //linphone初始化状态刷新
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(kLinphoneCoreUpdate:) name:kLinphoneCoreUpdate object:nil];
    //登录注册状态更新
    NSLog(@"all observer==%@",self.observationInfo);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(kLinphoneRegistrationUpdate:)
                                                 name:kLinphoneRegistrationUpdate object:nil];
    //通话更新
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(callUpdateEvent:)
                                                 name:kLinphoneCallUpdate object:nil];
}

- (void)kLinphoneCoreUpdate:(NSNotification*)notif {
//    NSLog(@"kLinphoneCoreUpdate********:%@",notif);
}
//linphone注册状态更新
- (void)kLinphoneRegistrationUpdate:(NSNotification *)notif{
    LinphoneRegistrationState state =[[notif.userInfo objectForKey: @"state"] intValue];
    
//    NSLog(@"{SIP}--Linphone--kLinphoneRegistrationUpdate--LinphoneRegistrationState==%d",state);
    switch (state) {
        case LinphoneRegistrationNone:
        {
            // NSLog(@"--{Kaadas}--Linphone注册的初始状态");
            [LinphoneManager instance].SIPAcountLoginSuccess = NO;
        }
            break;
        case LinphoneRegistrationProgress:
        {
            // NSLog(@"--{Kaadas}--Linphone登录中");
            [LinphoneManager instance].SIPAcountLoginSuccess = NO;
        }
            break;
        case LinphoneRegistrationOk:
        {
            // NSLog(@"--{Kaadas}--Linphone登录成功");
            [LinphoneManager instance].SIPAcountLoginSuccess = YES;
        }
            break;
        case LinphoneRegistrationCleared:
        {
            NSLog(@"--{Kaadas}--Linphone注消成功");
            [LinphoneManager instance].SIPAcountLoginSuccess = NO;
        }
            break;
        case LinphoneRegistrationFailed:
        {
            NSLog(@"--{Kaadas}--Linphonec注册失败");
            [LinphoneManager instance].SIPAcountLoginSuccess = NO;
        }
            break;
        default:
            break;
    }
}
- (void)callUpdateEvent:(NSNotification*)notif {
    KDSLog(@"callUpdateEvent:%@",notif);
    LinphoneCallState state = [[notif.userInfo objectForKey: @"state"] intValue];
    switch (state) {
        case LinphoneCallIncomingReceived://收到来电
        {
            [[LinphoneManager instance] sendInfoMessage];
            NSLog(@"{KAADAS}--Linphone收到呼叫--LinphoneCallIncomingReceived");
            [[KDSUserManager sharedManager].cateyes enumerateObjectsUsingBlock:^(KDSCatEye * _Nonnull cateye, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([cateye.gatewayDeviceModel.deviceId isEqualToString:[KDSUserManager sharedManager].getCurrentCateyeId]) {
                    *stop = YES;
                    if (cateye.isCalling) {
                        return;
                    }else{
                        UIViewController * VC = [KDSTool currentViewController];
                        if ([[NSString stringWithUTF8String:object_getClassName(VC)] isEqual:@"UIAlertController"] ) {
                            [VC dismissViewControllerAnimated:NO completion:nil];
                        }
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            KDSCallIncomingView *view = [KDSCallIncomingView shareCallIncomingView];
                            view.catyeNameLab.text = cateye.gatewayDeviceModel.deviceId;
                            [view show];
                            }
                        );
                    }
                }
            }];
            break;
        }
        case LinphoneCallUpdatedByRemote:
        {
            KDSLog(@"{KAADAS}--Linphone--收到视频");
            break;
        }
        case LinphoneCallOutgoingInit:{
            KDSLog(@"{KAADAS}--Linphone--开始发出呼叫");
            break;
        }
        case LinphoneCallOutgoingProgress:{
            KDSLog(@"{KAADAS}--Linphone--呼叫进行中");
            break;
        }
        case LinphoneCallOutgoingRinging:{
            KDSLog(@"{KAADAS}--Linphone--对方收到呼叫");
            break;
        }
        case LinphoneCallConnected:{
            KDSLog(@"{KAADAS}--Linphone--会话连接");
            [[KDSUserManager sharedManager].cateyes enumerateObjectsUsingBlock:^(KDSCatEye * _Nonnull cateye, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([cateye.gatewayDeviceModel.deviceId isEqualToString:[KDSUserManager sharedManager].getCurrentCateyeId]) {
                    *stop = YES;
                    if (cateye.isCalling) {
                        return;
                    }else{
                        KDSCateyeCallVC *CallVC = [[KDSCateyeCallVC alloc] init];
                        CallVC.gatewayDeviceModel = cateye.gatewayDeviceModel;
                        CallVC.hidesBottomBarWhenPushed = YES;
                        UIViewController * VC = [KDSTool currentViewController];
                        
                        KDSLog(@"当前显示的控制器%@",VC);

                        //判断当前VC是否是CallVC窗口，没有显示则push显示
                        if (![[NSString stringWithUTF8String:object_getClassName(VC)] isEqual:[NSString stringWithUTF8String:object_getClassName(CallVC)]])
                        {
                            [VC.navigationController pushViewController:CallVC animated:YES];
//                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                
//                            });
                        }
                    }
                }
            }];
           
            break;
        }
        case LinphoneCallStreamsRunning:{
            KDSLog(@"{KAADAS}--Linphone--LinphoneCallStreamsRunning-流媒体建立");
            break;
        }
        case LinphoneCallError:
            NSLog(@"{KAADAS}--Linphone--LinphoneCallError");
        case LinphoneCallEnd:{
            NSLog(@"{KAADAS}--Linphone--LinphoneCallEnd");
            KDSCallIncomingView *view = [KDSCallIncomingView shareCallIncomingView];
            [view dismissView];
        }
            break;
        case LinphoneCallReleased:{
            NSLog(@"{KAADAS}--Linphone--LinphoneCallReleased");
            break;
        }
        default:
            break;
    }
}
-(void)startCateye{
    static dispatch_once_t disOnce;
    dispatch_once(&disOnce,^ {
        //只执行一次的代码
//        [self startSip];
    });
}

///点击添加设备的按钮
- (IBAction)addDeviceBtn:(id)sender {

    
    KDSAddDeviceVC *vc = [[KDSAddDeviceVC alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.gateways = [KDSUserManager sharedManager].gateways;
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark -- 通知事件---

- (void)appDidBecomeActive:(NSNotification *)noti
{
//    [self getAllBindDevice];
}
-(void)gwOnlineRefreshDevice:(NSNotification *)noti
{
    [self getAllBindDevice];
}
-(void)updateBleVersionRefreshDevices:(NSNotification *)noti
{
    [self getAllBindDevice];
}
///设备被删除的通知。
- (void)lockHasBeenDeleted:(NSNotification *)noti
{
    KDSLock *deleted = noti.userInfo[@"lock"];
    KDSUserManager *userMgr = [KDSUserManager sharedManager];
    KDSDBManager *dbMgr = [KDSDBManager sharedManager];
    [userMgr.locks removeObject:deleted];
    if (deleted.device)
    {
        NSMutableArray *array = [NSMutableArray array];
        for (KDSLock *lock in userMgr.locks)
        {
            if (lock.device) [array addObject:lock.device];
        }
        [self.devicesArr removeObject:deleted.device];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [dbMgr updateBindedDevices:array];
        });
    }
    else if (deleted.gwDevice)
    {
        [self.devicesArr removeObject:deleted.gwDevice];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [dbMgr deleteGWLocks:@[deleted.gwDevice] sn:nil];
        });
    }
    else if (deleted.gw && !deleted.gwDevice)
    {
        [userMgr.gateways removeObject:deleted.gw];
        for (NSInteger i = 0; i < self.devicesArr.count; ++i)
        {
            GatewayDeviceModel *device = self.devicesArr[i];
            if ([device isKindOfClass:GatewayDeviceModel.class] && [device.gwId isEqualToString:deleted.gw.model.deviceSN])
            {
                [self.devicesArr removeObjectAtIndex:i];
                i--;
            }
        }
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [dbMgr deleteGWLocks:nil sn:deleted.gw.model.deviceSN];
            NSMutableArray *array = [NSMutableArray array];
            for (KDSGW *gw in userMgr.gateways)
            {
                [array addObject:gw.model];
            }
            [[KDSDBManager sharedManager] updateBindedGateways:array];
        });
    }else if (deleted.wifiDevice){
        [self.devicesArr removeObject:deleted.wifiDevice];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
//            [dbMgr deleteGWLocks:@[deleted.wifiDevice] sn:nil];
        });
    }
    [self refreshChildViewControllersAndTitleView];
}
///猫眼删除设备的通知。
-(void)cateyeHasBeendeleted:(NSNotification *)noti
{
    KDSCatEye * cateye = noti.userInfo[@"cateye"];
    [[KDSUserManager sharedManager].cateyes removeObject:cateye];
    if (cateye.gatewayDeviceModel) {
        [self.devicesArr removeObject:cateye.gatewayDeviceModel];
    }
     [self refreshChildViewControllersAndTitleView];
}

///锁上报报警通知。
- (void)lockDidAlarm:(NSNotification *)noti
{
    CBPeripheral *p = noti.userInfo[@"peripheral"];
    NSData *data = noti.userInfo[@"data"];
    [[KDSUserManager sharedManager] addAlarmForLockWithBleName:p.advDataLocalName data:data];
}

///绑定新设备的通知。
- (void)lockHasBeenAdded:(NSNotification *)noti
{
    id device = noti.userInfo[@"device"];
    NSMutableArray *devices = [NSMutableArray array];
    if ([device isKindOfClass:MyDevice.class])
    {
        for (KDSLock *lock in [KDSUserManager sharedManager].locks)
        {
            if (lock.device) [devices addObject:lock.device];
        }
        [devices addObject:device];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [[KDSDBManager sharedManager] updateBindedDevices:devices];
        });
    }
    if (![self.devicesArr containsObject:device]) [self.devicesArr addObject:device];
    [self refreshChildViewControllersAndTitleView];
}

///收到更改了本地语言的通知，刷新表视图。
- (void)localeLanguageDidChange:(NSNotification *)noti
{
    
}

// 允许自动旋转
-(BOOL)shouldAutorotate{
    return NO;
}
///网络状态改变的通知。当网络不可用时，会将网关、猫眼和网关锁的状态设置为离线后发出通知KDSDeviceSyncNotification
- (void)networkReachabilityStatusDidChange:(NSNotification *)noti
{
    NSNumber *number = noti.userInfo[AFNetworkingReachabilityNotificationStatusItem];
    AFNetworkReachabilityStatus status = number.integerValue;
    KDSUserManager *manager = [KDSUserManager sharedManager];
    for (KDSGW *gw in manager.gateways)
    {
        gw.networkAvailable = (status==AFNetworkReachabilityStatusReachableViaWWAN || status==AFNetworkReachabilityStatusReachableViaWiFi);
    }
    switch (status)
    {
        case AFNetworkReachabilityStatusReachableViaWWAN:
        case AFNetworkReachabilityStatusReachableViaWiFi:
            [self getAllBindDevice];
            break;
        default:
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:KDSDeviceSyncNotification object:nil userInfo:nil];
        }
            break;
    }
}

- (void)doorBellNotification:(NSNotification *)noti
{
    NSString * wifiSn = noti.userInfo[@"wifiSn"];
    for (KDSLock *lock in [KDSUserManager sharedManager].locks)
    {
        if (lock.wifiDevice) {
            if ([lock.wifiDevice.wifiSN isEqualToString:wifiSn]){
                ///门铃报警
                XMPlayController *vc = [[XMPlayController alloc] initWithType:XMPlayTypeLive];
                vc.lock = lock;
                vc.isActive = NO;
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
    }
                    
}

#pragma arguments  ---- 懒加载 ----
- (NSMutableArray *)devicesArr
{
    if (_devicesArr == nil)
    {
        _devicesArr = [NSMutableArray array];
    }
    return _devicesArr;
}



-(void)dealloc{

        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"queryP2P_passwordNotication" object:nil];
    [KDSNotificationCenter removeObserver:self];
    NSLog(@"%@被销毁了",self.class);
}

#pragma mark - function
-(void) addHomeDevicesVC  {
    UIViewController *vc = [UIViewController homeDevicesVC];
    if (vc) {
        [self addChildViewController:vc];
        [self.view addSubview:vc.view];
        vc.view.frame = self.view.bounds;
        [vc.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.equalTo(self.view);
        }];
        [vc willMoveToParentViewController:self];
    }
}
@end


