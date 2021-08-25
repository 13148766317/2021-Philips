//
//  PLPDeviceCardsVC.h
//  Pages
//
//  Created by Apple on 2021/5/21.
//

#import <UIKit/UIKit.h>
#import "PLPDevicePageViewDataSource.h"
NS_ASSUME_NONNULL_BEGIN

@interface PLPDeviceCardsVC : UIPageViewController
@property(nonatomic, strong) PLPDevicePageViewDataSource *devicePageViewDataSource;

@end

NS_ASSUME_NONNULL_END
