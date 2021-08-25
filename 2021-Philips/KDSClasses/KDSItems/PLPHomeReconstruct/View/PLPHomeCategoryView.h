//
//  PLPHomeCategoryView.h
//  Pages
//
//  Created by Apple on 2021/5/21.
//

#import <UIKit/UIKit.h>
#import "PLPCategoryDeviceDataSource.h"
NS_ASSUME_NONNULL_BEGIN

@interface PLPHomeCategoryView : UIView

@property(nonatomic, strong) PLPCategoryDeviceDataSource *deviceDataSource;

@end

NS_ASSUME_NONNULL_END
