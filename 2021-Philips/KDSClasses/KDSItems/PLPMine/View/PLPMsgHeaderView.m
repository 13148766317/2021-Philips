//
//  PLPMsgHeaderView.m
//  2021-Philips
//
//  Created by zhaoxueping on 2021/5/8.
//  Copyright © 2021 com.Kaadas. All rights reserved.
//

#import "PLPMsgHeaderView.h"

@interface PLPMsgHeaderView ()
///右箭头
@property (nonatomic,readwrite,strong)UIImageView * rightArrowImageView;
///头像点击手势
@property (nonatomic,readwrite,strong)UITapGestureRecognizer *iconTap;

@end

@implementation PLPMsgHeaderView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.userInteractionEnabled = YES;
        [self addGestureRecognizer:self.iconTap];
        [self addMySubViews];
        [self addMakeContrants];
       
    }
    
    return self;
}

-(void)addMySubViews
{
    [self addSubview:self.heardImageView];
    [self addSubview:self.rightArrowImageView];
    [self addSubview:self.nickNameLabel];
    [self addSubview:self.accountLabel];
}

-(void)addMakeContrants
{
    [self.heardImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(self.mas_left).offset(16);
        make.height.width.mas_equalTo(66);
        make.centerY.mas_equalTo(self.mas_centerY);
        
    }];
    
    [self.rightArrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_equalTo(self.mas_right).offset(-16);
        make.width.height.mas_equalTo(14);
        make.centerY.mas_equalTo(self.heardImageView.mas_centerY);
    }];
    
    [self.nickNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.heardImageView.mas_right).offset(15);
        make.right.mas_equalTo(self.rightArrowImageView.mas_left).offset(-15);
        make.height.equalTo(@30);
        make.centerY.mas_equalTo(self.heardImageView.mas_centerY).offset(-15);
    }];
    [self.accountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.heardImageView.mas_right).offset(15);
        make.right.mas_equalTo(self.rightArrowImageView.mas_left).offset(-15);
        make.height.equalTo(@20);
        make.top.equalTo(self.nickNameLabel.mas_bottom).offset(5);
    }];
    
}

#pragma mark -- private methods
-(void)iconTapAction:(UITapGestureRecognizer *)tap{
    if (self.block) {
        self.block(@"");
    }
}


#pragma mark --Lazy load

-(UIImageView *)heardImageView
{
    if (!_heardImageView) {
        
        _heardImageView = ({
            
            UIImageView * heardImg = [UIImageView new];
            heardImg.image = [UIImage imageNamed:@"头像"];
            heardImg.layer.borderWidth = 1;
            heardImg.layer.borderColor = [UIColor whiteColor].CGColor;
            heardImg.layer.masksToBounds = YES;
            heardImg.layer.cornerRadius = 33;
            heardImg;
        });
      
        
    }
    
    return _heardImageView;
}

- (UIImageView *)rightArrowImageView
{
    if (!_rightArrowImageView) {
        
        _rightArrowImageView = ({
            
            UIImageView * rightImag = [UIImageView new];
            rightImag.image = [UIImage imageNamed:@"philips_icon_more"];
            
            rightImag;
        });
    }
    
    return _rightArrowImageView;
}

-(UILabel *)nickNameLabel
{
    if (!_nickNameLabel) {
        _nickNameLabel = ({
            
            UILabel * nL = [UILabel new];
            nL.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
            nL.textColor = KDSRGBColor(51, 51, 51);
            nL.textAlignment = NSTextAlignmentLeft;
//            nL.numberOfLines = 0;
            nL.text = @"壮壮家的守护者";
            nL;
        });
    }
    return _nickNameLabel;
}
- (UILabel *)accountLabel
{
    if (!_accountLabel) {
        _accountLabel = ({
    
            UILabel * aLb = [UILabel new];
            aLb.font = [UIFont systemFontOfSize:14];
            aLb.textColor = KDSRGBColor(153, 153, 153);
            aLb.textAlignment = NSTextAlignmentLeft;
//            aLb.numberOfLines = 0;
            aLb.text = @"账号：183****9999";
            aLb;
            
        });
    }
    
    return _accountLabel;
}
-(UITapGestureRecognizer *)iconTap{
    if (!_iconTap) {
        _iconTap = ({
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(iconTapAction:)];
            
            tap;
        });
    }
    return _iconTap;
}

@end
