//
//  PLPLockMsgChartCell.m
//  2021-Philips
//
//  Created by zhaoxueping on 2021/5/13.
//  Copyright © 2021 com.Kaadas. All rights reserved.
//

#import "PLPLockMsgChartCell.h"
#import "PLPLineChartView.h"
#import "KDSHttpManager+WifiLock.h"

@interface PLPLockMsgChartCell ()

@property (nonatomic, strong)NSMutableArray *weekArr;
///开门记录统计
@property (nonatomic, strong)NSMutableArray *openLockCountArr;
///访客记录统计
@property (nonatomic, strong)NSMutableArray *doorbellCountArr;
///告警记录统计
@property (nonatomic, strong)NSMutableArray *alarmCountArr;
@property (nonatomic, strong)PLPLineChartView * lockChartView;
@property (nonatomic, strong)PLPLineChartView * visitorChartView;
@property (nonatomic, strong)PLPLineChartView * warnChartView;

@end

@implementation PLPLockMsgChartCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUI];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return self;
}

- (void)setLock:(KDSLock *)lock
{
    KDSLock * modelLock = lock;
    if (modelLock.wifiDevice) {
        [self setDataWithLock:modelLock];
    }
    
}

- (void)setDataWithLock:(KDSLock *)modelLock{
   
    [[KDSHttpManager sharedManager] getwifiLockStatistics7DaysWithUid:[KDSUserManager sharedManager].user.uid wifiSN:modelLock.wifiDevice.wifiSN success:^(NSArray<PLPWeekStatisticsModel *> * _Nonnull statisticsList) {
        [self.weekArr removeAllObjects];
        [self.openLockCountArr removeAllObjects];
        [self.doorbellCountArr removeAllObjects];
        [self.alarmCountArr removeAllObjects];
        
        NSMutableArray * modelArr = [NSMutableArray arrayWithArray:statisticsList];
        [modelArr sortUsingComparator:^NSComparisonResult(PLPWeekStatisticsModel *  _Nonnull obj1, PLPWeekStatisticsModel *  _Nonnull obj2) {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-MM-dd"];
            NSDate *date = [formatter dateFromString:obj1.date];
            NSDate * date11 = [formatter dateFromString:obj2.date];
            NSTimeInterval interval = [date timeIntervalSince1970];
            NSTimeInterval interval111 = [date11 timeIntervalSince1970];
            
            return interval > interval111;
        }];
        for (int y = 0; y < modelArr.count; y ++) {
            PLPWeekStatisticsModel * mmm = modelArr[y];
            NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
            [formatter1 setDateFormat:@"yyyy-MM-dd"];
            NSDate *date =[formatter1 dateFromString:mmm.date];
            NSDateFormatter *formatter2 = [[NSDateFormatter alloc] init];
            [formatter2 setDateFormat:@"MM.dd"];
            NSString *dateString2 = [formatter2 stringFromDate:date ];
            [self.weekArr addObject:dateString2];
            [self.openLockCountArr addObject:@(mmm.openLockCount)];
            [self.doorbellCountArr addObject:@(mmm.doorbellCount)];
            [self.alarmCountArr addObject:@(mmm.alarmCount)];
        }
        NSLog(@"weekArr:%@openLockCountArr:%@doorbellCountArr:%@alarmCountArr:%@",_weekArr,_openLockCountArr,_doorbellCountArr,_alarmCountArr);
        [self.lockChartView drawLineChart];
        [self.visitorChartView drawLineChart];
        [self.warnChartView drawLineChart];
        
    } error:^(NSError * _Nonnull error) {
        
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

- (void)setUI{
    
    UILabel * tipsLb = [UILabel new];
    tipsLb.text = @"近7天数据统计";
    tipsLb.textAlignment = NSTextAlignmentLeft;
    tipsLb.font = [UIFont systemFontOfSize:15];
    tipsLb.textColor = KDSRGBColor(51, 51, 51);
    [self addSubview:tipsLb];
    [tipsLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(15);
        make.right.mas_equalTo(self.mas_right).offset(-15);
        make.height.equalTo(@30);
        make.top.mas_equalTo(self.mas_top).offset(15);
    }];
    ///门锁记录父视图
    self.lockRecordView = [UIView new];
    [self addSubview:self.lockRecordView];
    [self.lockRecordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(0);
        make.right.mas_equalTo(self.mas_right).offset(0);
        make.top.mas_equalTo(tipsLb.mas_bottom).offset(20);
        make.height.equalTo(@250);
    }];
    
    UIImageView * lockCharImg = [UIImageView new];
    lockCharImg.image = [UIImage imageNamed:@"philips_message_icon_display(2)"];
    [self.lockRecordView addSubview:lockCharImg];
    [lockCharImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.lockRecordView.mas_top).offset(15);
        make.width.height.equalTo(@11);
        make.left.mas_equalTo(self.lockRecordView.mas_left).offset(15);
    }];
    UILabel * lockTipsLb = [UILabel new];
    lockTipsLb.text = @"开门记录";
    lockTipsLb.textColor = KDSRGBColor(102, 102, 102);
    lockTipsLb.font = [UIFont systemFontOfSize:12];
    lockTipsLb.textAlignment = NSTextAlignmentLeft;
    [self.lockRecordView addSubview:lockTipsLb];
    [lockTipsLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(lockCharImg.mas_right).offset(10);
        make.right.mas_equalTo(self.lockRecordView.mas_right).offset(-10);
        make.height.equalTo(@20);
        make.top.mas_equalTo(self.lockRecordView.mas_top).offset(10);
    }];
    ///访客记录父视图
    self.visitorRecordView = [UIView new];
    [self addSubview:self.visitorRecordView];
    [self.visitorRecordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(0);
        make.right.mas_equalTo(self.mas_right).offset(0);
        make.top.mas_equalTo(self.lockRecordView.mas_bottom).offset(0);
        make.height.equalTo(@250);
    }];
    
    UIImageView * visitorCharImg = [UIImageView new];
    visitorCharImg.image = [UIImage imageNamed:@"philips_message_icon_display(2)"];
    [self.visitorRecordView addSubview:visitorCharImg];
    [visitorCharImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.visitorRecordView.mas_top).offset(15);
        make.width.height.equalTo(@11);
        make.left.mas_equalTo(self.visitorRecordView.mas_left).offset(15);
    }];
    UILabel * visitorTipsLb = [UILabel new];
    visitorTipsLb.text = @"访客记录";
    visitorTipsLb.textColor = KDSRGBColor(102, 102, 102);
    visitorTipsLb.font = [UIFont systemFontOfSize:12];
    visitorTipsLb.textAlignment = NSTextAlignmentLeft;
    [self.visitorRecordView addSubview:visitorTipsLb];
    [visitorTipsLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(visitorCharImg.mas_right).offset(10);
        make.right.mas_equalTo(self.visitorRecordView.mas_right).offset(-10);
        make.height.equalTo(@20);
        make.top.mas_equalTo(self.visitorRecordView.mas_top).offset(10);
    }];
    ///预警信息父视图
    self.warnRecordView = [UIView new];
    [self addSubview:self.warnRecordView];
    [self.warnRecordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(0);
        make.right.mas_equalTo(self.mas_right).offset(0);
        make.top.mas_equalTo(self.visitorRecordView.mas_bottom).offset(0);
        make.height.equalTo(@250);
    }];
    
    UIImageView * warnCharImg = [UIImageView new];
    warnCharImg.image = [UIImage imageNamed:@"philips_message_icon_display(2)"];
    [self.warnRecordView addSubview:warnCharImg];
    [warnCharImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.warnRecordView.mas_top).offset(15);
        make.width.height.equalTo(@11);
        make.left.mas_equalTo(self.warnRecordView.mas_left).offset(15);
    }];
    UILabel * warnTipsLb = [UILabel new];
    warnTipsLb.text = @"预警信息";
    warnTipsLb.textColor = KDSRGBColor(102, 102, 102);
    warnTipsLb.font = [UIFont systemFontOfSize:12];
    warnTipsLb.textAlignment = NSTextAlignmentLeft;
    [self.warnRecordView addSubview:warnTipsLb];
    [warnTipsLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(warnCharImg.mas_right).offset(10);
        make.right.mas_equalTo(self.warnRecordView.mas_right).offset(-10);
        make.height.equalTo(@20);
        make.top.mas_equalTo(self.warnRecordView.mas_top).offset(10);
    }];
}

///开门记录的折线图
- (PLPLineChartView *)lockChartView
{
    if (!_lockChartView) {
        _lockChartView = [[PLPLineChartView alloc] initWithFrame:CGRectMake(0, 30, KDSScreenWidth-30, 200)];
        [self.lockRecordView addSubview:_lockChartView];
    }else{
        [_lockChartView removeFromSuperview];
        _lockChartView = [[PLPLineChartView alloc] initWithFrame:CGRectMake(0, 30, KDSScreenWidth-30, 200)];
        [self.lockRecordView addSubview:_lockChartView];
    }
    _lockChartView.backgroundColor = UIColor.clearColor;
    _lockChartView.showLineData = NO;//是否显示关键点上的数据
    _lockChartView.isShowKeyPointCircle = NO;//是否显示关键点圆圈
    _lockChartView.angle = 0;//底部x轴文本偏角
    _lockChartView.horizontalDataArr = self.weekArr.count > 6 ? self.weekArr :[self getCurrentDayToLastServeDay];
    _lockChartView.lineDataAry = self.openLockCountArr.count > 6 ? self.openLockCountArr : @[@0,@20,@0,@50,@0,@30,@20];
    _lockChartView.splitCount = 4;
    _lockChartView.toCenter = NO;
    CGFloat maxValue = [[_lockChartView.lineDataAry valueForKeyPath:@"@max.floatValue"] floatValue];
    _lockChartView.max = maxValue > 80 ? @(maxValue) : @80;
    _lockChartView.min = @0;
    _lockChartView.edge = UIEdgeInsetsMake(25, 15, 50, 15);
    return _lockChartView;
}
///访客记录的折线图
- (PLPLineChartView *)visitorChartView
{
    if (!_visitorChartView) {
        _visitorChartView = [[PLPLineChartView alloc] initWithFrame:CGRectMake(0, 30, KDSScreenWidth-30, 200)];
        [self.visitorRecordView addSubview:_visitorChartView];
    }else{
        [_visitorChartView removeFromSuperview];
        _visitorChartView = [[PLPLineChartView alloc] initWithFrame:CGRectMake(0, 30, KDSScreenWidth-30, 200)];
        [self.visitorRecordView addSubview:_visitorChartView];
    }
    
    _visitorChartView.backgroundColor = UIColor.clearColor;
    _visitorChartView.showLineData = NO;//是否显示关键点上的数据
    _visitorChartView.isShowKeyPointCircle = NO;//是否显示关键点圆圈
    _visitorChartView.angle = 0;//底部x轴文本偏角
    _visitorChartView.horizontalDataArr = self.weekArr.count > 6 ? self.weekArr :[self getCurrentDayToLastServeDay];
    _visitorChartView.lineDataAry = self.doorbellCountArr.count >6 ? self.doorbellCountArr : @[@0,@20,@20,@50,@60,@30,@10];
    _visitorChartView.splitCount = 4;
    _visitorChartView.toCenter = NO;
    CGFloat maxValue = [[ _visitorChartView.lineDataAry valueForKeyPath:@"@max.floatValue"] floatValue];
    _visitorChartView.max = maxValue > 80 ? @(maxValue) : @80;
    _visitorChartView.min = @0;
    _visitorChartView.edge = UIEdgeInsetsMake(25, 15, 50, 15);
    return _visitorChartView;
}

///预警信息的折线图
- (PLPLineChartView *)warnChartView
{
    if (!_warnChartView) {
        _warnChartView = [[PLPLineChartView alloc] initWithFrame:CGRectMake(0, 30, KDSScreenWidth-30, 200)];
        [self.warnRecordView addSubview:_warnChartView];
    }else{
        [_warnChartView removeFromSuperview];
        _warnChartView = [[PLPLineChartView alloc] initWithFrame:CGRectMake(0, 30, KDSScreenWidth-30, 200)];
        [self.warnRecordView addSubview:_warnChartView];
    }
    _warnChartView.backgroundColor = UIColor.clearColor;
    _warnChartView.showLineData = NO;//是否显示关键点上的数据
    _warnChartView.isShowKeyPointCircle = NO;//是否显示关键点圆圈
    _warnChartView.angle = 0;//底部x轴文本偏角
    _warnChartView.horizontalDataArr = self.weekArr.count > 6 ? self.weekArr :[self getCurrentDayToLastServeDay];
    _warnChartView.lineDataAry = self.alarmCountArr.count >6 ? self.alarmCountArr : @[@350,@0,@10,@80,@40,@20,@20];
    _warnChartView.splitCount = 4;
    _warnChartView.toCenter = NO;
    CGFloat maxValue = [[ _warnChartView.lineDataAry valueForKeyPath:@"@max.floatValue"] floatValue];
    _warnChartView.max = maxValue > 80 ? @(maxValue) : @80;
    _warnChartView.min = @0;
    _warnChartView.edge = UIEdgeInsetsMake(25, 15, 50, 15);
    return _warnChartView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setFrame:(CGRect)frame{
    //frame.origin.x +=10;
    frame.origin.y += 10;
    frame.size.height -= 10;
    //frame.size.width -= 20;
    [super setFrame:frame];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark --Lazy

- (NSMutableArray *)weekArr
{
    if (!_weekArr) {
        _weekArr = [NSMutableArray array];
    }
    return _weekArr;
}

- (NSMutableArray *)openLockCountArr
{
    if (!_openLockCountArr) {
        _openLockCountArr = [NSMutableArray array];
    }
    return _openLockCountArr;
}

- (NSMutableArray *)doorbellCountArr
{
    if (!_doorbellCountArr) {
        _doorbellCountArr = [NSMutableArray array];
    }
    return _doorbellCountArr;
}

- (NSMutableArray *)alarmCountArr
{
    if (!_alarmCountArr) {
        _alarmCountArr = [NSMutableArray array];
    }
    return _alarmCountArr;
}

-(NSMutableArray *)getCurrentDayToLastServeDay{
    NSDate *nowDate = [NSDate date];
    //计算从当前日期开始的七天日期
    for (int i = 0; i < 7; i ++) {
           //从现在开始的24小时
           NSTimeInterval secondsPerDay = i * 24*60*60;
           NSDate *curDate = [NSDate dateWithTimeInterval:secondsPerDay sinceDate:nowDate];
           NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
           [dateFormatter setDateFormat:@"M.d"];
           NSString *dateStr = [dateFormatter stringFromDate:curDate];//几月几号
           [self.weekArr addObject:dateStr];
       }
    return self.weekArr;
}


@end
