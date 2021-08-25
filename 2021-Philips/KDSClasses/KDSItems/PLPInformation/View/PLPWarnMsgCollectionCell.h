//
//  PLPWarnMsgCollectionCell.h
//  2021-Philips
//
//  Created by zhaoxueping on 2021/5/10.
//  Copyright © 2021 com.Kaadas. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PLPWarnMsgCollectionCell : UICollectionViewCell
///预警信息（视频：第一帧的图片、图片）展示
@property (weak, nonatomic) IBOutlet UIImageView *warnMsgTipsImgView;
///播放按钮（有可能隐藏--当没有视频播放源的时候是隐藏的）
@property (weak, nonatomic) IBOutlet UIButton *playBtn;
/// 点击播放事件回调
@property (nonatomic,copy)dispatch_block_t plpPlayBtnClickBlock;

@end

NS_ASSUME_NONNULL_END
