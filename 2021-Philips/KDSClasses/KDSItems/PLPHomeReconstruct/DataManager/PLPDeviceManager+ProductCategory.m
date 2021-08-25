//
//  PLPDeviceManager+ProductCategory.m
//  Pages
//
//  Created by Apple on 2021/5/19.
//

#import "PLPDeviceManager+ProductCategory.h"
@implementation PLPDeviceManager (ProductCategory)

//产品分类设备
-(NSArray *) devicesWithCategory:(PLPProductCategory) category {
    NSMutableArray *result;
    
    if (category == PLPProductCategoryAll ) {
        return [self allDevices];
    }else {
        NSArray *allDevices = [self allDevices];
        result = [[NSMutableArray alloc] init];
        for (NSUInteger i=0; i< allDevices.count; i++) {
            //比较设备类别
            if (category & [allDevices[i] plpProductCategory] || category == [allDevices[i] plpProductCategory] ) {
                [result addObject:allDevices[i]];
            }
        }
    }
    return result.count ? result : nil;
}

//产品分类，提取所有设备类别
-(NSArray<NSNumber *> *) categorysFromDevices {
    __block NSMutableSet *categorySet = [[NSMutableSet alloc] init];
    
    NSArray *allDevices = [self allDevices];
    //提取分类
    [allDevices enumerateObjectsUsingBlock:^(id<PLPDeviceProtocol>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [categorySet addObject:@([obj plpProductCategory])];
    }];
    
    NSArray *result = [categorySet allObjects];
    return result.count ? result : nil;
}
@end
