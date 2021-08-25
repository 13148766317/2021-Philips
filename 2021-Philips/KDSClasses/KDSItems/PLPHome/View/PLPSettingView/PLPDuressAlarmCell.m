//
//  PLPDuressAlarmCell.m
//  2021-Philips
//
//  Created by 小凯互联科技有限公司 on 2021/5/12.
//  Copyright © 2021 com.Kaadas. All rights reserved.
//

#import "PLPDuressAlarmCell.h"

@implementation PLPDuressAlarmCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.subtitleLabel.textColor = KDSRGBColor(154, 154, 154);
    
    self.alarmSwitch.onTintColor = KDSRGBColor(69, 150, 240);
    self.alarmSwitch.transform = CGAffineTransformMakeScale(sqrt(0.5), sqrt(0.5));
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

@end
