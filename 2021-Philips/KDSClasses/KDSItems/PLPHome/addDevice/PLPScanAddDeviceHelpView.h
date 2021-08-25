//
//  PLPScanAddDeviceHelpView.h
//  2021-Philips
//
//  Created by kaadas on 2021/6/11.
//  Copyright © 2021 com.Kaadas. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PLPScanAddDeviceHelpView : UIView
// 点击取消事件回调
@property (nonatomic,copy)dispatch_block_t cancelBtnClickBlock;
// 点击添加蓝牙锁事件回调
@property (nonatomic,copy)dispatch_block_t settingBtnClickBlock;
@end

NS_ASSUME_NONNULL_END
