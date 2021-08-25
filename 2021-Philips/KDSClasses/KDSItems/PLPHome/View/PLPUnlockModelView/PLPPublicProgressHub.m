//
//  PLPPublicProgressHub.m
//  2021-Philips
//
//  Created by 小凯互联科技有限公司 on 2021/5/21.
//  Copyright © 2021 com.Kaadas. All rights reserved.
//

#import "PLPPublicProgressHub.h"

@implementation PLPPublicProgressHub

/**
 没有副标题的时候，整体文字在150
 副标题右一行文字时，整体高度在180
 副标题在二行文字时，整体高度在200
 副标题在三行文字时，整体高度在220
 副标题在四行文字时，整体高度在240
 */

-(instancetype) initWithFrame:(CGRect)frame InformationDic:(NSDictionary *)informatioDic{
    
    self = [super initWithFrame:frame];
    if (self) {
        @autoreleasepool {
            [self setupMainView:informatioDic];
        }
    }
    return self;
}

#pragma mark - 初始化主视图
-(void) setupMainView:(NSDictionary *)informationDic{
    
    self.layer.cornerRadius = 8;
    //NSDictionary *dic = @{@"Title":@"标题",@"SibTitle":@"",@"LButton":@"取消",@"RButton":@"右Button"};
    
    //顶部主标题
    NSString *title = [informationDic objectForKey:@"Title"];
    if (title.length > 0) {
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont systemFontOfSize:17];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = title;
        [self addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).with.offset(0);
            make.right.equalTo(self).with.offset(0);
            make.top.equalTo(self).with.offset(30);
            make.height.mas_equalTo(@20);
        }];
    }
    
    //顶部副标题
    NSString *subTitle = [informationDic objectForKey:@"SibTitle"];
    if (subTitle.length > 0) {
        _subTitleLabel = [UILabel new];
        _subTitleLabel.font = [UIFont systemFontOfSize:15];
        _subTitleLabel.textColor = KDSRGBColor(171, 172, 175);
        _subTitleLabel.numberOfLines = 0;
        _subTitleLabel.textAlignment = NSTextAlignmentLeft;
        _subTitleLabel.text = subTitle;
        [self addSubview:_subTitleLabel];
        [_subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).with.offset(20);
            make.right.equalTo(self).with.offset(-20);
            make.top.equalTo(_titleLabel.mas_bottom).with.offset(20);
            make.bottom.equalTo(self).with.offset(-90);
        }];
    }
    
    //左Button
    NSString *leftButton = [informationDic objectForKey:@"LButton"];
    if (leftButton.length > 0) {
        _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_leftButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_leftButton setTitleColor:KDSRGBColor(46, 102, 155) forState:UIControlStateNormal];
        _leftButton.tag = 10;
        [_leftButton setTitle:Localized(@"MediaLibrary_Cancel") forState:UIControlStateNormal];
        _leftButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:_leftButton];
        [_leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self).with.offset(-50);
            make.bottom.equalTo(self).with.offset(-20);
            make.size.mas_offset(CGSizeMake(90,40));
        }];
    }
    
    //右Button
    NSString *rightButton = [informationDic objectForKey:@"RButton"];
    if (rightButton.length > 0) {
        _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _rightButton.tag = 11;
        _rightButton.layer.masksToBounds = YES;
        _rightButton.layer.cornerRadius = 5;
        [_rightButton setTitle:rightButton forState:UIControlStateNormal];
        _rightButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_rightButton setBackgroundColor:KDSRGBColor(46, 102, 155)];
        [self addSubview:_rightButton];
        [_rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
            if (leftButton.length > 0) {
                make.centerX.equalTo(self).with.offset(50);
                make.size.mas_offset(CGSizeMake(90,40));
            }else{
                make.left.equalTo(self).with.offset(15);
                make.right.equalTo(self).with.offset(-15);
                make.height.mas_equalTo(@40);
            }
            make.bottom.equalTo(self).with.offset(-20);
        }];
    }
}

#pragma mark - 点击事件
-(void)btnClick:(UIButton *)btn{
    
    if ([self.publicProgressHubDelegate respondsToSelector:@selector(publicProgressHubClick:)]) {
        [self.publicProgressHubDelegate publicProgressHubClick:btn.tag];
    }
}

-(void) setRightButtonColor:(UIColor *)color{
    
    [self.rightButton setTitleColor:color forState:UIControlStateNormal];
}

@end
