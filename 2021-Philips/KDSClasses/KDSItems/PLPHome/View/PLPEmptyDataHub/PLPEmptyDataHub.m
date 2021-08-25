//
//  PLPEmptyDataHub.m
//  2021-Philips
//
//  Created by 小凯互联科技有限公司 on 2021/5/24.
//  Copyright © 2021 com.Kaadas. All rights reserved.
//

#import "PLPEmptyDataHub.h"

@implementation PLPEmptyDataHub

-(instancetype) initWithFrame:(CGRect)frame HeadImage:(UIImage *)headImage Title:(NSString *)title{
    
    self = [super initWithFrame:frame];
    if (self) {
        @autoreleasepool {
            [self setupMainView:headImage Title:title];
        }
    }
    return self;
}

#pragma mark - 初始化主视图
-(void) setupMainView:(UIImage *)headImage Title:(NSString *)title{

    //图标
    UIImageView *headImageView = [UIImageView new];
    headImageView.image =  headImage;
    [self addSubview:headImageView];
    [headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY).with.offset(-40);
        make.size.mas_equalTo(CGSizeMake(80, 80));
    }];
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.font = [UIFont systemFontOfSize:17];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = title;
    [self addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(0);
        make.right.equalTo(self).with.offset(0);
        make.top.equalTo(headImageView.mas_bottom).with.offset(20);
        make.height.mas_equalTo(@20);
    }];
}


@end
