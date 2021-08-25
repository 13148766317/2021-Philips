//
//  PLPCalendarHub.m
//  2021-Philips
//
//  Created by 小凯互联科技有限公司 on 2021/5/7.
//  Copyright © 2021 com.Kaadas. All rights reserved.
//

#import "PLPCalendarHub.h"
#import "LXCalender.h"

@interface PLPCalendarHub ()

@property(nonatomic,strong)LXCalendarView *calenderView;

@end

@implementation PLPCalendarHub

-(instancetype) initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        @autoreleasepool {
            [self setupMainView];
        }
    }
    return self;
}

#pragma mark - 初始化主视图
-(void) setupMainView{
    
    self.calenderView =[[LXCalendarView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight/2)];
    self.calenderView.currentMonthTitleColor =[UIColor hexStringToColor:@"2c2c2c"];
    self.calenderView.lastMonthTitleColor =[UIColor hexStringToColor:@"8a8a8a"];
    self.calenderView.nextMonthTitleColor =[UIColor hexStringToColor:@"8a8a8a"];
    
    self.calenderView.isHaveAnimation = YES;
    self.calenderView.isCanScroll = YES;
    self.calenderView.isShowLastAndNextBtn = YES;
    self.calenderView.isShowLastAndNextDate = YES;
    self.calenderView.todayTitleColor =[UIColor redColor];//KDSRGBColor(47, 102, 158);
    self.calenderView.selectBackColor =KDSRGBColor(229, 229, 229);
    self.calenderView.backgroundColor =[UIColor whiteColor];
    [self.calenderView dealData];

    [self addSubview:self.calenderView];

    __weak typeof(self) weakSelf = self;
    self.calenderView.selectBlock = ^(NSInteger year, NSInteger month, NSInteger day) {
        //NSLog(@"%ld年 - %ld月 - %ld日",year,month,day);
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if ([strongSelf.calendarHubDelegate respondsToSelector:@selector(calendarHubSelectYear:Months:Day:)]) {
            [strongSelf.calendarHubDelegate calendarHubSelectYear:year Months:month Day:day];
        }
    };
}

@end
