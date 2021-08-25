//
//  KDSResolutionSettingsVC.h
//  2021-Philips
//
//  Created by zhaona on 2019/4/27.
//  Copyright © 2019 com.Kaadas. All rights reserved.
//

#import "KDSBaseViewController.h"
#import "KDSCatEye.h"
#import "KDSGWCateyeParam.h"


NS_ASSUME_NONNULL_BEGIN

@interface KDSResolutionSettingsVC : KDSBaseViewController

@property (nonatomic,readwrite,strong)KDSCatEye * cateye;
@property (nonatomic,readwrite,strong)KDSGWCateyeParam * cateyeParam;

@end

NS_ASSUME_NONNULL_END
