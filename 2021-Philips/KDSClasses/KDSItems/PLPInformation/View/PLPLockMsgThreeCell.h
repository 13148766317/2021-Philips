//
//  PLPLockMsgThreeCell.h
//  2021-Philips
//
//  Created by zhaoxueping on 2021/5/10.
//  Copyright © 2021 com.Kaadas. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PLPLockMsgThreeCell : UITableViewCell
///展示门锁消息总条数的lb
@property (weak, nonatomic) IBOutlet UILabel *lockMsgCountLb;
///展示门锁消息类型的滚动视图
@property (nonatomic, strong) UICollectionView * lockMsgTypeCollectionView;
@property (weak, nonatomic) IBOutlet UILabel *msgTipsLb;
///圆圈图片
@property (weak, nonatomic) IBOutlet UIImageView *tipsImgView;
@property (nonatomic, strong) KDSLock * lock;

@end

NS_ASSUME_NONNULL_END
