//
//  PLPMsgHeaderView.h
//  2021-Philips
//
//  Created by zhaoxueping on 2021/5/8.
//  Copyright © 2021 com.Kaadas. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PLPMsgHeaderView : UIView
///用户昵称
@property (nonatomic,readwrite,strong)UILabel * nickNameLabel;
///用户账号
@property (nonatomic,readwrite,strong)UILabel * accountLabel;
///头像
@property (nonatomic,readwrite,strong)UIImageView * heardImageView;
@property (nonatomic,readwrite,copy) void(^block)(id );

@end

NS_ASSUME_NONNULL_END
