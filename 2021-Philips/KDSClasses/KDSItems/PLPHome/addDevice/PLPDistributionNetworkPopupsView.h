//
//  PLPDistributionNetworkPopupsView.h
//  2021-Philips
//
//  Created by kaadas on 2021/6/1.
//  Copyright © 2021 com.Kaadas. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PLPDistributionNetworkPopupsView : UIView

// 点击取消事件回调
@property (nonatomic,copy)dispatch_block_t cancelBtnClickBlock;
// 点击添加蓝牙锁事件回调
@property (nonatomic,copy)dispatch_block_t settingBtnClickBlock;
@property (nonatomic,strong)  UIView  * holderview;
@property (nonatomic,strong)  UILabel  * tipsLable;
@property (nonatomic,strong)  UIImageView  * image;
@property (nonatomic,strong)  UILabel  * desLablel;
@property (nonatomic,strong)  UIButton  * rightBtn ;
@property (nonatomic,strong)  UIButton  * leftBtn ;

@end

NS_ASSUME_NONNULL_END
