//
//  PLPVisitorRecoreCell.m
//  2021-Philips
//
//  Created by 小凯互联科技有限公司 on 2021/5/6.
//  Copyright © 2021 com.Kaadas. All rights reserved.
//

#import "PLPVisitorRecoreCell.h"

@implementation PLPVisitorRecoreCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    //头部蓝色小圆点
    self.headMarkView.layer.cornerRadius = 5;
    self.headMarkView.backgroundColor = KDSRGBColor(47, 102, 158);
    
    self.visitorsHeadPortraitIconImg.layer.masksToBounds = YES;
    self.visitorsHeadPortraitIconImg.layer.cornerRadius = 10;
    
    self.visitorsHeadPortraitIconImg.userInteractionEnabled = NO;
    double Degree=90.0/180.0;
    CGAffineTransform transform= CGAffineTransformMakeRotation(M_PI* Degree);
    self.visitorsHeadPortraitIconImg.transform = transform;//旋转
    
    UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(whenClickImage)];
    [self.visitorsHeadPortraitIconImg addGestureRecognizer:singleTap];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

#pragma mark - 播放按钮点击事件
- (IBAction)playBtn:(id)sender {
    
    !_playBtnClickBlock ?: _playBtnClickBlock();
}

- (void)whenClickImage
{
    !_playBtnClickBlock ?: _playBtnClickBlock();
}

@end
