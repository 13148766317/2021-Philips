//
//  PLPDeviceBaseView.h
//  Pages
//
//  Created by Apple on 2021/5/19.
//

#import <UIKit/UIKit.h>
#import "PLPDeviceViewConfigProtocol.h"
#import "PLPProductDeviceCommon.h"
#import "PLPDeviceProtocol.h"
#import "PLPDeviceUIActionsCollectionView.h"


NS_ASSUME_NONNULL_BEGIN

@protocol PLPDeviceViewActionDelegateProtocol;

//设备基本视图
//IB_DESIGNABLE
@interface PLPDeviceBaseView : UIView <PLPDeviceViewConfigProtocol>
//关联设备
@property(nonatomic, strong) id<PLPDeviceProtocol> device;
//对应产品视图类别 PLPProductViewType
@property(nonatomic, assign) PLPProductViewType productViewType;
//设备UI交互动作委托
@property(nonatomic, weak) id<PLPDeviceViewActionDelegateProtocol> actionDelegate;

//容器视图
@property (strong, nonatomic) IBOutlet UIView *contentView;

//设备图像
@property(nonatomic, weak) IBOutlet UIImageView *ivDevice;
//设备名称
@property(nonatomic, weak) IBOutlet UILabel *labName;
//设备副标题
@property(nonatomic, weak) IBOutlet UILabel *labSubTitle;
//设备连网
@property(nonatomic, weak) IBOutlet UIImageView *ivWiFi;
//设备电量
@property(nonatomic, weak) IBOutlet UIImageView *ivBattery;

//设备UI交互按钮
@property(nonatomic, weak) IBOutlet PLPDeviceUIActionsCollectionView *actionsView;

//设备UI交互按钮布局
@property(nonatomic, strong) UICollectionViewFlowLayout *actionsViewCollectionViewFlowLayout;

/// 回调动作代理
/// @param actionType 动作类型
-(void) callbackActionDelegateWithActionType:(PLPDeviceUIActionType) actionType;

@end

@protocol PLPDeviceViewActionDelegateProtocol <NSObject>
//回调用户交互动作类别，处理交互事件
-(void) deviceView:(PLPDeviceBaseView *) deviceView actionType:(PLPDeviceUIActionType) actionType;

/// 显示设备交互对应视图控制器
/// @param device 设备
/// @param actionType 交互类型
/// @param navVc 导航控制器
+(UIViewController * ) pushDevice:(id<PLPDeviceProtocol>) device actionType:(PLPDeviceUIActionType) actionType navVc:(UINavigationController *) navVc;
@end

NS_ASSUME_NONNULL_END
