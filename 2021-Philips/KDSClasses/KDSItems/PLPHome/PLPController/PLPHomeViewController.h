//
//  PLPHomeViewController.h
//  2021-Philips
//
//  Created by kaadas on 2021/4/21.
//  Copyright © 2021 com.Kaadas. All rights reserved.
//
#import "KDSBaseViewController.h"
#import "PLPVideoDeviceViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface PLPHomeViewController : KDSBaseViewController
///关联的锁。
@property (nonatomic, strong) KDSLock *lock;
@end

NS_ASSUME_NONNULL_END
