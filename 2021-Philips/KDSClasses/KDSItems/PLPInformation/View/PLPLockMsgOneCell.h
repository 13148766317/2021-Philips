//
//  PLPLockMsgOneCell.h
//  2021-Philips
//
//  Created by zhaoxueping on 2021/5/10.
//  Copyright © 2021 com.Kaadas. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PLPLockMsgOneCell : UITableViewCell
///展示添加设备时长的lb
@property (weak, nonatomic) IBOutlet UILabel *addDevTimeLb;
///展示消息总次数的lb
@property (weak, nonatomic) IBOutlet UILabel *msgCountLb;
@property (nonatomic, strong) NSString * devTimeString;
@property (nonatomic, strong) NSString * msgContString;
@property (nonatomic, strong) KDSLock * lock;

@end

NS_ASSUME_NONNULL_END
