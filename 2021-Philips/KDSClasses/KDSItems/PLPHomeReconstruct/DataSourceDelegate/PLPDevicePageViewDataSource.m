//
//  PLPDevicePageViewDataSource.m
//  Pages
//
//  Created by Apple on 2021/5/20.
//

#import "PLPDevicePageViewDataSource.h"
#import "PLPConfigUtils.h"
#import "PLPDeviceCardVC.h"

@interface PLPDevicePageViewDataSource()

@property(nonatomic, strong) NSMutableArray<PLPDeviceVC *> *viewControllers;
@property(nonatomic, strong) id<PLPDeviceProtocol> lastDevice;

@end
@implementation PLPDevicePageViewDataSource


- (instancetype)init
{
    self = [super init];
    if (self) {
        [self configure];
    }
    return self;
}
- (instancetype)initWithPageViewController:(UIPageViewController *) pageViewController
{
    self = [super init];
    if (self) {
        self.pageViewController = pageViewController;
        [self configure];
    }
    return self;
}


-(void) configure {
    
}

-(void) dealloc {
    [self.deviceDataSource.multicastDelegate removeDelegate:self];
}

#pragma mark - property

- (void)setPageViewController:(UIPageViewController *)pageViewController {
    if (pageViewController) {
        pageViewController.dataSource = self;
        pageViewController.delegate = self;
    }
    _pageViewController = pageViewController;
}


- (void)setDeviceDataSource:(PLPCategoryDeviceDataSource *)deviceDataSource {
    if (deviceDataSource) {
        [deviceDataSource.multicastDelegate addDelegate:self delegateQueue:dispatch_get_main_queue()];
    }
    _deviceDataSource = deviceDataSource;
}

- (NSMutableArray *)viewControllers {
    if (!_viewControllers) {
        self.viewControllers = [[NSMutableArray alloc] init];
    }
    return _viewControllers;
}

#pragma mark - 生成与更新设备视图控制器
//生成设备视图控制器
-(NSArray<PLPDeviceVC *> *) generateViewControllersFromDevices:(NSArray <id<PLPDeviceProtocol>>*) devices {
    NSMutableArray *result = [[NSMutableArray alloc] init];
    [devices enumerateObjectsUsingBlock:^(id<PLPDeviceProtocol>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        PLPDeviceCardVC *vc = [[PLPDeviceCardVC alloc] init];
        vc.device = obj;
        [result addObject:vc];
    }];
    return result.count
    ? result : nil;
}

//更新设备
-(void) updateViewControllers:(NSArray<PLPDeviceVC *> *) viewControllers {
    
    [self.viewControllers removeAllObjects];
    if (viewControllers && viewControllers.count) {
        [self.viewControllers addObjectsFromArray:viewControllers];
    }
    if (self.viewControllers.count) {
        [self.pageViewController setViewControllers:@[viewControllers.firstObject] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    }else {
        [self.pageViewController setViewControllers:@[[[PLPDeviceVC alloc] init]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    }
    
}


- (void) reloadData {
    __weak __typeof(self)weakSelf = self;
    dispatch_block_t block = ^(){
        [weakSelf updateViewControllers:[weakSelf generateViewControllersFromDevices:[weakSelf.deviceDataSource currentCategoryDevices]]];
    };
    dispatch_async(dispatch_get_main_queue(), block);
}
#pragma mark - UIPageViewControllerDataSource


- (nullable UIViewController *)pageViewController:(nonnull UIPageViewController *)pageViewController viewControllerBeforeViewController:(nonnull UIViewController *)viewController {
    
    NSUInteger index = [self.viewControllers indexOfObject:(PLPDeviceVC *)viewController];
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    index--;
   
    return [[self viewControllers] objectAtIndex:index];
    
}

- (nullable UIViewController *)pageViewController:(nonnull UIPageViewController *)pageViewController viewControllerAfterViewController:(nonnull UIViewController *)viewController {
    NSUInteger index = [self.viewControllers indexOfObject:(PLPDeviceVC *)viewController];
    if (index == NSNotFound) {
        return nil;
    }
    index++;
    if (index == [self.viewControllers count]) {
        return nil;
    }
    return [[self viewControllers] objectAtIndex:index];
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController API_AVAILABLE(ios(6.0));  {
    return [self.viewControllers count];
}
- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
    //todo 重定向显示最后设备视图
    if (self.lastDevice) {

    }
    return 0;
}

#pragma mark - UIPageViewControllerDelegate


#pragma mark - PLPDeviceDataSourceDelegateProtocol

//分类变化通知
-(void) deviceDataSource:(PLPCategoryDeviceDataSource *) deviceDataSource changeCategory:(PLPProductCategory) category {
    [self reloadData];
}

//设备变化通知
-(void) devicesChangeWithDeviceDataSource:(PLPCategoryDeviceDataSource *) deviceDataSource {
    [self reloadData];
}
@end
