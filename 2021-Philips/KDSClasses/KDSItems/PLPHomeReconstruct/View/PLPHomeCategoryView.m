//
//  PLPHomeCategoryView.m
//  Pages
//
//  Created by Apple on 2021/5/21.
//

#import "PLPHomeCategoryView.h"
#import "PLPDeviceManager.h"
#import "PLPProductListManager.h"
#import "PLPDeviceManager+ProductCategory.h"

@import Masonry;
@import HMSegmentedControl;

@interface PLPHomeCategoryView () <PLPDeviceDataSourceDelegateProtocol>


@property (nonatomic, strong) HMSegmentedControl *categorySegmentedControl;


@property(nonatomic, strong) NSArray *deviceCategorys;
@property(nonatomic, strong) NSArray *deviceCategorysTitles;

@end

@implementation PLPHomeCategoryView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self configure];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configure];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self configure];
    }
    return self;
}

-(void) configure {
    [self addSubview:self.categorySegmentedControl];
    self.categorySegmentedControl.frame = self.bounds;
    __weak __typeof(self)weakSelf = self;
    [self.categorySegmentedControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(weakSelf);
    }];
    
}

-(void) dealloc {
    [self.deviceDataSource.multicastDelegate removeDelegate:self];
}

- (void)setDeviceDataSource:(PLPCategoryDeviceDataSource *)deviceDataSource {
    if (deviceDataSource) {
        [deviceDataSource.multicastDelegate addDelegate:self delegateQueue:dispatch_get_main_queue()];
        [self reloadDevice];
    }
    _deviceDataSource = deviceDataSource;
}

- (HMSegmentedControl *)categorySegmentedControl {
    if (!_categorySegmentedControl) {
        HMSegmentedControl *segmentedControl = [[HMSegmentedControl alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
        
        segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationBottom;
        segmentedControl.selectionIndicatorColor = [UIColor colorWithRed:0/255.0 green:102/255.0 blue:161/255.0 alpha:1.0];
        segmentedControl.selectionIndicatorHeight = 3.0;
        
        segmentedControl.backgroundColor = [UIColor clearColor];
        segmentedControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName : [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0],NSFontAttributeName: [UIFont boldSystemFontOfSize:17.0]};
        segmentedControl.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0] ,NSFontAttributeName: [UIFont boldSystemFontOfSize:14.0]};
        //segmentedControl.segmentWidthStyle = HMSegmentedControlSegmentWidthStyleDynamic;
        segmentedControl.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
        [segmentedControl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
        
        _categorySegmentedControl = segmentedControl;
        
        
    }
    return _categorySegmentedControl;
}

- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl {
    NSLog(@"Selected index %tu (via UIControlEventValueChanged)", segmentedControl.selectedSegmentIndex);
    NSNumber *category = self.deviceCategorys[segmentedControl.selectedSegmentIndex];
    self.deviceDataSource.currentCategory = [category unsignedIntegerValue];
}

-(void) reloadDevice {
    NSMutableArray *categorys = [[NSMutableArray alloc] init];
    [categorys addObject:@(PLPProductCategoryAll)];
    
    NSArray *categorysFromDevices = [[PLPDeviceManager sharedInstance] categorysFromDevices];
    if (categorysFromDevices && categorysFromDevices.count) {
        [categorys addObjectsFromArray:categorysFromDevices];
    }
    self.deviceCategorys = categorys;
    self.deviceCategorysTitles = [PLPProductListManager titlesForCategorys:categorys];
    self.categorySegmentedControl.sectionTitles = self.deviceCategorysTitles;
    
    //todo 确定当前selection
    
   
}
#pragma mark -PLPDeviceDataSourceDelegateProtocol

- (void)deviceDataSource:(nonnull PLPCategoryDeviceDataSource *)deviceDataSource changeCategory:(PLPProductCategory)category {

}

- (void)devicesChangeWithDeviceDataSource:(nonnull PLPCategoryDeviceDataSource *)deviceDataSource {
    
    [self reloadDevice];
    
}
@end
