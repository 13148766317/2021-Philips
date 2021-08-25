//
//  PLPCompatibleDeviceVCProtocol.h
//  2021-Philips
//
//  Created by Apple on 2021/5/28.
//  Copyright © 2021 com.Kaadas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KDSLock.h"
NS_ASSUME_NONNULL_BEGIN

@protocol PLPCompatibleDeviceVCProtocol <NSObject>
@property (nonatomic, strong) KDSLock *lock;
@end

NS_ASSUME_NONNULL_END
