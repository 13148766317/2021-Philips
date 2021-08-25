//
//  PLPVideoDeviceFunctionListCell.m
//  2021-Philips
//
//  Created by Frank Hu on 2021/4/21.
//  Copyright © 2021 com.Kaadas. All rights reserved.
//

#import "PLPVideoDeviceFunctionListCell.h"

@implementation PLPVideoDeviceFunctionListCell

#pragma mark - UI初始化

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    
    self.backgroundColor = KDSRGBColor(234, 239, 242);
    
    [self.contentView addSubview:self.holderView];
    [self.contentView  addSubview:self.coverImageView];
    [self.contentView addSubview:self.arrowimage];
    [self.contentView  addSubview:self.functionlabel];

    self.arrowimage.image = [UIImage imageNamed:@"philips_icon_more"];
    
    [self.holderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
    //功能图标
    [self.coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.holderView).offset(24);
        make.height.width.equalTo(@34);
        make.centerY.equalTo(self.holderView);
    }];
    
    //功能描述信息
    [self.functionlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.coverImageView.mas_right).offset(10);
        make.height.equalTo(@17);
        make.centerY.equalTo(self.holderView);
    }];
    
    //箭头
    [self.arrowimage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.holderView.mas_right).offset(-16);
        make.height.equalTo(@17);
        make.centerY.equalTo(self.holderView);
    }];
}

#pragma mark - Getter  控件懒加载
- (UIImageView *)coverImageView {
    if (!_coverImageView) {
        _coverImageView = [UIImageView new];
        _coverImageView.contentMode = UIViewContentModeScaleAspectFill;
        _coverImageView.clipsToBounds = YES;
    }
    return _coverImageView;
}
- (UIImageView *)arrowimage{
    if (!_arrowimage) {
        _arrowimage  = [UIImageView new];
        _arrowimage.contentMode = UIViewContentModeScaleAspectFill;
    }
    
    return _arrowimage;
}
- (UILabel *)functionlabel {
    if (!_functionlabel) {
        _functionlabel = [UILabel new];
        _functionlabel.font = [UIFont systemFontOfSize:11];
        _functionlabel.textColor = [UIColor blackColor];
        _functionlabel.textAlignment = NSTextAlignmentCenter;
    }
    return _functionlabel;
}
- (UIView *)holderView{
    if (!_holderView) {
         
        _holderView = [UIView new];
        _holderView.layer.masksToBounds = YES;
        _holderView.layer.borderWidth =1;
        _holderView.layer.borderColor = KDSRGBColor(140, 174, 192).CGColor;
        _holderView.layer.cornerRadius = 5;
    }
    return _holderView;
}


@end
