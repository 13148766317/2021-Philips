//
//  PLPDevice.m
//  Pages
//
//  Created by Apple on 2021/5/18.
//

#import "PLPDevice.h"
#import "PLPProductListManager.h"
#import "PLPDevice+Compatible.h"


@interface PLPDevice()
@property(nonatomic, strong) id oldLock;
@end
@implementation PLPDevice

+(PLPDevice *) deviceName:(NSString *) name pid:(NSString *) pid deviceId:(NSString *) deviceId {
    
    PLPDevice *device = [[PLPDevice alloc] init];
    device.name = name;
    device.pid = pid;
    device.deviceId = deviceId;
    return device;
}
+(NSArray<PLPDevice *> *) demoDevices {
    NSMutableArray * result = [[NSMutableArray alloc] init];
    [result addObject:[PLPDevice deviceName:@"设备1" pid:@"1" deviceId:@"设备1"]];
    [result addObject:[PLPDevice deviceName:@"设备2" pid:@"2" deviceId:@"设备2"]];
    [result addObject:[PLPDevice deviceName:@"设备3" pid:@"3" deviceId:@"设备3"]];
    [result addObject:[PLPDevice deviceName:@"设备4" pid:@"4" deviceId:@"设备4"]];
    [result addObject:[PLPDevice deviceName:@"设备5" pid:@"5" deviceId:@"设备5"]];
    [result addObject:[PLPDevice deviceName:@"设备6" pid:@"6" deviceId:@"设备6"]];
    [result addObject:[PLPDevice deviceName:@"设备7" pid:@"7" deviceId:@"设备7"]];

    
    return result;
}

- (void)setOldDevice:(id)oldDevice {
    _oldDevice = oldDevice;
    _oldDeviceType = [PLPDevice compareDeviceType:oldDevice];
    
    
    if (_oldDeviceType == PLPOldDeviceTypeWifiLockModel) {
        self.pid = @"1";
    }else if (_oldDeviceType == PLPOldDeviceTypeHanger) {
        self.pid = @"2";
    }
    
    //直接生成
    _oldLock = [PLPDevice oldDeviceToLock:oldDevice];
    
}

#pragma mark - PLPDeviceProtocol

//设备id
-(NSString *) plpDeviceId {
    if (self.deviceId) {
        return self.deviceId;
    }else {
        return [self getOldDeviceId];
    }
}

- (id<PLPProductInfoProtocol>)plpProduct {
    //todo 如果找不到产品信息，创建未知产品信息
    PLPProductInfo *productInfo;
    
    productInfo = [[PLPProductListManager sharedInstance] productInfoWithPid:self.pid];
    
    
    
    return productInfo ? : [[PLPProductInfo alloc] init];
}

- (PLPProductCategory)plpProductCategory {
    PLPProductCategory category = PLPProductCategoryNotDefined;
    
    //如果是原设备model，进行类别转换
    if ([self plpOldDeviceType] != PLPOldDeviceTypeNone) {
        
        switch ([self plpOldDeviceType]) {
            case PLPOldDeviceTypeWifiLockModel:
                category = PLPProductCategoryWiFiSmartLock;
                break;
            case PLPOldDeviceTypeHanger:
                category = PLPProductCategorySmartHanger;
                break;
            default:
                break;
        }
        
    }else {
        //如果是新设备model，通过获取设备产品，取分类
        PLPProductInfo *product = [self plpProduct];
        category =   [product plpProductCategory];
    }
    return category;
    
}


-(id) plpOldDevice {
    return self.oldDevice;
}

//原有设备类型
-(PLPOldDeviceType) plpOldDeviceType {
    return self.oldDeviceType;
}
- (NSUInteger)plpSort {
    return 0;
}

//原有设备Lock类型，
-(id) plpLockWithOldDevice {
    return self.oldLock;
}
#pragma mark - PLPDeviceViewDataSourceProtocol

- (nonnull NSString *)plpDeviceViewImageName {
    PLPProductInfo *product = [self plpProduct];
    return product ? [product plpDeviceListImage] : kPLPProductDefaultDeviceListImage;
    
}

- (nonnull NSString *)plpDeviceViewName {
    NSString *name;
    if (self.oldDevice && [self plpOldDeviceType] != PLPOldDeviceTypeNone) {
        name = [[self plpLockWithOldDevice] name];
    }else {
        name = self.name;
    }
    return name;
    
}

//设备子标题
-(NSString *) plpDeviceViewSubTitle {
    return nil;
}
//设备列表视图显示图片
-(nonnull NSString *) plpDeviceViewListImageName {
    PLPProductInfo *product = [self plpProduct];
    return  [product plpDeviceListImage] ? : kPLPProductDefaultDeviceListImage;
}
//设备卡片视图显示图片
-(nonnull NSString *) plpDeviceViewCardImageName {
    PLPProductInfo *product = [self plpProduct];
    return  [product plpDeviceListImage]  ? : kPLPProductDefaultDeviceCardImage;
}

//设备主界面视图显示图片
-(NSString *) plpDeviceViewDashboardImageName {
    return [self plpDeviceViewCardImageName];
}



@end
