//
//  imageCell.m
//  UICollerctionViewHorizontal
//
//  Created by MAC on 2018/11/8.
//  Copyright © 2018年 MAC. All rights reserved.
//

#import "imageCell.h"
#import <Masonry/Masonry.h>
// 屏幕比例
#define SCREEN_RATE       ([UIScreen mainScreen].bounds.size.width/375.0)

@interface imageCell()

@end

@implementation imageCell

@synthesize itemModel = _itemModel;

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.contentView.backgroundColor = [UIColor clearColor];
        [self initView];
    }
    return self;
}

- (void)initView{
    
    // 先添加一个包含 视图的veiw
    UIView  * holderView = [UIView new];
    holderView.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];;
     // 设置圆角
    holderView.layer.masksToBounds = YES;
    holderView.layer.cornerRadius = 15;
    [self.contentView addSubview:holderView];
    [holderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(16);
        make.right.equalTo(self.contentView).offset(-16);
        make.top.equalTo(self.contentView).offset(-50);
        make.bottom.equalTo(self.contentView).offset(0).offset(-30);
    }];
    // 添加 顶部的显示
    _titleLabel = [UILabel new];
    _titleLabel.text =@"DDL708-V-5HW";
    _titleLabel.font = [UIFont systemFontOfSize:15];
    _titleLabel.textColor = KDSRGBColor(51, 51, 51);
    [holderView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(holderView).offset(20);
        make.top.equalTo(holderView).offset(18);
        make.height.equalTo(@17);
    }];
    UIImageView  * powerImage= [UIImageView new];
    powerImage.image =[UIImage imageNamed:@"home_icon_battery"];
    
    [holderView addSubview:powerImage];
    [powerImage  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(holderView).offset(18);
        make.height.equalTo(@18);
        make.width.equalTo(@20);
        make.right.equalTo(holderView.mas_right).offset(-20);
    }];
    
    UIImageView  * wifiImage= [UIImageView new];
    wifiImage.image =[UIImage imageNamed:@"home_icon_wifi"];
    [holderView addSubview:wifiImage];
    [wifiImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(holderView).offset(18);
        make.width.height.equalTo(@18);
        make.right.equalTo(powerImage.mas_left).offset(-10);
    }];
    _itemIcon = [[UIImageView alloc] init];
    _itemIcon.backgroundColor = [UIColor clearColor];
    _itemIcon.image = [UIImage imageNamed:@"home_icon_video_card"];
    _itemIcon.layer.masksToBounds = YES;
    _itemIcon.layer.cornerRadius = 80;
    [holderView addSubview:_itemIcon];
    //CGFloat iconWidth = 80 * SCREEN_RATE;
    //_itemIcon.frame = CGRectMake(0, 0, iconWidth, iconWidth);
    //_itemIcon.center = self.contentView.center;
    [_itemIcon mas_makeConstraints:^(MASConstraintMaker *make) {
       // CGFloat iconWidth = 80 * SCREEN_RATE;
        make.height.width.equalTo(@161);
        make.top.equalTo(@70);
        make.centerX.equalTo(holderView.mas_centerX);
       // make.center.equalTo(holderView);
    }];
    UILabel  * timeLabel = [UILabel new];
    timeLabel.text = @"2021.03.29  10:00   小明指纹00开锁";
    timeLabel.font = [UIFont systemFontOfSize:12];
    timeLabel.textColor =KDSRGBColor(102,102, 102);
    [holderView  addSubview:timeLabel];
    [timeLabel  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(holderView.mas_centerX);
        make.height.equalTo(@14);
        make.top.equalTo(_itemIcon.mas_bottom).offset(40);
    }];
    // 添加功能按键
    //消息  密匙  设置
    UIView * functionViewPasswrod = [UIView new];
    //functionView.backgroundColor = [UIColor systemGrayColor];
    [holderView addSubview:functionViewPasswrod];
    [functionViewPasswrod  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(timeLabel.mas_bottom).offset(50);
        make.centerX.equalTo(holderView.mas_centerX);
        make.height.equalTo(@60);
        make.width.equalTo(@42);
    }];
    UIImageView * funimagePasswrod = [UIImageView new];
    funimagePasswrod.image = [UIImage imageNamed:@"home_icon_psaaword"];
    [functionViewPasswrod addSubview: funimagePasswrod];
    [funimagePasswrod mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(functionViewPasswrod);
    }];
    UILabel  * funLabelPassWord= [UILabel new];
    funLabelPassWord.text =@"密匙";
    funLabelPassWord.font = [UIFont systemFontOfSize:12];
    funLabelPassWord.textAlignment = NSTextAlignmentCenter;
    [functionViewPasswrod addSubview:funLabelPassWord];
    [funLabelPassWord mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(funimagePasswrod.mas_bottom).offset(5);
        make.centerX.equalTo(functionViewPasswrod.mas_centerX);
        }];
    // 消息
    UIView * functionViewnotifiction = [UIView new];
    //functionView.backgroundColor = [UIColor systemGrayColor];
    [holderView addSubview:functionViewnotifiction];
    [functionViewnotifiction  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(timeLabel.mas_bottom).offset(50);
        make.centerX.equalTo(holderView.mas_centerX).offset(-90);
        make.height.equalTo(@60);
        make.width.equalTo(@42);
    }];
    UIImageView * funimagenotifiction = [UIImageView new];
    funimagenotifiction.image = [UIImage imageNamed:@"home_icon_message"];
    [functionViewnotifiction addSubview: funimagenotifiction];
    [funimagenotifiction mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(functionViewnotifiction);
    }];
    UILabel  * funLabelnotifiction= [UILabel new];
    funLabelnotifiction.text =@"消息";
    funLabelnotifiction.font = [UIFont systemFontOfSize:12];
    funLabelnotifiction.textAlignment = NSTextAlignmentCenter;
    [functionViewnotifiction addSubview:funLabelnotifiction];
    [funLabelnotifiction mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(funimagenotifiction.mas_bottom).offset(5);
        make.centerX.equalTo(functionViewnotifiction.mas_centerX);

        }];

    //
    UIView * functionViewSetting = [UIView new];
    //functionView.backgroundColor = [UIColor systemGrayColor];
    [holderView addSubview:functionViewSetting];
    [functionViewSetting  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(timeLabel.mas_bottom).offset(50);
        make.centerX.equalTo(holderView.mas_centerX).offset(90);
        make.height.equalTo(@60);
        make.width.equalTo(@42);
    }];
    UIImageView * funimagesetting = [UIImageView new];
    funimagesetting.image = [UIImage imageNamed:@"home_icon_fingerprint"];
    [functionViewSetting addSubview: funimagesetting];
    [funimagesetting mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(functionViewSetting);
    }];
    UILabel  * funLabelsetting= [UILabel new];
    funLabelsetting.text =@"设置";
    funLabelsetting.font = [UIFont systemFontOfSize:12];
    funLabelsetting.textAlignment = NSTextAlignmentCenter;
    [functionViewSetting addSubview:funLabelsetting];
    [funLabelsetting mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(funimagesetting.mas_bottom).offset(5);
        make.centerX.equalTo(functionViewSetting.mas_centerX);

        }];


    
    
    
    
    
    
    
    
}

- (CollModel *)itemModel{
    return _itemModel;
}

- (void)setItemModel:(CollModel *)itemModel
{
    if (!itemModel) {
        return;
    }
    _itemModel = itemModel;
    
    [self setCellWithModel:_itemModel];
}

- (void)setCellWithModel:(CollModel *)itemModel{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
      //  self.itemIcon.image = [UIImage imageNamed:itemModel.url];
    }];
}






@end
