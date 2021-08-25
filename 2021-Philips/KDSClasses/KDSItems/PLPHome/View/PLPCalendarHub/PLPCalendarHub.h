//
//  PLPCalendarHub.h
//  2021-Philips
//
//  Created by 小凯互联科技有限公司 on 2021/5/7.
//  Copyright © 2021 com.Kaadas. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol PLPCalendarHubDelegate <NSObject>

//选择的日期
-(void) calendarHubSelectYear:(NSInteger) year Months:(NSInteger)month Day:(NSInteger)day;

@end

@interface PLPCalendarHub : UIView

//申明代理
@property (nonatomic, strong)id<PLPCalendarHubDelegate>calendarHubDelegate;

@end

NS_ASSUME_NONNULL_END
