//
//  PLPDeviceBaseView+WiFiSmartLock.h
//  2021-Philips
//
//  Created by Apple on 2021/6/8.
//  Copyright © 2021 com.Kaadas. All rights reserved.
//

#import "PLPDeviceBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface PLPDeviceBaseView (WiFiSmartLock)
//加载内容视图
-(void) loadNibNamedView;
//配置设备UI交互按钮
-(void) configureActionsView;

//更新设备UI交互按钮数据源
-(void) updateActionsViewData;
//更新设备图标
-(void) updateDeivceImage;

/// 更新电量
-(void) updateBatteryImage;


/// 更新状态或模式
/// @param label 标签
-(void) updateWiFiSmartLockModelLable:(UILabel *) label;


/// 更新开锁记录
-(void) updateLastUnlockRecordLabel;

/// 进行视频
/// @param sender 按钮
-(IBAction) btnOpenVideoAction:(id) sender;

/// 显示帮助
/// @param sender 按钮
-(IBAction) btnModelHelpAction:(id) sender;

/// 显示设置
/// @param sender 按钮
-(IBAction) btnSettingAction:(id) sender;

-(IBAction) btnSHAREDELETEAction:(id) sender ;
@end

NS_ASSUME_NONNULL_END
