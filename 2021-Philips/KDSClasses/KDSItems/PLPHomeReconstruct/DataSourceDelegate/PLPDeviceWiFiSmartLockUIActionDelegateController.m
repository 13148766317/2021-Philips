//
//  PLPDeviceUIController.m
//  Pages
//
//  Created by Apple on 2021/5/25.
//

#import "PLPDeviceWiFiSmartLockUIActionDelegateController.h"

#import "PLPDevice.h"
#import "PLPDevice+Compatible.h"

#import "PLPDeviceDashboardVC.h"

#import "KDSMediaLockMoreSettingVC.h"
#import "KDSMediaLockRecordDetailsVC.h"
#import "KDSMyAlbumVC.h"
#import "KDSWifiLockPwdListVC.h"
#import "KDSLockKeyVC.h"
#import "PLPUnlockModelViewController.h"
#import "PLPCompatibleDeviceVCProtocol.h"
#import "PLPVideoDeviceViewController.h"
#import "KDSMediaLockParamVC.h"
#import "PLPDeleteAlertView.h"
#import "KDSHttpManager+VideoWifiLock.h"
#import "KDSUserManager.h"
#import "KDSXMMediaLockHelpVC.h"

@interface PLPDeviceWiFiSmartLockUIActionDelegateController ()

@property(nonatomic, strong) PLPDeleteAlertView *deleteAlertView;
@property(nonatomic, weak) PLPDevice  *device;
@end
@implementation PLPDeviceWiFiSmartLockUIActionDelegateController

#pragma mark - PLPDeviceViewActionDelegateProtocol

//回调用户交互动作类别
-(void) deviceView:(PLPDeviceBaseView *) deviceView actionType:(PLPDeviceUIActionType) actionType {
    
    if (actionType == PLPDeviceUIActionTypeOpenVideo) {
        
        if ([[deviceView device] plpOldDeviceType] == PLPOldDeviceTypeWifiLockModel && ((KDSWifiLockModel *)[deviceView.device plpOldDevice]).distributionNetwork == 3 &&  ((KDSWifiLockModel *)[deviceView.device plpOldDevice]).powerSave.intValue == 1) {
            ///锁已开启节能模式，无法查看门外情况
            UIAlertController * alerVC = [UIAlertController alertControllerWithTitle:Localized(@"PowerSavingMode_UnableToViewOutside") message:Localized(@"ReplaceBattery") preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *retryAction = [UIAlertAction actionWithTitle:Localized(@"sure") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            //修改title Font
            NSMutableAttributedString *alertTitleStr = [[NSMutableAttributedString alloc] initWithString:Localized(@"PowerSavingMode_UnableToViewOutside")];
            [alertTitleStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(0, alertTitleStr.length)];
            [alerVC setValue:alertTitleStr forKey:@"attributedTitle"];

            //修改message Font
            NSMutableAttributedString *alertControllerMessageStr = [[NSMutableAttributedString alloc] initWithString:Localized(@"ReplaceBattery")];
            [alertControllerMessageStr addAttribute:NSForegroundColorAttributeName value:KDSRGBColor(153, 153, 153) range:NSMakeRange(0, alertControllerMessageStr.length)];
            [alertControllerMessageStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:11] range:NSMakeRange(0, alertControllerMessageStr.length)];
            
            [alerVC setValue:alertControllerMessageStr forKey:@"attributedMessage"];
            [retryAction setValue:KDSRGBColor(32, 150, 248) forKey:@"titleTextColor"];
            
            [alerVC addAction:retryAction];
            [self.parentVC presentViewController:alerVC animated:YES completion:nil];
            return;
        }
    }else if (actionType == PLPDeviceUIActionTypeShareDelete) {
        self.device = (PLPDevice *)deviceView.device;
        [self.deleteAlertView show];
        return;
    }
    
    if (!self.parentVC.navigationController) {
        return;
    }
    
    [PLPDeviceWiFiSmartLockUIActionDelegateController pushDevice:deviceView.device actionType:actionType navVc:self.parentVC.navigationController];
}


- (PLPDeleteAlertView *)deleteAlertView {
    if (!_deleteAlertView) {
        self.deleteAlertView = [[PLPDeleteAlertView alloc] init];
        __weak __typeof(self)weakSelf = self;
        _deleteAlertView.confirmedBlock = ^(BOOL isConfirmed) {
            
            if (isConfirmed) {
                [weakSelf deleteBindedDevice];
            }
            [weakSelf releaseDeleteAlertView];
            
        };
    }
    return _deleteAlertView;
}


/// 清理删除确认view
-(void) releaseDeleteAlertView {
    if (_deleteAlertView) {
        //_deleteAlertView.confirmedBlock = nil;
        _deleteAlertView = nil;
    }
}
    
#pragma mark -删除绑定的设备
- (void)deleteBindedDevice
{
    MBProgressHUD *hud = [MBProgressHUD showMessage:Localized(@"deleting") toView:self.parentVC.view];
    __weak __typeof(self)weakSelf = self;
    [[KDSHttpManager sharedManager] unbindXMMediaWifiDeviceWithWifiSN:[self.device getWiFiSN]  uid:[KDSUserManager sharedManager].user.uid success:^{
        [hud hideAnimated:YES];
        [MBProgressHUD showSuccess:Localized(@"deleteSuccess")];
        [[NSNotificationCenter defaultCenter] postNotificationName:KDSLockHasBeenDeletedNotification object:nil userInfo:@{@"lock" : [self.device plpLockWithOldDevice]}];
        [weakSelf.parentVC.navigationController popToRootViewControllerAnimated:YES];
    } error:^(NSError * _Nonnull error) {
        [hud hideAnimated:YES];
        [MBProgressHUD showError:[Localized(@"deleteFailed") stringByAppendingFormat:@", %@", error.localizedDescription]];
    } failure:^(NSError * _Nonnull error) {
        [hud hideAnimated:YES];
        [MBProgressHUD showError:[Localized(@"deleteFailed") stringByAppendingFormat:@", %@", error.localizedDescription]];
    }];
}

/// 显示设备交互对应视图控制器
/// @param device 设备
/// @param actionType 交互类型
/// @param navVc 导航控制器
+(UIViewController * ) pushDevice:(id<PLPDeviceProtocol>) device actionType:(PLPDeviceUIActionType) actionType navVc:(UINavigationController *) navVc {
    
    UIViewController *vc;
    //原来的
    BOOL compatibleVC = YES;
    
    switch (actionType) {
        case PLPDeviceUIActionTypeSetting://设置
            vc = [[KDSMediaLockMoreSettingVC alloc] init];
            break;
        case PLPDeviceUIActionTypeMessage://消息记录跳转
            vc = [[KDSMediaLockRecordDetailsVC alloc] init];
            break;
        case PLPDeviceUIActionTypeKeys://密匙
            vc = [[PLPUnlockModelViewController alloc] init];
            break;
        case PLPDeviceUIActionTypeShare: {//分享
            KDSLockKeyVC *shareVC =  [[KDSLockKeyVC alloc] init];
            shareVC.keyType = KDSBleKeyTypeReserved;
            vc = shareVC;
        }
            break;
        case PLPDeviceUIActionTypeMore: {
            PLPDeviceDashboardVC *dashboardVC = [[PLPDeviceDashboardVC alloc] init];
            vc = dashboardVC;
            compatibleVC = NO;
            /*
            if (1) {
                PLPDeviceDashboardVC *dashboardVC = [[PLPDeviceDashboardVC alloc] init];
                vc = dashboardVC;
                compatibleVC = NO;
            }else {
                vc = [[PLPVideoDeviceViewController alloc] init];
            }*/
        }
            break;
        case PLPDeviceUIActionTypePhotos: {//相册
            vc = [[KDSMyAlbumVC alloc] init];
        }
            break;
        case PLPDeviceUIActionTypeOpenVideo: {//打开视频
            XMPlayController * xmPlayVC = [[XMPlayController alloc] initWithType:XMPlayTypeLive];
            xmPlayVC.isActive = YES;
            vc = xmPlayVC;
        }
            break;
        case PLPDeviceUIActionTypeShareSetting: {
            //分享用户设置
            vc = [[KDSMediaLockParamVC alloc] init];
            
            
        }
            break;
        case PLPDeviceUIActionTypeHelp:{
            vc = [[KDSXMMediaLockHelpVC alloc] init];
            
        }
            break;
            
        default: {
            vc = [[PLPDeviceVC alloc] init];
            compatibleVC = NO;

        }
            break;
    }
    if (vc) {
        //使用原有功能控制器
        if (compatibleVC) {
            UIViewController <PLPCompatibleDeviceVCProtocol> *temp = (UIViewController <PLPCompatibleDeviceVCProtocol> *)vc;
            //
            //生成原有设备对象，并赋值给控制器
            KDSLock *lock;
            if (device && [device conformsToProtocol:@protocol(PLPDeviceProtocol)] && [device plpOldDevice]) {
                
                lock  = [device plpLockWithOldDevice];
            }
            
            if (!lock) {
                //如果为空，重新生成；避免视图控制器空值出错
                lock = [[KDSLock alloc] init];
            }
            temp.lock = lock;
            
        }else {
            UIViewController <PLPDeviceVCProtocol> *temp = (UIViewController <PLPDeviceVCProtocol> *) vc;
            temp.device = device;
            
        }
        vc.hidesBottomBarWhenPushed = YES;
        
    }
    [navVc pushViewController:vc animated:YES];
    return vc;
}
@end
