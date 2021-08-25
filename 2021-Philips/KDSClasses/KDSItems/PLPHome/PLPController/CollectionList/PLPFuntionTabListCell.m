
//
//  KDSFuntionTabListCell.m
//  KaadasLock
//
//  Created by kaadas on 2021/1/28.
//  Copyright © 2021 com.Kaadas. All rights reserved.
//

#import "PLPFuntionTabListCell.h"
#import <Masonry/Masonry.h>
@interface PLPFuntionTabListCell ()

@property (nonatomic, strong) UIImageView *coverImageView;
@property (nonatomic, strong) UIImageView *arrowimage;
@property (nonatomic, strong) UILabel *funtablabel;
@property (nonatomic, strong) UIView  *holderView;
@end
@implementation PLPFuntionTabListCell
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    [self.contentView addSubview:self.holderView];
    [self.contentView  addSubview:self.coverImageView];
    [self.contentView addSubview:self.arrowimage];
    [self.contentView  addSubview:self.funtablabel];
    //填充假数据
    self.coverImageView.image =[UIImage imageNamed:@"home_icon_message"];
    self.funtablabel.text =@"消息";
    self.arrowimage.image = [UIImage imageNamed:@"icon_more"];
    
    [self.holderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
    [self.coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.holderView).offset(24);
        make.height.width.equalTo(@34);
        make.centerY.equalTo(self.holderView);
        
    }];
    [self.funtablabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.coverImageView.mas_right).offset(10);
        make.height.equalTo(@17);
        make.centerY.equalTo(self.holderView);
    }];
    
    [self.arrowimage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.holderView.mas_right).offset(-30);
        make.height.equalTo(@17);
        make.centerY.equalTo(self.holderView);
    }];
    
    
}


 //  数据填充
//- (void)setupData:(KDSFuntionTabModel *)data {
//   // self.funtablabel.text = data.funtabtitle;
//    //[self.coverImageView sd_setImageWithURL:[NSURL URLWithString:data.images]];
////    self.coverImageView.image = [UIImage  imageNamed:data.imageName];
////    if (data.countdown>0) {
////        self.labelCountDown.hidden = NO;
////        self.labelCountDown.text = [self formatMinute:data.countdown];
////    }else {
////        self.labelCountDown.hidden = YES;
////    }
//}





// MARK: - Getter  控件懒加载
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
- (UILabel *)funtablabel {
    if (!_funtablabel) {
        _funtablabel = [UILabel new];
        _funtablabel.font = [UIFont systemFontOfSize:11];
        _funtablabel.textColor = [UIColor blackColor];
        _funtablabel.textAlignment = NSTextAlignmentCenter;
    }
    return _funtablabel;
}
- (UIView *)holderView{
    if (!_holderView) {
         
        _holderView = [UIView new];
        _holderView.layer.masksToBounds = YES;
        _holderView.layer.borderWidth =1;
        _holderView.layer.borderColor = [UIColor blueColor].CGColor;
        _holderView.layer.cornerRadius = 5;
        
    }
    return _holderView;
}

@end
