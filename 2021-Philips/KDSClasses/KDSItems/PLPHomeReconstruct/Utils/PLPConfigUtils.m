//
//  PLPConfigUtils.m
//  Pages
//
//  Created by Apple on 2021/5/19.
//

#import "PLPConfigUtils.h"

#import "PLPDeviceBaseCell.h"
#import "PLPDeviceBaseView.h"

#import "PLPDeviceWiFiSmartLockCell.h"
#import "PLPDeviceCardWiFiSmartLockView.h"
#import "PLPDeviceDashboardWiFiSmartLockView.h"

#import "PLPDevice+Compatible.h"

NSString *const PLPProductViewTypeCellBase = @"CellBase";
NSString *const PLPProductViewTypeCardBase = @"CardBase";
NSString *const PLPProductViewTypeDashboardBase = @"DashboardBase";

NSString *const PLPProductViewTypeCellWiFiSmartLock = @"CellWiFiSmartLock";
NSString *const PLPProductViewTypeCardWiFiSmartLock = @"CardWiFiSmartLock";
NSString *const PLPProductViewTypeDashboardWiFiSmartLock = @"DashboardWiFiSmartLock";


@implementation PLPConfigUtils

//配置单元格类别的视图class
+(NSMutableDictionary *)cellClassesForTypes
{
    static NSMutableDictionary * _cellClassesForTypes;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _cellClassesForTypes = [@{PLPProductViewTypeCellBase: [PLPDeviceBaseCell class],
                                  PLPProductViewTypeCellWiFiSmartLock:[PLPDeviceWiFiSmartLockCell class]
        } mutableCopy];
    });
    return _cellClassesForTypes;
}

//配置卡片类别的视图class
+(NSMutableDictionary<NSString *,NSString *> *)cardViewClassesForTypes {
    static NSMutableDictionary * _cardViewClassesForTypes;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _cardViewClassesForTypes = [@{PLPProductViewTypeCardBase: [PLPDeviceBaseView class],
                                      PLPProductViewTypeCardWiFiSmartLock: [PLPDeviceCardWiFiSmartLockView class]
        } mutableCopy];
    });
    return _cardViewClassesForTypes;
}

//配置主界面类别的视图class
+(NSMutableDictionary<NSString *,NSString *> *)dachboardViewClassesForTypes {
    static NSMutableDictionary * _dachboardViewClassesForTypes;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _dachboardViewClassesForTypes = [@{PLPProductViewTypeDashboardBase: [PLPDeviceBaseView class],
                                           PLPProductViewTypeDashboardWiFiSmartLock:[PLPDeviceDashboardWiFiSmartLockView class]
        } mutableCopy];
    });
    return _dachboardViewClassesForTypes;
}

//配置产品id对应列表/卡片/主界面视图类别
+(NSMutableDictionary<NSString *,NSDictionary <NSNumber *, NSString *>*> *) viewTypesForProductids{
    static NSMutableDictionary * _viewTypesForProductids;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _viewTypesForProductids = [@{@"1":[PLPConfigUtils viewTypesCellType:nil cardType:nil dashboardType:nil],
                                     @"2":[PLPConfigUtils viewTypesCellType:nil cardType:nil dashboardType:nil],
                                     @"3":[PLPConfigUtils viewTypesCellType:nil cardType:nil dashboardType:nil],
                                     @"4":[PLPConfigUtils viewTypesCellType:nil cardType:nil dashboardType:nil],
                                     @"5":[PLPConfigUtils viewTypesCellType:nil cardType:nil dashboardType:nil],
                                     @"6":[PLPConfigUtils viewTypesCellType:nil cardType:nil dashboardType:nil],
                                     @"7":[PLPConfigUtils viewTypesCellType:nil cardType:nil dashboardType:nil],
                                     
        } mutableCopy];
    });
    return _viewTypesForProductids;
}

//生成产品对应视图类别字典
+(NSDictionary *) viewTypesCellType:(NSString *) cellType cardType:(NSString *) cardType dashboardType:(NSString *) dashboardType {
    return @{@(PLPProductViewTypeCell):cellType ?: PLPProductViewTypeCellWiFiSmartLock,@(PLPProductViewTypeCard): cardType ? :PLPProductViewTypeCardWiFiSmartLock,@(PLPProductViewTypeDashboard): dashboardType ? :PLPProductViewTypeDashboardWiFiSmartLock};
}

//获取产品与指定类别视图class
+(NSString *) viewClassForProductId:(NSString *) productId viewType:(PLPProductViewType)viewType {
    NSString *result = nil;
    NSDictionary *productViewTypeConfig;
    if (productId) {

        productViewTypeConfig =  [[PLPConfigUtils viewTypesForProductids] objectForKey:productId];
    }
   
    //NSLog(@"%@",[PLPConfigUtils viewTypesForProductids]);
    
    //如果没有，生成缺省的
    if (!productViewTypeConfig) {
        productViewTypeConfig = [PLPConfigUtils viewTypesCellType:nil cardType:nil dashboardType:nil];
    }
    if (productViewTypeConfig) {
        NSString *typeKey = [productViewTypeConfig objectForKey:@(viewType)];
        if (typeKey) {
            switch (viewType) {
                case PLPProductViewTypeCell:
                    result = [[PLPConfigUtils cellClassesForTypes] objectForKey:typeKey];
                    break;
                case PLPProductViewTypeCard:
                    result = [[PLPConfigUtils cardViewClassesForTypes] objectForKey:typeKey];
                    break;
                case PLPProductViewTypeDashboard:
                    result = [[PLPConfigUtils dachboardViewClassesForTypes] objectForKey:typeKey];
                    break;
                default:
                    break;
            }
        }
    }
    
    return result;
}

#pragma mark - 设备UI交互动作对应图标、文字
+(NSDictionary *) deviceActionType:(PLPDeviceUIActionType) actionType title:(NSString *)title cardImageName:(NSString *) cardImageName dashboardImageName:(NSString *) dashboardImageName {
    return @{@"title":title ? :@"", @(PLPProductViewTypeCard): cardImageName ? :@"", @(PLPProductViewTypeDashboard): dashboardImageName ? :@"",@"actionType":@(actionType)};
}

+(NSDictionary *) deviceUIActionsConfig {
    
    return @{
        @(PLPDeviceUIActionTypeMessage): [PLPConfigUtils deviceActionType:PLPDeviceUIActionTypeMessage title:@"消息" cardImageName:@"philips_home_icon_message" dashboardImageName:@"philips_equipment_icon_message"],
        @(PLPDeviceUIActionTypeSetting): [PLPConfigUtils deviceActionType:PLPDeviceUIActionTypeSetting title:@"设置" cardImageName:@"philips_equipment_icon_setting" dashboardImageName:@"philips_equipment_icon_setting"],
        @(PLPDeviceUIActionTypeKeys): [PLPConfigUtils deviceActionType:PLPDeviceUIActionTypeKeys title:@"密钥" cardImageName:@"philips_home_icon_psaaword" dashboardImageName:@"philips_equipment_icon_psaaword"],
        @(PLPDeviceUIActionTypeShare): [PLPConfigUtils deviceActionType:PLPDeviceUIActionTypeShare title:@"分享" cardImageName:@"philips_equipment_icon_share" dashboardImageName:@"philips_equipment_icon_share"],
        @(PLPDeviceUIActionTypeMore): [PLPConfigUtils deviceActionType:PLPDeviceUIActionTypeMore title:@"更多" cardImageName:@"philips_home_icon_more" dashboardImageName:@"philips_home_icon_more"],
        @(PLPDeviceUIActionTypePhotos): [PLPConfigUtils deviceActionType:PLPDeviceUIActionTypePhotos title:@"相册" cardImageName:@"philips_equipment_icon_photo" dashboardImageName:@"philips_equipment_icon_photo"],
        @(PLPDeviceUIActionTypeShareDelete): [PLPConfigUtils deviceActionType:PLPDeviceUIActionTypePhotos title:@"删除" cardImageName:@"philips_equipment_icon_delete" dashboardImageName:@"philips_equipment_icon_delete"],
        @(PLPDeviceUIActionTypeShareSetting): [PLPConfigUtils deviceActionType:PLPDeviceUIActionTypeShareSetting title:@"设置" cardImageName:@"philips_equipment_icon_setting" dashboardImageName:@"philips_equipment_icon_setting"],



    };
}

//获取设备UI交互动作
+(NSArray<PLPDeviceUIAction *> *) actionsFromDevice:(id<PLPDeviceProtocol>) device viewType:(PLPProductViewType) viewType {
    
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    
    if (device ) {
        id<PLPProductInfoProtocol> product = [device plpProduct];
        
        if (product) {
            //todo 根据产品id，生成
            
            NSArray *actions;
            
            PLPDevice *plpDevice = (PLPDevice *) device;
            if (viewType == PLPProductViewTypeCard) {
                
                if ([plpDevice isAdmin]) {
                    actions = @[@(PLPDeviceUIActionTypeMessage),
                                @(PLPDeviceUIActionTypeKeys),
                                @(PLPDeviceUIActionTypeMore)
                    ];
                }else {
                    actions = @[@(PLPDeviceUIActionTypeMessage),
                                @(PLPDeviceUIActionTypeMore)
                    ];
                }
                
            }else if (viewType == PLPProductViewTypeDashboard) {
                if ([plpDevice isAdmin]) {
                    actions = @[
                        @(PLPDeviceUIActionTypeMessage),
                        @(PLPDeviceUIActionTypePhotos),
                        @(PLPDeviceUIActionTypeKeys),
                        @(PLPDeviceUIActionTypeShare)
                    ];
                }else {
                    actions = @[
                        @(PLPDeviceUIActionTypeMessage),
                        @(PLPDeviceUIActionTypeShareSetting)
                    ];
                }
                

            }
            
            NSDictionary *deviceUIActionsConfig = [PLPConfigUtils deviceUIActionsConfig];
            for (NSUInteger i=0; i<actions.count; i++) {
                NSDictionary *dict = [deviceUIActionsConfig objectForKey:actions[i]];
                if (dict) {
                    PLPDeviceUIAction *action = [[PLPDeviceUIAction alloc] init];
                    action.title = [dict objectForKey:@"title"];
                    action.imageName = [dict objectForKey:@(viewType)];
                    NSNumber *actionType = [dict objectForKey:@"actionType"];
                    action.actionType = [actionType unsignedIntegerValue];
                    [result addObject:action];
                }
            }
        }
    }
    return result.count ? result : nil;
}


@end
