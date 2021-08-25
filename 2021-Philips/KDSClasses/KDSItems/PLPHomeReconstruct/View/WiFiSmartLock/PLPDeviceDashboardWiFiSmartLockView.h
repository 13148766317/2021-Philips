//
//  PLPDeviceDashboardWiFiSmartLockView.h
//  Pages
//
//  Created by Apple on 2021/5/19.
//

#import "PLPDeviceBaseView.h"
#import "PLPDeviceBaseView+WiFiSmartLock.h"
NS_ASSUME_NONNULL_BEGIN

@interface PLPDeviceDashboardWiFiSmartLockView : PLPDeviceBaseView
@property(nonatomic, strong) IBOutlet NSLayoutConstraint *layoutConstraintActionsCollectionViewHeight;
///显示门锁模式的Lb
@property(nonatomic, weak) IBOutlet UILabel *labModel;
///呼叫按钮
@property(nonatomic, weak) IBOutlet UIButton *btnOpenVideo;
///帮助按钮---跳转到帮助页面
@property(nonatomic, weak) IBOutlet UIButton *btnModelHelp;



@end

NS_ASSUME_NONNULL_END
