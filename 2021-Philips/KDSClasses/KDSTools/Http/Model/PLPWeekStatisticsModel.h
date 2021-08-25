//
//  PLPWeekStatisticsModel.h
//  2021-Philips
//
//  Created by zhaoxueping on 2021/5/19.
//  Copyright © 2021 com.Kaadas. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

//----门锁近7日统计
@interface PLPWeekStatisticsModel : NSObject
///日期。格式为yyyy-MM-dd
@property(nonatomic,strong)NSString * date;
///开门记录统计
@property(nonatomic,assign)int openLockCount;
///访客记录统计
@property(nonatomic,assign)int doorbellCount;
///告警记录统计
@property(nonatomic,assign)int alarmCount;


@end

NS_ASSUME_NONNULL_END
