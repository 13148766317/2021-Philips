//
//  PLPLockMsgChartCell.h
//  2021-Philips
//
//  Created by zhaoxueping on 2021/5/13.
//  Copyright © 2021 com.Kaadas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PLPWeekStatisticsModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PLPLockMsgChartCell : UITableViewCell

///展示开门记录的折线图
@property (nonatomic,strong) UIView *lockRecordView;
///展示访客记录的折线图
@property (nonatomic,strong) UIView *visitorRecordView;
///展示预警信息的折线图
@property (nonatomic,strong) UIView *warnRecordView;
////门锁近7天统计的数据
@property (nonatomic,strong) NSArray<PLPWeekStatisticsModel *>*weekStatisticsModel;
@property (nonatomic, strong) KDSLock * lock;

@end

NS_ASSUME_NONNULL_END
