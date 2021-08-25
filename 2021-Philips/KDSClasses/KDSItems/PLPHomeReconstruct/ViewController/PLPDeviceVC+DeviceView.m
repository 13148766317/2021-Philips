//
//  PLPDeviceVC+DeviceView.m
//  Pages
//
//  Created by Apple on 2021/5/24.
//

#import "PLPDeviceVC+DeviceView.h"
#import "PLPDeviceBaseView+CreateFromDevice.h"
#import "KDSLock+DeviceManager.h"

@import Masonry;

@implementation PLPDeviceVC (DeviceView)

-(void) addDeviceView {
    if (self.device) {
        self.deviceBaseView = [PLPDeviceBaseView createFromDevice:self.device viewType:self.productViewType];
        if (self.deviceBaseView) {
            [self.view addSubview:self.deviceBaseView];
            __weak __typeof(self)weakSelf = self;
            if (@available(iOS 11,*)) {
                [self.deviceBaseView mas_makeConstraints:^(MASConstraintMaker *make) {
                   make.top.mas_equalTo(weakSelf.view.mas_top);
                    if (weakSelf.productViewType == PLPProductViewTypeCard) {
                        make.left.equalTo(weakSelf.view.mas_left).offset(16);
                        make.right.equalTo(weakSelf.view.mas_right).offset(-16);
                        make.bottom.equalTo(weakSelf.view.mas_bottom).offset(-4);

                    }else {
                        make.left.equalTo(weakSelf.view.mas_left);
                        make.right.equalTo(weakSelf.view.mas_right);
                        make.bottom.equalTo(weakSelf.view.mas_bottom);
                    }
                }];
             } else {
                 [self.deviceBaseView mas_makeConstraints:^(MASConstraintMaker *make) {
                     make.edges.offset(0);
                 }];
             }
            KDSLock *lock = [self.device plpLockWithOldDevice];
            [lock getUnlockRecord];
            self.deviceBaseView.device = self.device;
            [self.deviceBaseView updateUI];
        }
       
    }
}
@end
