//
//  PLPVideoDeviceFunctionListCell.h
//  2021-Philips
//
//  Created by Frank Hu on 2021/4/21.
//  Copyright © 2021 com.Kaadas. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PLPVideoDeviceFunctionListCell : UICollectionViewCell

///UIImageView 功能Icon
@property (nonatomic, strong) UIImageView *coverImageView;
///UIImageView 箭头
@property (nonatomic, strong) UIImageView *arrowimage;
///UILabel 描述对应的功能
@property (nonatomic, strong) UILabel *functionlabel;
///UIView 二级视图
@property (nonatomic, strong) UIView *holderView;

@end

NS_ASSUME_NONNULL_END
