//
//  DeviceListTableViewCell.m
//  UIViewDome
//
//  Created by kaadas on 2021/4/16.
//

#import "DeviceListTableViewCell.h"
#import <Masonry/Masonry.h>
@implementation DeviceListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
         // 设置一个容器控制器
        // 要设置cell的背景色为空白色
        self.contentView.backgroundColor = KDSRGBColor(247, 247, 247);
        UIView *holderView  = [UIView new];
        holderView.backgroundColor = [UIColor whiteColor];
        holderView.layer.cornerRadius = 20;
        holderView.layer.masksToBounds = YES;
        [self.contentView addSubview:holderView];
        [holderView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView);
            make.bottom.equalTo(self.contentView);
            make.left.equalTo(self.contentView).offset(25);
            make.right.equalTo(self.contentView).offset(-25);
        }];
        _logoimg = [UIImageView new];
       // _logoimg.image = [UIImage imageNamed:@"home_icon_video_card"];
        [holderView addSubview:_logoimg];
        [_logoimg  mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(holderView);
            make.height.width.equalTo(@78);
            make.left.equalTo(holderView.mas_left).offset(15);
        }];
        _titlelabelSN = [UILabel new];
        _titlelabelSN.font = [UIFont  systemFontOfSize:15 weight:0.3];
        _titlelabelSN.textColor = KDSRGBColor(51, 51, 51);
        [holderView addSubview:_titlelabelSN];
        [_titlelabelSN mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@22);
            make.left.equalTo(_logoimg.mas_right).offset(20);
            make.centerY.equalTo(holderView.mas_centerY).offset(-15);
        }];
        
        _detaillabelDoor = [UILabel new];
        _detaillabelDoor.text = @"2021.03.29  10:00   小明指纹开锁";
        _detaillabelDoor.font = [UIFont  systemFontOfSize:12];
        _titlelabelSN.textColor = KDSRGBColor(51, 51, 51);
        [holderView addSubview:_detaillabelDoor];
        [_detaillabelDoor mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@22);
            make.left.equalTo(_logoimg.mas_right).offset(20);
            make.centerY.equalTo(holderView.mas_centerY).offset(15);
        }];
        
        // 显示电量的图标
        _doorimg = [UIImageView new];
        _doorimg.image = [UIImage imageNamed:@"home_icon_battery"];
        [holderView  addSubview:_doorimg];
        [_doorimg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(holderView).offset(5);
            make.height.equalTo(@18);
            make.width.equalTo(@20);
            make.right.equalTo(holderView).offset(-20);
           
        }];
        //显示wifi的图标
        _flagimg = [UIImageView new];
         _flagimg.image = [UIImage  imageNamed:@"home_icon_wifi"];
         [holderView  addSubview:_flagimg];
         [_flagimg mas_makeConstraints:^(MASConstraintMaker *make) {
             make.top.equalTo(holderView).offset(5);
             make.height.width.equalTo(@18);
             make.right.equalTo(_doorimg.mas_left).offset(-10);
         }];
    }
    return self;
}

// 设置间距
- (void)setFrame:(CGRect)frame{
   // frame.origin.x += 10;
    //  frame.origin.y += 10;
       frame.size.height -= 10;
     //  frame.size.width -= 20;
       [super setFrame:frame];
}


@end
