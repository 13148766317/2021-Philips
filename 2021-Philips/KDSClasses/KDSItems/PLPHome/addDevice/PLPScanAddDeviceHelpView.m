//
//  PLPScanAddDeviceHelpView.m
//  2021-Philips
//
//  Created by kaadas on 2021/6/11.
//  Copyright © 2021 com.Kaadas. All rights reserved.
//
#import "PLPScanAddDeviceHelpView.h"

@implementation PLPScanAddDeviceHelpView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self layoutAllSubviews];
    }
    return self;
}

- (void)layoutAllSubviews {
    UIView *holderView = [UIView new];
    holderView.backgroundColor = [UIColor whiteColor];
    holderView.layer.masksToBounds = YES;
    holderView.layer.cornerRadius = 3;
    [self addSubview:holderView];

    [holderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(200);
        make.centerX.equalTo(self.mas_centerX);
        make.left.equalTo(self.mas_left).offset(15);
        make.right.equalTo(self.mas_right).offset(-15);
        make.height.equalTo(@480);
    }];

    UILabel *titleLabel = [UILabel new];
    titleLabel.text = @"如何添加设备";
    titleLabel.font = [UIFont systemFontOfSize:17];
    [holderView addSubview:titleLabel];

    [holderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@25);
        make.centerX.equalTo(holderView.mas_centerX);
    }];
    UILabel *textOne = [UILabel new];
    textOne.text = @"方式一";
    textOne.textColor = [UIColor grayColor];
    [holderView addSubview:textOne];

    [textOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(holderView.mas_left).offset(15);
        make.top.equalTo(titleLabel.mas_bottom).offset(25);
    }];
    UILabel *desOne = [UILabel new];
    desOne.text = @"扫码门锁电池盖上的二维码，进行添加";
    desOne.textColor = [UIColor grayColor];
    [holderView addSubview:desOne];
    [desOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(holderView.mas_left).offset(15);
        make.top.equalTo(textOne.mas_bottom).offset(12);
    }];
    // 添加一张图片
    UIImageView *tipsImg = [UIImageView new];
    tipsImg.image = [UIImage imageNamed:@"philips_home_scan_img_tips"];
    [holderView addSubview:tipsImg];

    [tipsImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(desOne.mas_bottom).offset(10);
        make.centerX.equalTo(holderView.mas_centerX);
        make.height.mas_equalTo(107);
        make.width.mas_equalTo(130);
    }];
    UILabel *textTwo = [UILabel new];
    textTwo.text = @"方式二";
    textTwo.textColor = [UIColor grayColor];
    [holderView addSubview:textTwo];
    [textTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(holderView.mas_left).offset(15);
        make.top.equalTo(tipsImg.mas_bottom).offset(25);
    }];
    UILabel *desTwo = [UILabel new];
    desTwo.text = @"查看包装盒上的门锁型号，手动输入进行添加";
    desTwo.textColor = [UIColor grayColor];
    [holderView addSubview:desTwo];
    [desTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(holderView.mas_left).offset(15);
        make.top.equalTo(textTwo.mas_bottom).offset(12);
    }];

    UIImageView *iconImg = [UIImageView new];
    iconImg.image = [UIImage imageNamed:@"philips_home_scan_img_referencefigure_02"];
    [holderView addSubview:iconImg];

    [iconImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(desTwo.mas_bottom).offset(10);
        make.centerX.equalTo(holderView.mas_centerX);
        make.height.mas_equalTo(104);
        make.width.mas_equalTo(136);
    }];

    UILabel *customerService = [UILabel new];
    customerService.text = @"服务热线：400-8828-236";
    customerService.textColor = [UIColor redColor];
    customerService.font = [UIFont systemFontOfSize:12];
    [holderView addSubview:customerService];

    [customerService mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(iconImg.mas_bottom).offset(30);
        make.centerX.equalTo(holderView.mas_centerX);
    }];
    // 添加一个取消的按钮
    UIButton *cancleBtn = [UIButton new];
    [cancleBtn setBackgroundImage:[UIImage imageNamed:@"philips_alarm_icon_close-1"] forState:UIControlStateNormal];
    [cancleBtn addTarget:self action:@selector(cancelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cancleBtn];
    [cancleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(holderView.mas_bottom).offset(40);
        make.centerX.equalTo(self.mas_centerX);
        make.height.width.equalTo(@40);
    }];
}


#pragma mark - 手势点击事件,移除View
- (void)dismissContactView:(UITapGestureRecognizer *)tapGesture {
    [self dismissContactView];
}

- (void)dismissContactView
{
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.5 animations:^{
        weakSelf.alpha = 0;
    } completion:^(BOOL finished) {
        [weakSelf removeFromSuperview];
    }];
}

- (void)cancelBtnClick:(UIButton *)sender
{
    !_cancelBtnClickBlock ? : _cancelBtnClickBlock();
}

- (void)settingBtnClick:(UIButton *)sender
{
    !_settingBtnClickBlock ? : _settingBtnClickBlock();
}
@end
