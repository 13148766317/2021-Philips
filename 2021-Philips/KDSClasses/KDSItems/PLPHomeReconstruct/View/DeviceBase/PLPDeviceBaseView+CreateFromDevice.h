//
//  PLPDeviceBaseView+CreateFromDevice.h
//  Pages
//
//  Created by Apple on 2021/5/21.
//

#import "PLPDeviceBaseView.h"
#import "PLPDeviceProtocol.h"
#import "PLPConfigUtils.h"
NS_ASSUME_NONNULL_BEGIN

@interface PLPDeviceBaseView (CreateFromDevice)
+(PLPDeviceBaseView *) createFromDevice:(id<PLPDeviceProtocol>) device viewType:(PLPProductViewType) viewType;
@end

NS_ASSUME_NONNULL_END
