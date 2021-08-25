//
//  LXCalenderCell.h
//  LXCalendar
//
//  Created by chenergou on 2017/11/2.
//  Copyright © 2017年 漫漫. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LXCalendarDayModel.h"
#import "UIView+FTCornerdious.h"
#import "UILabel+LXLabel.h"
#import "UIView+LX_Frame.h"
#import "UIColor+Expanded.h"

@interface LXCalenderCell : UICollectionViewCell

@property(nonatomic,strong)LXCalendarDayModel *model;
@end
