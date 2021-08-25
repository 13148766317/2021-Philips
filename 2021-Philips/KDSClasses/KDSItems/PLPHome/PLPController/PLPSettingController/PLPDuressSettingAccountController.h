//
//  PLPDuressSettingAccountController.h
//  2021-Philips
//
//  Created by 小凯互联科技有限公司 on 2021/5/12.
//  Copyright © 2021 com.Kaadas. All rights reserved.
//

#import "KDSBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface PLPDuressSettingAccountController : KDSBaseViewController

//关联的锁。
@property (nonatomic, strong) KDSLock *lock;

//关联数据源
@property (nonatomic, strong) KDSPwdListModel *model;

@end

NS_ASSUME_NONNULL_END
