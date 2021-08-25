//
//  PLPDeviceUIActionsCollectionView.h
//  Pages
//
//  Created by Apple on 2021/5/27.
//

#import <UIKit/UIKit.h>
#import "PLPDeviceUIAction.h"

NS_ASSUME_NONNULL_BEGIN

//单元格重用id，用于register cell class或nib
extern NSString * const PLPDeviceUIActionsDefaultCellWithReuseIdentifier;

@interface PLPDeviceUIActionsCollectionView : UICollectionView <UICollectionViewDelegate, UICollectionViewDataSource>

@property(nonatomic, strong) NSArray<PLPDeviceUIAction *> *actionsDataSource;

@property(nonatomic, copy) void (^didSelectRowBlock)(PLPDeviceUIAction * item);
//计算单元格大小
+(CGSize) itemSizeWithColNum:(NSUInteger) colNum layoutWidth:(CGFloat)layoutWidth rowHeight:(CGFloat) height minimumInteritemSpacing:(CGFloat) minimumInteritemSpacing edgeLeft:(CGFloat) edgeLeft edageRight:(CGFloat) edgeRight;
+(UICollectionViewFlowLayout *) collectionViewFlowLayoutWithItemSize:(CGSize) itemSize minimumLineSpacing:(CGFloat) minimumLineSpacing minimumInteritemSpacing:(CGFloat) minimumInteritemSpacing;
@end

NS_ASSUME_NONNULL_END
