//
//  PLPDeviceWiFiSmartLockView.m
//  Pages
//
//  Created by Apple on 2021/5/19.
//

#import "PLPDeviceWiFiSmartLockView.h"
#import "PLPDeviceBaseView+WiFiSmartLock.h"
@import Masonry;

@implementation PLPDeviceWiFiSmartLockView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void) updateUI {
    [super updateUI];
    [self updateLastUnlockRecordLabel];
    [self updateBatteryImage];
    __weak __typeof(self)weakSelf = self;
    if ([self.labSubTitle.text length] ) {
        [self.labName mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(weakSelf.ivDevice.mas_centerY).offset(-4);
            make.left.equalTo(weakSelf.ivDevice.mas_right).offset(16);
            make.right.equalTo(weakSelf.mas_right).offset(-16);

        }];
        [self.labSubTitle mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.ivDevice.mas_centerY).offset(4);
            make.left.equalTo(weakSelf.ivDevice.mas_right).offset(16);
            make.right.equalTo(weakSelf.mas_right).offset(-16);

        }];
        
    }else {
        [self.labName mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(weakSelf.ivDevice.mas_centerY);
            make.left.equalTo(weakSelf.ivDevice.mas_right).offset(16);
            make.right.equalTo(weakSelf.mas_right).offset(-16);

        }];
    }
    
    
}


@end
