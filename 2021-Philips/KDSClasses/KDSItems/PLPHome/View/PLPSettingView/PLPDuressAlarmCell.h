//
//  PLPDuressAlarmCell.h
//  2021-Philips
//
//  Created by 小凯互联科技有限公司 on 2021/5/12.
//  Copyright © 2021 com.Kaadas. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PLPDuressAlarmCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;
@property (weak, nonatomic) IBOutlet UISwitch *alarmSwitch;
@property (weak, nonatomic) IBOutlet UIImageView *markImageView;

@end

NS_ASSUME_NONNULL_END
