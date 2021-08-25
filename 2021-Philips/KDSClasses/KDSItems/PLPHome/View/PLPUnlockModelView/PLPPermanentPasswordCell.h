//
//  PLPPermanentPasswordCell.h
//  2021-Philips
//
//  Created by 小凯互联科技有限公司 on 2021/4/28.
//  Copyright © 2021 com.Kaadas. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PLPPermanentPasswordCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *headLineView;
@property (weak, nonatomic) IBOutlet UILabel *passwordTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *removeButton;
@property (weak, nonatomic) IBOutlet UILabel *passwordNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addTimeTltleLabel;
@property (weak, nonatomic) IBOutlet UILabel *addTimeLabel;

@end

NS_ASSUME_NONNULL_END
