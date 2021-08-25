//
//  PLPConfigUtils.h
//  Pages
//
//  Created by Apple on 2021/5/19.
//

#import <Foundation/Foundation.h>

#import "PLPDeviceProtocol.h"

#import "PLPDeviceUIAction.h"

NS_ASSUME_NONNULL_BEGIN
extern NSString *const PLPProductViewTypeCellBase;
extern NSString *const PLPProductViewTypeCardBase;
extern NSString *const PLPProductViewTypeDashboardBase;

extern NSString *const PLPProductViewTypeCellWiFiSmartLock;
extern NSString *const PLPProductViewTypeCardWiFiSmartLock;
extern NSString *const PLPProductViewTypeDashboardWiFiSmartLock;

@interface PLPConfigUtils : NSObject

//配置单元格类别的视图class
+(NSMutableDictionary<NSString *,NSString *> *)cellClassesForTypes;

//配置卡片类别的视图class
+(NSMutableDictionary<NSString *,NSString *> *)cardViewClassesForTypes;

//配置主界面类别的视图class
+(NSMutableDictionary<NSString *,NSString *> *)dachboardViewClassesForTypes;

//配置产品id对应列表/卡片/主界面视图类别
+(NSMutableDictionary<NSString *,NSDictionary <NSNumber *, NSString *>*> *) viewTypesForProductids;

//获取产品与指定类别视图class
+(NSString *) viewClassForProductId:(NSString *) productId viewType:(PLPProductViewType)viewType;

//获取设备UI交互动作
+(NSArray<PLPDeviceUIAction *> *) actionsFromDevice:(id<PLPDeviceProtocol>) device viewType:(PLPProductViewType) viewType;

@end

NS_ASSUME_NONNULL_END
