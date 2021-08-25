//
//  PLPDeviceDataSource.h
//  Pages
//
//  Created by Apple on 2021/5/18.
//

#import <Foundation/Foundation.h>
#import "PLPProductDeviceCommon.h"
#import "PLPDeviceProtocol.h"
#import "GCDMulticastDelegate.h"

NS_ASSUME_NONNULL_BEGIN
@protocol PLPDeviceDataSourceDelegateProtocol;

@interface PLPCategoryDeviceDataSource : NSObject

@property (nonatomic, strong) GCDMulticastDelegate <PLPDeviceDataSourceDelegateProtocol> *multicastDelegate;


//当前分类
@property(nonatomic, assign) PLPProductCategory currentCategory;

//当前分类设备
-(NSArray <id<PLPDeviceProtocol>>*) currentCategoryDevices;
//通过索引获取设备
-(id<PLPDeviceProtocol>) deviceAtIndex:(NSUInteger) index;
//设备数量
-(NSUInteger) deviceCount;
@end

@protocol PLPDeviceDataSourceDelegateProtocol <NSObject>

//分类变化通知
-(void) deviceDataSource:(PLPCategoryDeviceDataSource *) deviceDataSource changeCategory:(PLPProductCategory) category;

//设备变化通知
-(void) devicesChangeWithDeviceDataSource:(PLPCategoryDeviceDataSource *) deviceDataSource;
@end


NS_ASSUME_NONNULL_END
