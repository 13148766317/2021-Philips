//
//  PLPLoginWithWieiXin.h
//  2021-Philips
//
//  Created by kaadas on 2021/6/8.
//  Copyright © 2021 com.Kaadas. All rights reserved.
//

#import "KDSBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN


@interface PLPLoginWithWieiXin : KDSBaseViewController

@property (nonatomic,strong)NSString * countryCodeString;
@property (nonatomic,strong)NSString * countryName;
///标示从安全设置修改密码过来的,目的是修改完之后重新登录
@property (nonatomic,strong)NSString * markSecuritySetting;
///验证码倒计时秒数。初始化时为59
@property (nonatomic, assign) NSInteger countdown;

//从服务器获取到的电话号码
@property (nonatomic ,strong) NSString * phoneNum;

@property (nonatomic ,assign) BOOL   IsAppleID;
@end

NS_ASSUME_NONNULL_END
