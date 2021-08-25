//
//  PLPDeviceListDataSource.m
//  Pages
//
//  Created by Apple on 2021/5/18.
//

#import "PLPDeviceTableViewDataSource.h"
#import "PLPDeviceBaseCell.h"
#import "PLPConfigUtils.h"
#import "PLPDeviceNotificationController.h"
@interface PLPDeviceTableViewDataSource ()

/// 设备通知处理
@property(nonatomic, strong) PLPDeviceNotificationController *deviceNotificationController;
@end
@implementation PLPDeviceTableViewDataSource

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        //设备通知处理
        self.deviceNotificationController = [[PLPDeviceNotificationController alloc] init];
        __weak __typeof(self)weakSelf = self;
        //电量与名称变化
        self.deviceNotificationController.notificationBlock = ^(NSNotification * _Nonnull notification, PLPDeviceNotificationType notificationType, PLPDeviceNotification * _Nonnull deviceNotification) {
            
            
            switch (notificationType) {
                case PLPDeviceNotificationTypePower:
                case PLPDeviceNotificationTypeName:
                case PLPDeviceNotificationTypeUnlockRecord:{
                    //todo 优化，查打设备对应的cell，进行reload
                    [weakSelf reloadData];
                }
                    break;
                default:
                    break;
            }
        };
        [self.deviceNotificationController addObserverNotification];
    }
    return self;
}
- (instancetype)initWithTableView:(UITableView *) tableView
{
    self = [super init];
    if (self) {
        self.tableView = tableView;
    }
    return self;
}

-(void) dealloc {
    [self.deviceDataSource.multicastDelegate removeDelegate:self];
    [self.deviceNotificationController removeObserverNotification];
    self.deviceNotificationController = nil;
}

- (void)setTableView:(UITableView *)tableView {
    if (tableView) {
        tableView.dataSource = self;
        tableView.delegate = self;
    }
    _tableView = tableView;
}

- (void)setDeviceDataSource:(PLPCategoryDeviceDataSource *)deviceDataSource {
    if (deviceDataSource) {
        [deviceDataSource.multicastDelegate addDelegate:self delegateQueue:dispatch_get_main_queue()];
    }
    _deviceDataSource = deviceDataSource;
}

-(void) reloadData {
    [self.tableView reloadData];
}

#pragma mark - PLPDeviceDataSourceDelegateProtocol

//分类变化通知
-(void) deviceDataSource:(PLPCategoryDeviceDataSource *) deviceDataSource changeCategory:(PLPProductCategory) category {
    [self reloadData];
}

//设备变化通知
-(void) devicesChangeWithDeviceDataSource:(PLPCategoryDeviceDataSource *) deviceDataSource {
    [self reloadData];
}

#pragma mark - UITableViewDataSource
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    PLPDeviceBaseCell *cell;
    
    id<PLPDeviceProtocol> device = [self.deviceDataSource deviceAtIndex:indexPath.section];
    
    id<PLPProductInfoProtocol> product = [device plpProduct];
    
    if (product) {
        id cellClass = [PLPConfigUtils viewClassForProductId:[product plpProductId] viewType:PLPProductViewTypeCell];
        
        if (cellClass) {
            
        }

        NSBundle *bundle = [NSBundle mainBundle];
        NSString *cellClassString = cellClass;
        NSString *cellResource = nil;
        NSBundle *bundleForCaller = [NSBundle bundleForClass:self.class];
        
        NSAssert(cellClass, @"Not defined PLPProductViewTypeCell %@",[product plpDisplayName]);
        
        if ([cellClass isKindOfClass:[NSString class]]) {
            if ([cellClassString rangeOfString:@"/"].location != NSNotFound) {
                NSArray *components = [cellClassString componentsSeparatedByString:@"/"];
                cellResource = [components lastObject];
                NSString *folderName = [components firstObject];
                NSString *bundlePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:folderName];
                bundle = [NSBundle bundleWithPath:bundlePath];
            } else {
                cellResource = [cellClassString componentsSeparatedByString:@"."].lastObject;
            }
        } else {
            cellResource = [NSStringFromClass(cellClass) componentsSeparatedByString:@"."].lastObject;
        }
        
        if ([bundle pathForResource:cellResource ofType:@"nib"]) {
            cell = [[bundle loadNibNamed:cellResource owner:nil options:nil] firstObject];
        } else if ([bundleForCaller pathForResource:cellResource ofType:@"nib"]) {
            cell = [[bundleForCaller loadNibNamed:cellResource owner:nil options:nil] firstObject];
        } else {
            cell = [[cellClass alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        }
    }
    
    if (!cell) {
        cell = [[PLPDeviceBaseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    }
    
    NSAssert([cell isKindOfClass:[PLPDeviceBaseCell class]], @"UITableViewCell must extend from PLPDeviceBaseCell");

    cell.device = device;
    [cell updateUI];
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.deviceDataSource deviceCount];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * view = [UIView new];
    view.backgroundColor = UIColor.clearColor;
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    id<PLPDeviceProtocol> device = [self.deviceDataSource deviceAtIndex:indexPath.section];
    
    if (self.didSelectRowBlock) {
        self.didSelectRowBlock(device);
    }
}

@end
