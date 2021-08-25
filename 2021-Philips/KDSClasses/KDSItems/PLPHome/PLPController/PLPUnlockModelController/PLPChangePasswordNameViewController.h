//
//  PLPChangePasswordNameViewController.h
//  2021-Philips
//
//  Created by 小凯互联科技有限公司 on 2021/4/29.
//  Copyright © 2021 com.Kaadas. All rights reserved.
//

#import "KDSBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface PLPChangePasswordNameViewController : KDSBaseViewController

//密匙类型。授权成员传KDSGWKeyTypeReserved。
@property (nonatomic, assign) KDSBleKeyType keyType;

@property (nonatomic, strong) id model;

@property (nonatomic, strong) NSString *nickName;

//关联的锁。
@property (nonatomic, strong) KDSLock *lock;

@end

NS_ASSUME_NONNULL_END
