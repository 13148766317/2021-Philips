//
//  KDSFuntionTabListCell.m
//  2021-Philips
//
//  Created by kaadas on 2021/1/28.
//  Copyright © 2021 com.Kaadas. All rights reserved.
//

#import "KDSFuntionTabListCell.h"

@interface KDSFuntionTabListCell ()

@property (nonatomic, strong) UIImageView *coverImageView;

@property (nonatomic, strong) UILabel *funtablabel;

@property (nonatomic, strong) UILabel *labelCountDown;

@end
@implementation KDSFuntionTabListCell
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}


- (void)setupUI{
    [self.contentView  addSubview:self.coverImageView];
    [self.contentView addSubview:self.labelCountDown];
    [self.contentView  addSubview:self.funtablabel];
    
    [self.coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@45);
        make.height.equalTo(@88);
        make.centerX.equalTo(self.contentView);
        
    }];
    
    [self.labelCountDown mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.equalTo(@62);
        make.centerX.equalTo(self.contentView);
    }];
    
    [self.funtablabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.width.equalTo(@45);
        make.bottom.equalTo(self.contentView).offset(0);
    }];
}
 //  数据填充
- (void)setupData:(KDSFuntionTabModel *)data {
     //self.funtablabel.text = data.funtabtitle;
    self.funtablabel.text = Localized(@"测试的数据");
    //[self.coverImageView sd_setImageWithURL:[NSURL URLWithString:data.images]];
    self.coverImageView.image = [UIImage  imageNamed:@"img_list"];
}

- (void)setupDataModel:(id<PLPCellProtocol>) dataModel {
    self.funtablabel.text = [dataModel plpCellTitle];
    self.coverImageView.image = [UIImage imageNamed:[dataModel plpCellImageName]];
}
// MARK: - Getter  控件懒加载
- (UIImageView *)coverImageView {
    if (!_coverImageView) {
        _coverImageView = [UIImageView new];
        _coverImageView.contentMode = UIViewContentModeScaleAspectFill;
        _coverImageView.clipsToBounds = YES;
    }
    return _coverImageView;
}

- (UILabel *)funtablabel {
    if (!_funtablabel) {
        _funtablabel = [UILabel new];
        _funtablabel.font = [UIFont systemFontOfSize:11];
        _funtablabel.text =@"测试的数据dfdfdfdfd";
        _funtablabel.numberOfLines = 0;
        _funtablabel.lineBreakMode = NSLineBreakByWordWrapping;
        _funtablabel.textColor = [UIColor blackColor];
        _funtablabel.textAlignment = NSTextAlignmentCenter;
    }
    return _funtablabel;
}

- (UILabel *)labelCountDown {
    if (!_labelCountDown) {
        self.labelCountDown = [[UILabel alloc] init];
        _labelCountDown.textColor = [UIColor whiteColor];
        _labelCountDown.textAlignment = NSTextAlignmentCenter;
        _labelCountDown.font = [UIFont systemFontOfSize:12];
    }
    return _labelCountDown;
}

@end
