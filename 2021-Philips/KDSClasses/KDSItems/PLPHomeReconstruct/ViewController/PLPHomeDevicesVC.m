//
//  PLPDeviceListHomeVC.m
//  Pages
//
//  Created by Apple on 2021/5/18.
//

#import "PLPHomeDevicesVC.h"
#import "PLPHomeCategoryView.h"
#import "PLPDeviceCardsVC.h"
#import "PLPDeviceListVC.h"
#import "PLPCategoryDeviceDataSource.h"
#import "PLPDeviceManager+ProductCategory.h"
#import "PLPProductListManager.h"
#import "PLPCompatibleController.h"
#import "UIViewController+PLP.h"


#define kStoryboardName @"PLPMain"
#define kPLPDeviceCardsVCIdentifier @"PLPDeviceCardsVC"
#define kPLPDeviceListVCIdentifier @"PLPDeviceListVC"

@interface PLPHomeDevicesVC ()<PLPDeviceDataSourceDelegateProtocol>

@property(nonatomic, weak) UIViewController  *currentDeviceVC;
@property(nonatomic, strong) PLPDeviceCardsVC *deviceCardsVC;
@property(nonatomic, strong) PLPDeviceListVC *deviceListVC;
@property(nonatomic, strong) NSArray *listCardButtons;

@property(nonatomic, strong) PLPCategoryDeviceDataSource *deviceDataSource;
@property(nonatomic, strong) NSArray *deviceCategorys;
@property(nonatomic, strong) NSArray *deviceCategorysTitles;
@property(nonatomic, weak) IBOutlet PLPHomeCategoryView *homeCategoryView;
@property(nonatomic, strong) PLPCompatibleController *compatibleController;
@end

@implementation PLPHomeDevicesVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //切换设备视图按钮
    self.listCardButtons = @[self.btnCardView,self.btnListView];
    
    //初始设备视图为列表
    [self changeDeviceView:self.btnListView];
    
    self.homeCategoryView.deviceDataSource = self.deviceDataSource;
    
    //初始化没有设备视图
    __weak __typeof(self)weakSelf = self;
    self.noDeviceView.backgroundColor = self.view.backgroundColor;
    
    self.noDeviceView.addDeviceBlock = ^{
        [weakSelf addDeviceAction:nil];
    };
   
    if (self.enableCompatibleMode) {
        [self.compatibleController viewDidLoad];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.enableCompatibleMode) {
        [self.compatibleController viewWillAppear:animated];
    }
    
    if (self.deviceDataSource.currentCategory == PLPProductCategoryNotDefined) {
        self.deviceDataSource.currentCategory = PLPProductCategoryAll;
    }
    
    [self updateNoDeviceView];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (self.enableCompatibleMode) {
        [self.compatibleController viewDidAppear:animated];
    }
}

-(void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if (self.enableCompatibleMode) {
        [self.compatibleController viewDidDisappear:animated];
    }
}
#pragma mark - propery
- (PLPCategoryDeviceDataSource *)deviceDataSource {
    if (!_deviceDataSource) {
        self.deviceDataSource = [[PLPCategoryDeviceDataSource alloc] init];
        [_deviceDataSource.multicastDelegate addDelegate:self delegateQueue:dispatch_get_main_queue()];
    }
    return _deviceDataSource;
}

- (PLPCompatibleController *)compatibleController {
    if (!_compatibleController) {
        self.compatibleController = [[PLPCompatibleController alloc] init];
        _compatibleController.navigationController = self.navigationController;
    }
    return _compatibleController;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:kPLPDeviceCardsVCIdentifier]) {
        _deviceCardsVC = segue.destinationViewController;
        _deviceCardsVC.devicePageViewDataSource.deviceDataSource = self.deviceDataSource;
    }else if ([segue.identifier isEqualToString:kPLPDeviceListVCIdentifier]) {
        _deviceListVC = segue.destinationViewController;
        _deviceListVC.deviceListDataSource.deviceDataSource = self.deviceDataSource;
    }
}

#pragma mark - 切换设备视图
//切换设备卡片与列表显示
- (IBAction)changeDeviceView:(UIButton *) sender {
    if (sender.isSelected) {
        return;
    }
    
    for (UIButton *button in self.listCardButtons) {
        button.selected =  [button isEqual:sender];
    }
   
    if ([sender isEqual:self.btnCardView]) {
        self.deviceListContainerView.hidden = YES;
        self.deviceCardContainerView.hidden = NO;
    }else {
        self.deviceListContainerView.hidden = NO;
        self.deviceCardContainerView.hidden = YES;
    }
}

//添加设备
- (IBAction)addDeviceAction:(id)sender {
    [UIViewController pushAddDeviceWithNavVC:self.navigationController];
}

-(void) updateNoDeviceView {
    BOOL isHidden = [[[PLPDeviceManager sharedInstance] allDevices] count] ? YES : NO;

    if (self.noDeviceView.hidden != isHidden) {
        self.noDeviceView.hidden = isHidden;
    }
}

#pragma mark - PLPDeviceDataSourceDelegateProtocol
- (void)deviceDataSource:(nonnull PLPCategoryDeviceDataSource *)deviceDataSource changeCategory:(PLPProductCategory)category { 
    
}

- (void)devicesChangeWithDeviceDataSource:(nonnull PLPCategoryDeviceDataSource *)deviceDataSource {
    
    [self updateNoDeviceView];
}

@end
