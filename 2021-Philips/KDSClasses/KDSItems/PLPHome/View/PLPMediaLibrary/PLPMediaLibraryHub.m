//
//  PLPMediaLibraryHub.m
//  2021-Philips
//
//  Created by 小凯互联科技有限公司 on 2021/5/18.
//  Copyright © 2021 com.Kaadas. All rights reserved.
//

#import "PLPMediaLibraryHub.h"

@implementation PLPMediaLibraryHub

-(instancetype) initWithFrame:(CGRect)frame  HeadImage:(UIImage *)headImage Title:(NSString *)title{
    
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
    
    self.layer.cornerRadius = 5;
    self.backgroundColor = KDSRGBColor(101, 87, 76);
    self.alpha = 0.8;

    //背景图
    UIImageView *backImageView = [UIImageView new];
    backImageView.layer.masksToBounds = YES;
    backImageView.layer.cornerRadius = 5;
    backImageView.image = headImage;
    [self addSubview:backImageView];
    [backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(35);
        make.right.equalTo(self).with.offset(-35);
        make.top.equalTo(self).with.offset(20);
        make.bottom.equalTo(self).with.offset(-50);
    }];
    
    //提示语
    UILabel *titleLabel = [UILabel new];
    titleLabel.text = title;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:20];
    [self addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backImageView.mas_bottom).with.offset(10);
        make.left.equalTo(self).offset(0);
        make.right.equalTo(self).offset(0);
        make.height.mas_equalTo(@20);
    }];
}


@end
