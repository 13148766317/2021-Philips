//
//  PLPDeviceViewDataSourceProtocol.h
//  Pages
//
//  Created by Apple on 2021/5/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol PLPDeviceViewDataSourceProtocol <NSObject>
//设备名称
-(NSString *) plpDeviceViewName;
//设备子标题
-(NSString *) plpDeviceViewSubTitle;
//设备列表视图显示图片
-(NSString *) plpDeviceViewListImageName;
//设备卡片视图显示图片
-(NSString *) plpDeviceViewCardImageName;
//设备主界面视图显示图片
-(NSString *) plpDeviceViewDashboardImageName;

@end

NS_ASSUME_NONNULL_END
