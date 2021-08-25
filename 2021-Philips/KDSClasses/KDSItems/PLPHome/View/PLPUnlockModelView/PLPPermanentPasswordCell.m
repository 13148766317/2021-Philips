//
//  PLPPermanentPasswordCell.m
//  2021-Philips
//
//  Created by 小凯互联科技有限公司 on 2021/4/28.
//  Copyright © 2021 com.Kaadas. All rights reserved.
//

#import "PLPPermanentPasswordCell.h"

@implementation PLPPermanentPasswordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.headLineView.backgroundColor = KDSRGBColor(248, 248, 248);
    self.passwordTitleLabel.font = [UIFont boldSystemFontOfSize:17];
    
    self.addTimeLabel.textColor = KDSRGBColor(0x99, 0x99, 0x99);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
