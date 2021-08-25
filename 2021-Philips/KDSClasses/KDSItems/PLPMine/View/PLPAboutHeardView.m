//
//  PLPAboutHeardView.m
//  2021-Philips
//
//  Created by zhaoxueping on 2021/5/11.
//  Copyright © 2021 com.Kaadas. All rights reserved.
//

#import "PLPAboutHeardView.h"

@interface PLPAboutHeardView ()

///背景图
@property (nonatomic,readwrite,strong)UIImageView * bgImageView;

@end

@implementation PLPAboutHeardView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self addMySubViews];
        [self addMakeContrants];
        
    }
    
    return self;
}

-(void)addMySubViews
{
    [self addSubview:self.bgImageView];
    [self addSubview:self.logoImageView];
    [self addSubview:self.titleLb];
    
}

-(void)addMakeContrants
{
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.left.right.bottom.mas_equalTo(0);
        
    }];
    
    [self.logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(self.mas_top).offset(50);
        make.height.width.mas_equalTo(192);
        make.centerX.mas_equalTo(self.mas_centerX);
        
        
    }];

    [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(self.mas_left).offset(30);
        make.right.mas_equalTo(self.mas_right).offset(-30);
        make.top.mas_equalTo(self.logoImageView.mas_bottom).offset(30);
    }];
   
    
}

#pragma mark --Lazy load

-(UIImageView *)logoImageView
{
    if (!_logoImageView) {
        
        _logoImageView = ({
            
            UIImageView * heardImg = [UIImageView new];
            heardImg.userInteractionEnabled = YES;
            heardImg.image = [UIImage imageNamed:@"LOGOAboutUs"];
            heardImg.backgroundColor = [UIColor clearColor];
            heardImg;
        });
    }
    
    return _logoImageView;
}

-(UIImageView *)bgImageView
{
    if (!_bgImageView) {
        _bgImageView = ({
            
            UIImageView *bgImg = [UIImageView new];
            bgImg.image = [UIImage imageNamed:@""];
            bgImg;
        });
    }
    
    return _bgImageView;
}

- (UILabel *)titleLb
{
    if (!_titleLb) {
        _titleLb = ({
            UILabel * lab = [UILabel new];
            lab.font = [UIFont systemFontOfSize:14];
            lab.textColor = KDSRGBColor(102, 102, 102);
            lab.text = @"欢迎使用飞利浦智能锁，门锁售后服务及资讯，请关注【飞利浦智能锁】公众号";
            lab.textAlignment = NSTextAlignmentLeft;
            lab.numberOfLines = 0;
            lab;
            
        });
    }
    return _titleLb;
}
@end
