//
//  PLPOperationRecordCell.h
//  2021-Philips
//
//  Created by 小凯互联科技有限公司 on 2021/5/6.
//  Copyright © 2021 com.Kaadas. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PLPOperationRecordCell : UITableViewCell

//头部蓝色小圆点
@property (weak, nonatomic) IBOutlet UIView *headMarkView;

//开锁者
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;

//开锁时间
@property (weak, nonatomic) IBOutlet UILabel *timerLabel;

//开锁方式
@property (weak, nonatomic) IBOutlet UILabel *unlockModeLabel;

//报警信息
@property (weak, nonatomic) IBOutlet UILabel *alarmRecLabel;

@end

NS_ASSUME_NONNULL_END
