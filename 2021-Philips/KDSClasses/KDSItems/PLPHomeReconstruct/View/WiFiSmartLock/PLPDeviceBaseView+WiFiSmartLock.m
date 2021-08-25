//
//  PLPDeviceBaseView+WiFiSmartLock.m
//  2021-Philips
//
//  Created by Apple on 2021/6/8.
//  Copyright © 2021 com.Kaadas. All rights reserved.
//

#import "PLPDeviceBaseView+WiFiSmartLock.h"
#import "PLPDevice+WiFiSmartLockDeviceViewDataSource.h"
#import "PLPConfigUtils.h"
#import "PLPDevice+WiFiSmartLockDeviceViewDataSource.h"
#import "PLPProductDeviceCommon.h"

@implementation PLPDeviceBaseView (WiFiSmartLock)

//加载内容视图
-(void) loadNibNamedView {
    //加载对应的视图
    NSString *nibNamed = self.productViewType == PLPProductViewTypeCard ? @"PLPDeviceCardWiFiSmartLockView" : @"PLPDeviceDashboardWiFiSmartLockView";
    
    [[NSBundle mainBundle] loadNibNamed:nibNamed owner:self options:nil];
    
    [self addSubview:self.contentView];
}
//配置设备UI交互按钮
-(void) configureActionsView {
    //配置设备UI交互动作布局与回调，actionsView 通过xib创建生成
    if (self.actionsView) {
        //指定单元格nib与注册
        NSString *cellNib;
       
        cellNib = self.productViewType == PLPProductViewTypeCard ?  @"PLPDeviceCardUIActionCell" : @"PLPDeviceDashboardUIActionCell";
        self.actionsView.backgroundColor = self.contentView.backgroundColor;
        [self.actionsView registerNib:[UINib nibWithNibName:cellNib bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:PLPDeviceUIActionsDefaultCellWithReuseIdentifier];
        __weak __typeof(self)weakSelf = self;
        //按钮回调给委托
        self.actionsView.didSelectRowBlock = ^(PLPDeviceUIAction * _Nonnull item) {
            [weakSelf callbackActionDelegateWithActionType:item.actionType];
        };
        
    }
}

//更新设备UI交互按钮数据源
-(void) updateActionsViewData {
    if (self.actionsView && self.device) {
        self.actionsView.actionsDataSource = [PLPConfigUtils actionsFromDevice:self.device viewType:self.productViewType];
        [self.actionsView reloadData];
    }
}
//更新设备图标
-(void) updateDeivceImage {
    if (self.device) {
        //todo  缺省图片名称
        NSString *imageName;
        switch (self.productViewType) {
            case PLPProductViewTypeCell:
                imageName = [self.device plpDeviceViewListImageName];
                break;
            case PLPProductViewTypeCard:
                imageName = [self.device plpDeviceViewCardImageName];
                break;
            case PLPProductViewTypeDashboard:
                imageName = [self.device plpDeviceViewDashboardImageName];
                break;
                
            default:
                imageName = kPLPProductDefaultDeviceImage;
                break;
        }
        
        /***************************显示锁图片时候赋值方式************************************/
        //[self.ivDevice setImage:[UIImage imageNamed:imageName]];
        /***********************************************************************************/
        self.ivDevice.image = [UIImage imageNamed:@"philips_home_icon_video_list-1"];//默认摄像头图标
    }
}
/// 更新电量
-(void) updateBatteryImage {
    PLPDevice *device = (PLPDevice *)self.device;
    NSInteger power = [device plpWiFiSmartLockDevicePower];
    NSString *imageName;
    if (power<31) {
        imageName =  @"philips_home_iocn_battery_0";
    }else if (power<61) {
        imageName = @"philips_home_iocn_battery_1";
    }else if (power<91) {
        imageName = @"philips_home_iocn_battery_2";
    }else {
        imageName = @"philips_home_iocn_battery_3";
    }
    [self.ivBattery setImage:[UIImage imageNamed:imageName]];
}

/// 更新状态或模式
/// @param label 标签
-(void) updateWiFiSmartLockModelLable:(UILabel *) label {
    NSString *text;

    if ([self.device plpOldDeviceType] == PLPOldDeviceTypeWifiLockModel) {
        PLPDevice *device = (PLPDevice *)self.device;
        KDSLockState lockState = [device plpWiFiSmartLockDeviceLockState];
        
        switch (lockState) {
            case KDSLockStateDefence: {
                text = NSLocalizedString(@"布防模式", nil);
            }
                break;
            case KDSLockStateLockInside:
                text = NSLocalizedString(@"反锁模式", nil);
                break;
            case KDSLockStateSecurityMode:
                text = NSLocalizedString(@"安全模式", nil);

                break;
            case KDSLockStateEnergy:
                text = NSLocalizedString(@"节能模式", nil);
                break;
            case KDSLockStateFaceTurnedOff:
                text = NSLocalizedString(@"节能模式", nil);

                break;
            case KDSLockStateNormal:
                text = NSLocalizedString(@"正常模式", nil);
                break;
            default:{
                NSLog(@"%d",lockState);
            }
                break;
        }
        
    }
    
    label.text = text;
}

-(void) updateLastUnlockRecordLabel {
    
    if (self.device) {
        PLPDevice *device = (PLPDevice *)self.device;

        KDSWifiLockOperation *record = [device plpWiFiSmartLockDeviceLastUnlockRecord];
        //todo 优化显示
        NSString *text;
        if (record.type == PLPDeviceTypeOpenLock) {
            switch (record.pwdType) {
                case PLPPwdTypePwd:
                {
                    if (record.pwdNum == 252) {
                        text = Localized(@"MessageRecord_Temporary_Unlocking");//临时密码开锁
                    }else if (record.pwdNum == 250){
                        text = Localized(@"MessageRecord_Temporary_Unlocking");
                    }else if (record.pwdNum == 253){
                        text = Localized(@"MessageRecord_Visitor_Unlocking");
                    }else if (record.pwdNum == 254){
                        text = Localized(@"MessageRecord_Admin_Unlocking");
                    }
                    
                    //NSString * tempString = [NSString stringWithFormat:@"%@密码开锁",record.userNickname] ?: [NSString stringWithFormat:@"编号%02d的密码开锁",record.pwdNum];
                    //text =  record ? [NSString stringWithFormat:@"%@ %@",record.date,tempString] : nil;
                }
                    break;
                case PLPPwdTypeCard:
                {
                    NSString * tempString = [NSString stringWithFormat:@"%@卡片开锁",record.userNickname] ?: [NSString stringWithFormat:@"编号%02d的卡片开锁",record.pwdNum];
                    text =  record ? [NSString stringWithFormat:@"%@ %@",record.date,tempString] : nil;
                }
                    break;
                case PLPPwdTypeFp:
                {
                    NSString * tempString = [NSString stringWithFormat:@"%@指纹开锁",record.userNickname] ?: [NSString stringWithFormat:@"编号%02d的指纹开锁",record.pwdNum];
                    text =  record ? [NSString stringWithFormat:@"%@ %@",record.date,tempString] : nil;
                }
                    break;
                case PLPPwdTypeFace:
                {
                    NSString * tempString = [NSString stringWithFormat:@"%@面容开锁",record.userNickname] ?: [NSString stringWithFormat:@"编号%02d的面容开锁",record.pwdNum];
                    text =  record ? [NSString stringWithFormat:@"%@ %@",record.date,tempString] : nil;
                }
                    break;
                case PLPPwdTypeApp:
                {
                    NSString * tempString = @"App开锁";
                    text =  record ? [NSString stringWithFormat:@"%@ %@",record.date,tempString] : nil;
                }
                    break;
                case PLPPwdTypeMechanicalKey:
                {
                    NSString * tempString = @"机械钥匙开锁";
                    text =  record ? [NSString stringWithFormat:@"%@ %@",record.date,tempString] : nil;
                }
                    break;
                case PLPPwdTypeIndoorOpenLock:
                {
                    NSString * tempString = @"室内多功能键开锁";
                    text =  record ? [NSString stringWithFormat:@"%@ %@",record.date,tempString] : nil;
                }
                    break;
                case PLPPwdTypeIndoorInductionHand:
                {
                    NSString * tempString = @"室内感应把手开锁";
                    text =  record ? [NSString stringWithFormat:@"%@ %@",record.date,tempString] : nil;
                }
                    break;
                    
                default:
                {
                    NSString * tempString = @"未定义";
                    text =  record ? [NSString stringWithFormat:@"%@ %@",record.date,tempString] : nil;
                }
                    break;
            }
            
        }else if (record.type == PLPDeviceTypeUnLock){
            text = [NSString stringWithFormat:@"门锁已上锁 %@",record.date];
        }else if (record.type == PLPDeviceTypeAddKey){
            switch (record.pwdType) {
                case PLPPwdTypePwd:
                    text = [NSString stringWithFormat:@"门锁添加编号%02d密码 %@",record.pwdNum,record.date];
                    break;
                case PLPPwdTypeCard:
                    text = [NSString stringWithFormat:@"门锁添加编号%02d卡片 %@",record.pwdNum,record.date];
                    break;
                case PLPPwdTypeFp:
                    text = [NSString stringWithFormat:@"门锁添加编号%02d指纹 %@",record.pwdNum,record.date];
                    break;
                case PLPPwdTypeFace:
                    text = [NSString stringWithFormat:@"门锁添加编号%02d面容识别 %@",record.pwdNum,record.date];
                    break;
                    
                default:
                    text = [NSString stringWithFormat:@"添加密钥 %@",record.date];
                    break;
            }
        }else if (record.type == PLPDeviceTypeDelKey){
            switch (record.pwdType) {
                case PLPPwdTypePwd:
                {
                    if (record.pwdNum == 255) {
                         text = [NSString stringWithFormat:@"门锁删除所有密码 %@",record.date];
                     }else{
                         text = [NSString stringWithFormat:@"门锁删除编号%02d密码 %@",record.pwdNum,record.date];
                     }
                }
                    break;
                case PLPPwdTypeCard:
                {
                    if (record.pwdNum == 255) {
                        text = [NSString stringWithFormat:@"门锁删除所有卡片 %@",record.date];
                    }else{
                        text = [NSString stringWithFormat:@"门锁删除编号%02d卡片 %@",record.pwdNum,record.date];
                    }
                }
                    break;
                case PLPPwdTypeFp:
                {
                    if (record.pwdNum == 255) {
                        text = [NSString stringWithFormat:@"门锁删除所有指纹 %@",record.date];
                    }else{
                        text = [NSString stringWithFormat:@"门锁删除编号%02d指纹 %@",record.pwdNum,record.date];
                    }
                }
                    break;
                case PLPPwdTypeFace:
                {
                    if (record.pwdNum == 255) {
                        text = [NSString stringWithFormat:@"门锁删除所有面容识别 %@",record.date];
                    }else{
                        text = [NSString stringWithFormat:@"门锁删除编号%02d面容识别 %@",record.pwdNum,record.date];
                    }
                }
                    break;
                    
                default:
                    text = [NSString stringWithFormat:@"删除密钥 %@",record.date];
                    break;
            }
            
        }else if (record.type == PLPDeviceTypeChangeAdmin){
            text = [NSString stringWithFormat:@"门锁修改管理员密码 %@",record.date];
        }else if (record.type == PLPDeviceTypeAutomaticMode){
            text = [NSString stringWithFormat:@"门锁切换自动模式 %@",record.date];
        }else if (record.type == PLPDeviceTypeManualMode){
            text = [NSString stringWithFormat:@"门锁切换手动模式 %@",record.date];
        }else if (record.type == PLPDeviceTypeCommonModeSwitching){
            text = [NSString stringWithFormat:@"门锁切换常用模式 %@",record.date];
        }else if (record.type == PLPDeviceTypeSafeModeSwitching){
            text = [NSString stringWithFormat:@"门锁切换安全模式 %@",record.date];
        }else if (record.type == PLPDeviceTypeLockedMode){
            text = [NSString stringWithFormat:@"门锁启动反锁模式 %@",record.date];
        }else if (record.type == PLPDeviceTypeProtectionMode){
            text = [NSString stringWithFormat:@"门锁启动布防模式 %@",record.date];
        }else if (record.type == PLPDeviceTypeChangePwdNickname){
            ///更改01密码昵称为妈妈
            switch (record.pwdType) {
                case PLPPwdTypePwd:
                    text = [NSString stringWithFormat:@"更改编号%02d密码昵称为%@ %@",record.pwdNum,record.pwdNickname,record.date];
                    break;
                case PLPPwdTypeCard:
                    text = [NSString stringWithFormat:@"更改编号%02d卡片昵称为%@ %@",record.pwdNum,record.pwdNickname,record.date];
                    break;
                case PLPPwdTypeFp:
                    text = [NSString stringWithFormat:@"更改编号%02d指纹昵称为%@ %@",record.pwdNum,record.pwdNickname,record.date];
                    break;
                case PLPPwdTypeFace:
                    text = [NSString stringWithFormat:@"更改编号%02d面容识别昵称为%@ %@",record.pwdNum,record.pwdNickname,record.date];
                    break;
                default:
                    break;
            }
        }else if (record.type == PLPDeviceTypeAddSharingUser){
            ///添加明明为门锁授权使用
            text = [NSString stringWithFormat:@"授权%@使用门锁 %@",record.shareUserNickname ?: record.shareAccount,record.date];
            
        }else if (record.type == PLPDeviceTypeDelSharingUsers){
            ///删除明明为门锁授权使用
            text = [NSString stringWithFormat:@"删除%@使用门锁 %@",record.shareUserNickname ?: record.shareAccount,record.date];
        }else if (record.type == PLPDeviceTypeModifyManagementFp){
            ///修改管理指纹
            text =  [NSString stringWithFormat:@"门锁修改管理员指纹 %@",record.date];
        }else if (record.type == PLPDeviceTypeAddAdminiFp){
            text = [NSString stringWithFormat:@"门锁添加管理员指纹 %@",record.date];
        }else if (record.type == PLPDeviceTypeTurnEnergyMode){
            text = [NSString stringWithFormat:@"门锁启动节能模式 %@",record.date];
        }else if (record.type == PLPDeviceTypeOffEnergyMod){
            text =[NSString stringWithFormat: @"门锁关闭节能模式 %@",record.date];
        }else{
            //text = [NSString stringWithFormat:@"%@ %@",Localized(@"未知操作"),record.date];
        }
        self.labSubTitle.text = text;
    }else {
        NSLog(@"error");
    }
        
    
   
}
-(IBAction) btnOpenVideoAction:(id) sender {
    [self callbackActionDelegateWithActionType:PLPDeviceUIActionTypeOpenVideo];
}

-(IBAction) btnModelHelpAction:(id) sender {
    [self callbackActionDelegateWithActionType:PLPDeviceUIActionTypeHelp];
}

/// 显示设置
/// @param sender 按钮
-(IBAction) btnSettingAction:(id) sender {
    [self callbackActionDelegateWithActionType:PLPDeviceUIActionTypeSetting];

}
@end
