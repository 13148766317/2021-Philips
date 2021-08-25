//
//  KDSSetDoorDirectionViewController.h
//  2021-Philips
//
//  Created by kaadas on 2021/3/1.
//  Copyright © 2021 com.Kaadas. All rights reserved.
//

#import "KDSAutoConnectViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface KDSSetDoorDirectionViewController : KDSAutoConnectViewController
// 开门方向数据回调
@property (nonatomic, copy) void (^myBlock)(NSString *myText);
@end

NS_ASSUME_NONNULL_END
