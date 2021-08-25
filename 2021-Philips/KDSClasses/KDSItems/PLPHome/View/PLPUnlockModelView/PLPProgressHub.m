//
//  PLPProgressHub.m
//  2021-Philips
//
//  Created by 小凯互联科技有限公司 on 2021/4/29.
//  Copyright © 2021 com.Kaadas. All rights reserved.
//

#import "PLPProgressHub.h"

@implementation PLPProgressHub

-(instancetype) initWithFrame:(CGRect)frame Title:(NSString *)title{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        @autoreleasepool {
            [self setupMainView:title];
        }
    }
    return self;
}

#pragma mark - 初始化主视图
-(void) setupMainView:(NSString *)title{
    
    self.layer.cornerRadius = 8;
    
    //是否删除提示语
    _midleTitleLabel = [UILabel new];
    _midleTitleLabel.font = [UIFont systemFontOfSize:17];
    _midleTitleLabel.textColor = KDSRGBColor(213, 56, 53);
    _midleTitleLabel.textAlignment = NSTextAlignmentCenter;
    _midleTitleLabel.text = title;
    [self addSubview:_midleTitleLabel];
    [_midleTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(0);
        make.right.equalTo(self).with.offset(0);
        make.top.equalTo(self).with.offset(30);
        make.height.mas_equalTo(@20);
    }];
    
    //取消
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn setTitleColor:KDSRGBColor(46, 101, 158) forState:UIControlStateNormal];
    cancelBtn.tag = 10;
    [cancelBtn setTitle:Localized(@"MediaLibrary_Cancel") forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:cancelBtn];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self).with.offset(-50);
        make.top.equalTo(_midleTitleLabel.mas_bottom).with.offset(30);
        make.size.mas_offset(CGSizeMake(90,40));
    }];
    
    //删除
    UIButton *removeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [removeBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [removeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    removeBtn.tag = 11;
    removeBtn.layer.masksToBounds = YES;
    removeBtn.layer.cornerRadius = 5;
    [removeBtn setTitle:NSLocalizedString(Localized(@"UnlockModel_Sure"), nil) forState:UIControlStateNormal];
    removeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [removeBtn setBackgroundColor:KDSRGBColor(46, 101, 158)];
    [self addSubview:removeBtn];
    [removeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self).with.offset(50);
        make.top.equalTo(_midleTitleLabel.mas_bottom).with.offset(30);
        make.size.mas_offset(CGSizeMake(90,40));
    }];
}

#pragma mark - 点击事件
-(void)btnClick:(UIButton *)btn{
    
    if ([self.progressHubDelegate respondsToSelector:@selector(informationBtnClick:)]) {
        [self.progressHubDelegate informationBtnClick:btn.tag];
    }
}


@end
