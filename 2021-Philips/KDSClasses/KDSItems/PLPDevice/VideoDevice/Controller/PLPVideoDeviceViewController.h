//
//  PLPVideoDeviceViewController.h
//  2021-Philips
//
//  Created by Frank Hu on 2021/4/21.
//  Copyright © 2021 com.Kaadas. All rights reserved.
//

#import "KDSBaseViewController.h"
#import "PLPVideoDeviceFunctionListCell.h"
#import "PLPVideoDeviceFunctionListModel.h"
#import "XMPlayController.h"
#import "KDSMediaLockRecordDetailsVC.h"
#import "KDSMyAlbumVC.h"
#import "KDSWifiLockPwdListVC.h"
#import "KDSLockKeyVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface PLPVideoDeviceViewController : KDSBaseViewController

///绑定的设备对应的门锁模型。
@property (nonatomic, strong) KDSLock *lock;

@end

NS_ASSUME_NONNULL_END

