//
//  PLPinformationVC.m
//  2021-Philips
//
//  Created by zhaoxueping on 2021/5/8.
//  Copyright © 2021 com.Kaadas. All rights reserved.
//

#import "PLPinformationVC.h"
#import "PLPLockMsgOneCell.h"
#import "PLPLockMsgTwoCell.h"
#import "PLPLockMsgThreeCell.h"
#import "PLPLockMsgChartCell.h"
#import "KDSHttpManager+WifiLock.h"
#import "PLPAlertCustomView.h"
#import "PLPDevice.h"
#import "UIViewController+PLP.h"
#import "KDSMyMessageinfoStyleOneCell.h"
#import "KDSMyMessageinfoStyleTwoCell.h"
#import "KDSSystemMsgDetailsVC.h"
#import "KDSHttpManager+User.h"
#import "KDSDBManager.h"
#import "MJRefresh.h"
#import "MBProgressHUD+MJ.h"

#import "PLPDeviceManager.h"

@interface PLPinformationVC ()<UIScrollViewDelegate,UITableViewDataSource, UITableViewDelegate>
///门锁消息按钮。
@property (nonatomic, strong) UIButton *lockMsgBtn;
///系统消息按钮。
@property (nonatomic, strong) UIButton *systemMsgBtn;
///蓝色移动游标。
@property (nonatomic, strong) UIView *cursorView;
///横向滚动的滚动视图，装着门锁消息和系统消息的表视图。
@property (nonatomic, strong) UIScrollView *scrollView;
///显示门锁消息的表视图。
@property (nonatomic, strong) UITableView *lockMsgTableView;
///显示系统消息的表视图。
@property (nonatomic, strong) UITableView *sysytemMsgTableView;
///显示系统消息的lb
@property (nonatomic, strong) UILabel * msgNumLb;
///wifi锁数组。
@property (nonatomic,strong)NSMutableArray<KDSLock *> * wifiLocks;
@property (nonatomic, strong)KDSLock *  currentLock;

///数据源数组。
@property (nonatomic,readwrite,strong) NSMutableArray<KDSSysMessage *> *messages;
///时间格式器，yyyy/MM/dd
@property (nonatomic,readwrite,strong) NSDateFormatter *dateFmt;
///左滑删除事件。
@property (nonatomic, strong) UITableViewRowAction *deleteAction;
///圆角视图。
@property (nonatomic, strong) UIView *cornerView;
@property (nonatomic, assign) int pageCount;

@end

@implementation PLPinformationVC

- (NSArray<KDSLock *> *)wifiLocks
{   // wifi 锁的信息是从单例类中上传的
    NSMutableArray * wifiLocks = [NSMutableArray array];
    //NSLog(@"---zxppppp----%@",[KDSUserManager sharedManager].locks);
    ///[device plpLockWithOldDevice];
    for (PLPDevice *device in [PLPDeviceManager sharedInstance].allDevices)
    {
        KDSLock * lock = [device plpLockWithOldDevice];
        if (lock.wifiDevice) [wifiLocks addObject:lock];
    }
    return wifiLocks.copy;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = KDSRGBColor(247, 247, 247);
    [self loadNewData];
    _pageCount = 1;
    [self setUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.wifiLocks.count > 0) {
        self.currentLock = self.wifiLocks[0];
    }
    [self reloadTableView:self.sysytemMsgTableView];
    [self reloadTableView:self.lockMsgTableView];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

-(void)setUI{
    
    UIView * navView = [UIView new];
    navView.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:navView];
    [navView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(0);
        make.right.mas_equalTo(self.view.mas_right).offset(0);
        make.top.mas_equalTo(self.view.mas_top).offset(0);
        make.height.equalTo(@(kNavBarHeight+kStatusBarHeight));
    }];
    
    UILabel * titleLb = [UILabel new];
    titleLb.text = Localized(@"RecordMessage");
    titleLb.textAlignment = NSTextAlignmentCenter;
    titleLb.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
    titleLb.textColor = UIColor.blackColor;
    [navView addSubview:titleLb];
    [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(navView.mas_left).offset(0);
        make.right.mas_equalTo(navView.mas_right).offset(0);
        make.top.mas_equalTo(navView.mas_top).offset(10+kStatusBarHeight);
        make.bottom.mas_equalTo(navView.mas_bottom).offset(-10);
    }];
    
    UIView * topFunView = [UIView new];
    topFunView.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:topFunView];
    [topFunView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(navView.mas_bottom).offset(0);
        make.left.mas_equalTo(self.view.mas_left).offset(0);
        make.right.mas_equalTo(self.view.mas_right).offset(0);
        make.height.equalTo(@50);
    }];
    
    self.lockMsgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.lockMsgBtn setTitle:@"门锁消息" forState:UIControlStateNormal];
    [self.lockMsgBtn setTitleColor:KDSRGBColor(153, 153, 153) forState:UIControlStateNormal];
    [self.lockMsgBtn setTitleColor:KDSRGBColor(0, 102, 161) forState:UIControlStateSelected];
    self.lockMsgBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    self.lockMsgBtn.selected = YES;
    [self.lockMsgBtn addTarget:self action:@selector(clickMsgBtnAdjustScrollViewContentOffset:) forControlEvents:UIControlEventTouchUpInside];
    [topFunView addSubview:self.lockMsgBtn];
    [self.lockMsgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(topFunView.mas_left).offset(0);
        make.top.mas_equalTo(topFunView.mas_top).offset(0);
        make.bottom.mas_equalTo(topFunView.mas_bottom).offset(0);
        make.width.equalTo(@(KDSScreenWidth/2));
    }];
    
    
    self.systemMsgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.systemMsgBtn setTitle:@"系统消息" forState:UIControlStateNormal];
    [self.systemMsgBtn setTitleColor:KDSRGBColor(153, 153, 153) forState:UIControlStateNormal];
    [self.systemMsgBtn setTitleColor:KDSRGBColor(0, 102, 161) forState:UIControlStateSelected];
    self.systemMsgBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.systemMsgBtn addTarget:self action:@selector(clickMsgBtnAdjustScrollViewContentOffset:) forControlEvents:UIControlEventTouchUpInside];
    [topFunView addSubview:self.systemMsgBtn];
    [self.systemMsgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(topFunView.mas_right).offset(0);
        make.top.mas_equalTo(topFunView.mas_top).offset(0);
        make.bottom.mas_equalTo(topFunView.mas_bottom).offset(0);
        make.width.equalTo(@(KDSScreenWidth/2));
    }];
    
    self.msgNumLb = [UILabel new];
    self.msgNumLb.textColor = UIColor.whiteColor;
    self.msgNumLb.backgroundColor = UIColor.redColor;
    self.msgNumLb.font = [UIFont systemFontOfSize:8];
    self.msgNumLb.textAlignment = NSTextAlignmentCenter;
    self.msgNumLb.layer.cornerRadius = 9;
    self.msgNumLb.layer.masksToBounds = YES;
    [self.systemMsgBtn addSubview:self.msgNumLb];
    [self.msgNumLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@18);
        make.top.mas_equalTo(self.systemMsgBtn.mas_top).offset(5);
        make.centerX.mas_equalTo(self.systemMsgBtn.mas_centerX).offset(40);
    }];
    
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.delegate = self;
    self.scrollView.bounces = NO;
    self.scrollView.alwaysBounceVertical = NO;
    //    self.scrollView.scrollEnabled = NO;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topFunView.mas_bottom);
        make.left.bottom.right.equalTo(self.view);
    }];
    
    self.cursorView = [[UIView alloc] init];
    self.cursorView.layer.cornerRadius = 1.5;
    self.cursorView.backgroundColor = KDSRGBColor(0, 102, 161);
    [topFunView addSubview:self.cursorView];
    [self.cursorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.lockMsgBtn);
        make.bottom.equalTo(topFunView);
        make.size.mas_equalTo(CGSizeMake(50, 3));
    }];
    
    self.lockMsgTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.lockMsgTableView.showsVerticalScrollIndicator = NO;
    self.lockMsgTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.lockMsgTableView.tableFooterView = [UIView new];
    self.lockMsgTableView.dataSource = self;
    self.lockMsgTableView.delegate = self;
    self.lockMsgTableView.backgroundColor = self.view.backgroundColor;
    [self.scrollView addSubview:self.lockMsgTableView];
    self.lockMsgTableView.backgroundColor = self.sysytemMsgTableView.backgroundColor = UIColor.clearColor;
    self.lockMsgTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.lockMsgTableView registerNib:[UINib nibWithNibName:@"PLPLockMsgOneCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"PLPLockMsgOneCell"];
    [self.lockMsgTableView registerNib:[UINib nibWithNibName:@"PLPLockMsgTwoCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"PLPLockMsgTwoCell"];
    [self.lockMsgTableView registerNib:[UINib nibWithNibName:@"PLPLockMsgThreeCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"PLPLockMsgThreeCell"];
    [self.lockMsgTableView registerClass:[PLPLockMsgChartCell class] forCellReuseIdentifier:@"PLPLockMsgChartCell"];
    
    self.sysytemMsgTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.sysytemMsgTableView.showsVerticalScrollIndicator = NO;
    self.sysytemMsgTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.sysytemMsgTableView.tableFooterView = [UIView new];
    self.sysytemMsgTableView.dataSource = self;
    self.sysytemMsgTableView.delegate = self;
    self.sysytemMsgTableView.backgroundColor = self.view.backgroundColor;
    [self.scrollView addSubview:self.sysytemMsgTableView];
    self.sysytemMsgTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.sysytemMsgTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreMessage)];
    [self.sysytemMsgTableView registerClass:[KDSMyMessageinfoStyleTwoCell class] forCellReuseIdentifier:@"KDSMyMessageinfoStyleTwoCell"];
    [self.sysytemMsgTableView registerClass:[KDSMyMessageinfoStyleOneCell class] forCellReuseIdentifier:@"KDSMyMessageinfoStyleOneCell"];
    
}

- (void)viewDidLayoutSubviews
{
    if (CGRectIsEmpty(self.lockMsgTableView.frame))
    {
        self.scrollView.contentSize = CGSizeMake(kScreenWidth * 2, self.scrollView.bounds.size.height);
        CGRect frame = self.scrollView.bounds;
        frame.origin.x += 10;
        frame.size.width -= 20;
        self.lockMsgTableView.frame = frame;
        frame.origin.x += kScreenWidth;
        self.sysytemMsgTableView.frame = frame;
    }
}

- (void)reloadTableView:(UITableView *)tableView
{
    void (^noRecord) (UITableView *) = ^(UITableView *tableView) {
        UIView * tipsView = [[UIView alloc] initWithFrame:tableView.bounds];
        tipsView.backgroundColor = UIColor.whiteColor;
        
        UIImageView * tipsImg = [UIImageView new];
        tipsImg.image = [UIImage imageNamed:@"philips_message_img_default"];
        [tipsView addSubview:tipsImg];
        [tipsImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@196);
            make.height.equalTo(@117);
            make.top.mas_equalTo(tipsView.mas_top).offset(KDSScreenWidth <= 375 ? 50 : 100);
            make.centerX.equalTo(tipsView.mas_centerX);
        }];
        UILabel *label = [UILabel new];
        label.textAlignment = NSTextAlignmentCenter;
        if (tableView == self.lockMsgTableView) {
            label.text = Localized(@"noMgs");
        }else{
            label.text = Localized(@"noMgs");
        }
        label.textColor = KDSRGBColor(51, 51, 51);
        label.font = [UIFont systemFontOfSize:14];
        [tipsView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(tipsImg.mas_bottom).offset(10);
            make.height.equalTo(@30);
            make.centerX.equalTo(tipsView.mas_centerX);
        }];
        tableView.tableHeaderView = tipsView;
    };
    if (tableView == self.lockMsgTableView)
    {
        if (self.wifiLocks.count == 0)
        {
            noRecord(self.lockMsgTableView);
            return;
        }
        else
        {
            self.lockMsgTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 0.01)];
        }
        [self.lockMsgTableView reloadData];
        
    }else{
        
        if (self.messages.count == 0)
        {
            noRecord(self.sysytemMsgTableView);
            return;
        }
        else
        {
            self.sysytemMsgTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 0.01)];
        }
        [self.sysytemMsgTableView reloadData];
    }
}
- (UITableViewRowAction *)deleteAction
{
    if (!_deleteAction)
    {
        __weak typeof(self) weakSelf = self;
        _deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:Localized(@"delete") handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
            KDSSysMessage *message = weakSelf.messages[indexPath.row];
            [weakSelf.messages removeObject:message];
            [weakSelf.sysytemMsgTableView beginUpdates];
            [weakSelf.sysytemMsgTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
            [weakSelf.sysytemMsgTableView endUpdates];
            [weakSelf scrollViewDidScroll:weakSelf.sysytemMsgTableView];
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                message.deleted = YES;
                [[KDSDBManager sharedManager] deleteFAQOrMessage:message type:2];
                [weakSelf deleteSystemMessage:message];
            });
        }];
    }
    return _deleteAction;
}

#pragma mark - 网络请求方法

///获取第几页的消息，从1起。
- (void)loadNewData
{
    [[KDSHttpManager sharedManager] getSystemMessageWithUid:[KDSUserManager sharedManager].user.uid page:1 success:^(NSArray<KDSSysMessage *> * _Nonnull messages) {
        [self.messages removeAllObjects];
        [self.messages addObjectsFromArray:messages];
        [self reloadTableView:self.sysytemMsgTableView];
        _pageCount = 1;
        [self.sysytemMsgTableView.mj_footer resetNoMoreData];
        self.msgNumLb.hidden =self.messages.count==0;
        self.msgNumLb.text = [NSString stringWithFormat:@"%ld",self.messages.count];//@"99+";
        self.sysytemMsgTableView.mj_header.state = MJRefreshStateIdle;
    } error:^(NSError * _Nonnull error) {
        self.sysytemMsgTableView.mj_header.state = MJRefreshStateIdle;

    } failure:^(NSError * _Nonnull error) {
        self.sysytemMsgTableView.mj_header.state = MJRefreshStateIdle;

    }];
}

-(void)loadMoreMessage{
    
    [[KDSHttpManager sharedManager] getSystemMessageWithUid:[KDSUserManager sharedManager].user.uid page:_pageCount +1 success:^(NSArray<KDSSysMessage *> * _Nonnull messages) {
        if (messages.count == 0)
        {
            self.sysytemMsgTableView.mj_footer.state = MJRefreshStateNoMoreData;
            return;
        }
        _pageCount ++;
        for (KDSSysMessage * message in messages) {
            if (![self.messages containsObject:message]) {
                [self.messages addObjectsFromArray:messages];
            }
        }

        [self reloadTableView:self.sysytemMsgTableView];
        self.msgNumLb.hidden =self.messages.count==0;
        self.msgNumLb.text = [NSString stringWithFormat:@"%ld",self.messages.count];//@"99+";
        self.sysytemMsgTableView.mj_footer.state = MJRefreshStateIdle;
        
    } error:^(NSError * _Nonnull error) {

    self.sysytemMsgTableView.mj_footer.state = MJRefreshStateIdle;

    } failure:^(NSError * _Nonnull error) {
        self.sysytemMsgTableView.mj_footer.state = MJRefreshStateIdle;

    }];
}

///删除本地的系统消息。该方法内会查询本地有没有已标记删除的消息，如果有会请求服务器将其删除，请在子线程执行。
- (void)deleteSystemMessage:(KDSSysMessage * __nullable )message
{
    [[KDSHttpManager sharedManager] deleteSystemMessage:message withUid:[KDSUserManager sharedManager].user.uid success:^{
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
           [[KDSDBManager sharedManager] deleteFAQOrMessage:message type:2];
        });
               
    } error:nil failure:nil];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollViewDidScroll:scrollView];
}
#pragma mark - UITableViewDataSource, UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.lockMsgTableView) {
        if (self.wifiLocks.count >0) {
            return 4;
        }else{
            return 0;
        }
    }
    return self.messages.count;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.sysytemMsgTableView) {
        return @[self.deleteAction];
    }
    return nil;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.lockMsgTableView) {
        if (indexPath.row == 0) {
            PLPLockMsgOneCell * oneCell = [tableView dequeueReusableCellWithIdentifier:@"PLPLockMsgOneCell"];
            oneCell.lock = self.currentLock;
            return oneCell;
        }else if (indexPath.row == 1){
            PLPLockMsgTwoCell * twoCell = [tableView dequeueReusableCellWithIdentifier:@"PLPLockMsgTwoCell"];
            twoCell.lock = self.currentLock;
            return twoCell;
            
        }else if (indexPath.row == 2){
            PLPLockMsgThreeCell * threeCell = [tableView dequeueReusableCellWithIdentifier:@"PLPLockMsgThreeCell"];
            threeCell.lock = self.currentLock;
            return threeCell;
        }else{
            PLPLockMsgChartCell * fourCell = [tableView dequeueReusableCellWithIdentifier:@"PLPLockMsgChartCell"];
            fourCell.lock = self.currentLock;
            return fourCell;
        }
        
        return nil;
        
    }else if (tableView == self.sysytemMsgTableView){
        
        KDSSysMessage * message = self.messages[indexPath.row];

        if (message.type == 1) {//系统消息
            KDSMyMessageinfoStyleOneCell *oneCell = [tableView dequeueReusableCellWithIdentifier:@"KDSMyMessageinfoStyleOneCell" forIndexPath:indexPath];
            oneCell.clipsToBounds = YES;
            oneCell.titleLabel.text = message.title;
            oneCell.detailLabel.text = message.content;

            oneCell.timeLabel.text = [self.dateFmt stringFromDate:[NSDate dateWithTimeIntervalSince1970:message.createTime]];
            return oneCell;
        }
        KDSMyMessageinfoStyleTwoCell *twoCell = [tableView dequeueReusableCellWithIdentifier:@"KDSMyMessageinfoStyleTwoCell" forIndexPath:indexPath];
        twoCell.clipsToBounds = YES;
        twoCell.titleLabel.text = message.title;
        twoCell.timeLabel.text = [self.dateFmt stringFromDate:[NSDate dateWithTimeIntervalSince1970:message.createTime]];
        return twoCell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.sysytemMsgTableView) {
        KDSSystemMsgDetailsVC *sysy = [[KDSSystemMsgDetailsVC alloc] init];
        sysy.messages = self.messages[indexPath.row];
        sysy.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:sysy animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.lockMsgTableView) {
        if (indexPath.row == 0) {
            return 100;
        }else if (indexPath.row == 1){
            return 196;
        }else if (indexPath.row == 2){
            return 340;
        }
        return 800;
    }else{
        KDSSysMessage * message = self.messages[indexPath.row];
        if (message.type == 1) {
            return 100;
        }
        return 70;
    }
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KDSScreenWidth, 60)];
    headerView.backgroundColor = self.view.backgroundColor;
    headerView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(bigTap:)];
    [headerView addGestureRecognizer:recognizer];
    
    ///显示设备名称的lb：DDL708-V-5HW
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 200, 30)];
    titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
    titleLabel.text = self.currentLock.wifiDevice.lockNickname ?:  self.currentLock.wifiDevice.wifiSN;
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.textColor = KDSRGBColor(51, 51, 51);
    titleLabel.backgroundColor = [UIColor clearColor];
    [headerView addSubview:titleLabel];
    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:@"philips_message_icon_cbb"] forState:UIControlStateNormal];
    btn.frame = CGRectMake(KDSScreenWidth - 50, 25, 20, 20);
    [headerView addSubview:btn];
    
    if (tableView == self.lockMsgTableView && self.wifiLocks.count >0) {
        return headerView;
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == self.lockMsgTableView && self.wifiLocks.count >0) {
        return 60;
    }
    return 0.001;
}

#pragma mark - 控件等事件方法。
///点击门锁消息、系统消息调整滚动视图的偏移，切换页面。
- (void)clickMsgBtnAdjustScrollViewContentOffset:(UIButton *)sender
{
    [UIView animateWithDuration:0.3 animations:^{
        self.cursorView.center = CGPointMake(sender.center.x, self.cursorView.center.y);
        self.scrollView.contentOffset = CGPointMake(sender == self.lockMsgBtn ? 0 : kScreenWidth, 0);
        if (sender == self.lockMsgBtn) {
            self.lockMsgBtn.selected = YES;
            self.systemMsgBtn.selected = NO;
        }else{
            self.lockMsgBtn.selected = NO;
            self.systemMsgBtn.selected = YES;
        }
    }];
}

- (void)bigTap:(UITapGestureRecognizer *)tap
{
    if (self.wifiLocks.count) {
        
        PLPAlertCustomView * alertCustomView = [PLPAlertCustomView new];

        KDSWeakSelf(self);
        alertCustomView.devArr = self.wifiLocks;
        alertCustomView.cellClickBlock = ^(KDSLock * lock) {
            weakself.currentLock =lock;
            [weakself.lockMsgTableView reloadData];
        };
        [alertCustomView show];
    
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.scrollView)
    {
        self.cursorView.center = CGPointMake(self.lockMsgBtn.center.x + (self.systemMsgBtn.center.x - self.lockMsgBtn.center.x) * scrollView.contentOffset.x / scrollView.bounds.size.width, self.cursorView.center.y);
        self.lockMsgBtn.selected = scrollView.contentOffset.x == 0;
        self.systemMsgBtn.selected = !self.lockMsgBtn.selected;
    }
    
    CGFloat offsetY = scrollView.contentOffset.y;
    CGFloat maxHeight = kScreenHeight - kStatusBarHeight - kNavBarHeight;
    CGFloat rowHeight = self.sysytemMsgTableView.rowHeight;
    CGFloat height = self.messages.count * rowHeight;
    if (offsetY < 0)
    {
        //不能超过上限
        CGFloat originY = 10 - offsetY;
        height = height + originY > maxHeight ? maxHeight + 10 - originY : height;
        height = height < 0 ? 0 : height;
        self.cornerView.frame = CGRectMake(0, originY, kScreenWidth, height);
    }
    else
    {
        //不能超过上下限
        height -= offsetY;
        height = height > maxHeight ? maxHeight : height;
        height = height < 0 ? 0 : height;
        self.cornerView.frame = CGRectMake(0, 0, kScreenWidth, height);
    }
    
    
}

#pragma mark --Lazy load

- (NSMutableArray<KDSSysMessage *> *)messages
{
    if (!_messages) {
        _messages = [NSMutableArray array];
    }
    
    return _messages;
}

- (NSDateFormatter *)dateFmt
{
    if (!_dateFmt) {
        _dateFmt = [[NSDateFormatter alloc] init];
        _dateFmt.dateFormat = @"yyyy/MM/dd";
    }
    return _dateFmt;
}

@end
