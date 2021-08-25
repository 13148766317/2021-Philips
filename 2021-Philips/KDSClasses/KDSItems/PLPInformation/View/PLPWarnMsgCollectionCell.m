//
//  PLPWarnMsgCollectionCell.m
//  2021-Philips
//
//  Created by zhaoxueping on 2021/5/10.
//  Copyright © 2021 com.Kaadas. All rights reserved.
//

#import "PLPWarnMsgCollectionCell.h"

@implementation PLPWarnMsgCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.warnMsgTipsImgView.layer.masksToBounds = YES;
    self.warnMsgTipsImgView.layer.cornerRadius = 10;
    
    self.warnMsgTipsImgView.userInteractionEnabled = NO;
    UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(plpWhenClickImage)];
    [self.warnMsgTipsImgView addGestureRecognizer:singleTap];
}
- (IBAction)playBtn:(id)sender {
    
    !_plpPlayBtnClickBlock ?: _plpPlayBtnClickBlock();
}

- (void)plpWhenClickImage
{
    !_plpPlayBtnClickBlock ?: _plpPlayBtnClickBlock();
}

@end
