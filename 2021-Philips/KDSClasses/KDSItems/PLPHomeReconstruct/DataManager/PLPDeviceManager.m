//
//  PLPDeviceManager.m
//  Pages
//
//  Created by Apple on 2021/5/18.
//

#import "PLPDeviceManager.h"
#import "PLPDeviceManager+DemoData.h"
#import "PLPDeviceManager+Compatible.h"
#import "PLPDevice.h"
#import "PLPDeviceManager+Notification.h"
#import "PLPDeviceManager+CachePrivate.h"
//设备管理通知
NSString *const PLPDeviceManagerNotification = @"PLPDeviceManagerNotification";

@interface PLPDeviceManager ()
//内部所有设备
@property(nonatomic, strong) NSMutableArray <id<PLPDeviceProtocol>>*devices;
//加载本地数据开关
@property (nonatomic, assign) BOOL enableLocalData;
@end
@implementation PLPDeviceManager

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static PLPDeviceManager *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[PLPDeviceManager alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        //监听设备添加删除事件
        self.cache = [[NSMutableDictionary alloc] init];
        [self addObserverDeviceManagerEvent];
        //监听设备MQTT事件
        [self addObserverMqttEvent];
        self.enableLocalData = NO;
        [self loadLocalData];
        
    }
    return self;
}

-(void) dealloc {
    [self removeObserverDeviceManagerEvent];
    [self removeObserverMqttEvent];
}

-(void) loadLocalData {
    if (self.enableLocalData) {
        
        [self.devices addObjectsFromArray:[PLPDeviceManager demoDevices]];

    }
}

#pragma mark - 内部属性
- (NSMutableArray *)devices {
    if (!_devices) {
        self.devices = [[NSMutableArray alloc] init];
    }
    return _devices;
}
#pragma mark - 接口
//返回所有设备
-(NSArray *) allDevices {
    return [self.devices copy];
}

#pragma mark - Compatible

//删除所有设备
-(void) removeAllDevices {
    [self.devices removeAllObjects];
    [[KDSUserManager sharedManager].locks removeAllObjects];
}
//添加设备前删除已有设备

-(void) removeBeforeAddingDevices:(NSArray *) devices; {
    
    //NSUInteger lastCount = [self.devices count];
    
    [self removeAllDevices];
    
    //创建新设备
    NSMutableArray *tempDevices = [[NSMutableArray alloc] init];
    [devices enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        PLPDevice *device = [[PLPDevice alloc] init];
        device.oldDevice = obj;
        [tempDevices addObject:device];
    }];
    
    if (tempDevices) {
        [self.devices addObjectsFromArray:tempDevices];
        //[[KDSUserManager sharedManager].locks addObjectsFromArray:tempDevices];
    }
    //发出改变设备
    //if ( lastCount != tempDevices.count) {
    //    [[NSNotificationCenter defaultCenter] postNotificationName:PLPDeviceManagerChangeNotification object:nil];
    //}
    [PLPDeviceManager postNotificationType:PLPDeviceNotificationTypeDeviceListChange device:nil];
    
}


@end
