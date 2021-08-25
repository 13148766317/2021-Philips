//
//  PLPVisitorRecoreCell.h
//  2021-Philips
//
//  Created by 小凯互联科技有限公司 on 2021/5/6.
//  Copyright © 2021 com.Kaadas. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PLPVisitorRecoreCell : UITableViewCell

//头部蓝色小圆点
@property (weak, nonatomic) IBOutlet UIView *headMarkView;

//记录的具体描述Lb
@property (weak, nonatomic) IBOutlet UILabel *contentLb;

//访客记录的时间Lb
@property (weak, nonatomic) IBOutlet UILabel *timeLb;

//记录的头像的图标
@property (weak, nonatomic) IBOutlet UIImageView *visitorsHeadPortraitIconImg;

//播放缩略图的按钮（用来标识是有无视频还单单的图片）
@property (weak, nonatomic) IBOutlet UIButton *playBtn;

// 点击播放事件回调
@property (nonatomic,copy)dispatch_block_t playBtnClickBlock;

/**

 ///记录的具体描述Lb


 ///标识记录类型的小图标
 @property (weak, nonatomic) IBOutlet UIImageView *smallTipsImg;

 /// 点击播放事件回调
 @property (nonatomic,copy)dispatch_block_t playBtnClickBlock;
 
 */

@end

NS_ASSUME_NONNULL_END
