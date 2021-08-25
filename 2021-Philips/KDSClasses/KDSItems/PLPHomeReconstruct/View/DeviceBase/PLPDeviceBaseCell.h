//
//  PLPDeviceBaseCell.h
//  Pages
//
//  Created by Apple on 2021/5/19.
//

#import <UIKit/UIKit.h>
#import "PLPDeviceViewConfigProtocol.h"
#import "PLPDeviceBaseView.h"

NS_ASSUME_NONNULL_BEGIN
//设备基本单元格
@interface PLPDeviceBaseCell : UITableViewCell <PLPDeviceViewConfigProtocol>
//关联设备
@property(nonatomic, weak) id<PLPDeviceProtocol> device;
//设备对应产品视图
@property(nonatomic, weak) IBOutlet PLPDeviceBaseView *deviceView;
//产品视图类别
@property(nonatomic, assign) PLPProductViewType productViewType;


@end

NS_ASSUME_NONNULL_END
