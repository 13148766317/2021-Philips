//
//  PLPDevicePageViewDataSource.h
//  Pages
//
//  Created by Apple on 2021/5/20.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PLPCategoryDeviceDataSource.h"
NS_ASSUME_NONNULL_BEGIN

@interface PLPDevicePageViewDataSource : NSObject <UIPageViewControllerDelegate,UIPageViewControllerDataSource, PLPDeviceDataSourceDelegateProtocol>

@property(nonatomic, strong) PLPCategoryDeviceDataSource *deviceDataSource;
@property(nonatomic, weak) UIPageViewController *pageViewController;
//@property(nonatomic, weak) id<UIPageViewControllerDelegate> delegate;

- (instancetype)initWithPageViewController:(UIPageViewController *) pageViewController;
-(void) reloadData;
@end


NS_ASSUME_NONNULL_END
