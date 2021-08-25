//
//  PLPProductInfoProtocol.h
//  2021-Philips
//
//  Created by Apple on 2021/5/13.
//  Copyright © 2021 com.Kaadas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PLPProductDeviceCommon.h"
NS_ASSUME_NONNULL_BEGIN

@protocol PLPProductInfoProtocol <NSObject>
//产品id
-(NSString *) plpProductId;
//用于添加设备显示的产品名称
-(NSString *) plpDisplayName;
//用于添加产品显示图片
-(NSString *) plpAddDeviceImage;
//用于设备列表显示图片
-(NSString *) plpDeviceListImage;
//用于设备卡片显示图片
-(NSString *) plpDeviceCardImage;

//返回查找产品字符串
-(NSString *) plpSearchText;
//显示顺序
-(NSInteger) plpSort;
//产品类别
-(PLPProductCategory) plpProductCategory;

@end

NS_ASSUME_NONNULL_END
