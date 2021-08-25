//
//  PLPDeviceWiFiSmartLockCell.m
//  Pages
//
//  Created by Apple on 2021/5/19.
//

#import "PLPDeviceWiFiSmartLockCell.h"

@implementation PLPDeviceWiFiSmartLockCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void) configure {
    
    [super configure];
    
    if (self.deviceView.labSubTitle) {
        self.deviceView.labSubTitle.numberOfLines = 1;
    }
    
}
@end
