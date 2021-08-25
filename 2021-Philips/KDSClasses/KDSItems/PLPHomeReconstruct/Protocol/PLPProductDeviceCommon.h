//
//  PLPProductDeviceCommon.h
//  Pages
//
//  Created by Apple on 2021/5/19.
//

#ifndef PLPProductDeviceCommon_h
#define PLPProductDeviceCommon_h

//产品类别
typedef NS_ENUM(NSUInteger, PLPProductCategory) {
    //没有定义
    PLPProductCategoryNotDefined = 0,
    //智能锁
    PLPProductCategoryWiFiSmartLock = 1 << 0,
    //晾衣机
    PLPProductCategorySmartHanger = 1 << 1,
    //门铃
    PLPProductCategoryDoorbell = 1 << 2,
    //所有类别
    PLPProductCategoryAll = (PLPProductCategoryWiFiSmartLock | PLPProductCategorySmartHanger | PLPProductCategoryDoorbell),
};

//产品设备视图类别
typedef NS_ENUM(NSUInteger, PLPProductViewType) {
    PLPProductViewTypeNone = 0,
    //单元格，用于列表
    PLPProductViewTypeCell = 1,
    //卡片
    PLPProductViewTypeCard = 2,
    //主界面
    PLPProductViewTypeDashboard = 3
};

//设备UI交互动作
typedef NS_ENUM(NSUInteger, PLPDeviceUIActionType) {
    //设置
    PLPDeviceUIActionTypeSetting,
    //消息
    PLPDeviceUIActionTypeMessage,
    //密钥
    PLPDeviceUIActionTypeKeys,
    //分享
    PLPDeviceUIActionTypeShare,
    //更多
    PLPDeviceUIActionTypeMore,
    //相册
    PLPDeviceUIActionTypePhotos,
    //视频
    PLPDeviceUIActionTypeOpenVideo,
    //帮助
    PLPDeviceUIActionTypeHelp,
    //分享用户设置功能
    PLPDeviceUIActionTypeShareSetting,
    //分享用户删除
    PLPDeviceUIActionTypeShareDelete,
};
//原设备class类型
typedef NS_ENUM(NSUInteger, PLPOldDeviceType) {
    //没有定义
    PLPOldDeviceTypeNone = 0,
    //MyDevice 门锁设备模型
    PLPOldDeviceTypeMyDevice,
    //KDSDeviceHangerModel
    PLPOldDeviceTypeHanger,
    //KDSWifiLockModel
    PLPOldDeviceTypeWifiLockModel,
    //GatewayDeviceModel 网关、网关锁、猫眼
    PLPOldDeviceTypeGateway,
    //KDSDevSwithModel Wi-Fi锁下面的单火开关
    PLPOldDeviceTypeSwith,
    //本地网关模型
    PLPOldDeviceTypeGw
};

//设备通知类型
typedef NS_ENUM(NSUInteger, PLPDeviceNotificationType) {
    //没有定义
    PLPDeviceNotificationTypeNone,
    //设备列表变化
    PLPDeviceNotificationTypeDeviceListChange,
    //添加设备
    PLPDeviceNotificationTypeAddDevice,
    //删除设备
    PLPDeviceNotificationTypeRemoveDevice,
    //设备电量
    PLPDeviceNotificationTypePower,
    //WiFi开锁状态
    PLPDeviceNotificationTypeWiFiLockState,
    //设备名称
    PLPDeviceNotificationTypeName,
    //开锁记录
    PLPDeviceNotificationTypeUnlockRecord
 
};

//记录类型
typedef NS_ENUM(NSUInteger,PLPDeviceOperationType) {
    //没有定义
    PLPDeviceTypeNone = 0,
    ///开锁
    PLPDeviceTypeOpenLock = 1,
    ///关锁
    PLPDeviceTypeUnLock = 2,
    ///添加密钥
    PLPDeviceTypeAddKey = 3,
    ///删除密钥
    PLPDeviceTypeDelKey = 4,
    ///修改管理员密码
    PLPDeviceTypeChangeAdmin = 5,
    ///自动模式
    PLPDeviceTypeAutomaticMode = 6,
    ///手动模式
    PLPDeviceTypeManualMode = 7,
    ///常用模式切换
    PLPDeviceTypeCommonModeSwitching = 8,
    ///安全模式切换
    PLPDeviceTypeSafeModeSwitching = 9,
    ///反锁模式
    PLPDeviceTypeLockedMode = 10,
    ///布防模式
    PLPDeviceTypeProtectionMode = 11,
    ///修改密码昵称
    PLPDeviceTypeChangePwdNickname = 12,
    ///添加分享用户
    PLPDeviceTypeAddSharingUser = 13,
    ///删除分享用户
    PLPDeviceTypeDelSharingUsers = 14,
    ///修改管理指纹
    PLPDeviceTypeModifyManagementFp = 15,
    ///添加管理员指纹
    PLPDeviceTypeAddAdminiFp = 16,
    ///开启节能模式
    PLPDeviceTypeTurnEnergyMode = 17,
    ///关闭节能模式
    PLPDeviceTypeOffEnergyMod = 18
    
    
};

//密码类型
typedef NS_ENUM(NSUInteger,PLPDevicePwdType) {
    ///密码
    PLPPwdTypePwd = 0,
    ///卡片
    PLPPwdTypeCard = 3,
    ///指纹
    PLPPwdTypeFp = 4,
    ///面容识别
    PLPPwdTypeFace = 7,
    ///APP用户
    PLPPwdTypeApp = 8,
    ///机械钥匙
    PLPPwdTypeMechanicalKey = 9,
    ///室内open键开锁
    PLPPwdTypeIndoorOpenLock = 10,
    ///室内感应把手开锁
    PLPPwdTypeIndoorInductionHand = 11
};


//设备列表视图缺省产品图片
#define kPLPProductDefaultDeviceListImage       @"philips_home_icon_video_list"
//设备卡片视图缺省产品图片
#define kPLPProductDefaultDeviceCardImage       @"philips_home_icon_video_card"
//设备缺省产品图片
#define kPLPProductDefaultDeviceImage       @"philips_home_icon_video_list"

#endif

