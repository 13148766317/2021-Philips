//
//  KDSMediaLockRecordDetailsVC.m
//  2021-Philips
//
//  Created by zhaoxueping on 2020/9/16.
//  Copyright © 2020 com.Kaadas. All rights reserved.
//

#import "KDSMediaLockRecordDetailsVC.h"
#import "KDSMQTT.h"
#import "KDSDBManager+GW.h"
#import "UIButton+Color.h"
#import "MJRefresh.h"
#import "KDSHomePageLockStatusCell.h"
#import "KDSVisitorsRecordCell.h"
#import "KDSHttpManager+WifiLock.h"
#import "KDSHttpManager+VideoWifiLock.h"
#import "KDSPlaybackCaptureVC.h"

#import "PLPOperationRecordCell.h"
#import "PLPVisitorRecoreCell.h"
#import "PLPCalendarHub.h"
#import "PLPEmptyDataHub.h"

@interface KDSMediaLockRecordDetailsVC ()<UITableViewDelegate, UITableViewDataSource,PLPCalendarHubDelegate>

///操作记录按钮。
@property (nonatomic, strong) UIButton *unlockRecBtn;

///操作记录按钮选中下划线
@property (nonatomic, strong) UIView *unlockRecLine;

///报警记录按钮
@property (nonatomic, strong) UIButton *alarmRecBtn;

///报警记录按钮选中下划线
@property (nonatomic, strong) UIView *alarmRecLine;

///访客记录按钮
@property (nonatomic, strong) UIButton *visitorsRecordBtn;

///访客记录按钮选中下划线
@property (nonatomic, strong) UIView *visitorsRecordLine;

///3个记录按钮数组。
@property (nonatomic, strong) NSMutableArray<UIButton *> * recBtnButtons;

///横向滚动的滚动视图，装着开锁记录和报警记录的表视图。
@property (nonatomic, strong) UIScrollView *scrollView;

///显示开锁记录的表视图。
@property (nonatomic, strong) UITableView *unlockTableView;

///显示访客记录的表视图。
@property (nonatomic, strong) UITableView *visitorsTableView;

///显示报警记录的表视图。
@property (nonatomic, strong) UITableView *alarmTableView;

///服务器请求回来的开锁记录数组。
@property (nonatomic, strong) NSMutableArray<KDSWifiLockOperation *> *unlockRecordArr;

///服务器请求回来开锁记录数组后按日期(天)提取的记录分组数组。
@property (nonatomic, strong) NSMutableArray<NSArray<KDSWifiLockOperation *> *> *unlockRecordSectionArr;

///本地存储的报警记录数组。
@property (nonatomic, strong) NSMutableArray<KDSWifiLockAlarmModel *> *alarmRecordArr;

///本地存储报警记录数组后按日期(天)提取的记录分组数组。
@property (nonatomic, strong) NSMutableArray<NSArray<KDSWifiLockAlarmModel *> *> *alarmRecordSectionArr;

///本地存储的报警记录数组。
@property (nonatomic, strong) NSMutableArray<KDSWifiLockAlarmModel *> *visitorsRecordArr;

///本地存储报警记录数组后按日期(天)提取的记录分组数组。
@property (nonatomic, strong) NSMutableArray<NSArray<KDSWifiLockAlarmModel *> *> *visitorsRecordSectionArr;

///开锁记录页数，初始化1.
@property (nonatomic, assign) int unlockIndex;

///报警记录页数，初始化1.
@property (nonatomic, assign) int alarmIndex;

///访客记录页数，初始化1.
@property (nonatomic, assign) int visitorsIndex;

///获取报警记录时转的菊花。
@property (nonatomic, strong) UIActivityIndicatorView *alarmActivity;

///获取开锁记录时转的菊花。
@property (nonatomic, strong) UIActivityIndicatorView *unlockActivity;

///获取访客记录时转的菊花。
@property (nonatomic, strong) UIActivityIndicatorView *visitorsActivity;

///格式yyyy-MM-dd HH:mm:ss
@property (nonatomic, strong) NSDateFormatter *fmt;

//蒙板
@property (nonatomic, strong) UIView *maskView;

//日历控件
@property (nonatomic, strong) PLPCalendarHub *calendarHub;

//记录是否正在检索
@property (nonatomic, assign) BOOL isSearching;

//在数据空的情况下提示框
@property (nonatomic, strong) PLPEmptyDataHub *emptyDataHub;

@property (nonatomic, assign) int startTime;
@property (nonatomic, assign) int endTime;

@end

@implementation KDSMediaLockRecordDetailsVC

#pragma mark - 生命周期、界面设置相关方法。
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //全局变量赋值初始值
    self.unlockIndex = 1;
    self.alarmIndex = 1;
    self.visitorsIndex = 1;
    
    //记录是否为搜索状态
    self.isSearching = NO;
    
    //初始化主界面
    [self setupUI];
    
    //从接口获取开锁记录数据
    [self loadNewUnlockRecord];
    
    //从接口获取报警记录
    [self loadNewAlarmRecord];
    
    //从接口获取访客记录
    [self loadNewVisitorsRecord];
}

- (void)viewDidLayoutSubviews
{
    if (CGRectIsEmpty(self.unlockTableView.frame))
    {
        self.scrollView.contentSize = CGSizeMake(kScreenWidth * 3, self.scrollView.bounds.size.height);
        CGRect frame = self.scrollView.bounds;
        frame.origin.x += 10;
        frame.size.width -= 20;
        self.unlockTableView.frame = frame;
        frame.origin.x += kScreenWidth;
        self.visitorsTableView.frame = frame;
        frame.origin.x += kScreenWidth;
        self.alarmTableView.frame = frame;
    }
}

#pragma mark - 初始化主视图
- (void)setupUI
{
    //导航栏位置的标题和关闭按钮。
    UIView *bgView = nil;
    if (self.navigationController)
    {
        self.navigationTitleLabel.text = Localized(@"MessageRecord_HeadTitle");
    }else
    {
        bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kStatusBarHeight + kNavBarHeight)];
        bgView.backgroundColor = UIColor.whiteColor;
        [self.view addSubview:bgView];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, kStatusBarHeight, kScreenWidth, kNavBarHeight)];
        titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.text = Localized(@"deviceStatus");
        [self.view addSubview:titleLabel];
        UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *closeImg = [UIImage imageNamed:@"返回"];
        [closeBtn setImage:closeImg forState:UIControlStateNormal];
        closeBtn.frame = CGRectMake(0, kStatusBarHeight, 44, 44);
        [closeBtn addTarget:self action:@selector(clickCloseBtnDismissController:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:closeBtn];
    }
    
    //添加右上角筛选按钮
    [self setRightButton];
    [self.rightButton setImage:[UIImage imageNamed:@"philips_messagerecord_icon_screen"] forState:UIControlStateNormal];
    
    //顶部功能选择按钮
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(bgView.frame), kScreenWidth, 54)];
    view.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:view];
    
    ///操作记录按钮
    self.unlockRecBtn = [UIButton new];
    [self.unlockRecBtn setTitle:Localized(@"MessageRecord_Operation_Record") forState:UIControlStateNormal];
    self.unlockRecBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    self.unlockRecBtn.adjustsImageWhenHighlighted = NO;
    [self.unlockRecBtn addTarget:self action:@selector(clickRecordBtnAdjustScrollViewContentOffset:) forControlEvents:UIControlEventTouchUpInside];
    self.unlockRecBtn.selected = YES;
    //self.unlockRecBtn.layer.masksToBounds = YES;
    //self.unlockRecBtn.layer.cornerRadius = 22;
    //[self.unlockRecBtn setBackgroundColor:KDSRGBColor(60, 116, 161) forState:UIControlStateSelected];
    //[self.unlockRecBtn setBackgroundColor:KDSRGBColor(163, 163, 165) forState:UIControlStateNormal];
    [self.unlockRecBtn setTitleColor:KDSRGBColor(47, 102, 158) forState:UIControlStateSelected];
    [self.unlockRecBtn setTitleColor:KDSRGBColor(163, 163, 165) forState:UIControlStateNormal];
    [view addSubview:self.unlockRecBtn];
    [self.recBtnButtons addObject:self.unlockRecBtn];
    
    ///操作记录按钮选中下划线
    self.unlockRecLine = [UIView new];
    self.unlockRecLine.backgroundColor = KDSRGBColor(47, 102, 158);
    self.unlockRecLine.hidden = NO;
    [view addSubview:self.unlockRecLine];
    
    ///访客记录按钮
    self.visitorsRecordBtn = [UIButton new];
    [self.visitorsRecordBtn setTitle:Localized(@"MessageRecord_Visitor_Record") forState:UIControlStateNormal];
    self.visitorsRecordBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    self.visitorsRecordBtn.adjustsImageWhenHighlighted = NO;
    [self.visitorsRecordBtn addTarget:self action:@selector(clickRecordBtnAdjustScrollViewContentOffset:) forControlEvents:UIControlEventTouchUpInside];
    self.visitorsRecordBtn.layer.masksToBounds = YES;
    self.visitorsRecordBtn.layer.cornerRadius = 22;
    //[self.visitorsRecordBtn setBackgroundColor:KDSRGBColor(31, 150, 247) forState:UIControlStateSelected];
    //[self.visitorsRecordBtn setBackgroundColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.visitorsRecordBtn setTitleColor:KDSRGBColor(47, 102, 158) forState:UIControlStateSelected];
    [self.visitorsRecordBtn setTitleColor:KDSRGBColor(163, 163, 165) forState:UIControlStateNormal];
    [view addSubview:self.visitorsRecordBtn];
    [self.recBtnButtons addObject:self.visitorsRecordBtn];
    
    ///访客记录按钮选中下划线
    self.visitorsRecordLine = [UIView new];
    self.visitorsRecordLine.hidden = YES;
    self.visitorsRecordLine.backgroundColor = KDSRGBColor(47, 102, 158);
    [view addSubview:self.visitorsRecordLine];
    
    ///预警信息按钮
    self.alarmRecBtn = [UIButton new];
    [self.alarmRecBtn setTitle:Localized(@"MessageRecord_Alarm_Record") forState:UIControlStateNormal];
    self.alarmRecBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    self.alarmRecBtn.adjustsImageWhenHighlighted = NO;
    [self.alarmRecBtn addTarget:self action:@selector(clickRecordBtnAdjustScrollViewContentOffset:) forControlEvents:UIControlEventTouchUpInside];
    //self.alarmRecBtn.layer.masksToBounds = YES;
    //self.alarmRecBtn.layer.cornerRadius = 22;
    //[self.alarmRecBtn setBackgroundColor:KDSRGBColor(31, 150, 247) forState:UIControlStateSelected];
    //[self.alarmRecBtn setBackgroundColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.alarmRecBtn setTitleColor:KDSRGBColor(47, 102, 158) forState:UIControlStateSelected];
    [self.alarmRecBtn setTitleColor:KDSRGBColor(163, 163, 165) forState:UIControlStateNormal];
    [view addSubview:self.alarmRecBtn];
    [self.recBtnButtons addObject:self.alarmRecBtn];
    
    ///预警信息按钮选中下划线
    self.alarmRecLine = [UIView new];
    self.alarmRecLine.hidden = YES;
    self.alarmRecLine.backgroundColor = KDSRGBColor(47, 102, 158);
    [view addSubview:self.alarmRecLine];
    
    CGFloat width = KDSScreenWidth/3;
    [self.unlockRecBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.top.equalTo(view);
        make.width.mas_equalTo(@(width));
    }];
    
    [self.unlockRecLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(view);
        make.size.mas_offset(CGSizeMake(width,2));
    }];
    
    [self.visitorsRecordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.unlockRecBtn.mas_right).offset(0);
        make.bottom.top.equalTo(view);
        make.right.equalTo(self.alarmRecBtn.mas_left).offset(0);
    }];
    
    [self.visitorsRecordLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(view);
        make.left.equalTo(self.unlockRecLine.mas_right).offset(0);
        make.size.mas_offset(CGSizeMake(width,2));
    }];
    
    [self.alarmRecBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.top.equalTo(view);
        make.width.mas_equalTo(@(width));
    }];
    
    [self.alarmRecLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(view);
        make.size.mas_offset(CGSizeMake(width,2));
    }];
    
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.delegate = self;
    self.scrollView.bounces = NO;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view.mas_bottom).offset(20);
        make.left.bottom.right.equalTo(self.view);
    }];
    
    ///操作记录的视图
    self.unlockTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.unlockTableView.showsVerticalScrollIndicator = NO;
    self.unlockTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.unlockTableView.dataSource = self;
    self.unlockTableView.delegate = self;
    self.unlockTableView.backgroundColor = self.view.backgroundColor;
    self.unlockTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 0.01)];
    self.unlockTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewUnlockRecord)];
    self.unlockTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreUnlockRecord)];
    [self.scrollView addSubview:self.unlockTableView];
    
    ///访客记录的视图
    self.visitorsTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.visitorsTableView.showsVerticalScrollIndicator = NO;
    self.visitorsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.visitorsTableView.dataSource = self;
    self.visitorsTableView.delegate = self;
    self.visitorsTableView.backgroundColor = self.view.backgroundColor;
    self.visitorsTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 0.01)];
    self.visitorsTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewVisitorsRecord)];
    self.visitorsTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreVisitorsRecord)];
    [self.scrollView addSubview:self.visitorsTableView];
    
    ///预警信息的视图
    self.alarmTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.alarmTableView.showsVerticalScrollIndicator = NO;
    self.alarmTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.alarmTableView.dataSource = self;
    self.alarmTableView.delegate = self;
    self.alarmTableView.backgroundColor = self.view.backgroundColor;
    self.alarmTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 0.01)];
    self.alarmTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewAlarmRecord)];
    self.alarmTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreAlarmRecord)];
    [self.scrollView addSubview:self.alarmTableView];
    
    if (@available(iOS 11.0, *)) {
        self.unlockTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        self.alarmTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        self.visitorsTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

/**
 *@abstract 刷新表视图，调用此方法前请确保开锁或者报警记录的属性数组内容已经更新。方法执行时会自动提取分组记录。
 *@param tableView 要刷新的表视图。
 */
- (void)reloadTableView:(UITableView *)tableView
{
    void (^noRecord) (UITableView *) = ^(UITableView *tableView) {
        UILabel *label = [[UILabel alloc] initWithFrame:tableView.bounds];
        label.textAlignment = NSTextAlignmentCenter;
        if (tableView == self.unlockTableView) {
            label.text = Localized(@"noUnlockRecord");
        }else{
            label.text = Localized(@"NoAlarmRecord");
        }
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = KDSRGBColor(0x99, 0x99, 0x99);
        label.font = [UIFont systemFontOfSize:12];
        tableView.tableHeaderView = label;
    };
    if (tableView == self.unlockTableView)
    {
        [self.unlockRecordArr sortUsingComparator:^NSComparisonResult(KDSWifiLockOperation *  _Nonnull obj1, KDSWifiLockOperation *  _Nonnull obj2) {
            return obj1.time < obj2.time;
        }];
        NSMutableArray *sections = [NSMutableArray array];
        NSMutableArray *elements = [NSMutableArray array];
        __block NSString *date = nil;
        [self.unlockRecordArr enumerateObjectsUsingBlock:^(KDSWifiLockOperation * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([[obj.date componentsSeparatedByString:@" "].firstObject isEqualToString:date])
            {
                [elements addObject:obj];
            }
            else
            {
                date = [obj.date componentsSeparatedByString:@" "].firstObject;
                if (elements.count > 0) {
                   [sections addObject:elements.copy];
                }
                [elements removeAllObjects];
                [elements addObject:obj];
            }
        }];
        if (elements.count) [sections addObject:elements.copy];
        self.unlockRecordSectionArr = sections;
        if (self.unlockRecordArr.count == 0)
        {
            noRecord(self.unlockTableView);
            [self showEmptyDataHub];
        }else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.unlockTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 0.01)];
                [self dismissEmptyDataHub];
                [self.unlockTableView reloadData];
            });
        }
    }else if (tableView == self.visitorsTableView){
        NSMutableArray *sections = [NSMutableArray array];
        NSMutableArray<KDSWifiLockAlarmModel *> *section = [NSMutableArray array];
        __block NSString *date = nil;
        [self.visitorsRecordArr sortUsingComparator:^NSComparisonResult(KDSWifiLockAlarmModel *  _Nonnull obj1, KDSWifiLockAlarmModel *  _Nonnull obj2) {
            if (obj1.time>0 && obj2.time>0)
            {
                return obj2.time < obj1.time ? NSOrderedAscending : NSOrderedDescending;
            }
            else
            {
                return [obj2.date compare:obj1.date];
            }
        }];
        [self.visitorsRecordArr enumerateObjectsUsingBlock:^(KDSWifiLockAlarmModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (!date)
            {
                date = [obj.date componentsSeparatedByString:@" "].firstObject;
                [section addObject:obj];
            }
            else if ([date isEqualToString:[obj.date componentsSeparatedByString:@" "].firstObject])
            {
                [section addObject:obj];
            }
            else
            {
                [sections addObject:[NSArray arrayWithArray:section]];
                [section removeAllObjects];
                date = [obj.date componentsSeparatedByString:@" "].firstObject;
                [section addObject:obj];
            }
        }];
        [sections addObject:[NSArray arrayWithArray:section]];
        //self.visitorsRecordSectionArr = [NSArray arrayWithArray:sections];
        self.visitorsRecordSectionArr = [NSMutableArray arrayWithArray:sections];
        if (self.visitorsRecordArr.count == 0)
        {
            noRecord(self.visitorsTableView);
            [self showEmptyDataHub];
        }
        else
        {
            self.visitorsTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 0.01)];
            [self dismissEmptyDataHub];
        }
        [self.visitorsTableView reloadData];
        
    }
    else
    {
        NSMutableArray *sections = [NSMutableArray array];
        NSMutableArray<KDSWifiLockAlarmModel *> *section = [NSMutableArray array];
        __block NSString *date = nil;
        [self.alarmRecordArr sortUsingComparator:^NSComparisonResult(KDSWifiLockAlarmModel *  _Nonnull obj1, KDSWifiLockAlarmModel *  _Nonnull obj2) {
            if (obj1.time>0 && obj2.time>0)
            {
                return obj2.time < obj1.time ? NSOrderedAscending : NSOrderedDescending;
            }
            else
            {
                return [obj2.date compare:obj1.date];
            }
        }];
        [self.alarmRecordArr enumerateObjectsUsingBlock:^(KDSWifiLockAlarmModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (!date)
            {
                date = [obj.date componentsSeparatedByString:@" "].firstObject;
                [section addObject:obj];
            }
            else if ([date isEqualToString:[obj.date componentsSeparatedByString:@" "].firstObject])
            {
                [section addObject:obj];
            }
            else
            {
                [sections addObject:[NSArray arrayWithArray:section]];
                [section removeAllObjects];
                date = [obj.date componentsSeparatedByString:@" "].firstObject;
                [section addObject:obj];
            }
        }];
        [sections addObject:[NSArray arrayWithArray:section]];
        //self.alarmRecordSectionArr = [NSArray arrayWithArray:sections];
        self.alarmRecordSectionArr = [NSMutableArray arrayWithArray:sections];
        if (self.alarmRecordArr.count == 0)
        {
            noRecord(self.alarmTableView);
            [self showEmptyDataHub];
        }
        else
        {
            self.alarmTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 0.01)];
            [self dismissEmptyDataHub];
        }
        [self.alarmTableView reloadData];
    }
}

#pragma mark - 控件等事件方法。开锁记录/访客记录/预警信息
///点击开锁记录、访客记录、预警信息按钮调整滚动视图的偏移，切换页面。
- (void)clickRecordBtnAdjustScrollViewContentOffset:(UIButton *)sender
{
    for (UIButton *btn in self.recBtnButtons)
    {
        btn.backgroundColor = UIColor.whiteColor;
        btn.selected = NO;
    }
    sender.selected = YES;
    [UIView animateWithDuration:0.3 animations:^{
        if (sender == self.unlockRecBtn) {
            self.unlockRecLine.hidden = NO;
            self.visitorsRecordLine.hidden = YES;
            self.alarmRecLine.hidden = YES;
            self.scrollView.contentOffset = CGPointMake(0 , 0);
            
            if (self.unlockRecordArr.count <= 0) {
                [self showEmptyDataHub];
            }else{
                [self dismissEmptyDataHub];
            }
            
            [self.unlockTableView reloadData];
        }else if (sender == self.visitorsRecordBtn){
            self.unlockRecLine.hidden = YES;
            self.visitorsRecordLine.hidden = NO;
            self.alarmRecLine.hidden = YES;
            self.scrollView.contentOffset = CGPointMake(kScreenWidth, 0);
            
            if (self.visitorsRecordArr.count <= 0) {
                [self showEmptyDataHub];
            }else{
                [self dismissEmptyDataHub];
            }
            
            [self.visitorsTableView reloadData];
        }else{
            self.unlockRecLine.hidden = YES;
            self.visitorsRecordLine.hidden = YES;
            self.alarmRecLine.hidden = NO;
            self.scrollView.contentOffset = CGPointMake(kScreenWidth *2, 0);
            
            if (self.alarmRecordArr.count <= 0) {
                [self showEmptyDataHub];
            }else{
                [self dismissEmptyDataHub];
            }
            
            [self.alarmTableView reloadData];
        }
    }];
}

///dismiss控制器。
- (void)clickCloseBtnDismissController:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 获取 操作记录  访客记录  预警信息  接口数据

#pragma mark - 获取 第一页 操作 记录数据
- (void)loadNewUnlockRecord
{
    [[KDSHttpManager sharedManager] getWifiLockBindedDeviceOperationWithWifiSN:self.lock.wifiDevice.wifiSN index:1 StartTime:self.startTime EndTime:self.endTime MarkIndex:self.isSearching ? 2 : 1 success:^(NSArray<KDSWifiLockOperation *> * _Nonnull operations) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
           if (operations.count == 0)
           {
               self.unlockTableView.mj_header.state = MJRefreshStateNoMoreData;
               return;
           }
          [self.unlockTableView.mj_footer resetNoMoreData];
           BOOL contain = NO;
           for (KDSWifiLockOperation * operation in operations)
           {
               if ([self.unlockRecordArr containsObject:operation])
               {
                   contain = YES;
                   break;
               }
               operation.date = [self.fmt stringFromDate:[NSDate dateWithTimeIntervalSince1970:operation.time]];
               [self.unlockRecordArr insertObject:operation atIndex:[operations indexOfObject:operation]];
           }
           if (!contain)
           {
               [self.unlockRecordArr removeAllObjects];
               [self.unlockRecordArr addObjectsFromArray:operations];
           }
        [self reloadTableView:self.unlockTableView];
        self.unlockTableView.mj_header.state = MJRefreshStateIdle;
    } error:^(NSError * _Nonnull error) {
         [MBProgressHUD hideHUDForView:self.view animated:YES];
         self.unlockTableView.mj_header.state = MJRefreshStateIdle;
    } failure:^(NSError * _Nonnull error) {
         [MBProgressHUD hideHUDForView:self.view animated:YES];
         self.unlockTableView.mj_header.state = MJRefreshStateIdle;
    }];
}

#pragma mark - 获取 更多 操作 记录数据
- (void)loadMoreUnlockRecord
{
    int page = self.unlockIndex + 1;
    [[KDSHttpManager sharedManager] getWifiLockBindedDeviceOperationWithWifiSN:self.lock.wifiDevice.wifiSN index:page StartTime:self.startTime EndTime:self.endTime MarkIndex:self.isSearching ? 2 : 1 success:^(NSArray<KDSWifiLockOperation *> * _Nonnull operations) {
        if (operations.count == 0)
        {
            self.unlockTableView.mj_footer.state = MJRefreshStateNoMoreData;
            return;
        }
        self.unlockTableView.mj_footer.state = MJRefreshStateIdle;
        self.unlockIndex++;
        for (KDSWifiLockOperation *operation in operations)
        {
            if ([self.unlockRecordArr containsObject:operation]) continue;
            operation.date = [self.fmt stringFromDate:[NSDate dateWithTimeIntervalSince1970:operation.time]];
            [self.unlockRecordArr addObject:operation];
        }
        [self reloadTableView:self.unlockTableView];
    } error:^(NSError * _Nonnull error) {
         [MBProgressHUD hideHUDForView:self.view animated:YES];
         self.unlockTableView.mj_footer.state = MJRefreshStateIdle;
    } failure:^(NSError * _Nonnull error) {
         [MBProgressHUD hideHUDForView:self.view animated:YES];
         self.unlockTableView.mj_footer.state = MJRefreshStateIdle;
    }];
}

#pragma mark - 获取 第一页 访客 记录
- (void)loadNewVisitorsRecord
{
    [[KDSHttpManager sharedManager] getXMMediaLockBindedDeviceVisitorRecordWithWifiSN:self.lock.wifiDevice.wifiSN index:1 StartTime:self.startTime EndTime:self.endTime MarkIndex:self.isSearching ? 2 : 1 success:^(NSArray<KDSWifiLockAlarmModel *> * _Nonnull models) {
        if (models.count == 0)
        {
            self.visitorsTableView.mj_header.state = MJRefreshStateNoMoreData;
            return;
        }
       [self.visitorsTableView.mj_footer resetNoMoreData];
        BOOL contain = NO;
        for (KDSWifiLockAlarmModel * operation in models)
        {
            if ([self.visitorsRecordArr containsObject:operation])
            {
                contain = YES;
                break;
            }
            operation.date = [self.fmt stringFromDate:[NSDate dateWithTimeIntervalSince1970:operation.time]];
            [self.visitorsRecordArr insertObject:operation atIndex:[models indexOfObject:operation]];
        }
        if (!contain)
        {
            [self.visitorsRecordArr removeAllObjects];
            [self.visitorsRecordArr addObjectsFromArray:models];
        }
     [self reloadTableView:self.visitorsTableView];
     self.visitorsTableView.mj_header.state = MJRefreshStateIdle;
    } error:^(NSError * _Nonnull error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.visitorsTableView.mj_header.state = MJRefreshStateIdle;
    } failure:^(NSError * _Nonnull error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.visitorsTableView.mj_header.state = MJRefreshStateIdle;
    }];
}

#pragma mark - 获取 更多 访客 记录
- (void)loadMoreVisitorsRecord
{
    [[KDSHttpManager sharedManager] getXMMediaLockBindedDeviceVisitorRecordWithWifiSN:self.lock.wifiDevice.wifiSN index:self.visitorsIndex +1 StartTime:self.startTime EndTime:self.endTime MarkIndex:self.isSearching ? 2 : 1 success:^(NSArray<KDSWifiLockAlarmModel *> * _Nonnull models) {
        
        if (models.count == 0)
        {
            self.visitorsTableView.mj_footer.state = MJRefreshStateNoMoreData;
            return;
        }
        self.visitorsTableView.mj_footer.state = MJRefreshStateIdle;
        self.visitorsIndex ++;
        for (KDSWifiLockAlarmModel *model in models)
        {
            if ([self.visitorsRecordArr containsObject:model]) continue;
            model.date = [self.fmt stringFromDate:[NSDate dateWithTimeIntervalSince1970:model.time]];
            [self.visitorsRecordArr addObject:model];
        }
        [self reloadTableView:self.visitorsTableView];
    } error:^(NSError * _Nonnull error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.visitorsTableView.mj_footer.state = MJRefreshStateIdle;
    } failure:^(NSError * _Nonnull error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.visitorsTableView.mj_footer.state = MJRefreshStateIdle;
    }];
    
}

#pragma mark - 获取 第一页 报警 记录。
- (void)loadNewAlarmRecord
{
    [[KDSHttpManager sharedManager] getXMMediaLockBindedDeviceAlarmRecordWithWifiSN:self.lock.wifiDevice.wifiSN index:1 StartTime:self.startTime EndTime:self.endTime MarkIndex:self.isSearching ? 2 : 1 success:^(NSArray<KDSWifiLockAlarmModel *> * _Nonnull models) {
        if (models.count == 0)
        {
            self.alarmTableView.mj_header.state = MJRefreshStateNoMoreData;
            return;
        }
        [self.alarmTableView.mj_footer resetNoMoreData];
        BOOL contain = NO;
        for (KDSWifiLockAlarmModel * alarm in models)
        {
            if ([self.alarmRecordArr containsObject:alarm])
            {
                contain = YES;
                break;
            }
            alarm.date = [self.fmt stringFromDate:[NSDate dateWithTimeIntervalSince1970:alarm.time]];
            [self.alarmRecordArr insertObject:alarm atIndex:[models indexOfObject:alarm]];
        }
        if (!contain)
        {
            [self.alarmRecordArr removeAllObjects];
            [self.alarmRecordArr addObjectsFromArray:models];
        }
        [self reloadTableView:self.alarmTableView];
        self.alarmTableView.mj_header.state = MJRefreshStateIdle;
    } error:^(NSError * _Nonnull error) {
        self.alarmTableView.mj_header.state = MJRefreshStateIdle;
    } failure:^(NSError * _Nonnull error) {
        self.alarmTableView.mj_header.state = MJRefreshStateIdle;
    }];
}

#pragma mark - 获取 更多 报警 记录
- (void)loadMoreAlarmRecord
{
    [[KDSHttpManager sharedManager] getXMMediaLockBindedDeviceAlarmRecordWithWifiSN:self.lock.wifiDevice.wifiSN index:self.alarmIndex + 1 StartTime:self.startTime EndTime:self.endTime MarkIndex:self.isSearching ? 2 : 1 success:^(NSArray<KDSWifiLockAlarmModel *> * _Nonnull models) {
         if (models.count == 0)
        {
            self.alarmTableView.mj_footer.state = MJRefreshStateNoMoreData;
            return;
        }
        self.alarmTableView.mj_footer.state = MJRefreshStateIdle;
        self.alarmIndex++;
        for (KDSWifiLockAlarmModel *model in models)
        {
            if ([self.alarmRecordArr containsObject:model]) continue;
            model.date = [self.fmt stringFromDate:[NSDate dateWithTimeIntervalSince1970:model.time]];
            [self.alarmRecordArr addObject:model];
        }
        [self reloadTableView:self.alarmTableView];
        
    } error:^(NSError * _Nonnull error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.alarmTableView.mj_footer.state = MJRefreshStateIdle;
    } failure:^(NSError * _Nonnull error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.alarmTableView.mj_footer.state = MJRefreshStateIdle;
    }];
}

#pragma mark - 右上角筛选按钮点击事件
-(void) navRightClick{
    
    //初始化日历控件
    [self showContactView];
}

#pragma mark - PLPProgressHub显示视图
-(void)showContactView{
    
    [_maskView removeFromSuperview];
    [_calendarHub removeFromSuperview];
    
    _maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    _maskView.alpha = 0.5;
    _maskView.backgroundColor = [UIColor blackColor];
    [[UIApplication sharedApplication].keyWindow addSubview:self.maskView];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(calenarTouchViewForRemove:)];
    [_maskView addGestureRecognizer:tapGesture];
    
    _calendarHub = [[PLPCalendarHub alloc] initWithFrame:CGRectMake(0, kScreenHeight/2 -70, kScreenWidth, kScreenHeight/2+70)];
    _calendarHub.backgroundColor = [UIColor whiteColor];
    _calendarHub.calendarHubDelegate = self;
    [[UIApplication sharedApplication].keyWindow addSubview:_calendarHub];
}

#pragma mark - PLPProgressHub删除视图
-(void)dismissContactView
{
    __weak typeof(self)weakSelf = self;
    [UIView animateWithDuration:0.1 animations:^{
        weakSelf.maskView.alpha = 0;
    } completion:^(BOOL finished) {
        [weakSelf.maskView removeFromSuperview];
        [weakSelf.calendarHub removeFromSuperview];
    }];
}

#pragma mark - 日历日期选择代理事件
-(void) calendarHubSelectYear:(NSInteger)year Months:(NSInteger)month Day:(NSInteger)day{
    
    //1 将全局变量赋值初始值
    self.unlockIndex = 1;
    self.alarmIndex = 1;
    self.visitorsIndex = 1;
    
    self.startTime = [KDSTool timeSwitchTimestamp:[NSString stringWithFormat:@"%ld-%02ld-%02ld 00:00:00",year,(long)month,(long)day]];
    self.endTime = [KDSTool timeSwitchTimestamp:[NSString stringWithFormat:@"%ld-%02ld-%02ld 23:59:59",year,(long)month,(long)day]];
    
    //2 置检索标志
    self.isSearching = YES;
    
    //3 清除数据
    if (self.unlockRecordArr) {
        [self.unlockRecordArr removeAllObjects];
        [self.unlockRecordSectionArr removeAllObjects];
    }
    
    if (self.visitorsRecordArr) {
        [self.visitorsRecordArr removeAllObjects];
        [self.visitorsRecordSectionArr removeAllObjects];
    }
    
    if (self.alarmRecordArr) {
        [self.alarmRecordArr removeAllObjects];
        [self.alarmRecordSectionArr removeAllObjects];
    }
    
    //4 根据选择的筛选日期，调用筛选接口
    //4.1 筛选操作记录
    [self loadNewUnlockRecord];
    
    //4.2 筛选访客记录
    [self loadNewVisitorsRecord];
    
    //4.3 筛选预警记录
    [self loadNewAlarmRecord];
    
    //5 删除日历视图
    [self dismissContactView];
    
    //6 刷新视图
    if (self.unlockRecBtn.selected) {
        
        if (self.unlockRecordArr.count <= 0) {
            [self showEmptyDataHub];
        }else{
            [self dismissEmptyDataHub];
        }
        
        [self.unlockTableView reloadData];
    }
    
    if (self.visitorsRecordBtn.selected) {
        
        if (self.visitorsRecordArr.count <= 0) {
            [self showEmptyDataHub];
        }else{
            [self dismissEmptyDataHub];
        }
        
        [self.visitorsTableView reloadData];
    }
    
    if (self.alarmRecBtn.selected) {
        
        if (self.alarmRecordArr.count <= 0) {
            [self showEmptyDataHub];
        }else{
            [self dismissEmptyDataHub];
        }
        
        [self.alarmTableView reloadData];
    }
}

#pragma mark - 触摸深色背景，回收视图事件
-(void) calenarTouchViewForRemove:(UITapGestureRecognizer *)tap{
    
    [self dismissContactView];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == self.scrollView)
    {
        if (scrollView.contentOffset.x == 0) {//操作记录
            
            self.visitorsRecordBtn.selected = NO;
            self.unlockRecBtn.selected = YES;
            self.alarmRecBtn.selected = NO;
            
            self.unlockRecLine.hidden = NO;
            self.visitorsRecordLine.hidden = YES;
            self.alarmRecLine.hidden = YES;
            
            if (self.unlockRecordArr.count <= 0) {
                [self showEmptyDataHub];
            }else{
                [self dismissEmptyDataHub];
            }
            
            [self.unlockTableView reloadData];
            
        }else if (scrollView.contentOffset.x == KDSScreenWidth){//访客记录
            
            self.visitorsRecordBtn.selected = YES;
            self.unlockRecBtn.selected = NO;
            self.alarmRecBtn.selected = NO;
            
            self.unlockRecLine.hidden = YES;
            self.visitorsRecordLine.hidden = NO;
            self.alarmRecLine.hidden = YES;
            
            if (self.visitorsRecordArr.count <= 0) {
                [self showEmptyDataHub];
            }else{
                [self dismissEmptyDataHub];
            }
            
            [self.visitorsTableView reloadData];
        }else{//预警信息
            
            self.visitorsRecordBtn.selected = NO;
            self.unlockRecBtn.selected = NO;
            self.alarmRecBtn.selected = YES;
            
            self.unlockRecLine.hidden = YES;
            self.visitorsRecordLine.hidden = YES;
            self.alarmRecLine.hidden = NO;
            
            if (self.alarmRecordArr.count <= 0) {
                [self showEmptyDataHub];
            }else{
                [self dismissEmptyDataHub];
            }
            
            [self.alarmTableView reloadData];
        }
    }
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == self.unlockTableView){
        if (self.isSearching) {
            return 1;
        }else{
            return self.unlockRecordSectionArr.count;
        }
        
    }else if (tableView == self.alarmTableView){
        if (self.isSearching) {
            return 1;
        }else{
            return self.alarmRecordSectionArr.count;
        }
    }else{
        if (self.isSearching) {
            return 1;
        }else{
            return self.visitorsRecordSectionArr.count;
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.unlockTableView){
        
        return self.unlockRecordSectionArr[section].count;
    }else if (tableView == self.alarmTableView){
        
        return self.alarmRecordSectionArr[section].count; return self.alarmRecordSectionArr[section].count;
    }else{
        
        return self.visitorsRecordSectionArr[section].count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    tableView.rowHeight = 55;
    
    //操作记录
    if (tableView == self.unlockTableView)
    {
        
        static NSString *cellId = @"PLPOperationRecordCell";
        PLPOperationRecordCell *cell = (PLPOperationRecordCell *)[tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            NSArray *nibArr = [[NSBundle mainBundle] loadNibNamed:@"PLPOperationRecordCell" owner:nil options:nil];
            cell = [nibArr objectAtIndex:0];
            cell.backgroundColor = self.view.backgroundColor;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
        }
       
        cell.alarmRecLabel.hidden = YES;
        
        KDSWifiLockOperation *record = self.unlockRecordSectionArr[indexPath.section][indexPath.row];
        cell.timerLabel.text = record.date.length > 16 ? [record.date substringWithRange:NSMakeRange(11, 5)] : record.date;
        //type记录类型：1开锁 2关锁 3添加密钥 4删除密钥 5修改管理员密码 6自动模式 7手动模式 8常用模式切换 9安全模式切换 10反锁模式 11布防模式
        //pwdType密码类型：1密码 2指纹 3卡片 4APP用户
        //开锁记录昵称（zigbee、蓝牙，都有昵称，么有昵称显示编号）
        cell.userNameLabel.text = @"";
        if (record.type == 1)
        {
            switch (record.pwdType) {
                case 0:
                    cell.unlockModeLabel.text = Localized(@"MessageRecord_Password_Unlocking");
                    cell.userNameLabel.text = record.userNickname ?: [NSString stringWithFormat:@"%@%02d",Localized(@"MessageRecord_Number"),record.pwdNum];
                    break;
                case 3:
                    cell.unlockModeLabel.text = Localized(@"MessageRecord_Card_Unlocking");
                    cell.userNameLabel.text = record.userNickname ?: [NSString stringWithFormat:@"%@%02d",Localized(@"MessageRecord_Number"),record.pwdNum];
                    break;
                case 4:
                    cell.unlockModeLabel.text = Localized(@"MessageRecord_Fingerprint_Unlocking");
                    cell.userNameLabel.text = record.userNickname ?: [NSString stringWithFormat:@"%@%02d",Localized(@"MessageRecord_Number"),record.pwdNum];
                    break;
                case 7:
                    cell.unlockModeLabel.text = Localized(@"MessageRecord_Face_Unlocking");
                    cell.userNameLabel.text = record.userNickname ?: [NSString stringWithFormat:@"%@%02d",Localized(@"MessageRecord_Number"),record.pwdNum];
                    break;
                case 8:
                    cell.unlockModeLabel.text = Localized(@"MessageRecord_APP_Unlocking");
                    cell.userNameLabel.text = @"";
                    break;
                case 9:
                    cell.userNameLabel.text = Localized(@"MessageRecord_Mechanics_Unlocking");
                    cell.unlockModeLabel.text = @"";
                    break;
                case 10:
                    cell.userNameLabel.text = Localized(@"MessageRecord_More_Function_Unlocking");//室内多功能键开锁
                    cell.unlockModeLabel.text = @"";
                    break;
                case 11:
                    cell.userNameLabel.text = Localized(@"MessageRecord_Induction_Unlocking");//室内感应把手开锁
                    cell.unlockModeLabel.text = @"";
                    break;

                default:
                    cell.unlockModeLabel.text = Localized(@"MessageRecord_Unlocking");
                    cell.userNameLabel.text = record.userNickname ?: [NSString stringWithFormat:@"%@%02d",Localized(@"MessageRecord_Number"),record.pwdNum];
                    break;
            }
            if (record.pwdNum == 252) {
                cell.userNameLabel.text = Localized(@"MessageRecord_Temporary_Unlocking");//临时密码开锁
                cell.unlockModeLabel.text = @"";
            }else if (record.pwdNum == 250){
                cell.userNameLabel.text = Localized(@"MessageRecord_Temporary_Unlocking");
                 cell.unlockModeLabel.text = @"";
            }else if (record.pwdNum == 253){
                 cell.userNameLabel.text = Localized(@"MessageRecord_Visitor_Unlocking");
                 cell.unlockModeLabel.text = @"";
            }else if (record.pwdNum == 254){
                 cell.userNameLabel.text = Localized(@"MessageRecord_Admin_Unlocking");
                 cell.unlockModeLabel.text = @"";
            }

        }else if (record.type == 2)
        {
            cell.unlockModeLabel.text = @"";
            cell.userNameLabel.text = Localized(@"MessageRecord_Lock_Door");
        }else if (record.type == 3){
            switch (record.pwdType) {
                case 0:
                    cell.userNameLabel.text = [NSString stringWithFormat:@"%@%02d%@",Localized(@"MessageRecord_Lock_Add_Num"),record.pwdNum,Localized(@"MessageRecord_Password")];
                    break;
                case 4:
                    cell.userNameLabel.text = [NSString stringWithFormat:@"%@%02d%@",Localized(@"MessageRecord_Lock_Add_Num"),record.pwdNum,Localized(@"MessageRecord_Fingerprint")];
                    break;
                case 3:
                    cell.userNameLabel.text = [NSString stringWithFormat:@"%@%02d%@",Localized(@"MessageRecord_Lock_Add_Num"),record.pwdNum,Localized(@"MessageRecord_Card")];
                    break;
                case 7:
                    cell.userNameLabel.text = [NSString stringWithFormat:@"%@%02d%@",Localized(@"MessageRecord_Lock_Add_Num"),record.pwdNum,Localized(@"MessageRecord_Face")];
                    break;

                default:
                    cell.userNameLabel.text = Localized(@"MessageRecord_Add_Pwd");
                    break;
            }
            cell.unlockModeLabel.text = @"";
        }else if (record.type == 4){
            switch (record.pwdType) {
                case 0:
                {
                   if (record.pwdNum == 255) {
                        cell.userNameLabel.text = [NSString stringWithFormat:Localized(@"MessageRecord_Delete_All_Pwd")];
                    }else{
                        cell.userNameLabel.text = [NSString stringWithFormat:@"%@%02d%@",Localized(@"MessageRecord_Delete_Pwd"),record.pwdNum,Localized(@"MessageRecord_Password")];
                    }
                }
                    break;
                case 4:
                {
                    if (record.pwdNum == 255) {
                        cell.userNameLabel.text = [NSString stringWithFormat:Localized(@"MessageRecord_Delete_All_Fingerprint")];
                    }else{
                        cell.userNameLabel.text = [NSString stringWithFormat:@"%@%02d%@",Localized(@"MessageRecord_Delete_Pwd"),record.pwdNum,Localized(@"MessageRecord_Fingerprint")];
                    }
                }
                    break;
                case 3:
                {
                    if (record.pwdNum == 255) {
                        cell.userNameLabel.text = [NSString stringWithFormat:Localized(@"MessageRecord_Delete_All_Card")];
                    }else{
                        cell.userNameLabel.text = [NSString stringWithFormat:@"%@%02d%@",Localized(@"MessageRecord_Delete_Pwd"),record.pwdNum,Localized(@"MessageRecord_Card")];
                    }
                }
                    break;
                case 7:
                {
                    if (record.pwdNum == 255) {
                        cell.userNameLabel.text = [NSString stringWithFormat:Localized(@"MessageRecord_Delete_All_Face")];
                    }else{
                        cell.userNameLabel.text = [NSString stringWithFormat:@"%@%02d%@",Localized(@"MessageRecord_Delete_Pwd"),record.pwdNum,Localized(@"MessageRecord_Face")];
                    }
                }
                    break;
                default:
                    cell.userNameLabel.text = Localized(@"MessageRecord_Delete_Pwd");
                    break;
            }
            cell.unlockModeLabel.text = @"";
        }else if (record.type == 5){
            cell.userNameLabel.text = Localized(@"MessageRecord_Lock_Admin");
            cell.unlockModeLabel.text = @"";
        }else if (record.type == 6){
            cell.userNameLabel.text = Localized(@"MessageRecord_Lock_Automatic");
            cell.unlockModeLabel.text = @"";
        }else if (record.type == 7){
            cell.userNameLabel.text = Localized(@"MessageRecord_Lock_Manual");
            cell.unlockModeLabel.text = @"";
        }else if (record.type == 8){
            cell.userNameLabel.text = Localized(@"MessageRecord_Lock_Normal");
            cell.unlockModeLabel.text = @"";
        }else if (record.type == 9){
            cell.userNameLabel.text = Localized(@"MessageRecord_Lock_Safe");
            cell.unlockModeLabel.text = @"";
        }else if (record.type == 10){
            cell.userNameLabel.text = Localized(@"MessageRecord_Lock_BackLock");
            cell.unlockModeLabel.text = @"";
        }else if (record.type == 11){
            cell.userNameLabel.text = Localized(@"MessageRecord_Lock_Deploy");
            cell.unlockModeLabel.text = @"";
        }else if (record.type == 12){
            ///更改01密码昵称为妈妈
            switch (record.pwdType) {
                case 0:
                    cell.unlockModeLabel.text = [NSString stringWithFormat:@"%@%02d%@%@",Localized(@"MessageRecord_Change_Num"),record.pwdNum,Localized(@"MessageRecord_Pwd_Name"),record.pwdNickname];
                    break;
                case 3:
                    cell.unlockModeLabel.text = [NSString stringWithFormat:@"%@%02d%@%@",Localized(@"MessageRecord_Change_Num"),record.pwdNum,Localized(@"MessageRecord_Card_Name"),record.pwdNickname];
                    break;
                case 4:
                    cell.unlockModeLabel.text = [NSString stringWithFormat:@"%@%02d%@%@",Localized(@"MessageRecord_Change_Num"),record.pwdNum,Localized(@"MessageRecord_Fingerprint_Name"),record.pwdNickname];
                    break;
                case 7:
                    cell.unlockModeLabel.text = [NSString stringWithFormat:@"%@%02d%@%@",Localized(@"MessageRecord_Change_Num"),record.pwdNum,Localized(@"MessageRecord_Face_Name"),record.pwdNickname];
                    break;
                default:
                    break;
            }
            cell.userNameLabel.text = record.userNickname;
        }else if (record.type == 13){
            ///添加明明为门锁授权使用
            cell.unlockModeLabel.text = [NSString stringWithFormat:@"%@%@%@",Localized(@"MessageRecord_Empower"),record.shareUserNickname ?: record.shareAccount,Localized(@"MessageRecord_Lock_User")];
            cell.userNameLabel.text = record.userNickname;
        }else if (record.type == 14){
            ///删除明明为门锁授权使用
            cell.unlockModeLabel.text = [NSString stringWithFormat:@"%@%@%@",Localized(@"MessageRecord_Delete"),record.shareUserNickname ?: record.shareAccount,Localized(@"MessageRecord_Lock_User")];
            cell.userNameLabel.text = record.userNickname;
        }else if (record.type == 15){
            ///修改管理指纹
            cell.userNameLabel.text = Localized(@"MessageRecord_Amdin_Change_Fingerprint");
            cell.unlockModeLabel.text = @"";
        }else if (record.type == 16){
            ///16添加管理员指纹
            cell.userNameLabel.text = Localized(@"MessageRecord_Amdin_Add_Fingerprint");
            cell.unlockModeLabel.text = @"";
        }else if (record.type == 17){
            ///17启动节能模式
            cell.userNameLabel.text = Localized(@"MessageRecord_Lock_Energy");
            cell.unlockModeLabel.text = @"";
        }else if (record.type == 18){
            ///18关闭节能模式
            cell.userNameLabel.text = Localized(@"MessageRecord_Lock_Close_Energy");
            cell.unlockModeLabel.text = @"";
        }else{
            cell.userNameLabel.text = Localized(@"MessageRecord_Operation_Normal");
            cell.unlockModeLabel.text = @"";
        }
        return cell;
    
    //访客记录
    }else if (tableView == self.visitorsTableView){
        
        KDSWifiLockAlarmModel *m = self.visitorsRecordSectionArr[indexPath.section][indexPath.row];
       
        static NSString *cellTwoId = @"PLPVisitorRecoreCell";
        PLPVisitorRecoreCell *twoCell = (PLPVisitorRecoreCell *)[tableView dequeueReusableCellWithIdentifier:cellTwoId];
        if (!twoCell) {
            NSArray *nibArr = [[NSBundle mainBundle] loadNibNamed:@"PLPVisitorRecoreCell" owner:nil options:nil];
            twoCell = [nibArr objectAtIndex:0];
            twoCell.backgroundColor = self.view.backgroundColor;
            twoCell.selectionStyle = UITableViewCellSelectionStyleNone;
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
        }
    
        twoCell.playBtn.hidden = YES;
        twoCell.visitorsHeadPortraitIconImg.userInteractionEnabled = NO;
        if (m.thumbState == YES && m.fileName.length > 0) {
            twoCell.playBtn.hidden = NO;
            twoCell.visitorsHeadPortraitIconImg.userInteractionEnabled = YES;
        }
        tableView.rowHeight = 180;
        twoCell.timeLb.text = m.date.length > 16 ? [m.date substringWithRange:NSMakeRange(11, 5)] :m.date;
        [twoCell.visitorsHeadPortraitIconImg sd_setImageWithURL:[NSURL URLWithString:m.thumbUrl] placeholderImage:[UIImage imageNamed:@"img_default"]];
        twoCell.playBtnClickBlock = ^{
            KDSPlaybackCaptureVC * vc = [KDSPlaybackCaptureVC new];
            vc.lock = self.lock;
            vc.model = m;
            [self.navigationController pushViewController:vc animated:YES];
        };

        switch (m.type) {
            case 96:
                twoCell.contentLb.text = Localized(@"MessageRecord_Lock_Ring");
                break;

            default:
                break;
        }
        
        return twoCell;
        
    }else//预警信息
    {
        KDSWifiLockAlarmModel *m = self.alarmRecordSectionArr[indexPath.section][indexPath.row];
        
        if (m.fileName.length > 0 || m.thumbUrl.length >0 || m.eventId.length >0) {
            //有视频地址、有缩略图、有事件ID（有其中一个都是KDSVisitorsRecordCell）
            //图片上传结果成功（有图片、缩略图）
            
            static NSString *cellThreeId = @"PLPVisitorRecoreCell";
            PLPVisitorRecoreCell *threeCell = (PLPVisitorRecoreCell *)[tableView dequeueReusableCellWithIdentifier:cellThreeId];
            if (!threeCell) {
                NSArray *nibArr = [[NSBundle mainBundle] loadNibNamed:@"PLPVisitorRecoreCell" owner:nil options:nil];
                threeCell = [nibArr objectAtIndex:0];
                threeCell.backgroundColor = self.view.backgroundColor;
                threeCell.selectionStyle = UITableViewCellSelectionStyleNone;
                [tableView deselectRowAtIndexPath:indexPath animated:YES];
            }
            
            tableView.rowHeight = 180;
            threeCell.timeLb.text = m.date.length > 16 ? [m.date substringWithRange:NSMakeRange(11, 5)] :m.date;
            [threeCell.visitorsHeadPortraitIconImg sd_setImageWithURL:[NSURL URLWithString:m.thumbUrl] placeholderImage:[UIImage imageNamed:@"img_default"]];
            threeCell.playBtnClickBlock = ^{
                KDSPlaybackCaptureVC * vc = [KDSPlaybackCaptureVC new];
                vc.lock = self.lock;
                vc.model = m;
                [self.navigationController pushViewController:vc animated:YES];
            };
            threeCell.playBtn.hidden = YES;
            threeCell.visitorsHeadPortraitIconImg.userInteractionEnabled = NO;
            if (m.thumbState == YES && m.fileName.length > 0) {
                threeCell.playBtn.hidden = NO;
                threeCell.visitorsHeadPortraitIconImg.userInteractionEnabled = YES;
            }
            switch (m.type) {
                case 1:
                    threeCell.contentLb.text = Localized(@"MessageRecord_Lock_Alarm");
                    //threeCell.smallTipsImg.image = [UIImage imageNamed:@"icon_locking"];
                    break;
                case 2:// 劫持报警（输入防劫持密码或防劫持指纹开锁就报警）
                    threeCell.contentLb.attributedText = [self setLabelTextWithlbTextStr:Localized(@"MessageRecord_Kidnap_Alarm") startRange:4 endRange:13];
                    //threeCell.smallTipsImg.image = [UIImage imageNamed:@"icon_warning"];
                    break;
                case 3:// 三次错误报警
                    threeCell.contentLb.text = Localized(@"MessageRecord_Contact_Baoan");
                    //threeCell.smallTipsImg.image = [UIImage imageNamed:@"icon_error"];
                    break;
                case 4:// 防撬报警（锁被撬开）
                    threeCell.contentLb.attributedText = [self setLabelTextWithlbTextStr:Localized(@"MessageRecord_AntiPrying_Alarm") startRange:4 endRange:11];
                    //threeCell.smallTipsImg.image = [UIImage imageNamed:@"icon_prylock"];
                    break;
                case 8://机械方式报警 （使用机械方式开锁）
                    threeCell.contentLb.attributedText = [self setLabelTextWithlbTextStr:Localized(@"MessageRecord_Mechanics_Alarm") startRange:6 endRange:12];
                    //threeCell.smallTipsImg.image = [UIImage imageNamed:@"icon_prylock"];
                    break;
                case 16:// 低电压报警（电池电量不足）
                    threeCell.contentLb.attributedText = [self setLabelTextWithlbTextStr:Localized(@"MessageRecord_LowPower_Alarm") startRange:15 endRange:18];
                    //threeCell.smallTipsImg.image = [UIImage imageNamed:@"icon_battery"];
                    break;
                case 32:// 锁体异常报警（旧:门锁不上报警）
                    threeCell.contentLb.text = Localized(@"MessageRecord_Lock_Fault");
                    //threeCell.smallTipsImg.image = [UIImage imageNamed:@"icon_fault"];
                    break;
                case 64:// 门锁布防报警
                    threeCell.contentLb.attributedText = [self setLabelTextWithlbTextStr:Localized(@"MessageRecord_Defence_Alarm") startRange:4 endRange:13];
                    //threeCell.smallTipsImg.image = [UIImage imageNamed:@"icon_protection"];
                    break;
                case 112://徘徊报警
                    threeCell.contentLb.text = Localized(@"MessageRecord_Linger_Alarm");
                    //threeCell.smallTipsImg.image = [UIImage imageNamed:@"icon_alert"];
                    break;
                
                    
                default:
                    break;
            }
            return threeCell;
            
        //报警记录
        }else{
            
            static NSString *cellFourId = @"PLPOperationRecordCell";
            PLPOperationRecordCell *fourCell = (PLPOperationRecordCell *)[tableView dequeueReusableCellWithIdentifier:cellFourId];
            if (!fourCell) {
                NSArray *nibArr = [[NSBundle mainBundle] loadNibNamed:@"PLPOperationRecordCell" owner:nil options:nil];
                fourCell = [nibArr objectAtIndex:0];
                fourCell.backgroundColor = self.view.backgroundColor;
                fourCell.selectionStyle = UITableViewCellSelectionStyleNone;
                [tableView deselectRowAtIndexPath:indexPath animated:YES];
            }
            
            tableView.rowHeight = 55;
            fourCell.alarmRecLabel.hidden = NO;
            fourCell.userNameLabel.hidden = YES;
            fourCell.unlockModeLabel.hidden = YES;
            
            fourCell.timerLabel.text = m.date.length > 16 ? [m.date substringWithRange:NSMakeRange(11, 5)] :m.date;
            switch (m.type) {
                case 1://锁定报警（输入错误密码或指纹或卡片超过 10 次就报 警系统锁定）
                    fourCell.alarmRecLabel.text = Localized(@"MessageRecord_ValidationFailed");
                    //fourCell.dynamicImageView.image = [UIImage imageNamed:@"icon_error"];
                    break;
                case 2:// 劫持报警（输入防劫持密码或防劫持指纹开锁就报警）
                    fourCell.alarmRecLabel.text = Localized(@"MessageRecord_Kidnap_Open");
                    //fourCell.dynamicImageView.image = [UIImage imageNamed:@"icon_warning"];
                    break;
                case 3:// 三次错误报警
                    fourCell.alarmRecLabel.text = Localized(@"MessageRecord_Contact_Baoan");
                    //fourCell.dynamicImageView.image = [UIImage imageNamed:@"icon_error"];
                    break;
                case 4:// 防撬报警（锁被撬开）
                    fourCell.alarmRecLabel.text = Localized(@"MessageRecord_Lock_Pried");
                    //fourCell.dynamicImageView.image = [UIImage imageNamed:@"icon_prylock"];
                    break;
                case 8:// 机械方式报警（使用机械方式开锁）
                    fourCell.alarmRecLabel.text = Localized(@"MessageRecord_Lock_MechanicsOpen");
                    //fourCell.dynamicImageView.image = [UIImage imageNamed:@"icon_prylock"];
                    break;
                case 16:// 低电压报警（电池电量不足）
                    fourCell.alarmRecLabel.attributedText = [self setLabelTextWithlbTextStr:Localized(@"MessageRecord_LowPower_Alarm") startRange:15 endRange:18];
                    //fourCell.dynamicImageView.image = [UIImage imageNamed:@"icon_battery"];
                    break;
                case 32:// 锁体异常报警（旧:门锁不上报警）
                    fourCell.alarmRecLabel.text = Localized(@"MessageRecord_Lock_Fault");
                    //fourCell.dynamicImageView.image = [UIImage imageNamed:@"icon_fault"];
                    break;
                case 64:// 门锁布防报警
                    fourCell.alarmRecLabel.text = Localized(@"MessageRecord_Defence_OpenAlarm");
                    //fourCell.dynamicImageView.image = [UIImage imageNamed:@"icon_protection"];
                    break;
                case 128://低电量关人脸
                    fourCell.alarmRecLabel.text = Localized(@"MessageRecord_Face_PowerAlarm");
                    break;
                    
                default:
                    break;
            }
            
            return fourCell;
        }
    }
    return nil;
}

#pragma mark - UITableView 点击代理时间
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.visitorsTableView) {
        ///访客记录
        KDSWifiLockAlarmModel *m = self.visitorsRecordSectionArr[indexPath.section][indexPath.row];
        
        if (m.thumbState == YES && m.fileName.length > 0) {
            KDSPlaybackCaptureVC * vc = [KDSPlaybackCaptureVC new];
            vc.lock = self.lock;
            vc.model = m;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else if (tableView == self.alarmTableView) {
        ///预警信息
        KDSWifiLockAlarmModel *m = self.alarmRecordSectionArr[indexPath.section][indexPath.row];
        
        if (m.thumbState == YES && m.fileName.length > 0) {
            KDSPlaybackCaptureVC * vc = [KDSPlaybackCaptureVC new];
            vc.lock = self.lock;
            vc.model = m;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

#pragma mark - UITableView/Header
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KDSScreenWidth, 40)];
    headerView.backgroundColor = self.view.backgroundColor;
    
    //UIView * line = [UIView new];
    //line.backgroundColor = KDSRGBColor(216, 216, 216);
    //line.frame = CGRectMake(10, 0, KDSScreenWidth-20, 1);
    //line.hidden = section == 0;
    //[headerView addSubview:line];
    
    ///显示日期：今天、昨天、///开锁时间:（yyyy-MM-dd ）
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 200, 20)];
    titleLabel.font = [UIFont boldSystemFontOfSize:17];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.textColor = [UIColor blackColor];//[UIColor lightGrayColor];
    titleLabel.backgroundColor = [UIColor clearColor];
    [headerView addSubview:titleLabel];

    NSString *todayStr = [[self.fmt stringFromDate:[NSDate date]] stringByReplacingOccurrencesOfString:@"-" withString:@""];
    NSInteger today = [todayStr substringToIndex:8].integerValue;
    NSString *dateStr = nil;
    
    if (tableView == self.unlockTableView){
        
        dateStr = self.unlockRecordSectionArr[section].firstObject.date;
    }else if (tableView == self.visitorsTableView){
        
        dateStr = self.visitorsRecordSectionArr[section].firstObject.date;
    }else{
        
        dateStr = self.alarmRecordSectionArr[section].firstObject.date;
    }
    NSInteger date = [[dateStr stringByReplacingOccurrencesOfString:@"-" withString:@""] substringToIndex:8].integerValue;
    if (today == date)
    {
        titleLabel.text = Localized(@"today");
    }
    else if (today - date == 1)
    {
        titleLabel.text = Localized(@"yesterday");
    }
    else
    {
        titleLabel.text = [[dateStr componentsSeparatedByString:@" "].firstObject stringByReplacingOccurrencesOfString:@"-" withString:@"/"];
    }
    
    return headerView;
}

#pragma mark - UITableView/Header/Height
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (NSMutableAttributedString *)setLabelTextWithlbTextStr:(NSString *)textStr startRange:(int)startRange endRange:(int)endRange
{
    NSMutableAttributedString * lbStr;
    NSMutableAttributedString *attributer = [[NSMutableAttributedString alloc]initWithString:textStr];
     [attributer addAttribute:NSForegroundColorAttributeName value:KDSRGBColor(153, 153, 153) range:NSMakeRange(startRange, endRange)];
     NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];//调整行间距
     [paragraphStyle setLineSpacing:4];
    [attributer addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, textStr.length)];
    [paragraphStyle setAlignment:NSTextAlignmentLeft];
    lbStr = attributer;
    
    return lbStr;
}

#pragma mark - 在数据为空时提示视图加载
-(void) showEmptyDataHub{
    
    [self.emptyDataHub removeFromSuperview];
    
    if (self.unlockRecBtn.selected) {//操作记录
        NSString *tittleStr = Localized(@"MessageRecord_No_Operation");
        UIImage *headImage = [UIImage imageNamed:@"PLPEmptyData_Normal"];
        
        self.emptyDataHub = [[PLPEmptyDataHub alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavBarHeight - kStatusBarHeight - 54 -20) HeadImage:headImage Title:tittleStr];
        [self.unlockTableView addSubview:self.emptyDataHub];
    }else if (self.visitorsRecordBtn.selected){
        NSString *tittleStr = Localized(@"MessageRecord_No_Visitor");
        UIImage *headImage = [UIImage imageNamed:@"PLPEmptyData_Recire_Normal"];
        
        self.emptyDataHub = [[PLPEmptyDataHub alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavBarHeight - kStatusBarHeight - 54 -20) HeadImage:headImage Title:tittleStr];
        [self.visitorsTableView addSubview:self.emptyDataHub];
    }else if (self.alarmRecBtn.selected){
        NSString *tittleStr = Localized(@"MessageRecord_No_Alarm");
        UIImage *headImage = [UIImage imageNamed:@"PLPEmptyData_Alarm_Normal"];
        
        self.emptyDataHub = [[PLPEmptyDataHub alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavBarHeight - kStatusBarHeight - 54 -20) HeadImage:headImage Title:tittleStr];
        [self.alarmTableView addSubview:self.emptyDataHub];
    }
}

-(void)dismissEmptyDataHub
{
    __weak typeof(self)weakSelf = self;
    [UIView animateWithDuration:0.1 animations:^{
       
    } completion:^(BOOL finished) {
        [weakSelf.emptyDataHub removeFromSuperview];
    }];
}


#pragma mark - getter setter

- (NSMutableArray<KDSWifiLockOperation *> *)unlockRecordArr
{
    if (!_unlockRecordArr){
        _unlockRecordArr = [NSMutableArray array];
    }
    return _unlockRecordArr;
}

- (NSMutableArray<KDSWifiLockAlarmModel *> *)alarmRecordArr
{
    if (!_alarmRecordArr){
        _alarmRecordArr = [NSMutableArray array];
    }
    return _alarmRecordArr;
}

- (NSMutableArray<KDSWifiLockAlarmModel *> *)visitorsRecordArr
{
    if (!_visitorsRecordArr) {
        _visitorsRecordArr = [NSMutableArray array];
    }
    return _visitorsRecordArr;
}

- (NSMutableArray<UIButton *> *)recBtnButtons
{
    if (!_recBtnButtons) {
        _recBtnButtons = [NSMutableArray array];
    }
    return _recBtnButtons;
}

- (UIActivityIndicatorView *)alarmActivity
{
    if (!_alarmActivity){
        _alarmActivity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        CGPoint center = CGPointMake(kScreenWidth * 2.5, self.scrollView.bounds.size.height / 2.0);;
        _alarmActivity.center = center;
        [self.scrollView addSubview:_alarmActivity];
    }
    return _alarmActivity;
}

- (UIActivityIndicatorView *)unlockActivity
{
    if (!_unlockActivity){
        _unlockActivity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        CGPoint center = CGPointMake(kScreenWidth / 2.0, self.scrollView.bounds.size.height / 2.0);
        _unlockActivity.center = center;
        [self.scrollView addSubview:_unlockActivity];
    }
    return _unlockActivity;
}

- (UIActivityIndicatorView *)visitorsActivity
{
    if (!_visitorsActivity){
        _visitorsActivity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        CGPoint center = CGPointMake(kScreenWidth * 1.5, self.scrollView.bounds.size.height / 2.0);
        _visitorsActivity.center = center;
        [self.scrollView addSubview:_visitorsActivity];
    }
    return _visitorsActivity;
}

- (NSDateFormatter *)fmt
{
    if (!_fmt)
    {
        _fmt = [[NSDateFormatter alloc] init];
        _fmt.timeZone = [NSTimeZone localTimeZone];
        _fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    }
    return _fmt;
}



@end
