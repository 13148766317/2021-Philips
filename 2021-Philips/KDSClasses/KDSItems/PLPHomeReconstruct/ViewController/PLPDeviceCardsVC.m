//
//  PLPDeviceCardsVC.m
//  Pages
//
//  Created by Apple on 2021/5/21.
//

#import "PLPDeviceCardsVC.h"

@interface PLPDeviceCardsVC ()

@end

@implementation PLPDeviceCardsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataSource = self.devicePageViewDataSource;
    
    if (self.tabBarController) {
        
        PLPCategoryDeviceDataSource *deviceDataSource =[[PLPCategoryDeviceDataSource alloc] init];
        deviceDataSource.currentCategory = PLPProductCategoryAll;
        self.devicePageViewDataSource.deviceDataSource = deviceDataSource;
        self.title = NSLocalizedString(@"卡片", nil);
        [self.devicePageViewDataSource  reloadData];
        self.view.backgroundColor = [UIColor whiteColor];
    }
        
    [[UIPageControl appearance] setPageIndicatorTintColor:[UIColor lightGrayColor]];
    [[UIPageControl appearance] setCurrentPageIndicatorTintColor:[UIColor grayColor]];

    /*
     _pageControl.pageIndicatorTintColor=[UIColor lightGrayColor];
            _pageControl.currentPageIndicatorTintColor=[UIColor blackColor];
     */
    
}

- (PLPDevicePageViewDataSource *)devicePageViewDataSource {
    if (!_devicePageViewDataSource) {
        self.devicePageViewDataSource = [[PLPDevicePageViewDataSource alloc] initWithPageViewController:self];
    }
    return _devicePageViewDataSource;
}

@end
