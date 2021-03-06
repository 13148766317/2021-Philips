//
//  CYPhotoCell.h
//  自定义流水布局
//
//  Created by 葛聪颖 on 15/11/13.
//  Copyright © 2015年 聪颖不聪颖. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CYPhotoCell : UICollectionViewCell
/** 图片名 */
@property (nonatomic, copy) NSString *imageName;
@property (weak, nonatomic) IBOutlet UIButton *lockImg;
@property (weak, nonatomic) IBOutlet UILabel *LockNameLab;
@end
