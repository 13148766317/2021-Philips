//
//  KDSAMapLocationManager.m
//  2021-Philips
//
//  Created by zhaona on 2020/2/12.
//  Copyright © 2020 com.Kaadas. All rights reserved.
//

#import "KDSAMapLocationManager.h"
#import <AMapLocationKit/AMapLocationKit.h>
#import <CoreLocation/CoreLocation.h>
#import <SystemConfiguration/CaptiveNetwork.h>

#import "PLPDistributionNetworkPopupsView.h"
#import "SYAlertView.h"

@interface KDSAMapLocationManager ()<AMapLocationManagerDelegate,CLLocationManagerDelegate>
///定位管理者
@property (nonatomic, strong) CLLocationManager * kdsLocationManager;
///添加成功之后弹出的提示设置开关的视图
@property (nonatomic, strong) PLPDistributionNetworkPopupsView *successShowView;
@property (nonatomic, strong) SYAlertView *alertView;

@end

@implementation KDSAMapLocationManager

+ (instancetype)sharedManager
{
    static KDSAMapLocationManager *_manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[KDSAMapLocationManager alloc] init];
    });
    return _manager;
}

- (void)initWithLocationManager
{
    CGFloat version = [[UIDevice currentDevice].systemVersion doubleValue];//float
    if(!_kdsLocationManager){
        
        // 初始化定位管理器
        _kdsLocationManager = [[CLLocationManager alloc] init];
        // 设置代理
        _kdsLocationManager.delegate = self;
        // 设置定位精确度到米
        _kdsLocationManager.desiredAccuracy = kCLLocationAccuracyBest;
        // 设置过滤器为无
        _kdsLocationManager.distanceFilter = kCLDistanceFilterNone;
        
        if(version > 8.0f){
            [_kdsLocationManager requestWhenInUseAuthorization]; //这句话ios8以上版本使用。
        }
        [_kdsLocationManager startUpdatingLocation];
        NSDictionary *netInfo = [self fetchNetInfo];
//        NSLog(@"提示提示提示提示提示睡一会：%@",netInfo);
        if (![[netInfo objectForKey:@"SSID"] hasPrefix:@"kaadas_"]) {
//            NSLog(@"中国中国中国中国%@",netInfo);
            self.originalSsid = [netInfo objectForKey:@"SSIDDATA"];
            self.ssid = [netInfo objectForKey:@"SSID"];
            self.bssid = [netInfo objectForKey:@"BSSID"];
        }
        
    }else{
        [self checkPermissions];
    }
   
}

-(void)checkPermissions{
    
    if (![KDSTool determineWhetherTheAPPOpensTheLocation]){
            UIViewController *rootViewController = [[[UIApplication sharedApplication] keyWindow] rootViewController];
        
        self.alertView.animation = nil;
        self.alertView.addDevicecontainerView.frame = CGRectMake(0, 0, KDSScreenWidth, KDSScreenHeight);
        self.successShowView.tipsLable.text = @"开启定位";
        self.successShowView.image.image = [UIImage  imageNamed:@"philips_dms_img_Positioning"];
        [self.successShowView.image  mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@150);
            make.width.equalTo(@52);
        }];
        self.successShowView.desLablel.text = @"请开启定位服务，否则无法添加门锁";
        [self.successShowView.leftBtn  setTitle:@"取消" forState:UIControlStateNormal];
        [self.successShowView.rightBtn setTitle:@"设置" forState:UIControlStateNormal];
        [self.alertView.addDevicecontainerView addSubview:self.successShowView];
        [self.successShowView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.right.equalTo(rootViewController.view);
        }];
        [self.alertView show];
//        UIAlertController * alerVC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请到设置->隐私->定位服务中开启【凯迪仕智能】定位服务，否则无法添加设备" preferredStyle:UIAlertControllerStyleAlert];
//
//        UIAlertAction * sureAction = [UIAlertAction actionWithTitle:Localized(@"sure") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            [KDSNotificationCenter postNotificationName:@"didOpenAutoLock" object:nil userInfo:nil];
//            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
//        }];
//
//        UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:Localized(@"cancel") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        }];
//        [alerVC addAction:cancleAction];
//        [alerVC addAction:sureAction];
//        UIViewController *rootViewController = [[[UIApplication sharedApplication] keyWindow] rootViewController];
        
       // [rootViewController presentViewController:alerVC animated:YES completion:nil];
        self.originalSsid = @"";
        self.ssid = @"";
        self.bssid = @"";
//        NSLog(@"提示提示提示提示提示睡一会");
    }else{
        NSDictionary *netInfo = [self fetchNetInfo];
//        NSLog(@"提示提示提示提示提示睡一会：%@",netInfo);
        if (![[netInfo objectForKey:@"SSID"] hasPrefix:@"kaadas_"]) {
//            NSLog(@"中国中国中国中国%@",netInfo);
            self.originalSsid = [netInfo objectForKey:@"SSIDDATA"];
            self.ssid = [netInfo objectForKey:@"SSID"];
            self.bssid = [netInfo objectForKey:@"BSSID"];
        }
        
    }
}
- (NSString *)fetchSsid
{
    NSDictionary *ssidInfo = [self fetchNetInfo];
    
    return [ssidInfo objectForKey:@"SSID"];
}

- (NSString *)fetchBssid
{
    NSDictionary *bssidInfo = [self fetchNetInfo];
    return [bssidInfo objectForKey:@"BSSID"];
}

- (NSDictionary *)fetchNetInfo
{
    NSArray *interfaceNames = CFBridgingRelease(CNCopySupportedInterfaces());
    NSDictionary *SSIDInfo;
    for (NSString *interfaceName in interfaceNames) {
        SSIDInfo = CFBridgingRelease(
                                     CNCopyCurrentNetworkInfo((__bridge CFStringRef)interfaceName));
        
        BOOL isNotEmpty = (SSIDInfo.count > 0);
        if (isNotEmpty) {
            break;
        }
    }
    return SSIDInfo;
}
#pragma mark  -  lazy
- (PLPDistributionNetworkPopupsView *)successShowView
{
    __weak typeof(self) weakSelf = self;
    if (_successShowView == nil) {
        _successShowView = [[PLPDistributionNetworkPopupsView alloc] init];
        _successShowView.cancelBtnClickBlock = ^{//重新输入
            [weakSelf.alertView hide];
            KDSLog(@" xxxx 点击了重新输入密码  重新输入密码");
          
        };
        _successShowView.settingBtnClickBlock = ^{// 忘记密码
            [weakSelf.alertView hide];
            KDSLog(@" xxxx  点击了忘记密码");
           
                [KDSNotificationCenter postNotificationName:@"didOpenAutoLock" object:nil userInfo:nil];
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                
           
        };
    }
    return _successShowView;
}

- (SYAlertView *)alertView
{
    if (_alertView == nil) {
        _alertView = [[SYAlertView alloc] init];
        _alertView.isAnimation = YES;
        _alertView.userInteractionEnabled = YES;
    }
    return _alertView;
}




@end
