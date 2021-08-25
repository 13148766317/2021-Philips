//
//  PLPDuressPasswordCell.m
//  2021-Philips
//
//  Created by 小凯互联科技有限公司 on 2021/5/12.
//  Copyright © 2021 com.Kaadas. All rights reserved.
//

#import "PLPDuressPasswordCell.h"

@implementation PLPDuressPasswordCell

- (void)awakeFromNib {
    [super awakeFromNib];

    self.alarmStatusLabel.textColor = KDSRGBColor(0x99, 0x99, 0x99);
    self.alarmNumberLabel.textColor = KDSRGBColor(0x99, 0x99, 0x99);
    self.lineView.backgroundColor = KDSRGBColor(248, 248, 248);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
