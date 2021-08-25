//
//  PLPAboutHeardView.h
//  2021-Philips
//
//  Created by zhaoxueping on 2021/5/11.
//  Copyright © 2021 com.Kaadas. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PLPAboutHeardView : UIView

///343:159label----显示内容
@property (nonatomic,strong)UILabel * titleLb;
///logo
@property (nonatomic,readwrite,strong)UIImageView * logoImageView;

@end

NS_ASSUME_NONNULL_END
