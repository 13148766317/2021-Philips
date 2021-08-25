//
//  PLPLockMsgTwoCell.h
//  2021-Philips
//
//  Created by zhaoxueping on 2021/5/10.
//  Copyright © 2021 com.Kaadas. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PLPLockMsgTwoCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *warnMsgTipsLb;
///展示预警消息通知的滚动视图
@property (nonatomic, strong) UICollectionView * warnMsgNotionCell;
@property (nonatomic, strong) KDSLock * lock;

@end

NS_ASSUME_NONNULL_END
