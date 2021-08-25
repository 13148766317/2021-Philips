//
//  PLPDeviceDataSource.m
//  Pages
//
//  Created by Apple on 2021/5/18.
//

#import "PLPCategoryDeviceDataSource.h"
#import "PLPDeviceManager+ProductCategory.h"
#import "PLPDeviceNotificationController.h"
@interface PLPCategoryDeviceDataSource ()

@property(nonatomic, strong) NSArray *devices;

@property(nonatomic, strong) PLPDeviceNotificationController *deviceNotificationController;

@end

@implementation PLPCategoryDeviceDataSource

- (instancetype)init
{
    self = [super init];
    if (self) {
        //todo 临听设备变动通知，如果增加/删除
        self.multicastDelegate = [[GCDMulticastDelegate alloc] init];
        
        //设备列表变化处理
        self.deviceNotificationController = [[PLPDeviceNotificationController alloc] init];
        __weak __typeof(self)weakSelf = self;
        self.deviceNotificationController.deviceListChangeNotificationBlock = ^(NSNotification * _Nonnull notification, PLPDeviceNotification * _Nonnull deviceNotification) {
            [weakSelf reloadDeviceWithCategory:weakSelf.currentCategory sendNoti:YES changType:1];
        };
        [self.deviceNotificationController addObserverNotification];
    }
    return self;
}

- (void)dealloc
{
    [self.multicastDelegate removeAllDelegates];
    [self.deviceNotificationController removeObserverNotification];
    self.deviceNotificationController = nil;
}

- (void)setCurrentCategory:(PLPProductCategory)currentCategory {
    
    
    if (_currentCategory != currentCategory) {
        _currentCategory = currentCategory;
        [self reloadDeviceWithCategory:currentCategory sendNoti:YES changType:0];
    }else {
        [self reloadDeviceWithCategory:currentCategory sendNoti:NO changType:0];
    }
}
//当前分类设备
-(NSArray <id<PLPDeviceProtocol>>*)  currentCategoryDevices {
    
    return self.devices;
}

//通过索引获取设备
-(id<PLPDeviceProtocol>) deviceAtIndex:(NSUInteger) index {
    if (index < [self deviceCount]) {
        return [self.devices objectAtIndex:index];
    }else {
        return nil;
    }
}

//重新加载设备，通知委托
-(void) reloadDeviceWithCategory:(PLPProductCategory) category sendNoti:(BOOL) sendNoti changType:(NSUInteger) type {
    
    self.devices = [[PLPDeviceManager sharedInstance] devicesWithCategory:category];
    
    if (sendNoti) {
        if (type) {
            [self.multicastDelegate devicesChangeWithDeviceDataSource:self];
        }else {
            [self.multicastDelegate deviceDataSource:self changeCategory:category];
        }
    }
}

-(NSUInteger) deviceCount {
    return [self.devices count];
}

@end
