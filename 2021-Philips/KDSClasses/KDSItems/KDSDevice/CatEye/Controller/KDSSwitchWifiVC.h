//
//  KDSSwitchWifiVC.h
//  2021-Philips
//
//  Created by zhaona on 2019/4/30.
//  Copyright © 2019 com.Kaadas. All rights reserved.
//

#import "KDSBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface KDSSwitchWifiVC : KDSBaseViewController

@property (nonatomic,readwrite,copy) void(^block)(id );

@end

NS_ASSUME_NONNULL_END
