//
//  PLPDistributionNetworkPopupsView.m
//  2021-Philips
//
//  Created by kaadas on 2021/6/1.
//  Copyright © 2021 com.Kaadas. All rights reserved.
//

#import "PLPDistributionNetworkPopupsView.h"

@interface PLPDistributionNetworkPopupsView ()
//

@end


@implementation PLPDistributionNetworkPopupsView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
       // [self layoutAllSubviews];
        [self layoutSub];
    }
    return self;
}
 
- (void)layoutSub{
    
    _holderview = [UIView new];
    _holderview.backgroundColor = [UIColor whiteColor];
    _holderview.layer.masksToBounds = YES;
    _holderview.layer.cornerRadius = 3 ;
    [self addSubview:_holderview];
    [_holderview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self);
        make.height.equalTo(@329);
        make.width.equalTo(@343);
    }];
    _tipsLable = [UILabel new];
    _tipsLable.text =@"密码错误";
    _tipsLable.font = [UIFont  systemFontOfSize:17 weight:0.3];
    [_holderview addSubview:_tipsLable];
    [_tipsLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_holderview).offset(20);
        make.left.equalTo(_holderview.mas_left).offset(25);
    }];
    _image = [UIImageView new];
    _image.image  = [UIImage imageNamed:@"philips_dms_pop_img_fail_01"];
    [_holderview  addSubview:_image];
    [_image  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@70);
        make.centerX.equalTo(_holderview.mas_centerX);
        make.height.equalTo(@130);
        make.width.equalTo(@96);
    }];
   _desLablel = [UILabel new];
    _desLablel.text = @"请输入正确的管理员密码，当错误超过5次需重新配网";
    _desLablel.font = [UIFont systemFontOfSize:16];
    _desLablel.numberOfLines = 0;
    _desLablel.lineBreakMode = NSLineBreakByWordWrapping;
    [_holderview addSubview:_desLablel];
    [_desLablel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_image.mas_bottom).offset(20);
        make.left.equalTo(_holderview.mas_left).offset(25);
        make.right.equalTo(_holderview.mas_right).offset(-25);
    }];
   _rightBtn = [UIButton new];
    [_rightBtn  setBackgroundColor:KDSRGBColor(0, 102, 161)];
    [_rightBtn setTitle:@"忘记密码" forState:UIControlStateNormal];
    [_rightBtn addTarget:self action:@selector(settingBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    _rightBtn.layer.masksToBounds = YES;
    _rightBtn.layer.cornerRadius = 3 ;
    [_holderview  addSubview: _rightBtn];
    [_rightBtn  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@40);
        make.width.equalTo(@100);
        make.bottom.equalTo(_holderview.mas_bottom).offset(-12);
        make.right.equalTo(_holderview.mas_right).offset(-12);
    }];
    // 添加点击的button
     _leftBtn  = [UIButton new];
     [_leftBtn setTitle:@"重新输入" forState:UIControlStateNormal];
     [_leftBtn setTitleColor:KDSRGBColor(0, 102, 161) forState:UIControlStateNormal];
     [_leftBtn addTarget:self action:@selector(cancelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
     // 圆角
    _leftBtn.layer.masksToBounds = YES;
    _leftBtn.layer.cornerRadius = 3 ;
     [_holderview  addSubview: _leftBtn];
     [_leftBtn  mas_makeConstraints:^(MASConstraintMaker *make) {
         make.height.equalTo(@40);
         make.width.equalTo(@100);
         make.bottom.equalTo(_holderview.mas_bottom).offset(-12);
         make.right.equalTo(_rightBtn.mas_left).offset(-8);
     }];
}


#pragma mark - 手势点击事件,移除View
- (void)dismissContactView:(UITapGestureRecognizer *)tapGesture{
    
    [self dismissContactView];
}
 
-(void)dismissContactView
{
    __weak typeof(self)weakSelf = self;
    [UIView animateWithDuration:0.5 animations:^{
        weakSelf.alpha = 0;
    } completion:^(BOOL finished) {
        [weakSelf removeFromSuperview];
    }];
    
}
-(void)cancelBtnClick:(UIButton *)sender
{
    !_cancelBtnClickBlock ?: _cancelBtnClickBlock();
    
}
-(void)settingBtnClick:(UIButton *)sender
{
    !_settingBtnClickBlock ?: _settingBtnClickBlock();
}

@end
